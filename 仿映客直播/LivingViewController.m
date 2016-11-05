//
//  LivingViewController.m
//  仿映客直播
//
//  Created by xxxxx on 16/11/5.
//  Copyright © 2016年 hst. All rights reserved.
//

#import "LivingViewController.h"
#import <IJKMediaFramework/IJKMediaFramework.h>
#import "Masonry.h"

@interface LivingViewController ()
{
    IJKFFMoviePlayerController *_moviePlayerController;
    UIButton *_backButton;
}


@end

@implementation LivingViewController

#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor whiteColor];
    
    // 1.拉流预备
    [self prepareToPull];
    
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
    self.navigationController.navigationBar.hidden = YES;
    // 关掉侧滑返回
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    
    // 2.创建UI控件
    [self initUIControl];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.tabBarController.tabBar.hidden = NO;
    self.navigationController.navigationBar.hidden = NO;
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    [_backButton removeFromSuperview];
}

#pragma mark - 拉流
- (void)prepareToPull
{
    /*
     iOS8系统支持硬解码.
     
     软解码：CPU
     硬解码: 显卡的GPU, 硬解码可以避免手机发烫。
     */
    
    IJKFFOptions *options = [IJKFFOptions optionsByDefault];
    // 开启硬解码
    [options setPlayerOptionIntValue:1 forKey:@"videotoolbox"];
    
    _moviePlayerController = [[IJKFFMoviePlayerController alloc] initWithContentURLString:self.model.flv withOptions:options];
    
    _moviePlayerController.scalingMode = IJKMPMovieScalingModeAspectFit;
    _moviePlayerController.view.frame = self.view.bounds;
    
    [self.view addSubview:_moviePlayerController.view];
    
    // 开始拉流
    [_moviePlayerController prepareToPlay];
    [_moviePlayerController play];
    
    // 启动通知
    [self installMovieNotificationObservers];
}

#pragma mark - 创建UI控件
- (void)initUIControl
{
    // 创建返回按钮
    [self initBackButton];
}

- (void)initBackButton
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *image = [UIImage imageNamed:@"messagechat_pop_back"];
    
    [btn setBackgroundImage:image forState:UIControlStateNormal];
    btn.backgroundColor = [UIColor blackColor];
    btn.alpha = 0.2;
    btn.frame = CGRectMake(self.view.bounds.size.width - 70, self.view.bounds.size.height - 70, 50, 50);
    btn.layer.cornerRadius = 25;
    btn.clipsToBounds = YES;
    [btn addTarget:self action:@selector(navigationPop) forControlEvents:UIControlEventTouchUpInside];
    [self.tabBarController.view addSubview:btn];
    _backButton = btn;
}

- (void)navigationPop
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)dealloc
{
    
    //关闭拉流
    [_moviePlayerController shutdown];
    
    //移除通知
    [self removeMovieNotificationObservers];
}

