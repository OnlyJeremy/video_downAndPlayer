//
//  KKVideoPlayerViewController.m
//  haowan
//
//  Created by AllenLiu on 15/5/2.
//  Copyright (c) 2015年 KK. All rights reserved.
//

#import "KKVideoPlayerViewController.h"

#import <MediaPlayer/MediaPlayer.h>
@interface KKVideoPlayerViewController ()
{
    UIButton *_playBtn; //播放按钮
    UIImageView *_image; //播放按钮图片
}
#pragma mark 初始化一个播放器
@property(strong, nonatomic)MPMoviePlayerViewController *playerViewController ;
@property(strong, nonatomic)MPMoviePlayerController  *player;
#pragma mark 通知的播放结束的一个对像
@property(strong, nonatomic) MPMoviePlayerController  *player1;
@property(strong, nonatomic) UIView *footView;
@property (strong, nonatomic) UIView *topView;
@property (strong, nonatomic) UIButton *btnCollect;
@property (strong, nonatomic) UIButton *btnName;
@property(strong, nonatomic)UIButton *btn;
@property(strong, nonatomic)UIButton *btnExit;
@property (nonatomic, strong) NSTimer *durationTimer;
#pragma mark 快进进度条
@property (nonatomic, strong) UISlider *durationSlider;
#pragma mark 快进的lable
@property (nonatomic, strong) UILabel *timeElapsedLabel;
@property (nonatomic, strong) UILabel *timeRemainingLabel;
#pragma mark 进度条的差值
@property (nonatomic) BOOL timeRemainingDecrements;
@property (nonatomic, getter = isShowing) BOOL showing;
@property (nonatomic, assign) int VIEWW;
@property (nonatomic, assign) int VIEWH;
@property (nonatomic, strong) UIImageView *image;

@end

@implementation KKVideoPlayerViewController
@synthesize player,player1,playerViewController;

