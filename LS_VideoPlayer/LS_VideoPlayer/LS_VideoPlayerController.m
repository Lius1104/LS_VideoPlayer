//
//  LS_VideoPlayerController.m
//  LS_VideoPlayer
//
//  Created by Mac on 16/7/27.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import "LS_VideoPlayerController.h"
#import "LS_PlayerControlView.h"
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>

#define BigPx       self.view.bounds.size.width > self.view.bounds.size.height ? self.view.bounds.size.width : self.view.bounds.size.height
#define SmallPx     self.view.bounds.size.width < self.view.bounds.size.height ? self.view.bounds.size.width : self.view.bounds.size.height

typedef enum : NSInteger {
    PanDirectionHorizontal,//水平
    PanDirectionVertical//竖直
}PanDirection;

typedef enum : NSInteger {
    PanStartFromLeft,
    PanStartFromRight
}PanStartFrom;

@interface LS_VideoPlayerController ()<UIGestureRecognizerDelegate>

@property (nonatomic, strong) AVPlayer *player;
@property (nonatomic, strong) AVPlayerItem *playerItem;
@property (nonatomic, strong) AVPlayerLayer *playerLayer;

@property (nonatomic, strong) LS_PlayerControlView *controlView;
@property (nonatomic, strong) UIActivityIndicatorView *indicator;

@property (nonatomic, strong) UIPanGestureRecognizer *pan;
@property (nonatomic, assign) PanDirection direction;
@property (nonatomic, assign) PanStartFrom panFrom;

@property (nonatomic, assign) BOOL isDragSlider;
@property (nonatomic, strong) NSNumber *orientationValue;
@property (nonatomic, assign) BOOL enterForeground;

@end

@implementation LS_VideoPlayerController

#pragma mark - lazy load
- (AVPlayer *)player {
    if (!_player) {
        _player = [[AVPlayer alloc] initWithPlayerItem:self.playerItem];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(moviePlayDidEnd:) name:AVPlayerItemDidPlayToEndTimeNotification object:_player.currentItem];
    }
    return _player;
}

- (AVPlayerItem *)playerItem {
    if (!_playerItem) {
        _playerItem = [[AVPlayerItem alloc] initWithURL:[NSURL URLWithString:self.videoURL]];
        [_playerItem addObserver:self forKeyPath:@"PlayerStatus" options:NSKeyValueObservingOptionNew context:nil];
        [_playerItem addObserver:self forKeyPath:@"LoadedTimeRange" options:NSKeyValueObservingOptionNew context:nil];
    }
    return _playerItem;
}

- (AVPlayerLayer *)playerLayer {
    if (!_playerLayer) {
        _playerLayer = [AVPlayerLayer playerLayerWithPlayer:self.player];
        _playerLayer.videoGravity = AVLayerVideoGravityResize;
    }
    return _playerLayer;
}

- (UIActivityIndicatorView *)indicator {
    if (!_indicator) {
        _indicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
        _indicator.center = self.view.center;
        [self.view addSubview:_indicator];
    }
    return _indicator;
}

- (UIPanGestureRecognizer *)pan {
    if (!_pan) {
        _pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanInView:)];
        _pan.delegate = self;
    }
    return _pan;
}

#pragma mark - View Controller Method
- (void)viewDidDisappear:(BOOL)animated {
    [self.player pause];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor orangeColor];
    [self.view.layer insertSublayer:self.playerLayer atIndex:1];
    self.orientationValue = [NSNumber numberWithInt:UIInterfaceOrientationLandscapeRight];
    self.enterForeground = YES;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(InterfaceOrientation:) name:UIApplicationDidChangeStatusBarOrientationNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(WillChangeInterfaceOrientation:) name:UIApplicationWillChangeStatusBarOrientationNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidEnterBackground:) name:UIApplicationWillResignActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationEnterForeground:) name:UIApplicationDidBecomeActiveNotification object:nil];
    
    self.controlView = [[LS_PlayerControlView alloc] initWithFrame:self.view.bounds Title:@"迪士尼小短片--章鱼"];
    self.controlView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:_controlView];
    [self setControlViewContrains];
    
    [self addTargetAction];
    
    [self setTimeAndProgress];
    [self.player play];
}

