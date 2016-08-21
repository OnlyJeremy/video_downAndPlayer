//
//  JFAppCommonDef.h
//  Video_playback
//
//  Created by Jeremy on 16/8/21.
//  Copyright © 2016年 Jeremy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JFAppCommonDef : NSObject
#ifdef DEBUG
#define NJLog(...) NSLog(__VA_ARGS__)
#else
#define NJLog(...)
#endif

#define KK_COLOR_TABBARBLACK [UIColor colorWithRed:20.0/255.0 green:25.0/255.0 blue:26.0/255.0 alpha:1.0]
#define KK_COLOR_FOOTVIEWBLACK [UIColor colorWithRed:32.0/255.0 green:34.0/255.0 blue:38.0/255.0 alpha:0.9]
#define KK_COLOR_durationSliderBLACK [UIColor colorWithRed:32.0/255.0 green:34.0/255.0 blue:38.0/255.0 alpha:0.1]
#define KK_COLOR_TOPVIEWLABLENAMEBLACK [UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:0.9]
//不同设备的屏幕比例(当然倍数可以自己控制)
#define SizeScale ((SCREEN_HEIGHT < 667) ? SCREEN_HEIGHT/667 : 1)
#define SCREEN_HEIGHT   ([[UIScreen mainScreen] bounds].size.height)
#define SCREEN_WIDTH    ([[UIScreen mainScreen] bounds].size.width)
#define Font(F) [UIFont systemFontOfSize:(F)]


//zip 下载路径
#define HE_SERVER_BASE_ZIPURL @"http://static.tripbe.com/videofiles/20121214/9533522808.f4v.mp4"
#define HE_SERVER_BASE_URL @"http://www.touchdelight.cn/mobileenglish/index.php"
#define HE_SERVER_INTERFACE_COURSEITEM @"Course/item"

@end
