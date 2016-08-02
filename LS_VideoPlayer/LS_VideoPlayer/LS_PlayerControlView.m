//
//  LS_PlayerControlView.m
//  LS_VideoPlayer
//
//  Created by Mac on 16/7/27.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import "LS_PlayerControlView.h"
#import <MediaPlayer/MediaPlayer.h>

@implementation LS_PlayerControlView

- (instancetype)initWithFrame:(CGRect)frame Title:(NSString *)title {
//- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _Viewframe = frame;
        _title = title;
        [self addSubview:self.TopView];
        [self setTopViewConstrains];
        
        [self addSubview:self.RightView];
        [self setRightViewConstrains];
        
        [self addSubview:self.BottomView];
        [self setBottomViewConstrains];
        
        [self addSubview:self.moreView];
        [self setMoreViewConstrains];
        
        self.userInteractionEnabled = YES;
    }
    return self;
}

#pragma mark - Top View
- (UIView *)TopView {
    if (!_TopView) {
        _TopView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _Viewframe.size.width, 70)];
        _TopView.translatesAutoresizingMaskIntoConstraints = NO;
        _TopView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.6];
        _TopView.userInteractionEnabled = YES;
        
        //返回按钮 设置
        self.backBtn = [[UIButton alloc] initWithFrame:CGRectMake(10, 20, 50, 50)];
        self.backBtn.translatesAutoresizingMaskIntoConstraints = NO;
        [self.backBtn setImage:[UIImage imageNamed:@"返回"] forState:UIControlStateNormal];
        [_TopView addSubview:_backBtn];
        
        //更多按钮 设置
        self.moreBtn = [[UIButton alloc] initWithFrame:CGRectMake(_TopView.bounds.size.width - 50, 20, 50, 50)];
        self.moreBtn.translatesAutoresizingMaskIntoConstraints = NO;
        [self.moreBtn setImage:[UIImage imageNamed:@"更多"] forState:UIControlStateNormal];
        [_TopView addSubview:_moreBtn];
        
        //标题 设置
        self.titleLab = [[BBFlashCtntLabel alloc] initWithFrame:CGRectMake(60, 20, _TopView.bounds.size.width - 110, 50)];
        self.titleLab.translatesAutoresizingMaskIntoConstraints = NO;
        self.titleLab.backgroundColor = [UIColor clearColor];
        self.titleLab.leastInnerGap = 50.f;
        self.titleLab.repeatCount = 0;
        self.titleLab.speed = BBFlashCtntSpeedSlow;
        self.titleLab.font = [UIFont systemFontOfSize:16];
        self.titleLab.text = _title;
        self.titleLab.textColor = [UIColor whiteColor];
        [_TopView addSubview:_titleLab];
        
        [self setBackBtnConstrains];
        [self setMoreBtnConstrains];
        [self setTitleLabConstrains];

    }
    return _TopView;
}

- (void)setTopViewConstrains {
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_TopView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeft multiplier:1 constant:0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_TopView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1 constant:0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_TopView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeRight multiplier:1 constant:0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_TopView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:70]];
}

- (void)setBackBtnConstrains {
    [_TopView addConstraint:[NSLayoutConstraint constraintWithItem:_backBtn attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:_TopView attribute:NSLayoutAttributeLeft multiplier:1 constant:10]];
    [_TopView addConstraint:[NSLayoutConstraint constraintWithItem:_backBtn attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:_TopView attribute:NSLayoutAttributeTop multiplier:1 constant:20]];
    [_TopView addConstraint:[NSLayoutConstraint constraintWithItem:_backBtn attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:50]];
    [_TopView addConstraint:[NSLayoutConstraint constraintWithItem:_backBtn attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:50]];
}

- (void)setMoreBtnConstrains {
    [_TopView addConstraint:[NSLayoutConstraint constraintWithItem:_moreBtn attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:_TopView attribute:NSLayoutAttributeRight multiplier:1 constant:0]];
    [_TopView addConstraint:[NSLayoutConstraint constraintWithItem:_moreBtn attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:_TopView attribute:NSLayoutAttributeTop multiplier:1 constant:20]];
    [_TopView addConstraint:[NSLayoutConstraint constraintWithItem:_moreBtn attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:50]];
    [_TopView addConstraint:[NSLayoutConstraint constraintWithItem:_moreBtn attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:50]];
}

