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
#import "TaskDeviceEntity.h"

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
    NSMutableArray *taskEntityArr = [[NSMutableArray alloc] init];
    Reachability *reach = [Reachability reachabilityForInternetConnection];
    if (reach.isReachable) {
        PRHTTPSessionManager *manager = [PRHTTPSessionManager sharePRHTTPSessionManager];
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        NSString *userName = [userDefaults objectForKey:@"userName"];
        NSMutableDictionary *condition = [[NSMutableDictionary alloc] init];
        [condition setObject:@"gettasklist" forKey:@"action"];
        [condition setObject:[DateUtil getCurrentTimestamp] forKey:@"tick"];
        [condition setObject:[NSString getDeviceId] forKey:@"imei"];
        [condition setObject:userName?userName:@"" forKey:@"username"];
        [condition addEntriesFromDictionary:filterDic];
        [manager GET:[[URLManager getSharedInstance] getURL:@""] parameters:condition progress:^(NSProgress * _Nonnull downloadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            if ([responseObject[@"success"] boolValue]) {
                NSArray* response = responseObject[@"data"];
                [self.taskList removeAllObjects];
                for (NSDictionary *obj in response) {
                    TaskListEntity *taskListEntity = [[TaskListEntity alloc] initWithDictionary:obj];
                    [self.taskList addObject:taskListEntity];
                }
                //离线存储
                dispatch_async(dispatch_get_main_queue(), ^{
                    [dbService deleteAllTaskList];
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

- (TaskEntity *)getTaskEntity:(NSString *)code fromLocal:(BOOL)isLocal success:(void (^)(TaskEntity *taskEntity))success failure:(void (^)(NSString *message))failure {
    __block TaskEntity *taskEntity;
    if (isLocal) {
        taskEntity = [dbService findTaskByCode:code];
    } else {
        //从本地移除
        [dbService deleteTaskEntity:code];
    }
    if (taskEntity) {
        success(taskEntity);
    } else {
        PRHTTPSessionManager *manager = [PRHTTPSessionManager sharePRHTTPSessionManager];
        NSMutableDictionary *condition = [[NSMutableDictionary alloc] init];
        [condition setObject:@"gettaskdata" forKey:@"action"];
        [condition setObject:[DateUtil getCurrentTimestamp] forKey:@"tick"];
        [condition setObject:[NSString getDeviceId] forKey:@"imei"];
        [condition setObject:code forKey:@"code"];
        [manager GET:[[URLManager getSharedInstance] getURL:@""] parameters:condition progress:^(NSProgress * _Nonnull downloadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            if ([responseObject[@"success"] boolValue]) {
                NSDictionary *response = responseObject[@"data"][0];
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
            failure(error.localizedDescription);
        }];
    }
    return taskEntity;
}

- (void)getTaskDevices:(NSString *)code success:(void (^)(NSArray *taskDevices))success failure:(void (^)(NSString *message))failure {
    NSMutableArray *taskDevicesArr = [[NSMutableArray alloc] init];
    Reachability *reach = [Reachability reachabilityForInternetConnection];
    if (reach.isReachable) {
        PRHTTPSessionManager *manager = [PRHTTPSessionManager sharePRHTTPSessionManager];
        NSMutableDictionary *condition = [[NSMutableDictionary alloc] init];
        [condition setObject:@"gettaskdetail" forKey:@"action"];
        [condition setObject:[DateUtil getCurrentTimestamp] forKey:@"tick"];
        [condition setObject:[NSString getDeviceId] forKey:@"imei"];
        [condition setObject:code forKey:@"code"];
        [manager GET:[[URLManager getSharedInstance] getURL:@""] parameters:condition progress:^(NSProgress * _Nonnull downloadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            if ([responseObject[@"success"] boolValue]) {
                NSArray* response = responseObject[@"data"];
                for (NSDictionary *obj in response) {
                    TaskDeviceEntity *taskDeviceEntity = [[TaskDeviceEntity alloc] initWithDictionary:obj];
                    [taskDevicesArr addObject:taskDeviceEntity];
                }
                //离线存储
                dispatch_async(dispatch_get_main_queue(), ^{
                    for (TaskDeviceEntity *taskDeviceEntity in self.taskList) {
                        if (taskDeviceEntity.IsLocalSave) {
                            [dbService saveTaskDevice:taskDeviceEntity];
                        }
                    }
                });
                success(taskDevicesArr);
            } else {
                failure(responseObject[@"message"]);
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSArray *taskDevicesArr = [dbService findTaskDevices:code];
            success(taskDevicesArr);
        }];
    } else {
        NSArray *taskDevicesArr = [dbService findTaskDevices:code];
        success(taskDevicesArr);
    }
}

- (void)submitAction:(NSMutableDictionary *)dataDic withCode:(NSString *)Code success:(void (^)())success failure:(void (^)(NSString *message))failure {
    PRHTTPSessionManager *manager = [PRHTTPSessionManager sharePRHTTPSessionManager];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *userName = [userDefaults objectForKey:@"userName"];
    NSMutableDictionary *condition = [[NSMutableDictionary alloc] init];
    NSString *url = [NSString stringWithFormat:@"%@?action=processtask&tick=%@&imei=%@&code=%@&eventname=%@&username=%@", [[URLManager getSharedInstance] getURL:@""], [DateUtil getCurrentTimestamp], [NSString getDeviceId], Code, dataDic[@"eventname"], userName];
    [condition setObject:[NSString convertArrayToString:dataDic[@"data"]] forKey:@"SubmitData"];
    [manager POST:url parameters:condition progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([responseObject[@"success"] boolValue]) {
            if (!(responseObject[@"data"] || ((NSArray *)responseObject[@"data"]).count<1)) {
                NSDictionary *response = responseObject[@"data"][0];
                TaskEntity *taskEntity = [[TaskEntity alloc] initWithDictionary:response];
                //离线存储
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (taskEntity.IsLocalSave) {
                        [dbService saveTask:taskEntity];
                    }
                });
            }
            success();
        } else {
            failure(responseObject[@"message"]);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error.localizedDescription);
    }];
}

- (BOOL) updateLocalTaskEntity:(TaskEntity *)taskEntity {
    return [dbService updateTaskEntity:taskEntity];
}

@end
