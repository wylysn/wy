//
//  AppDelegate.h
//  wy
//
//  Created by wangyilu on 16/7/11.
//  Copyright © 2016年 ___PURANG___. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DownloadViewController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (copy) void (^backgroundSessionCompletionHandler)();

@property (strong, nonatomic) DownloadViewController *downloadViewController;

@property (nonatomic, assign) BOOL isLogin;

@end

