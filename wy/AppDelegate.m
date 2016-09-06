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
    NSLog(@"server:%@",[[URLManager getSharedInstance] getURL:URL_CALENDAR_LASTYEAR]);
    
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
        
        
        DeviceDBService *dbService = [DeviceDBService getSharedInstance];
        DeviceListEntity *deviceList1 = [[DeviceListEntity alloc] initWithDictionary:@{@"Code":@"0001",@"Name":@"冷却塔",@"Class":@"",@"Location":@"上海科技馆",@"KeyId":@""}];
        [dbService saveDeviceList:deviceList1];
        
        KnowledgeEntity *knowledge1 = [[KnowledgeEntity alloc] initWithDictionary:@{@"conDE":@"机器语言",@"Content":@"机器语言学校是什么鬼，我还真不知道",@"Lyxm":@"人民日报",@"createPerson":@"系统录入",@"createTime":@"2016-08-31"}];
        KnowledgeDBService *knowledgeService = [KnowledgeDBService getSharedInstance];
        [knowledgeService saveKnowledge:knowledge1];
        
        
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

- (void)application:(UIApplication *)application handleEventsForBackgroundURLSession:(NSString *)identifier completionHandler:(void (^)())completionHandler
{
    NSLog(@"Save completionHandler");
//    self.completionHandler = completionHandler;
    
}

//
//- (NSURLSession *)backgroundURLSession
//{
//    static NSURLSession *session = nil;
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//        NSString *identifier = @"io.objc.backgroundTransferExample";
//        NSURLSessionConfiguration* sessionConfig = [NSURLSessionConfiguration backgroundSessionConfigurationWithIdentifier:identifier];
//        session = [NSURLSession sessionWithConfiguration:sessionConfig
//                                                delegate:self
//                                           delegateQueue:[NSOperationQueue mainQueue]];
//    });
//    
//    return session;
//}
//
//#pragma mark - NSURLSessionDownloadDelegate
//
//- (void) URLSession:(NSURLSession *)session
//       downloadTask:(NSURLSessionDownloadTask *)downloadTask
//didFinishDownloadingToURL:(NSURL *)location
//{
//    NSLog(@"downloadTask:%@ didFinishDownloadingToURL:%@", downloadTask.taskDescription, location);
//    
//    // 必须用 NSFileManager 将文件复制到应用的存储中，因为临时文件在方法返回后会被删除
//    // ...
//    
//    // 通知 UI 刷新
//}
//
//- (void) URLSession:(NSURLSession *)session
//       downloadTask:(NSURLSessionDownloadTask *)downloadTask
//  didResumeAtOffset:(int64_t)fileOffset
// expectedTotalBytes:(int64_t)expectedTotalBytes
//{
//}
//
//- (void) URLSession:(NSURLSession *)session
//       downloadTask:(NSURLSessionDownloadTask *)downloadTask
//       didWriteData:(int64_t)bytesWritten totalBytesWritten:(int64_t)totalBytesWritten
//totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite
//{
//}
//后台的任务完成后如果应用没有在前台运行，需要实现UIApplication的两个delegate让系统唤醒应用

//- (void) application:(UIApplication *)application
//handleEventsForBackgroundURLSession:(NSString *)identifier completionHandler:(void (^)())completionHandler
//{
//    // 你必须重新建立一个后台 seesiong 的参照
//    // 否则 NSURLSessionDownloadDelegate 和 NSURLSessionDelegate 方法会因为
//    // 没有 对 session 的 delegate 设定而不会被调用。参见上面的 backgroundURLSession
//    NSURLSession *backgroundSession = [self backgroundURLSession];
//    
//    NSLog(@"Rejoining session with identifier %@ %@", identifier, backgroundSession);
//    
//    // 保存 completion handler 以在处理 session 事件后更新 UI
//    [self addCompletionHandler:completionHandler forSession:identifier];
//}
//
//- (void)URLSessionDidFinishEventsForBackgroundURLSession:(NSURLSession *)session
//{
//    NSLog(@"Background URL session %@ finished events.", session);
//          
//          if (session.configuration.identifier) {
//              // 调用在 -application:handleEventsForBackgroundURLSession: 中保存的 handler
//              [self callCompletionHandlerForSession:session.configuration.identifier];
//          }
//}
//
//- (void)addCompletionHandler:(CompletionHandlerType)handler forSession:(NSString *)identifier
//{
//    if ([self.completionHandlerDictionary objectForKey:identifier]) {
//        NSLog(@"Error: Got multiple handlers for a single session identifier. This should not happen. ");
//    }
//              
//    [self.completionHandlerDictionary setObject:handler forKey:identifier];
//            }

//              - (void)callCompletionHandlerForSession: (NSString *)identifier
//        {
//            CompletionHandlerType handler = [self.completionHandlerDictionary objectForKey: identifier];
//            
//            if (handler) {
//                [self.completionHandlerDictionary removeObjectForKey: identifier];
//                NSLog(@"Calling completion handler for session %@", identifier);
//                
//                handler();
//            }
//        }

@end
