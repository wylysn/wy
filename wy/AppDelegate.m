//
//  AppDelegate.m
//  wy
//
//  Created by wangyilu on 16/7/11.
//  Copyright © 2016年 ___PURANG___. All rights reserved.
//

#import "AppDelegate.h"
#import "PersonDBService.h"
#import "PersonEntity.h"
#import "DeviceListEntity.h"
#import "DeviceDBService.h"
#import "KnowledgeDBService.h"
#import "KnowledgeEntity.h"
#import "PositionEntity.h"
#import "PositionDBservice.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    //状态栏颜色
    [application setStatusBarStyle:UIStatusBarStyleLightContent];
    
    //将设置的服务器地址初始化
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *server = [userDefaults objectForKey:@"server"];
    if (server) {
        [[URLManager getSharedInstance] setURL_PATH:server];
    }
    
    if ([[UIApplication sharedApplication] respondsToSelector:@selector(registerUserNotificationSettings:)]) {
        UIUserNotificationType type =  UIUserNotificationTypeAlert | UIUserNotificationTypeBadge | UIUserNotificationTypeSound;
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:type
                                                                                 categories:nil];
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
    } else {
        
    }
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

/*
- (void)application:(UIApplication *)application handleEventsForBackgroundURLSession:(NSString *)identifier
  completionHandler:(void (^)())completionHandler {
    self.backgroundSessionCompletionHandler = completionHandler;
    //添加本地通知
    [self presentNotification:identifier];
 }
 */

-(void)presentNotification:(NSString *)identifier{
    UILocalNotification* localNotification = [[UILocalNotification alloc] init];
    localNotification.alertBody = [NSString stringWithFormat:@"%@下载完成!", identifier];
    localNotification.alertAction = @"后台传输下载已完成!";
    //提示音
    localNotification.soundName = UILocalNotificationDefaultSoundName;
    //icon提示加1
//    localNotification.applicationIconBadgeNumber = [[UIApplication sharedApplication] applicationIconBadgeNumber] + 1;
    [[UIApplication sharedApplication] presentLocalNotificationNow:localNotification];
}

- (void)application:(UIApplication *)application handleEventsForBackgroundURLSession:(NSString *)identifier completionHandler:(void (^)())completionHandler
{
//    NSURLSessionConfiguration *backgroundConfigObject = [NSURLSessionConfiguration backgroundSessionConfigurationWithIdentifier: identifier];
    
//    NSURLSession *backgroundSession = [NSURLSession sessionWithConfiguration: backgroundConfigObject delegate: self.downloadViewController delegateQueue: [NSOperationQueue mainQueue]];
    
    NSLog(@"Rejoining session %@\n", identifier);
    
    [self.downloadViewController addCompletionHandler: completionHandler forSession: identifier];
    
    //添加本地通知
    [self presentNotification:identifier];
}

@end