- (void)setControlViewContrains {
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_controlView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeft multiplier:1 constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_controlView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1 constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_controlView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeWidth multiplier:1 constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_controlView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeHeight multiplier:1 constant:0]];
}

- (void)setTimeAndProgress {
    __weak typeof(self) weakSelf = self;
    [self.player addPeriodicTimeObserverForInterval:CMTimeMake(1.0, 1.0) queue:dispatch_get_main_queue() usingBlock:^(CMTime time) {
        if (weakSelf.isDragSlider) {
            return;
        }
        CGFloat current = CMTimeGetSeconds(time);
        CGFloat total = CMTimeGetSeconds(weakSelf.playerItem.duration);
        //设置滑块的位置
        if (current) {
            [weakSelf.controlView.progressSlider setValue:(current/total) animated:YES];
        }
        weakSelf.controlView.alreadyTimeLab.text = [weakSelf secondsConvertToTime:current];
        weakSelf.controlView.totalTimeLab.text = [weakSelf secondsConvertToTime:total];
    }];
}

#pragma mark - Target Action
- (void)addTargetAction {
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hidesOrShowControlView:)];
    [self.controlView addGestureRecognizer:tap];
    
    [self.controlView addGestureRecognizer:self.pan];
    
    [self.controlView.backBtn addTarget:self action:@selector(backLastPage:) forControlEvents:UIControlEventTouchUpInside];
    [self.controlView.moreBtn addTarget:self action:@selector(showMoreView:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.controlView.startStopBtn addTarget:self action:@selector(StartOrStop:) forControlEvents:UIControlEventTouchUpInside];
    
    //slider 开始滑动
    [self.controlView.progressSlider addTarget:self action:@selector(sliderBeginSlide:) forControlEvents:UIControlEventTouchDown];
    //slider 值改变
    [self.controlView.progressSlider addTarget:self action:@selector(sliderValueChange:) forControlEvents:UIControlEventValueChanged];
    //slider 结束滑动
    [self.controlView.progressSlider addTarget:self action:@selector(sliderEndSlide:) forControlEvents:UIControlEventTouchCancel | UIControlEventTouchUpOutside | UIControlEventTouchUpInside];
    
    
    [self.controlView.downloadBtn addTarget:self action:@selector(DownloadVideo:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.controlView.tvBtn addTarget:self action:@selector(ToTV:) forControlEvents:UIControlEventTouchUpInside];
    [self.controlView.screenshotBtn addTarget:self action:@selector(GetScreenShot:) forControlEvents:UIControlEventTouchUpInside];
    [self.controlView.lockingBtn addTarget:self action:@selector(LockScreen:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.controlView.collectBtn addTarget:self action:@selector(CollectVideo:) forControlEvents:UIControlEventTouchUpInside];
    [self.controlView.shareBtn addTarget:self action:@selector(ShareVideo:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.controlView.volumeSlider addTarget:self action:@selector(VolumeValueChange:) forControlEvents:UIControlEventValueChanged];

    [self.controlView.brightSlider addTarget:self action:@selector(BrightnessValueChange:) forControlEvents:UIControlEventValueChanged];
    
    UITapGestureRecognizer *tapMore = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(touchMoreView:)];
    [self.controlView.moreView addGestureRecognizer:tapMore];
}

- (void)backLastPage:(UIButton *)sender {
    LSLog(@"点击了返回按钮");
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)showMoreView:(UIButton *)sender {
    LSLog(@"点击了更多按钮");
    sender.selected = !sender.selected;
    self.controlView.moreView.hidden = !sender.selected;
}

- (void)StartOrStop:(UIButton *)sender {
    sender.selected = !sender.selected;
    LSLog(@"点击播放/暂停按钮");
    if (sender.selected) {
        [self.player pause];
    } else {
        [self.player play];
    }
}

- (void)DownloadVideo:(UIButton *)sender {
    LSLog(@"点击了下载按钮");
}

- (void)sliderBeginSlide:(UISlider *)sender {
    LSLog(@"开始移动滑块");
    self.isDragSlider = YES;
}

- (void)sliderValueChange:(UISlider *)sender {
    LSLog(@"滑块值改变");
    CGFloat total = CMTimeGetSeconds(self.playerItem.duration);
    CGFloat current = total * sender.value;
    self.controlView.alreadyTimeLab.text = [self secondsConvertToTime:current];
}

- (void)sliderEndSlide:(UISlider *)sender {
    LSLog(@"结束移动滑块");
    
    self.isDragSlider = NO;
    CGFloat total = CMTimeGetSeconds(self.playerItem.duration);
    CGFloat current = total * sender.value;
    [self.player pause];
    [self.indicator startAnimating];
    [self.player seekToTime:CMTimeMake(current, 1.0) completionHandler:^(BOOL finished) {
        LSLog(@"跳到指定时间");
        [self.indicator stopAnimating];
        if (self.controlView.startStopBtn.isSelected) {
            return;
        }
        [self.player play];
    }];
}

- (void)ToTV:(UIButton *)sender {
    LSLog(@"点击投屏按钮");
}

- (void)GetScreenShot:(UIButton *)sender {
    LSLog(@"点击截屏按钮");
    AVURLAsset *urlAsset=[AVURLAsset assetWithURL:[NSURL URLWithString:self.videoURL]];
    AVAssetImageGenerator *imageGenerator = [AVAssetImageGenerator assetImageGeneratorWithAsset:urlAsset];
    NSError *error = nil;
    CMTime time = CMTimeMakeWithSeconds(self.controlView.progressSlider.value * CMTimeGetSeconds(self.playerItem.duration), 10);
    CMTime actualTime;
    CGImageRef cgImage= [imageGenerator copyCGImageAtTime:time actualTime:&actualTime error:&error];
    CMTimeShow(actualTime);
    UIImage *image=[UIImage imageWithCGImage:cgImage];
    
    UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
}

- (void)image: (UIImage *) image didFinishSavingWithError: (NSError *) error contextInfo: (void *) contextInfo {
    NSString *msg = nil ;
    if(error != NULL){
        msg = @"保存图片失败";
    }else{
        msg = @"保存图片成功";
    }
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"保存图片结果提示" message:msg delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
    [alert show];
}

- (void)LockScreen:(UIButton *)sender {
    LSLog(@"点击方向锁按钮");
    sender.selected = !sender.selected;
//    self.controlView.TopView.hidden = !self.controlView.TopView.hidden;
//    self.controlView.BottomView.hidden = !self.controlView.BottomView.hidden;
    if (sender.selected) {
        [[UIDevice currentDevice] setValue:self.orientationValue forKey:@"orientation"];
        self.orientationValue = [NSNumber numberWithInt:UIInterfaceOrientationPortrait];
    } else {
        self.orientationValue = [NSNumber numberWithInt:UIInterfaceOrientationLandscapeRight];
    }
    [[UIDevice currentDevice] setValue:self.orientationValue forKey:@"orientation"];
}

- (void)CollectVideo:(UIButton *)sender {
    LSLog(@"点击收藏按钮");
}

- (void)ShareVideo:(UIButton *)sender {
    LSLog(@"点击分享按钮");
}

- (void)VolumeValueChange:(UISlider *)sender {
    LSLog(@"音量 Slider 正在变化");
    MPVolumeView *volumeView = [[MPVolumeView alloc] init];
    UISlider *volumeSlider = nil;
    for (UIView *view in [volumeView subviews]){
        if ([view.class.description isEqualToString:@"MPVolumeSlider"]){
            volumeSlider = (UISlider *)view;
            volumeSlider.value = sender.value;
            break;
        }
    }
    volumeView.frame = CGRectMake(-1000, -1000, 100, 100);
    volumeView.tag = 1000;
    [self.view addSubview:volumeView];
}

- (void)BrightnessValueChange:(UISlider *)sender {
    LSLog(@"亮度 Slider 正在变化");
    [UIScreen mainScreen].brightness = sender.value;
}

#pragma mark - Gesture Recognizer
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self.controlView];
    CGSize size = [UIScreen mainScreen].bounds.size;
    if (point.x < size.width / 2 - 10) {
        _panFrom = PanStartFromLeft;
    }
    if (point.x > size.width / 2 + 10) {
        _panFrom = PanStartFromRight;
    }
}

