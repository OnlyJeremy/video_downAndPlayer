//
//  ViewController.m
//  Video_playback
//
//  Created by Jeremy on 16/8/21.
//  Copyright © 2016年 Jeremy. All rights reserved.
//

#import "ViewController.h"
#import "TNSServerManager.h"
#import "AFNetworking.h"
#import "AudioButton.h"
#import <MediaPlayer/MediaPlayer.h>
#import "KKVideoPlayerViewController.h"
@interface ViewController ()
{
    // 下载句柄
    NSURLSessionDownloadTask *_downloadTask;
     unsigned long long Recordull;
    AudioButton *musicBt;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
   musicBt = [[AudioButton alloc]initWithFrame:CGRectMake(135, 50, 50, 50)];

    
    [musicBt addTarget:self action:@selector(downFileFromServer) forControlEvents:UIControlEventTouchUpInside];
  
    [musicBt setTag:1];
    [self.view addSubview:musicBt];
    
    
    UIButton *btn_cacel = [UIButton buttonWithType:UIButtonTypeSystem];
    [btn_cacel setTitle:@"取消下载" forState:UIControlStateNormal];
    btn_cacel.frame = CGRectMake(100, 120, 100, 50);
    [btn_cacel addTarget:self action:@selector(cacalDown) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn_cacel];
    
    
    
    UIButton *btn_jixu = [UIButton buttonWithType:UIButtonTypeSystem];
    [btn_jixu setTitle:@"继续下载" forState:UIControlStateNormal];
    btn_jixu.frame = CGRectMake(100, 180, 100, 50);
    [btn_jixu addTarget:self action:@selector(cacalDown) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn_jixu];
    
    
    
    UIButton *btn_zanting = [UIButton buttonWithType:UIButtonTypeSystem];
    [btn_zanting setTitle:@"暂停下载" forState:UIControlStateNormal];
    btn_zanting.frame = CGRectMake(100, 260, 100, 50);
    [btn_zanting addTarget:self action:@selector(btn_zantingway) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn_zanting];

   
}
-(void)btn_zantingway
{
 [_downloadTask suspend];
}
-(void)btn_jixuway
{
    [_downloadTask resume];
}
//-(void)f
//{
//
// [[TNSServerManager  sharedServer]loadingZipWithID:nil success:^(NSDictionary *obj) {
//     
// } failure:^(NSDictionary *obj) {
//     
// }];
//    
//    
//}


- (void)downFileFromServer{
    
    
    
    //
   
    NSString *cachePath = [NSHomeDirectory() stringByAppendingPathComponent:@"Library/Private Documents/Cache"];
    NSLog(@"%@",cachePath);
   
    NSFileManager *fileManager=[NSFileManager defaultManager];
    //判断是否存在一个文件cachePath 如果不存在就创建一个文件
    if(![fileManager fileExistsAtPath:cachePath])
    {
        [fileManager createDirectoryAtPath:cachePath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    //在文件夹cachePath的文件vedio.MP4的文件，如果存在就播放
    if ([fileManager fileExistsAtPath:[cachePath stringByAppendingPathComponent:[NSString stringWithFormat:@"vedio.mp4"]]]) {
        
        KKVideoPlayerViewController  *sec=[[KKVideoPlayerViewController alloc]initWithFilm:[cachePath stringByAppendingPathComponent:[NSString stringWithFormat:@"vedio.mp4"]]];
        sec.modalTransitionStyle=UIModalTransitionStyleFlipHorizontal;
        [self presentViewController:sec animated:YES completion:nil];
        
        
    }else{
  
    [musicBt startSpin];
    // 1.创建管理者对象
//    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        
        //默认配置
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
        
        //AFN3.0+基于封住URLSession的句柄
        AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    // 2.设置请求的URL地址
    NSURL *url = [NSURL URLWithString:@"http://static.tripbe.com/videofiles/20121214/9533522808.f4v.mp4"];
    // 3.创建请求对象
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
        
    // 4.下载任务
    _downloadTask = [manager downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress) {
      
        float downProgress =1.0 * downloadProgress.completedUnitCount / downloadProgress.totalUnitCount;
        NSLog(@"=====%f",downProgress);
//        musicBt.progress = downProgress;
      
        dispatch_sync(dispatch_get_main_queue(), ^{
            //Update UI in UI thread here
//        musicBt.progress = 0.7;
          musicBt.progress = downProgress;
            
        });
        
        NSLog(@"当前下载进度为:%lf", 1.0 * downloadProgress.completedUnitCount / downloadProgress.totalUnitCount);
    } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        // 下载地址
        NSLog(@"默认下载地址%@",targetPath);
        // 设置下载路径,通过沙盒获取缓存地址,最后返回NSURL对象
        NSString *filePath = [cachePath stringByAppendingPathComponent:[NSString stringWithFormat:@"vedio.mp4"]];
        return [NSURL fileURLWithPath:filePath]; // 返回的是文件存放在本地沙盒的地址
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        // 下载完成调用的方法
        [musicBt stopSpin];
        NSLog(@"%@---%@", response, filePath);
    }];
    // 5.启动下载任务
    [_downloadTask resume];
        
    }
}
-(void)cacalDown
{
    [_downloadTask cancel];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