- (void)setTitleLabConstrains {
    [_TopView addConstraint:[NSLayoutConstraint constraintWithItem:_titleLab attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:_TopView attribute:NSLayoutAttributeLeft multiplier:1 constant:60]];
    [_TopView addConstraint:[NSLayoutConstraint constraintWithItem:_titleLab attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:_TopView attribute:NSLayoutAttributeRight multiplier:1 constant:-60]];
    [_TopView addConstraint:[NSLayoutConstraint constraintWithItem:_titleLab attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:_TopView attribute:NSLayoutAttributeTop multiplier:1 constant:20]];
    [_TopView addConstraint:[NSLayoutConstraint constraintWithItem:_titleLab attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:50]];
}

#pragma mark - Bottom View
- (UIView *)BottomView {
    if (!_BottomView) {
        _BottomView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _Viewframe.size.width, 50)];
        _BottomView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.6];
        _BottomView.translatesAutoresizingMaskIntoConstraints = NO;
        _BottomView.userInteractionEnabled = YES;
        
        //设置播放按钮
        self.startStopBtn = [[UIButton alloc] initWithFrame:CGRectMake(10, 0, 50, 50)];
        [self.startStopBtn setImage:[UIImage imageNamed:@"暂停"] forState:UIControlStateNormal];
        [self.startStopBtn setImage:[UIImage imageNamed:@"播放"] forState:UIControlStateSelected];
        self.startStopBtn.translatesAutoresizingMaskIntoConstraints = NO;
        [_BottomView addSubview:_startStopBtn];
        
        //设置已播放时间 Label
        self.alreadyTimeLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 60, 50)];
        self.alreadyTimeLab.font = [UIFont systemFontOfSize:14];
        self.alreadyTimeLab.textColor = [UIColor whiteColor];
        self.alreadyTimeLab.textAlignment = NSTextAlignmentCenter;
        self.alreadyTimeLab.translatesAutoresizingMaskIntoConstraints = NO;
        self.alreadyTimeLab.text = @"00:00";
        [_BottomView addSubview:_alreadyTimeLab];
        
        //设置进度条
        self.progressSlider = [[UISlider alloc] initWithFrame:CGRectMake(0, 0, _Viewframe.size.width - 230, 25)];
        self.progressSlider.translatesAutoresizingMaskIntoConstraints = NO;
        [_BottomView addSubview:_progressSlider];
        
        //设置总时间
        self.totalTimeLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 60, 50)];
        self.totalTimeLab.font = [UIFont systemFontOfSize:14];
        self.totalTimeLab.textColor = [UIColor whiteColor];
        self.totalTimeLab.textAlignment = NSTextAlignmentCenter;
        self.totalTimeLab.translatesAutoresizingMaskIntoConstraints = NO;
        self.totalTimeLab.text = @"00:00";
        [_BottomView addSubview:_totalTimeLab];
        
        //设置下载按钮
        self.downloadBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
        [self.downloadBtn setImage:[UIImage imageNamed:@"下载"] forState:UIControlStateNormal];
        self.downloadBtn.translatesAutoresizingMaskIntoConstraints = NO;
        [_BottomView addSubview:_downloadBtn];
        
        [self setStartStopConstrains];
        [self setAlreadyTimeConstrains];
        [self setDownloadConstrains];
        [self setTotalTimeConstrains];
        [self setProgressSliderConstrains];
    }
    return _BottomView;
}

- (void)setBottomViewConstrains {
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_BottomView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeft multiplier:1 constant:0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_BottomView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1 constant:0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_BottomView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeWidth multiplier:1 constant:0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_BottomView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:50]];
}

- (void)setStartStopConstrains {
    [_BottomView addConstraint:[NSLayoutConstraint constraintWithItem:_startStopBtn attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:_BottomView attribute:NSLayoutAttributeLeft multiplier:1 constant:10]];
    [_BottomView addConstraint:[NSLayoutConstraint constraintWithItem:_startStopBtn attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:_BottomView attribute:NSLayoutAttributeTop multiplier:1 constant:0]];
    [_BottomView addConstraint:[NSLayoutConstraint constraintWithItem:_startStopBtn attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:50]];
    [_BottomView addConstraint:[NSLayoutConstraint constraintWithItem:_startStopBtn attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:50]];
}

