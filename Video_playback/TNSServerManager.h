//
//  TNSServerManager.h
//  Video_playback
//
//  Created by Jeremy on 16/8/21.
//  Copyright © 2016年 Jeremy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "AFNetworking.h"
#import "JFAppCommonDef.h"
@interface TNSServerManager : NSObject
+(instancetype)sharedServer;
-(void)loadingZipWithID:(NSString *)ID success:(void (^)(NSDictionary *))success failure:(void (^)(NSDictionary *))failure;
@end
