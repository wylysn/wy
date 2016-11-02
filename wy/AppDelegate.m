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
    if (!server || [server isBlankString]) {
        [userDefaults setObject:[[URLManager getSharedInstance] getURL:@""] forKey:@"server"];
    }
    
    //本地推送
    if ([[UIApplication sharedApplication] respondsToSelector:@selector(registerUserNotificationSettings:)]) {
        UIUserNotificationType type =  UIUserNotificationTypeAlert | UIUserNotificationTypeBadge | UIUserNotificationTypeSound;
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:type
                                                                                 categories:nil];
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
    } else {
        
    }
    
    //注册远程通知
    [self notifyWith:application];
    
    //检查版本
    dispatch_async(dispatch_get_main_queue(), ^{
        [self checkVersion];
    });
    
    return YES;
}

- (void)checkVersion {
    PRHTTPSessionManager *manager = [PRHTTPSessionManager sharePRHTTPSessionManager];
    NSMutableDictionary *condition = [[NSMutableDictionary alloc] init];
    [condition setObject:@"getversion" forKey:@"action"];
    [condition setObject:[DateUtil getCurrentTimestamp] forKey:@"tick"];
    [condition setObject:[NSString getDeviceId] forKey:@"imei"];
    [manager GET:[[URLManager getSharedInstance] getURL:@""] parameters:condition progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([responseObject[@"success"] boolValue]) {
            NSDictionary *response = responseObject[@"data"];
            NSString *newVersion = response[@"Ver"];
            NSString *url = response[@"Url"];
            
            NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
            NSString *oldVersion = [infoDic objectForKey:@"CFBundleShortVersionString"];
            
            if (![newVersion isEqualToString:oldVersion]) {
                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"更新提示" message:@"您有新版本需要更新，去更新" preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
                }];
                [alertController addAction:okAction];
                UIWindow *alertWindow = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
                alertWindow.rootViewController = [[UIViewController alloc] init];
                alertWindow.windowLevel = UIWindowLevelAlert + 1;
                [alertWindow makeKeyAndVisible];
                [alertWindow.rootViewController presentViewController:alertController animated:YES completion:nil];
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}

- (void)notifyWith:(UIApplication *)application
{
    //判断是否注册了远程通知
    if (![application isRegisteredForRemoteNotifications]) {
        UIUserNotificationSettings *uns = [UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeAlert|UIUserNotificationTypeBadge|UIUserNotificationTypeSound) categories:nil];
        [application registerUserNotificationSettings:uns];
        //注册远程通知
        [application registerForRemoteNotifications];
    }else{
        [self getDivceToken:application];
    }
}

- (void)getDivceToken:(UIApplication *)application {
    NSUserDefaults* defaluts =[NSUserDefaults standardUserDefaults];
    NSString *deviceToken = [defaluts objectForKey:@"deviceToken"];
    if ([deviceToken isBlankString]) {
        BOOL isNotification = [self isAllowedNotification];
        if (isNotification) {
            UIUserNotificationSettings *uns = [UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeAlert|UIUserNotificationTypeBadge|UIUserNotificationTypeSound) categories:nil];
            [application registerUserNotificationSettings:uns];
            //注册远程通知
            [application registerForRemoteNotifications];
        }
    }
}

//判断app是否开启推送
- (BOOL)isAllowedNotification {
    UIUserNotificationSettings *setting = [[UIApplication sharedApplication] currentUserNotificationSettings];
    if (UIUserNotificationTypeNone != setting.types) {
        return YES;
    }
    return NO;
}

//注册成功，返回deviceToken
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    if (deviceToken) {
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        NSString * newString  = [[[[deviceToken description] stringByReplacingOccurrencesOfString: @"<" withString: @""]                  stringByReplacingOccurrencesOfString: @">" withString: @""]                 stringByReplacingOccurrencesOfString: @" " withString: @""];
        [userDefaults setObject:newString forKey:@"deviceToken"];
        [userDefaults synchronize];
    }
    NSLog(@"deviceToken:%@", deviceToken);
}

//注册失败
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    NSLog(@"%@", error);
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
    
    //检查版本
    dispatch_async(dispatch_get_main_queue(), ^{
        [self checkVersion];
    });
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
