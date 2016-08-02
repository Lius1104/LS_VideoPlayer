//
//  LS_TabBarController.m
//  LS_VideoPlayer
//
//  Created by Mac on 16/7/27.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import "LS_TabBarController.h"

@interface LS_TabBarController ()

@end

@implementation LS_TabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)shouldAutorotate {
    return [[self.viewControllers objectAtIndex:(int)self.selectedIndex] shouldAutorotate];
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return [[self.viewControllers objectAtIndex:(int)self.selectedIndex] supportedInterfaceOrientations];
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return [[self.viewControllers objectAtIndex:(int)self.selectedIndex] preferredInterfaceOrientationForPresentation];
}

@end
