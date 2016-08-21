//
//  ZDProgressView.h
//  PE
//
//  Created by 杨志达 on 14-6-20.
//  Copyright (c) 2014年 PE. All rights reserved.
//
#define SCREEN_HEIGHT   ([[UIScreen mainScreen] bounds].size.height)
//不同设备的屏幕比例(当然倍数可以自己控制)
#define SizeScale ((SCREEN_HEIGHT < 667) ? SCREEN_HEIGHT/667 : 1)
#import <UIKit/UIKit.h>

@interface ZDProgressView : UIView

@property (nonatomic,strong) NSString *text;
@property (nonatomic,strong) UIFont *textFont;
@property (nonatomic,assign) CGFloat progress;
@property (nonatomic,assign) NSInteger cornerRadius;
@property (nonatomic,assign) NSInteger borderWidth;

@property (nonatomic,strong) UIColor *noColor;
@property (nonatomic,strong) UIColor *prsColor;


@end
