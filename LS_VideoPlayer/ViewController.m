//
//  ViewController.m
//  LS_VideoPlayer
//
//  Created by Mac on 16/7/27.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import "ViewController.h"
#import "LS_VideoPlayerController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"视频列表";
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    btn.center = self.view.center;
    [btn setImage:[UIImage imageNamed:@"jump"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(jumpToVideoPlayer:) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:btn];
}

- (void)jumpToVideoPlayer:(UIButton *)sender {
    LSLog(@"点击跳转按钮");
    LS_VideoPlayerController *playerVC = [[LS_VideoPlayerController alloc] init];
    playerVC.videoURL = @"http://v.iseeyoo.cn/video/2010/10/25/2a9f0f4e-e035-11df-9117-001e0bbb2442_001.mp4";
    [self presentViewController:playerVC animated:YES completion:nil];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
