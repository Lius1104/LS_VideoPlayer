//
//  LS_PlayerControlView.h
//  LS_VideoPlayer
//
//  Created by Mac on 16/7/27.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BBFlashCtntLabel.h"

@interface LS_PlayerControlView : UIView
/**视频名称*/
@property (nonatomic, copy) NSString *title;

/**控制器的 frame*/
@property (nonatomic, assign) CGRect Viewframe;
/**上侧控制条*/
@property (nonatomic, strong) UIView *TopView;
/**下侧控制条*/
@property (nonatomic, strong) UIView *BottomView;
/**右侧控制条*/
@property (nonatomic, strong) UIView *RightView;
/**更多控制功能*/
@property (nonatomic, strong) UIView *moreView;

/****************************上侧控制条的子控件****************************/
/**返回按钮*/
@property (nonatomic, strong) UIButton *backBtn;
/**标题*/
@property (nonatomic, strong) BBFlashCtntLabel *titleLab;
/**更多按钮*/
@property (nonatomic, strong) UIButton *moreBtn;

/****************************底部控制条的子控件****************************/
/**开始/暂停按钮*/
@property (nonatomic, strong) UIButton *startStopBtn;
/**已播放时间 label*/
@property (nonatomic, strong) UILabel *alreadyTimeLab;
/**播放进度滑块*/
@property (nonatomic, strong) UISlider *progressSlider;
/**总时间 label*/
@property (nonatomic, strong) UILabel *totalTimeLab;
/**下载按钮*/
@property (nonatomic, strong) UIButton *downloadBtn;

/****************************右侧控制条的子控件****************************/
/**投屏按钮*/
@property (nonatomic, strong) UIButton *tvBtn;
/**截屏按钮*/
@property (nonatomic, strong) UIButton *screenshotBtn;
/**方向锁按钮*/
@property (nonatomic, strong) UIButton *lockingBtn;

/****************************更多控制页的子控件****************************/
/**收藏按钮*/
@property (nonatomic, strong) UIButton *collectBtn;
/**分享按钮*/
@property (nonatomic, strong) UIButton *shareBtn;
/**声音滑杆*/
@property (nonatomic, strong) UISlider *volumeSlider;
/**亮度滑杆*/
@property (nonatomic, strong) UISlider *brightSlider;

- (instancetype)initWithFrame:(CGRect)frame Title:(NSString *)title;

@end
