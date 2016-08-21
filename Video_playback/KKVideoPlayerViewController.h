//
//  KKVideoPlayerViewController.h
//  haowan
//
//  Created by AllenLiu on 15/5/2.
//  Copyright (c) 2015年 KK. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>
#import "JFAppCommonDef.h"
@interface KKVideoPlayerViewController : UIViewController
{
    BOOL isPlay;
    BOOL _show;
}
@property (nonatomic, readonly, getter = isShowing) BOOL showing;
@property(strong,nonatomic)UIView *viewplay;
@property(strong,nonatomic)MPVolumeView *volumeView;
@property (nonatomic, assign) NSTimeInterval fadeDelay;
@property (nonatomic, retain) NSString *fileUrl;
-(instancetype)initWithFilm:(NSString*)fileUrl;
@end
