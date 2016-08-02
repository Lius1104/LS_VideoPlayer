//
//  main.m
//  LS_VideoPlayer
//
//  Created by Mac on 16/7/27.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

int main(int argc, char * argv[]) {
    @try {
        @autoreleasepool
        {
            return UIApplicationMain(argc, argv, nil, NSStringFromClass([AppDelegate class]));
        }
    }
    @catch (NSException* exception)
    {
        LSLog(@"Exception=%@\nStack Trace:%@", exception, [exception callStackSymbols]);
    }
}