#pragma mark - 通知方法
- (void)loadStateDidChange:(NSNotification*)notification {
    IJKMPMovieLoadState loadState = _moviePlayerController.loadState;
    
    ////状态为缓冲几乎完成，可以连续播放
    if ((loadState & IJKMPMovieLoadStatePlaythroughOK) != 0) {
        NSLog(@"LoadStateDidChange: IJKMovieLoadStatePlayThroughOK: %d\n",(int)loadState);
    }
    ////缓冲中
    else if ((loadState & IJKMPMovieLoadStateStalled) != 0) {
        /*
         这里主播可能已经结束直播了。我们需要请求服务器查看主播是否已经结束直播。
         方法：
         1、从服务器获取主播是否已经关闭直播。
         优点：能够正确的获取主播端是否正在直播。
         缺点：主播端异常crash的情况下是没有办法通知服务器该直播关闭的。
         2、用户http请求该地址，若请求成功表示直播未结束，否则结束
         优点：能够真实的获取主播端是否有推流数据
         缺点：如果主播端丢包率太低，但是能够恢复的情况下，数据请求同样是失败的。
         */
        NSLog(@"loadStateDidChange: IJKMPMovieLoadStateStalled: %d\n", (int)loadState);
        
    } else {
        NSLog(@"loadStateDidChange: ???: %d\n", (int)loadState);
    }
}
- (void)moviePlayBackFinish:(NSNotification*)notification {
    int reason =[[[notification userInfo] valueForKey:IJKMPMoviePlayerPlaybackDidFinishReasonUserInfoKey] intValue];
    switch (reason) {
        case IJKMPMovieFinishReasonPlaybackEnded:
            NSLog(@"playbackStateDidChange: IJKMPMovieFinishReasonPlaybackEnded: %d\n", reason);
            break;
            
        case IJKMPMovieFinishReasonUserExited:
            NSLog(@"playbackStateDidChange: IJKMPMovieFinishReasonUserExited: %d\n", reason);
            break;
            
        case IJKMPMovieFinishReasonPlaybackError:
            NSLog(@"playbackStateDidChange: IJKMPMovieFinishReasonPlaybackError: %d\n", reason);
            break;
            
        default:
            NSLog(@"playbackPlayBackDidFinish: ???: %d\n", reason);
            break;
    }
}
- (void)mediaIsPreparedToPlayDidChange:(NSNotification*)notification {
    //NSLog(@"mediaIsPrepareToPlayDidChange\n");
}
- (void)moviePlayBackStateDidChange:(NSNotification*)notification {
    
#if 0
    //    NSLog(@"%@",notification);
    //    IJKMPMoviePlaybackStateStopped,        停止
    //    IJKMPMoviePlaybackStatePlaying,        正在播放
    //    IJKMPMoviePlaybackStatePaused,         暂停
    //    IJKMPMoviePlaybackStateInterrupted,    打断
    //    IJKMPMoviePlaybackStateSeekingForward, 快进
    //    IJKMPMoviePlaybackStateSeekingBackward 快退
    
    
    switch (self.player.playbackState) {
        case IJKMPMoviePlaybackStateStopped:
            NSLog(@"停止");
            break;
        case IJKMPMoviePlaybackStatePlaying:
            NSLog(@"正在播放");
            break;
        case IJKMPMoviePlaybackStatePaused:
            NSLog(@"暂停");
            break;
        case IJKMPMoviePlaybackStateInterrupted:
            NSLog(@"打断");
            break;
        case IJKMPMoviePlaybackStateSeekingForward:
            NSLog(@"快进");
            break;
        case IJKMPMoviePlaybackStateSeekingBackward:
            NSLog(@"快退");
            break;
        default:
            break;
    }
#endif
    
    switch (_moviePlayerController.playbackState) {
        case IJKMPMoviePlaybackStateStopped:
            NSLog(@"IJKMPMoviePlayBackStateDidChange %d: stoped", (int)_moviePlayerController.playbackState);
            break;
            
        case IJKMPMoviePlaybackStatePlaying:
            NSLog(@"IJKMPMoviePlayBackStateDidChange %d: playing", (int)_moviePlayerController.playbackState);
            break;
            
        case IJKMPMoviePlaybackStatePaused:
            NSLog(@"IJKMPMoviePlayBackStateDidChange %d: paused", (int)_moviePlayerController.playbackState);
            break;
            
        case IJKMPMoviePlaybackStateInterrupted:
            NSLog(@"IJKMPMoviePlayBackStateDidChange %d: interrupted", (int)_moviePlayerController.playbackState);
            break;
            
        case IJKMPMoviePlaybackStateSeekingForward:
        case IJKMPMoviePlaybackStateSeekingBackward: {
            NSLog(@"IJKMPMoviePlayBackStateDidChange %d: seeking", (int)_moviePlayerController.playbackState);
            break;
        }
            
        default: {
            NSLog(@"IJKMPMoviePlayBackStateDidChange %d: unknown", (int)_moviePlayerController.playbackState);
            break;
        }
    }
}


#pragma Install Notifiacation
- (void)installMovieNotificationObservers {
    
    /*
     IJKFFMoviePlayerController 支持的通知有很多,常见的有:
     
     IJKMPMoviePlayerLoadStateDidChangeNotification(加载状态改变通知)
     IJKMPMoviePlayerPlaybackDidFinishNotification(播放结束通知)
     IJKMPMoviePlayerPlaybackStateDidChangeNotification(播放状态改变通知)
     */
    
    //监听加载状态改变通知
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(loadStateDidChange:)
                                                 name:IJKMPMoviePlayerLoadStateDidChangeNotification
                                               object:_moviePlayerController];
    //播放结束通知
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(moviePlayBackFinish:)
                                                 name:IJKMPMoviePlayerPlaybackDidFinishNotification
                                               object:_moviePlayerController];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(mediaIsPreparedToPlayDidChange:)
                                                 name:IJKMPMediaPlaybackIsPreparedToPlayDidChangeNotification
                                               object:_moviePlayerController];
    //播放状态改变通知
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(moviePlayBackStateDidChange:)
                                                 name:IJKMPMoviePlayerPlaybackStateDidChangeNotification
                                               object:_moviePlayerController];
    
}
- (void)removeMovieNotificationObservers {
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:IJKMPMoviePlayerLoadStateDidChangeNotification
                                                  object:_moviePlayerController];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:IJKMPMoviePlayerPlaybackDidFinishNotification
                                                  object:_moviePlayerController];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:IJKMPMediaPlaybackIsPreparedToPlayDidChangeNotification
                                                  object:_moviePlayerController];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:IJKMPMoviePlayerPlaybackStateDidChangeNotification
                                                  object:_moviePlayerController];
    
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