-(instancetype)initWithFilm:(NSString*)fileUrl
{
    if (self=[super init]) {
        self.fileUrl=fileUrl;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view setBackgroundColor:[UIColor grayColor]];
    [self.view setUserInteractionEnabled:YES];
     self.VIEWW = self.view.frame.size.width;
     self.VIEWH = self.view.frame.size.height;
  _fadeDelay = 4.0;
    //控制条
    [self footview];
    [self topview];
    // 播放
    [self Btnplay];
    //退出
    [self btnexit];
    [self labviewName];
    [self btncollect];
    //声音条
    [self volumeview];
    [self volumeImage];
    //快进的进度条
    [self durationslider];
    //快进开始的lable
    [self timeelapsedLabel];
    //快进结束的lable
    [self timeremaininglabel];
    

        //开始播放
    [self MoverPlay];
}
-(void)durationslider
{
    _durationSlider = [[UISlider alloc] init];
    _durationSlider.value = 0.f;
    _durationSlider.continuous = YES;
        [_durationSlider addTarget:self action:@selector(durationSliderValueChanged:) forControlEvents:UIControlEventValueChanged];
    [_durationSlider addTarget:self action:@selector(durationSliderTouchBegan:) forControlEvents:UIControlEventTouchDown];
//    [_durationSlider addTarget:self action:@selector(durationSliderTouchEnded1:) forControlEvents:UIControlEventTouchUpOutside];
    [_durationSlider addTarget:self action:@selector(durationSliderValueChanged:) forControlEvents:UIControlEventValueChanged];
      [_durationSlider addTarget:self action:@selector(durationSliderTouchEnded:) forControlEvents:UIControlEventTouchUpInside];
    //_durationSlider.backgroundColor=[UIColor redColor];
    [_durationSlider setThumbImage:[UIImage imageNamed:@"1bf_tuodong.png"] forState:UIControlStateNormal];
    [_durationSlider setBackgroundColor:KK_COLOR_durationSliderBLACK];
    _durationSlider.frame=CGRectMake(self.btn.frame.origin.x+self.btn.frame.size.height+18,self.footView.frame.size.height/2-10, self.VIEWH/2, 20);
    NSLog(@"%f",self.btn.frame.origin.x);
}
-(void)timeelapsedLabel
{
    _timeElapsedLabel = [[UILabel alloc] init];
    
    _timeElapsedLabel.font = [UIFont systemFontOfSize:11.f];
    _timeElapsedLabel.textColor = [UIColor whiteColor];
    _timeElapsedLabel.textAlignment = NSTextAlignmentRight;
    _timeElapsedLabel.text = @"0:00/";
    _timeElapsedLabel.layer.shadowColor = [UIColor blackColor].CGColor;
    _timeElapsedLabel.layer.shadowRadius = 1.f;
    _timeElapsedLabel.layer.shadowOffset = CGSizeMake(1.f, 1.f);
    _timeElapsedLabel.layer.shadowOpacity = 0.8f;
    _timeElapsedLabel.frame=CGRectMake(self.durationSlider.frame.origin.x+self.durationSlider.frame.size.width+2,self.footView.frame.size.height/2-15, 40, 30);
    _timeElapsedLabel.backgroundColor=KK_COLOR_durationSliderBLACK;
    //_timeElapsedLabel.backgroundColor = [UIColor redColor];
}
-(void)timeremaininglabel
{
    _timeRemainingLabel = [[UILabel alloc] init];
    _timeRemainingLabel.font = [UIFont systemFontOfSize:11.f];
    _timeRemainingLabel.textColor = [UIColor whiteColor];
    _timeRemainingLabel.textAlignment = NSTextAlignmentLeft;
    _timeRemainingLabel.text = @"0:00";
    _timeRemainingLabel.layer.shadowColor = [UIColor blackColor].CGColor;
    _timeRemainingLabel.layer.shadowRadius = 1.f;
    _timeRemainingLabel.layer.shadowOffset = CGSizeMake(1.f, 1.f);
    _timeRemainingLabel.layer.shadowOpacity = 0.8f;
    _timeRemainingLabel.backgroundColor=KK_COLOR_durationSliderBLACK;
    _timeRemainingLabel.frame=CGRectMake(self.timeElapsedLabel.frame.origin.x+self.timeElapsedLabel.frame.size.width, self.footView.frame.size.height/2-15, 30, 30);
}
-(void)Btnplay
{
    self.btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.btn setBackgroundColor:[UIColor clearColor]];
    
    [self.btn setFrame:CGRectMake(self.VIEWH/26, self.footView.frame.size.height/2-17, 35 , 35)];
    //self.btn.center = CGPointMake(self.VIEWH/26+9, self.footView.frame.size.height/2);
    [self.btn setImage:[UIImage imageNamed:@"1bf_bofang.png"] forState:UIControlStateNormal];
    [self.btn addTarget:self action:@selector(play) forControlEvents:UIControlEventTouchUpInside];
    self.btn.alpha=1.f;
}
-(void)btncollect
{
    self.btnCollect = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.btnCollect setFrame:CGRectMake(self.VIEWH-45,self.topView.frame.size.height/2-13, 26, 26)];
    [self.btnCollect setImage:[UIImage imageNamed:@"1bf_fenxiang.png"] forState:UIControlStateNormal];
    [self.btnCollect addTarget:self action:@selector(touchFavorite) forControlEvents:UIControlEventTouchUpInside];
}
-(void)touchFavorite
{
    
   
}


-(void)btnexit
{
    self.btnExit = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.btnExit setTitle:@"退出" forState:UIControlStateNormal];