- (void)setAlreadyTimeConstrains {
    [_BottomView addConstraint:[NSLayoutConstraint constraintWithItem:_alreadyTimeLab attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:_startStopBtn attribute:NSLayoutAttributeRight multiplier:1 constant:0]];
    [_BottomView addConstraint:[NSLayoutConstraint constraintWithItem:_alreadyTimeLab attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:_BottomView attribute:NSLayoutAttributeTop multiplier:1 constant:0]];
    [_BottomView addConstraint:[NSLayoutConstraint constraintWithItem:_alreadyTimeLab attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:60]];
    [_BottomView addConstraint:[NSLayoutConstraint constraintWithItem:_alreadyTimeLab attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:50]];
}

- (void)setDownloadConstrains {
    [_BottomView addConstraint:[NSLayoutConstraint constraintWithItem:_downloadBtn attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:_BottomView attribute:NSLayoutAttributeTop multiplier:1 constant:0]];
    [_BottomView addConstraint:[NSLayoutConstraint constraintWithItem:_downloadBtn attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:_BottomView attribute:NSLayoutAttributeRight multiplier:1 constant:0]];
    [_BottomView addConstraint:[NSLayoutConstraint constraintWithItem:_downloadBtn attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:50]];
    [_BottomView addConstraint:[NSLayoutConstraint constraintWithItem:_downloadBtn attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:50]];
}

- (void)setTotalTimeConstrains {
    [_BottomView addConstraint:[NSLayoutConstraint constraintWithItem:_totalTimeLab attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:_BottomView attribute:NSLayoutAttributeTop multiplier:1 constant:0]];
    [_BottomView addConstraint:[NSLayoutConstraint constraintWithItem:_totalTimeLab attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:_downloadBtn attribute:NSLayoutAttributeLeft multiplier:1 constant:0]];
    [_BottomView addConstraint:[NSLayoutConstraint constraintWithItem:_totalTimeLab attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:60]];
    [_BottomView addConstraint:[NSLayoutConstraint constraintWithItem:_totalTimeLab attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:50]];
}

- (void)setProgressSliderConstrains {
    [_BottomView addConstraint:[NSLayoutConstraint constraintWithItem:_progressSlider attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:_alreadyTimeLab attribute:NSLayoutAttributeRight multiplier:1 constant:0]];
    [_BottomView addConstraint:[NSLayoutConstraint constraintWithItem:_progressSlider attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:_totalTimeLab attribute:NSLayoutAttributeLeft multiplier:1 constant:0]];
    [_BottomView addConstraint:[NSLayoutConstraint constraintWithItem:_progressSlider attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:_BottomView attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
    [_BottomView addConstraint:[NSLayoutConstraint constraintWithItem:_progressSlider attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:25]];
}

#pragma mark - Right View
- (UIView *)RightView {
    if (!_RightView) {
        _RightView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 60, 120)];
        _RightView.translatesAutoresizingMaskIntoConstraints = NO;
        _RightView.backgroundColor = [UIColor clearColor];
        _RightView.userInteractionEnabled = YES;
        
        //投屏按钮 设置
        self.tvBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
        [self.tvBtn setImage:[UIImage imageNamed:@"投屏"] forState:UIControlStateNormal];
        self.tvBtn.backgroundColor = [UIColor colorWithWhite:0 alpha:0.6];
        self.tvBtn.layer.cornerRadius = 25;
        self.tvBtn.layer.masksToBounds = YES;
        self.tvBtn.translatesAutoresizingMaskIntoConstraints = NO;
        [_RightView addSubview:_tvBtn];
        
        //截屏按钮 设置
        self.screenshotBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 65, 50, 50)];
        [self.screenshotBtn setImage:[UIImage imageNamed:@"截屏"] forState:UIControlStateNormal];
        self.screenshotBtn.backgroundColor = [UIColor colorWithWhite:0 alpha:0.6];
        self.screenshotBtn.layer.cornerRadius = 25;
        self.screenshotBtn.layer.masksToBounds = YES;
        self.screenshotBtn.translatesAutoresizingMaskIntoConstraints = NO;
        [_RightView addSubview:_screenshotBtn];
        
        //锁屏按钮 设置
        self.lockingBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 130, 50, 50)];
