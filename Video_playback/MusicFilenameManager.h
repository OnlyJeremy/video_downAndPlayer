//
//  MusicFilenameManager.h
//  hotelEnglish
//
//  Created by Jeremy on 16/3/25.
//  Copyright © 2016年 JF. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MusicFilenameManager : NSObject
+(instancetype)shareFileManager;
+(NSString*)newRandomFileName;
+(NSString*)cachpath:(NSString*)filename;
@end
