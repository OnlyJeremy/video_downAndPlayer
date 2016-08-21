//
//  MusicFilenameManager.m
//  hotelEnglish
//
//  Created by Jeremy on 16/3/25.
//  Copyright © 2016年 JF. All rights reserved.
//

#import "MusicFilenameManager.h"

@implementation MusicFilenameManager
MusicFilenameManager *fileServiceInstance;
+(instancetype)shareFileManager
{
    if (fileServiceInstance == nil) {
        fileServiceInstance = [[MusicFilenameManager alloc]init];
    }
    return fileServiceInstance;
}
//给文件重新取名
+(NSString*)newRandomFileName
{
    long long ms=[[NSDate date] timeIntervalSince1970]*1000;
    return [NSString stringWithFormat:@"%lld",ms];
}
+(NSString *)cachpath:(NSString *)filename
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *cachesDir = [paths objectAtIndex:0];
    NSString *savepath = [NSString stringWithFormat:@"%@/%@",cachesDir,filename];
    return savepath;
}
@end