- (void)touchMoreView:(UITapGestureRecognizer *)sender {
    self.controlView.moreView.hidden = YES;
    self.controlView.moreBtn.selected = !self.controlView.moreBtn.selected;
}

- (void)hidesOrShowControlView:(UITapGestureRecognizer *)sender {
    //hidden 动画
    /*
     [UIView animateWithDuration:2 animations:^{
     self.TopView.hidden = !self.TopView.hidden;
     self.BottomView.hidden = !self.BottomView.hidden;
     self.RightView.hidden = !self.RightView.hidden;
     }];
     */
    
    //移出动画
    if (self.controlView.TopView.frame.origin.y < 0) {
        //将控制条移入
        [UIView animateWithDuration:0.45 animations:^{
            CGRect frame = self.controlView.TopView.frame;
            self.controlView.TopView.frame = CGRectMake(frame.origin.x, 0, frame.size.width, frame.size.height);
            frame = self.controlView.BottomView.frame;
            self.controlView.BottomView.frame = CGRectMake(frame.origin.x, frame.origin.y - frame.size.height, frame.size.width, frame.size.height);
            frame = self.controlView.RightView.frame;
            self.controlView.RightView.frame = CGRectMake(frame.origin.x - frame.size.width, frame.origin.y, frame.size.width, frame.size.height);
        }];
    } else {
        //将控制条移出
        [UIView animateWithDuration:0.45 animations:^{
            CGRect frame = self.controlView.TopView.frame;
            self.controlView.TopView.frame = CGRectMake(frame.origin.x, -frame.size.height, frame.size.width, frame.size.height);
            frame = self.controlView.BottomView.frame;
            self.controlView.BottomView.frame = CGRectMake(frame.origin.x, frame.origin.y + frame.size.height, frame.size.width, frame.size.height);
            frame = self.controlView.RightView.frame;
            self.controlView.RightView.frame = CGRectMake(frame.origin.x + frame.size.width, frame.origin.y, frame.size.width, frame.size.height);
        }];
    }
}