//    [self.btnExit setBackgroundColor:[UIColor clearColor]];
    [self.btnExit setFrame:CGRectMake(20, self.topView.frame.size.height/2-10, 50 , 21)];
    [self.btnExit setImage:[UIImage imageNamed:@"vidio_back_ios.png"] forState:UIControlStateNormal];
    [self.btnExit setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
   
    [self.btnExit.titleLabel setFont:Font(17*SizeScale)];
    [self.btnExit addTarget:self action:@selector(btnExit:) forControlEvents:UIControlEventTouchUpInside];
}
-(void)labviewName
{
    self.btnName = [[UIButton alloc]initWithFrame:CGRectMake(self.btnExit.frame.origin.x+self.btnExit.frame.size.width+10, self.topView.frame.size.height/2-15, self.view.frame.size.height/2, 30)];
    NSLog(@"%f, %f",self.btnName.frame.origin.x, self.btnName.frame.size.width);
    self.btnName.titleLabel.textAlignment=NSTextAlignmentLeft;
//    self.btnName.text = @"电影名";
//    self.btnName.textAlignment = 1;
//    self.btnName.textColor = KK_COLOR_TOPVIEWLABLENAMEBLACK ;

    [self.btnName setTitleColor:KK_COLOR_TOPVIEWLABLENAMEBLACK forState:UIControlStateNormal];
    self.btnName.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    self.btnName.backgroundColor=[UIColor clearColor];
    [self.btnName addTarget:self action:@selector(btnExit:) forControlEvents:UIControlEventTouchUpInside];
    
    
}
-(void)topview
{
    self.topView=[[UIView alloc]initWithFrame:CGRectMake(0,0,self.VIEWH,self.VIEWW/6)];
    // self.footView.backgroundColor=[UIColor whiteColor];
    [self.topView setBackgroundColor:KK_COLOR_FOOTVIEWBLACK];
}
-(void)footview
{
#pragma mark footView
    self.footView=[[UIView alloc]initWithFrame:CGRectMake(0,self.VIEWW-self.VIEWW/6,self.VIEWH, self.VIEWW/6)];
   // self.footView.backgroundColor=[UIColor whiteColor];
    [self.footView setBackgroundColor:KK_COLOR_FOOTVIEWBLACK];
}
-(void)volumeview
{
    //#pragma mark 声音条
    self.volumeView = [[MPVolumeView alloc]init];
    [self.volumeView setShowsVolumeSlider:YES];
    [self.volumeView setShowsRouteButton:NO];
    [self.volumeView setVolumeThumbImage:[UIImage imageNamed:@"yinliang_tab.png"] forState:UIControlStateNormal];
    [self.volumeView setBackgroundColor:KK_COLOR_durationSliderBLACK];
    self.volumeView.frame=CGRectMake(self.footView.frame.size.width-self.VIEWH/8-5, self.footView.frame.size.height/2-10, self.VIEWH/8, 20);
    self.volumeView.alpha=1.f;
}
-(void)volumeImage
{
    self.image = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"1bf_shengying.png"]];
    self.image.frame=CGRectMake(self.footView.frame.size.width-self.VIEWH/8-28, self.footView.frame.size.height/2-7, 17, 14);
    NSLog(@"%f",self.timeRemainingLabel.frame.origin.y);
    
}
- (void)MoverPlay
{
   

    
        playerViewController = [[MPMoviePlayerViewController alloc]initWithContentURL:[NSURL fileURLWithPath:self.fileUrl]];
        
        playerViewController.view.frame=CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height);
    
        
        [playerViewController.moviePlayer setRepeatMode:MPMovieRepeatModeNone];
        playerViewController.moviePlayer.scalingMode= MPMovieScalingModeAspectFill;
        //没有任何样式
        [playerViewController.moviePlayer setControlStyle:MPMovieControlStyleNone];
        [self addNotification];
        [self.footView addSubview:self.durationSlider];
        [self.footView addSubview:_timeRemainingLabel];
        [self.footView addSubview:_timeElapsedLabel];
        
        [self.footView addSubview:self.image];

        [self.footView addSubview:self.volumeView];
        [self.footView addSubview:self.btn];
        [self.footView addSubview:self.image];
        [self.topView addSubview:self.btnCollect];
        [self.topView addSubview:self.btnExit];
        [self.topView addSubview:self.btnName];
        [self.footView addSubview:self.image];

        [playerViewController.view addSubview:self.footView];
        [playerViewController.view addSubview:self.topView];
        [self.view addSubview:playerViewController.view];
        