//        [self.lockingBtn setImage:[UIImage imageNamed:@"锁定"] forState:UIControlStateNormal];
        [self.lockingBtn setImage:[UIImage imageNamed:@"横屏"] forState:UIControlStateNormal];
        [self.lockingBtn setImage:[UIImage imageNamed:@"竖屏"] forState:UIControlStateSelected];
        self.lockingBtn.backgroundColor = [UIColor colorWithWhite:0 alpha:0.6];
        self.lockingBtn.layer.cornerRadius = 25;
        self.lockingBtn.layer.masksToBounds = YES;
        self.lockingBtn.translatesAutoresizingMaskIntoConstraints = NO;
        [_RightView addSubview:_lockingBtn];
        
        [self setTVConstrains];
        [self setScreenShotConstrains];
        [self setLockingConstrains];
    }
    return _RightView;
}

- (void)setRightViewConstrains {
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_RightView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeRight multiplier:1 constant:0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_RightView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_RightView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:60]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_RightView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:180]];
}

- (void)setTVConstrains {
    [_RightView addConstraint:[NSLayoutConstraint constraintWithItem:_tvBtn attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:_RightView attribute:NSLayoutAttributeLeft multiplier:1 constant:0]];
    [_RightView addConstraint:[NSLayoutConstraint constraintWithItem:_tvBtn attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:_RightView attribute:NSLayoutAttributeTop multiplier:1 constant:0]];
    [_RightView addConstraint:[NSLayoutConstraint constraintWithItem:_tvBtn attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:50]];
    [_RightView addConstraint:[NSLayoutConstraint constraintWithItem:_tvBtn attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:50]];
}

- (void)setScreenShotConstrains {
    [_RightView addConstraint:[NSLayoutConstraint constraintWithItem:_screenshotBtn attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:_RightView attribute:NSLayoutAttributeLeft multiplier:1 constant:0]];
    [_RightView addConstraint:[NSLayoutConstraint constraintWithItem:_screenshotBtn attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:_tvBtn attribute:NSLayoutAttributeBottom multiplier:1 constant:15]];
    [_RightView addConstraint:[NSLayoutConstraint constraintWithItem:_screenshotBtn attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:50]];
    [_RightView addConstraint:[NSLayoutConstraint constraintWithItem:_screenshotBtn attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:50]];
}

- (void)setLockingConstrains {
    [_RightView addConstraint:[NSLayoutConstraint constraintWithItem:_lockingBtn attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:_RightView attribute:NSLayoutAttributeLeft multiplier:1 constant:0]];
    [_RightView addConstraint:[NSLayoutConstraint constraintWithItem:_lockingBtn attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:_screenshotBtn attribute:NSLayoutAttributeBottom multiplier:1 constant:15]];
    [_RightView addConstraint:[NSLayoutConstraint constraintWithItem:_lockingBtn attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:50]];
    [_RightView addConstraint:[NSLayoutConstraint constraintWithItem:_lockingBtn attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:50]];
}

#pragma mark - More View
- (UIView *)moreView {
    if (!_moreView) {
        _moreView = [[UIView alloc] initWithFrame:_Viewframe];
        _moreView.translatesAutoresizingMaskIntoConstraints = NO;
        _moreView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.8];
        _moreView.hidden = YES;
        _moreView.userInteractionEnabled = YES;
        
        //收藏 按钮
        self.collectBtn = [[UIButton alloc] initWithFrame:CGRectMake(_Viewframe.size.width / 2 - 60, _Viewframe.size.height / 2 - 50, 50, 50)];
        [self.collectBtn setImage:[UIImage imageNamed:@"收藏"] forState:UIControlStateNormal];
        self.collectBtn.translatesAutoresizingMaskIntoConstraints = NO;
        [_moreView addSubview:self.collectBtn];
        
        //分享 按钮
        self.shareBtn = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_collectBtn.frame), _Viewframe.size.height / 2 - 50, 50, 50)];
        [self.shareBtn setImage:[UIImage imageNamed:@"分享"] forState:UIControlStateNormal];
        self.shareBtn.translatesAutoresizingMaskIntoConstraints = NO;
        [_moreView addSubview:self.shareBtn];
        
        //声音 滑杆
        self.volumeSlider = [[UISlider alloc] initWithFrame:CGRectMake(_Viewframe.size.width / 2 - 60, CGRectGetMaxY(_collectBtn.frame), 180, 25)];
        MPVolumeView *volumeView = [[MPVolumeView alloc] init];
        UISlider *volumeSlider = nil;
        for (UIView *view in [volumeView subviews]){
            if ([view.class.description isEqualToString:@"MPVolumeSlider"]){
                volumeSlider = (UISlider *)view;
                volumeSlider.frame = CGRectMake(-1000, -100, 100, 100);
                break;
            }
        }
        self.volumeSlider.translatesAutoresizingMaskIntoConstraints = NO;
        [self.volumeSlider setThumbTintColor:[UIColor orangeColor]];
        self.volumeSlider.value = volumeSlider.value;
        [_moreView addSubview:self.volumeSlider];
        
        //亮度 滑杆
        self.brightSlider = [[UISlider alloc] initWithFrame:CGRectMake(_Viewframe.size.width / 2 - 60, CGRectGetMaxY(_volumeSlider.frame), 180, 25)];
        self.brightSlider.translatesAutoresizingMaskIntoConstraints = NO;
        [self.brightSlider setThumbTintColor:[UIColor orangeColor]];
        self.brightSlider.value = [UIScreen mainScreen].brightness;
        [_moreView addSubview:self.brightSlider];
        
        [self setCollectConstrains];
        [self setShareConstrains];
        [self setVolumeConstrains];
        [self setBrightConstrains];
    }
    return _moreView;
}