- (void)handlePanInView:(UIPanGestureRecognizer *)sender {
    
    CGPoint velocityPoint = [sender velocityInView:self.controlView];
    switch (sender.state) {
        case UIGestureRecognizerStateBegan: {
            CGFloat x = fabs(velocityPoint.x);
            CGFloat y = fabs(velocityPoint.y);
            if (x > y) {
                _direction = PanDirectionHorizontal;
                _isDragSlider = YES;
            }
            if (y > x) {
                _direction = PanDirectionVertical;
            }
        }
            break;
        case UIGestureRecognizerStateChanged: {
            switch (_direction) {
                case PanDirectionHorizontal: {//水平
                    [self horizontalMovedWithValue:velocityPoint.x];
                    [self sliderValueChange:self.controlView.progressSlider];
                }
                    break;
                case PanDirectionVertical: {//竖直
                    //判断在屏幕左侧还是右侧
                    if (_panFrom == PanStartFromLeft) {//改变音量
                        [self VerticalVolumeWithValue:velocityPoint.y];
                    } else if (_panFrom == PanStartFromRight) {//改变亮度
                        [self VerticalBrightnessWithValue:velocityPoint.y];
                    }
                }
                    break;
                    
                default:
                    break;
            }
        }
            break;
        case UIGestureRecognizerStateEnded: {
            if (_direction == PanDirectionHorizontal) {
                [self sliderEndSlide:self.controlView.progressSlider];
            }
        }
            break;
        default:
            break;
    }
}

- (void)horizontalMovedWithValue:(CGFloat)value {
    self.controlView.progressSlider.value += value / 10000;
}

- (void)VerticalVolumeWithValue:(CGFloat)value {
    self.controlView.volumeSlider.value += - value / 10000;
    MPVolumeView *volumeView = (MPVolumeView *)[self.view viewWithTag:1000];
    
    UISlider *volumeSlider = nil;
    for (UIView *view in [volumeView subviews]){
        if ([view.class.description isEqualToString:@"MPVolumeSlider"]){
            volumeSlider = (UISlider *)view;
            volumeSlider.value = self.controlView.volumeSlider.value;
            break;
        }
    }
}

- (void)VerticalBrightnessWithValue:(CGFloat)value {
    [UIScreen mainScreen].brightness += -value / 10000;
}