//        UITapGestureRecognizer *tapviewFootview = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapgestureViewFootview)];
//        [self.footView addGestureRecognizer:tapviewFootview];
//        UITapGestureRecognizer *tapviewTopview = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapgestureViewTopview)];
//        [self.topView addGestureRecognizer:tapviewTopview];
    

        
        //---play movie---
#pragma mark 播放器的一个属性 player 对象
        player = [playerViewController moviePlayer];
        [player play];
        _showing = YES;
        
        [self hideControls:^{
        }];
        self.timeRemainingDecrements=NO;
        [self playStarSliderChange];
        [self hideStatusBar];
        
    }
-(void)addNotification
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(movieFinishedCallback:)
                                                 name:MPMoviePlayerPlaybackDidFinishNotification
                                               object:[playerViewController moviePlayer]];
}
-(BOOL)prefersStatusBarHidden
{
    return YES;
}
-(void)showStatusBar
{
    if ([self respondsToSelector:@selector(setNeedsStatusBarAppearanceUpdate)]) {
        [self prefersStatusBarHidden];
        [self setNeedsStatusBarAppearanceUpdate];
    }
}
-(void)hideStatusBar
{
    if ([self respondsToSelector:@selector(setNeedsStatusBarAppearanceUpdate)]) {
        [self prefersStatusBarHidden];
        [self setNeedsStatusBarAppearanceUpdate];
    }
}

- (void) movieFinishedCallback:(NSNotification*) aNotification {
    player1 = [aNotification object];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:MPMoviePlayerPlaybackDidFinishNotification object:player1];
    [player1 stop];
     [self.durationTimer invalidate];
    [player setCurrentPlaybackTime:0.0];
    [playerViewController.view removeFromSuperview];
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark 退出按钮
-(void)btnExit:btn
{
    [player stop];

    
    [playerViewController.view removeFromSuperview];
    [self dismissViewControllerAnimated:NO completion:nil];
}
-(void)play
{
    //根据视频播放状态，点击视频，出现播放按钮图片或者隐藏
    if (player && player.playbackState == MPMoviePlaybackStatePlaying ) {
        [player pause];
        //self.btn.alpha=1;
        [self.btn setImage:[UIImage imageNamed:@"1bf_zanting.png"] forState:UIControlStateNormal];
        return;
    }else if (player && player.playbackState == MPMoviePlaybackStatePaused) {
        //self.btn.alpha=0.1;
        [self.btn setImage:[UIImage imageNamed:@"1bf_bofang.png"] forState:UIControlStateNormal];
        [player play];
        return;
    }
}
#pragma mark 进度条 按下时暂停
- (void)durationSliderTouchBegan:(UISlider *)slider {
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(hideControls:) object:nil];
//    [player pause];
     NJLog(@"暂停");
}


