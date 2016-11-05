//
//  AnchorViewController.m
//  仿映客直播
//
//  Created by xxxxx on 16/11/5.
//  Copyright © 2016年 hst. All rights reserved.
//

#import "AnchorViewController.h"
#import "LFLiveKit.h"

@interface AnchorViewController ()<LFLiveSessionDelegate>

/** 推流 */
@property (nonatomic, strong) LFLiveSession *session;

/** 显示视频流的视图 */
@property (nonatomic, weak) UIView *livingView;

@end

@implementation AnchorViewController

- (UIView *)livingView
{
    if (!_livingView)
    {
        UIView *livingView = [[UIView alloc] initWithFrame:self.view.bounds];
        livingView.backgroundColor = [UIColor clearColor];
        livingView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [self.view addSubview:livingView];
        _livingView = livingView;
    }
    return _livingView;
}

- (LFLiveSession *)session
{
    if (!_session)
    {
        _session = [[LFLiveSession alloc] initWithAudioConfiguration:[LFLiveAudioConfiguration defaultConfiguration] videoConfiguration:[LFLiveVideoConfiguration defaultConfigurationForQuality:LFLiveVideoQuality_Medium2] liveType:LFLiveRTMP];
        
        _session.delegate = self;
        _session.running = YES;
        _session.preView = self.livingView;
    }
    return _session;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    // 开始直播
    LFLiveStreamInfo *stream = [[LFLiveStreamInfo alloc] init];
    // 推流的服务器地址
    stream.url = @"rtmp://192.168.1.102:1935/rtmplive/room";
    // 开始推流
    [self.session startLive:stream];
    
    //初始化UI
    [self initUI];
}

- (void)initUI
{
    /**
     *  切换前后摄像头
     */
    UIButton *switchCamareButton = [UIButton buttonWithType:UIButtonTypeCustom];
    switchCamareButton.frame = CGRectMake(20, self.view.frame.size.height - 100, 120, 50);
    [switchCamareButton setTitle:@"切换摄像头" forState:UIControlStateNormal];
    [switchCamareButton addTarget:self action:@selector(switchCamareButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:switchCamareButton];
    
    
    UIButton *beautifulButton = [UIButton buttonWithType:UIButtonTypeCustom];
    beautifulButton.frame = CGRectMake(180, self.view.frame.size.height - 100, 120, 50);
    [beautifulButton setTitle:@"启动美颜" forState:UIControlStateNormal];
    [beautifulButton setTitle:@"关闭美颜" forState:UIControlStateSelected];
    [beautifulButton addTarget:self action:@selector(beautifulButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:beautifulButton];
}

- (void)dealloc
{
    [self.session stopLive];
}

#pragma mark - 是否启动美颜
- (void)beautifulButtonClick:(UIButton *)btn
{
    btn.selected = !btn.selected;
    
    if (btn.selected)
    {
        //启动美颜
        self.session.beautyFace = YES;
    }
    else
    {
        //关闭美颜
        self.session.beautyFace = NO;
    }
}

#pragma mark - 摄像头切换
- (void)switchCamareButtonClick:(UIButton *)btn
{
    btn.selected = !btn.selected;
    
    //后置
    if (btn.selected)
    {
        self.session.captureDevicePosition = AVCaptureDevicePositionBack;
    }
    //前置
    else
    {
        self.session.captureDevicePosition = AVCaptureDevicePositionFront;
    }
}

#pragma mark -- LFStreamingSessionDelegate
/*
- (void)liveSession:(nullable LFLiveSession *)session liveStateDidChange:(LFLiveState)state
{
    NSString *tempStatus;
    switch (state)
    {
        case LFLiveReady:
            tempStatus = @"准备中";
            break;
        case LFLivePending:
            tempStatus = @"连接中";
            break;
        case LFLiveStart:
            tempStatus = @"已连接";
            break;
        case LFLiveStop:
            tempStatus = @"已断开";
            break;
        case LFLiveError:
            tempStatus = @"连接出错";
            break;
        default:
            break;
    }
}
 */

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
