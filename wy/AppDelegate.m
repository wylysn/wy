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
#import "DeviceEntity.h"
#import "DeviceDBService.h"
#import "KnowledgeDBService.h"
#import "KnowledgeEntity.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    //状态栏颜色
    [application setStatusBarStyle:UIStatusBarStyleLightContent];
    
    //创建打开数据库
    /*
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        PersonDBService *dbService1 = [PersonDBService getSharedInstance];
        PersonEntity *person = [[PersonEntity alloc] initWithDictionary:@{@"id":@"1",@"name":@"张三",@"department":@"运维部",@"position":@"总经理"}];
        [dbService1 saveData:person];
        
        PersonEntity *person1 = [dbService1 findById:@"1"];
        NSLog(@"从数据库中找出人员数据：%@", person1);
        
        DeviceDBService *dbService = [DeviceDBService getSharedInstance];
        DeviceEntity *device1 = [[DeviceEntity alloc] initWithDictionary:@{@"code":@"0001",@"name":@"冷却塔",@"position":@"世博馆"}];
        [dbService saveDevice:device1];
        DeviceEntity *device2 = [[DeviceEntity alloc] initWithDictionary:@{@"code":@"0002",@"name":@"水泵",@"position":@"科技馆"}];
        [dbService saveDevice:device2];
        
        DeviceEntity *d1 = [dbService findDeviceById:@"0001"];
        NSLog(@"从数据库中找出设备信息：%@", d1.code);
        
        NSArray *dArr = [dbService findAll];
        NSLog(@"从数据库中找出%ld台设备信息", dArr.count);
        
        
        KnowledgeEntity *knowledge1 = [[KnowledgeEntity alloc] initWithDictionary:@{@"id":@"1",@"content":@"机器语言学校是什么鬼，我还真不知道",@"source":@"人民日报",@"createPerson":@"系统录入",@"createTime":@"2016-08-31"}];
        KnowledgeDBService *knowledgeService = [KnowledgeDBService getSharedInstance];
        [knowledgeService saveKnowledge:knowledge1];
    });
    */
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
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
