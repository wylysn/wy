//
//  TaskDBService.h
//  wy
//
//  Created by wangyilu on 16/9/5.
//  Copyright © 2016年 ___PURANG___. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>
#import "TaskListEntity.h"
#import "TaskEntity.h"
#import "TaskDeviceEntity.h"

@interface TaskDBService : NSObject

+ (TaskDBService*)getSharedInstance;

+ (sqlite3 *)open;

+ (void)close;

- (BOOL)saveTaskList:(TaskListEntity *)taskList;
- (BOOL)deleteTaskList:(TaskListEntity *)taskList;
- (BOOL)deleteAllTaskList;

- (NSArray *)findTaskLists:(NSDictionary *)condition;

- (BOOL)saveTask:(TaskEntity *)taskEntity;
- (BOOL)updateTaskEntity:(TaskEntity *)taskEntity;
- (BOOL)deleteTaskEntity:(NSString *)code;

- (TaskEntity *)findTaskByCode:(NSString*)Code;

- (BOOL)saveTaskDevice:(TaskDeviceEntity *)taskDevice;

- (NSArray *)findTaskDevices:code;

@end
