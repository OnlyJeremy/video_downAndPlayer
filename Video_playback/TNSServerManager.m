//
//  TNSServerManager.m
//  Video_playback
//
//  Created by Jeremy on 16/8/21.
//  Copyright © 2016年 Jeremy. All rights reserved.
//

#import "TNSServerManager.h"
#import "MusicFilenameManager.h"
@implementation TNSServerManager
TNSServerManager *serverInstance;
+(instancetype)sharedServer
{
    if (serverInstance==nil) {
        serverInstance=[[TNSServerManager alloc]init];
    }
    return serverInstance;
}

+(AFHTTPSessionManager *)manager
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    // 超时时间
    manager.requestSerializer.timeoutInterval = 30;
    
    // 声明上传的是json格式的参数，需要你和后台约定好，不然会出现后台无法获取到你上传的参数问题
    manager.requestSerializer = [AFHTTPRequestSerializer serializer]; // 上传普通格式
    //    manager.requestSerializer = [AFJSONRequestSerializer serializer]; // 上传JSON格式
    
    // 声明获取到的数据格式
    manager.responseSerializer = [AFHTTPResponseSerializer serializer]; // AFN不会解析,数据是data，需要自己解析
    //    manager.responseSerializer = [AFJSONResponseSerializer serializer]; // AFN会JSON解析返回的数据
    // 个人建议还是自己解析的比较好，有时接口返回的数据不合格会报3840错误，大致是AFN无法解析返回来的数据
    return manager;
}

-(void)loadingZipWithID:(NSString *)ID success:(void (^)(NSDictionary *))success failure:(void (^)(NSDictionary *))failure
{
  
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
         /**设置接受的类型*/
   manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html", @"text/plain", nil];
//     [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    // 声明上传的是json格式的参数，需要你和后台约定好，不然会出现后台无法获取到你上传的参数问题
       manager.requestSerializer = [AFHTTPRequestSerializer serializer]; // 上传普通格式
//    manager.requestSerializer = [AFJSONRequestSerializer serializer]; // 上传JSON格式
    
    // 声明获取到的数据格式
        manager.responseSerializer = [AFHTTPResponseSerializer serializer]; // AFN不会解析,数据是data，需要自己解析
//    manager.responseSerializer = [AFJSONResponseSerializer serializer]; // AFN会JSON解析返回的数据
    // 个人建议还是自己解析的比较好，有时接口返回的数据不合格会报3840错误，大致是AFN无法解析返回来的数据
    
    
    NSMutableDictionary *inputParameters=[NSMutableDictionary dictionary];
    
    [inputParameters setObject:@"76" forKey:@"userid"];
    
    
    [inputParameters setObject:@"11" forKey:@"courseid"];
    
//    [inputParameters setObject:[NSNumber numberWithInt:0] forKey:@"pagesize"];
//    [inputParameters setObject:[NSNumber numberWithInt:10] forKey:@"readcount"];

    NSString *requestURL =[NSString stringWithFormat:@"%@/%@",HE_SERVER_BASE_URL,HE_SERVER_INTERFACE_COURSEITEM];
    
    
    
    [manager GET:requestURL parameters:inputParameters progress:^(NSProgress * _Nonnull downloadProgress) {
        // 这里可以获取到目前数据请求的进度
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        // 请求成功
        if(responseObject){
            NSError *error = nil;
            id dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:&error];
            //            success(dict,YES);
        } else {
            //            success(@{@"msg":@"暂无数据"}, NO);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        // 请求失败
        //        fail(error);
    }];
    
}

/**
 *  通过下面这个方法过滤字符串中的换行和空格、制表符，返回的就是正常解析的OC字典了
 */
- (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString {
    if (jsonString == nil) {
        return nil;
    }
    NSString *string = [jsonString stringByReplacingOccurrencesOfString:@"\r" withString:@""];
    string = [string stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    string = [string stringByReplacingOccurrencesOfString:@"\t" withString:@""];
    string = [string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSData *jsonData = [string dataUsingEncoding:NSUTF8StringEncoding];
    
    __autoreleasing NSError *dataError;
    NSDictionary *responseDic=[NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableLeaves error:&dataError];
    if (dataError) {
        NSLog(@"数据转换过程中日志输出：%@",dataError);
        return nil;
    }else{
        return responseDic;
    }
}

/**
 *  处理json格式的字符串中的换行符、回车符
 */
-(NSData *)deleteSpecialCode:(NSString *)str {
    
    NSString *string = [str stringByReplacingOccurrencesOfString:@"\r" withString:@""];
    string = [string stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    string = [string stringByReplacingOccurrencesOfString:@"\t" withString:@""];
    string = [string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSData *jsonData = [string dataUsingEncoding:NSUTF8StringEncoding];
    return jsonData;
}

@end
