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
#import "PositionEntity.h"
#import "PositionDBservice.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    //状态栏颜色
    [application setStatusBarStyle:UIStatusBarStyleLightContent];
    
    //创建打开数据库
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        PersonDBService *dbService1 = [PersonDBService getSharedInstance];
        PersonEntity *person1 = [[PersonEntity alloc] initWithDictionary:@{@"AppUserName":@"00001", @"EmployeeName":@"张三", @"DepartName":@"运维1部", @"SortIndex":[NSString stringWithFormat:@"%d", 1], @"Phone":@"60610000", @"Mobile":@"13800000000"}];
        [dbService1 saveData:person1];
        PersonEntity *person2 = [[PersonEntity alloc] initWithDictionary:@{@"AppUserName":@"00002", @"EmployeeName":@"李四", @"DepartName":@"运维2部", @"SortIndex":[NSString stringWithFormat:@"%d", 1], @"Phone":@"60610000", @"Mobile":@"13800000000"}];
        [dbService1 saveData:person2];
        PersonEntity *person3 = [[PersonEntity alloc] initWithDictionary:@{@"AppUserName":@"00003", @"EmployeeName":@"王五", @"DepartName":@"运维3部", @"SortIndex":[NSString stringWithFormat:@"%d", 1], @"Phone":@"60610000", @"Mobile":@"13800000000"}];
        [dbService1 saveData:person3];
        PersonEntity *person4 = [[PersonEntity alloc] initWithDictionary:@{@"AppUserName":@"00004", @"EmployeeName":@"周六", @"DepartName":@"运维4部", @"SortIndex":[NSString stringWithFormat:@"%d", 1], @"Phone":@"60610000", @"Mobile":@"13800000000"}];
        [dbService1 saveData:person4];
        
        PersonEntity *person = [dbService1 findByAppUserName:@"00001"];
        NSLog(@"从数据库中找出人员数据：%@", person);
        
        /*
        DeviceDBService *dbService = [DeviceDBService getSharedInstance];
        DeviceEntity *device1 = [[DeviceEntity alloc] initWithDictionary:@{@"code":@"0001",@"name":@"冷却塔",@"position":@"世博馆"}];
        [dbService saveDevice:device1];
        DeviceEntity *device2 = [[DeviceEntity alloc] initWithDictionary:@{@"code":@"0002",@"name":@"水泵",@"position":@"科技馆"}];
        [dbService saveDevice:device2];
        
        DeviceEntity *d1 = [dbService findDeviceById:@"0001"];
        NSLog(@"从数据库中找出设备信息：%@", d1.code);
        
        NSArray *dArr = [dbService findAll];
        NSLog(@"从数据库中找出%ld台设备信息", dArr.count);
        
        
        KnowledgeEntity *knowledge1 = [[KnowledgeEntity alloc] initWithDictionary:@{@"conDE":@"机器语言",@"Content":@"机器语言学校是什么鬼，我还真不知道",@"Lyxm":@"人民日报",@"createPerson":@"系统录入",@"createTime":@"2016-08-31"}];
        KnowledgeDBService *knowledgeService = [KnowledgeDBService getSharedInstance];
        [knowledgeService saveKnowledge:knowledge1];
         */
        
        PositionEntity *p1 = [[PositionEntity alloc] initWithDictionary:@{@"id":@"1", @"Code":@"0001", @"Name":@"上海国际旅游度假区", @"FullName":@"上海国际旅游度假区", @"Sort":@"1", @"Status":@"1", @"Description":@"张东路1388号", @"ParentID":@"0"}];
        PositionEntity *p2 = [[PositionEntity alloc] initWithDictionary:@{@"id":@"2", @"Code":@"000101", @"Name":@"运输管理所", @"FullName":@"运输管理所", @"Sort":@"2", @"Status":@"1", @"Description":@"张东路1388号", @"ParentID":@"1"}];
        PositionEntity *p3 = [[PositionEntity alloc] initWithDictionary:@{@"id":@"3", @"Code":@"00010101", @"Name":@"所1", @"FullName":@"所1", @"Sort":@"3", @"Status":@"1", @"Description":@"张东路1388号", @"ParentID":@"2"}];
        PositionEntity *p4 = [[PositionEntity alloc] initWithDictionary:@{@"id":@"4", @"Code":@"00010102", @"Name":@"所2", @"FullName":@"所2", @"Sort":@"4", @"Status":@"1", @"Description":@"张东路1388号", @"ParentID":@"2"}];
        PositionEntity *p5 = [[PositionEntity alloc] initWithDictionary:@{@"id":@"5", @"Code":@"000102", @"Name":@"设备系统", @"FullName":@"设备系统", @"Sort":@"5", @"Status":@"1", @"Description":@"张东路1388号", @"ParentID":@"1"}];
        PositionEntity *p6 = [[PositionEntity alloc] initWithDictionary:@{@"id":@"6", @"Code":@"00010201", @"Name":@"化水车间1", @"FullName":@"化水车间1", @"Sort":@"6", @"Status":@"1", @"Description":@"张东路1388号", @"ParentID":@"5"}];
        PositionEntity *p7 = [[PositionEntity alloc] initWithDictionary:@{@"id":@"7", @"Code":@"00010202", @"Name":@"化水车间2", @"FullName":@"化水车间2", @"Sort":@"7", @"Status":@"1", @"Description":@"张东路1388号", @"ParentID":@"5"}];
        PositionDBservice *positionService = [PositionDBservice getSharedInstance];
        [positionService savePosition:p1];
        [positionService savePosition:p2];
        [positionService savePosition:p3];
        [positionService savePosition:p4];
        [positionService savePosition:p5];
        [positionService savePosition:p6];
        [positionService savePosition:p7];
    });
    
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
