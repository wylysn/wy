//
//  TaskService.m
//  wy
//
//  Created by wangyilu on 16/8/11.
//  Copyright © 2016年 ___PURANG___. All rights reserved.
//

#import "TaskService.h"
#import "TaskEntity.h"
#import "TaskDBService.h"

@implementation TaskService {
    TaskDBService *dbService;
}

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        self.taskList = [[NSMutableArray alloc] init];
        dbService = [TaskDBService getSharedInstance];
    }
    return self;
}

- (NSMutableArray *)getTaskListEntityArr:(NSMutableDictionary *)filterDic  success:(void (^)())success failure:(void (^)(NSString *message))failure {
    /*
    NSMutableArray *taskEntityArr = [[NSMutableArray alloc] init];
    //测试数据，后期删除
    TaskListEntity *e1 = [[TaskListEntity alloc] initWithDictionary:@{@"Code":@"PM000000001",@"ShortTitle":@"1",@"Subject":@"任务紧急，需尽快完成",@"ReceiveTime":@"2016-08-11 16:00",@"TaskStatus":@"1",@"ServiceType":@"1",@"Priority":@"1",@"IsLocalSave":@FALSE}];
    TaskListEntity *e2 = [[TaskListEntity alloc] initWithDictionary:@{@"Code":@"PM000000002",@"ShortTitle":@"2",@"Subject":@"任务紧急，需尽快完成",@"ReceiveTime":@"2016-08-11 16:00",@"TaskStatus":@"2",@"ServiceType":@"2",@"Priority":@"2",@"IsLocalSave":@FALSE}];
    TaskListEntity *e3 = [[TaskListEntity alloc] initWithDictionary:@{@"Code":@"PM000000003",@"ShortTitle":@"3",@"Subject":@"任务紧急，需尽快完成",@"ReceiveTime":@"2016-08-11 16:00",@"TaskStatus":@"3",@"ServiceType":@"3",@"Priority":@"3",@"IsLocalSave":@FALSE}];
    TaskListEntity *e4 = [[TaskListEntity alloc] initWithDictionary:@{@"Code":@"PM000000004",@"ShortTitle":@"1",@"Subject":@"任务紧急，需尽快完成",@"ReceiveTime":@"2016-08-11 16:00",@"TaskStatus":@"4",@"ServiceType":@"4",@"Priority":@"4",@"IsLocalSave":@FALSE}];
    TaskListEntity *e5 = [[TaskListEntity alloc] initWithDictionary:@{@"Code":@"PM000000005",@"ShortTitle":@"1",@"Subject":@"任务紧急，需尽快完成",@"ReceiveTime":@"2016-08-11 16:00",@"TaskStatus":@"5",@"ServiceType":@"1",@"Priority":@"1",@"IsLocalSave":@FALSE}];
    [taskEntityArr addObject:e1];
    [taskEntityArr addObject:e2];
    [taskEntityArr addObject:e3];
    [taskEntityArr addObject:e4];
    [taskEntityArr addObject:e5];
    [self.taskList removeAllObjects];
    [self.taskList addObjectsFromArray:taskEntityArr];
    success();
    */
    
    NSMutableArray *taskEntityArr = [[NSMutableArray alloc] init];
    Reachability *reach = [Reachability reachabilityForInternetConnection];
    if (reach.isReachable) {
        PRHTTPSessionManager *manager = [PRHTTPSessionManager sharePRHTTPSessionManager];
        NSMutableDictionary *condition = [[NSMutableDictionary alloc] init];
        [condition setObject:@"gettasklist" forKey:@"action"];
        [condition setObject:[DateUtil getCurrentTimestamp] forKey:@"tick"];
        [condition setObject:[NSString getDeviceId] forKey:@"imei"];
        [condition setObject:@"" forKey:@"username"];   //后续补上
        [condition setObject:filterDic forKey:@"filter"];
        [manager GET:[[URLManager getSharedInstance] getURL:@""] parameters:condition progress:^(NSProgress * _Nonnull downloadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            if ([responseObject[@"success"] isEqualToString:@"true"]) {
                NSArray* response = responseObject[@"data"];
                [self.taskList removeAllObjects];
                for (NSDictionary *obj in response) {
                    TaskListEntity *taskListEntity = [[TaskListEntity alloc] initWithDictionary:obj];
                    [self.taskList addObject:taskListEntity];
                }
                //离线存储
                dispatch_async(dispatch_get_main_queue(), ^{
                    for (TaskListEntity *taskListEntity in self.taskList) {
                        if (taskListEntity.IsLocalSave) {
                            [dbService saveTaskList:taskListEntity];
                        }
                    }
                });
                success();
            } else {
                failure(responseObject[@"message"]);
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSArray *taskArray = [dbService findTaskLists:filterDic];
            [self.taskList removeAllObjects];
            [self.taskList addObjectsFromArray:taskArray];
            success();
        }];
    } else {
        NSArray *taskArray = [dbService findTaskLists:filterDic];
        [self.taskList removeAllObjects];
        [self.taskList addObjectsFromArray:taskArray];
        success();
    }
    
    return taskEntityArr;
}

- (TaskEntity *)getTaskEntity:(NSString *)code success:(void (^)(TaskEntity *taskEntity))success failure:(void (^)(NSString *message))failure {
//    TaskEntity *e1 = [[TaskEntity alloc] initWithDictionary:@{@"Code":@"PM000000001",@"Applyer":@"叶雨",@"ApplyerTel":@"13888888888",@"ServiceType":@"1",@"Priority":@"1",@"Location":@"",@"Description":@"",@"CreateDate":@"2016-09-03 17:00",@"Creator":@"系统",@"Executors":@"",@"Leader":@"",@"EStartTime":@"",@"EEndTime":@"",@"EWorkHours":@"",@"AStartTime":@"",@"AEndTime":@"",@"AWorkHours":@"",@"WorkContent":@"",@"EditFields":@"",@"IsLocalSave":@FALSE}];
    __block TaskEntity *taskEntity;
    Reachability *reach = [Reachability reachabilityForInternetConnection];
    if (reach.isReachable) {
        PRHTTPSessionManager *manager = [PRHTTPSessionManager sharePRHTTPSessionManager];
        NSMutableDictionary *condition = [[NSMutableDictionary alloc] init];
        [condition setObject:@"gettaskdata" forKey:@"action"];
        [condition setObject:[DateUtil getCurrentTimestamp] forKey:@"tick"];
        [condition setObject:[NSString getDeviceId] forKey:@"imei"];
        [condition setObject:code forKey:@"code"];
        [manager GET:[[URLManager getSharedInstance] getURL:@""] parameters:condition progress:^(NSProgress * _Nonnull downloadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            if ([responseObject[@"success"] isEqualToString:@"true"]) {
                NSDictionary *response = responseObject[@"data"];
                taskEntity = [[TaskEntity alloc] initWithDictionary:response];
                //离线存储
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (taskEntity.IsLocalSave) {
                        [dbService saveTask:taskEntity];
                    }
                });
                success(taskEntity);
            } else {
                failure(responseObject[@"message"]);
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            taskEntity = [dbService findTaskByCode:code];
            success(taskEntity);
        }];
    } else {
        taskEntity = [dbService findTaskByCode:code];
        success(taskEntity);
    }
    return taskEntity;
}

@end