#pragma mark 进度条 起来时播放
- (void)durationSliderTouchEnded:(UISlider *)slider {
    NJLog(@"播放");
//    [player  play];
    NJLog(@"开启定时器");
    //    开启定时器
            [self.durationTimer setFireDate:[NSDate distantPast]];
    [player setCurrentPlaybackTime:floor(slider.value)];
        [self performSelector:@selector(hideControls:) withObject:nil afterDelay:_fadeDelay];
}
#pragma mark 开始播放时就启动这个方法
-(void)playStarSliderChange
{
    double delayInSeconds = 1;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [self setDurationSliderMaxMinValues];
        [self monitorMoviePlayback]; //resume values
        [self startDurationTimer];
        _showing=NO;
    });
}
#pragma mark 滑动进度条
- (void)durationSliderValueChanged:(UISlider *)slider {
    //关闭定时器
    [self.durationTimer setFireDate:[NSDate distantFuture]];
    
    double currentTime = floor(slider.value);
    double totalTime = floor(player.duration);
    [self setTimeLabelValues:currentTime totalTime:totalTime];
}
- (void)setDurationSliderMaxMinValues {
    CGFloat duration = self.player.duration;
    self.durationSlider.minimumValue = 0.f;
    self.durationSlider.maximumValue = duration;
}
- (void)startDurationTimer {
    self.durationTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(monitorMoviePlayback) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:self.durationTimer forMode:NSDefaultRunLoopMode];
}
#pragma 进度条的进度时时等于视频的系统进度
- (void)monitorMoviePlayback {
    

    double currentTime = floor(player.currentPlaybackTime);
    double totalTime = floor(player.duration);
    [self setTimeLabelValues:currentTime totalTime:totalTime];
    self.durationSlider.value = ceil(currentTime);
    
}

- (void)setTimeLabelValues:(double)currentTime totalTime:(double)totalTime {
    double minutesElapsed = floor(currentTime / 60.0);
    double secondsElapsed = fmod(currentTime, 60.0);
    self.timeElapsedLabel.text = [NSString stringWithFormat:@"%.0f:%02.0f/", minutesElapsed, secondsElapsed];
    
    double minutesRemaining;
    double secondsRemaining;
    if (self.timeRemainingDecrements) {
        minutesRemaining = floor((totalTime - currentTime) / 60.0);
        secondsRemaining = fmod((totalTime - currentTime), 60.0);
    } else {
        minutesRemaining = floor(totalTime / 60.0);
        secondsRemaining = floor(fmod(totalTime, 60.0));
    }
    self.timeRemainingLabel.text = self.timeRemainingDecrements ? [NSString stringWithFormat:@"-%.0f:%02.0f", minutesRemaining, secondsRemaining] : [NSString stringWithFormat:@"%.0f:%02.0f", minutesRemaining, secondsRemaining];
    


}


//-(void)longpressTouchdown
//{
//    
//}
//
//-(void)tapgestureViewFootview
//{
//    NSLog(@"ff");
//
//}
//-(void)tapgestureViewTopview
//{
//    NSLog(@"gg");
//}

//-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
//{
//    NSLog(@"开始点击");
//    
//    
//}
-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSLog(@"点击结束");
    self.isShowing ? [self hideControls:nil] : [self showControls:nil];
    if (self.showing) {
        [self hideControls:nil];
    }
    else
    {
        [self showControls:nil];
    }
    
}


#pragma  mark  再次点击控制栏消失
- (void)hideControls:(void(^)(void))completion {
    if (self.isShowing) {
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(hideControls:) object:nil];
        [UIView animateWithDuration:0.3 delay:0.0 options:0 animations:^{
            self.footView.alpha = 0.f;
            self.topView.alpha = 0.f;
        } completion:^(BOOL finished) {
            _showing = NO;
            if (completion)
                completion();
        }];
    } else {
        if (completion)
            completion();
        
    }
}

- (void)showControls:(void(^)(void))completion {
    if (!self.isShowing) {
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(hideControls:) object:nil];
        
        [self.footView setNeedsDisplay];
        [self.topView setNeedsDisplay];
        
        [UIView animateWithDuration:0.3 delay:0.0 options:0 animations:^{
#pragma mark 测试
            self.footView.alpha = 1.f;
            self.topView.alpha = 1.f;
            
        } completion:^(BOOL finished) {
            _showing = YES;
            if (completion)
                completion();
            [self performSelector:@selector(hideControls:) withObject:nil afterDelay:_fadeDelay];
        }];
    } else {
        if (completion)
            completion();
        
    }
}

- (BOOL)shouldAutorotate
{
    return NO;
}

-(UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    return UIInterfaceOrientationLandscapeRight;
}

-(NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskLandscapeRight;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