- (void)setMoreViewConstrains {
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_moreView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeft multiplier:1 constant:0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_moreView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeRight multiplier:1 constant:0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_moreView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1 constant:0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_moreView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1 constant:0]];
}

- (void)setCollectConstrains {
    [_moreView addConstraint:[NSLayoutConstraint constraintWithItem:_collectBtn attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:50]];
    [_moreView addConstraint:[NSLayoutConstraint constraintWithItem:_collectBtn attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:50]];
    
    [_moreView addConstraint:[NSLayoutConstraint constraintWithItem:_collectBtn attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:_moreView attribute:NSLayoutAttributeCenterX multiplier:1 constant:-50]];
    [_moreView addConstraint:[NSLayoutConstraint constraintWithItem:_collectBtn attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:_moreView attribute:NSLayoutAttributeCenterY multiplier:1 constant:-25]];
}

- (void)setShareConstrains {
    [_moreView addConstraint:[NSLayoutConstraint constraintWithItem:_shareBtn attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:_collectBtn attribute:NSLayoutAttributeRight multiplier:1 constant:50]];
    [_moreView addConstraint:[NSLayoutConstraint constraintWithItem:_shareBtn attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:_collectBtn attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
    [_moreView addConstraint:[NSLayoutConstraint constraintWithItem:_shareBtn attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:50]];
    [_moreView addConstraint:[NSLayoutConstraint constraintWithItem:_shareBtn attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:50]];
}

- (void)setVolumeConstrains {
    [_moreView addConstraint:[NSLayoutConstraint constraintWithItem:_volumeSlider attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:_collectBtn attribute:NSLayoutAttributeLeft multiplier:1 constant:0]];
    [_moreView addConstraint:[NSLayoutConstraint constraintWithItem:_volumeSlider attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:_shareBtn attribute:NSLayoutAttributeBottom multiplier:1 constant:15]];
    [_moreView addConstraint:[NSLayoutConstraint constraintWithItem:_volumeSlider attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:180]];
    [_moreView addConstraint:[NSLayoutConstraint constraintWithItem:_volumeSlider attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:25]];
}

- (void)setBrightConstrains {
    [_moreView addConstraint:[NSLayoutConstraint constraintWithItem:_brightSlider attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:_volumeSlider attribute:NSLayoutAttributeLeft multiplier:1 constant:0]];
    [_moreView addConstraint:[NSLayoutConstraint constraintWithItem:_brightSlider attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:_volumeSlider attribute:NSLayoutAttributeBottom multiplier:1 constant:15]];
    [_moreView addConstraint:[NSLayoutConstraint constraintWithItem:_brightSlider attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:180]];
    [_moreView addConstraint:[NSLayoutConstraint constraintWithItem:_brightSlider attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:25]];
}

#pragma mark - setter
- (void)setTitle:(NSString *)title {
    _title = title;
    self.titleLab.text = title;
//    [self.titleLab setText:title];
}

@end