#pragma mark - Gesture Recognizer Delegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if ([touch.view isKindOfClass:[UISlider class]]) {
        return NO;
    } else if (touch.view == _controlView.moreView) {
        return NO;
    }
    return YES;
}

#pragma mark - 通知
- (void)moviePlayDidEnd:(NSNotification *)notification {
    [self.player seekToTime:CMTimeMake(0, 1) completionHandler:^(BOOL finished) {
        LSLog(@"播放完了");
        self.controlView.startStopBtn.selected = NO;
    }];
}

- (void)InterfaceOrientation:(NSNotification *)notification {
    UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
    if (orientation == UIInterfaceOrientationPortrait) {
        
        LSLog(@"竖屏");
        self.playerLayer.frame = CGRectMake(0, 0, SmallPx, BigPx);
    } else if (orientation == UIInterfaceOrientationLandscapeRight) {
        LSLog(@"横屏");
        self.playerLayer.frame = CGRectMake(0, 0, BigPx, SmallPx);
    }
}

- (void)WillChangeInterfaceOrientation:(NSNotification *)notification {
    if (self.enterForeground && [self.orientationValue intValue] == 3) {
        [self shouldAutorotate];
    }
}

- (void)applicationDidEnterBackground:(NSNotification *)notification {
    [self.player pause];
    self.enterForeground = NO;
}

- (void)applicationEnterForeground:(NSNotification *)notification {
    self.enterForeground = YES;
    [self shouldAutorotate];
    //回到前台, 更新屏幕方向
    if ([self.orientationValue intValue] == 1) {
        self.controlView.lockingBtn.selected = YES;
    } else {
        self.controlView.lockingBtn.selected = NO;
    }
    if (self.controlView.startStopBtn.selected == NO) {
        [self.player play];
    }
}

#pragma mark - KVO
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    if (object == self.playerItem) {
        //监测视频播放状态
        if ([keyPath isEqualToString:@"PlayerStatus"]) {
            if (self.player.status == AVPlayerStatusReadyToPlay) {
                LSLog(@"正在播放");
                [self.indicator stopAnimating];
                [self.player play];
                self.controlView.startStopBtn.selected = YES;
            } else if (self.player.status == AVPlayerStatusFailed){
                LSLog(@"播放失败");
                [self.indicator startAnimating];
                self.controlView.startStopBtn.selected = NO;
            }
        }
        //监测网络加载情况
        if ([keyPath isEqualToString:@"LoadedTimeRange"]) {
            NSArray *array = _playerItem.loadedTimeRanges;
            CMTimeRange timeRange = [array.firstObject CMTimeRangeValue];//本次缓冲时间范围
            float startSeconds = CMTimeGetSeconds(timeRange.start);
            float durationSeconds = CMTimeGetSeconds(timeRange.duration);
            NSTimeInterval totalBuffer = startSeconds + durationSeconds;//缓冲总长度
            NSLog(@"共缓冲：%.2f",totalBuffer);
        }
        
    }
}

#pragma mark - Interface Orientation
- (BOOL)shouldAutorotate {
    return self.enterForeground;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return UIInterfaceOrientationLandscapeRight;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait | UIInterfaceOrientationMaskLandscapeRight;
}



#pragma mark - Status Bar
- (UIStatusBarAnimation)preferredStatusBarUpdateAnimation {
    return UIStatusBarAnimationNone;
}

- (BOOL)prefersStatusBarHidden {
    return NO;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

#pragma mark - Helper Methods
- (NSString *)secondsConvertToTime:(CGFloat)seconds {
    NSInteger durHour = (NSInteger)seconds / 3600;
    NSInteger durMin = ((NSInteger)seconds - durHour * 3600) / 60;
    NSInteger durSec = ((NSInteger)seconds - durHour * 3600) % 60;
    if (durHour <= 0) {
        NSString *strTime = [NSString stringWithFormat:@"%02zd:%02zd", durMin, durSec];
        return strTime;
    } else {
        NSString *strTime = [NSString stringWithFormat:@"%02zd:%02zd:%02zd", durHour, durMin, durSec];
        return strTime;
    }
}

#pragma mark -
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self.playerItem removeObserver:self forKeyPath:@"PlayerStatus"];
    [self.playerItem removeObserver:self forKeyPath:@"LoadedTimeRange"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
