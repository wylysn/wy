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
#import "PlanDetailEntity.h"

@interface TaskDBService : NSObject

+ (TaskDBService*)getSharedInstance;

+ (sqlite3 *)open;

+ (void)close;

/*
 * 任务列表
 */
- (BOOL)saveTaskList:(TaskListEntity *)taskList;
- (BOOL)deleteTaskList:(TaskListEntity *)taskList;
- (BOOL)deleteAllTaskList;
- (NSArray *)findTaskLists:(NSDictionary *)condition;

/*
 * 任务详情
 */
- (BOOL)saveTask:(TaskEntity *)taskEntity;
- (BOOL)updateTaskEntity:(TaskEntity *)taskEntity;
- (BOOL)deleteTaskEntity:(NSString *)code;
- (TaskEntity *)findTaskByCode:(NSString*)Code;

/*
 * 巡检设备
 */
- (BOOL)saveTaskDevice:(TaskDeviceEntity *)taskDevice;
- (NSArray *)findTaskDevices:code;

/*
 * 计划维护任
 */
- (BOOL)savePlanDetail:(PlanDetailEntity *)planDetail;
- (BOOL)updatePlanDetail:(PlanDetailEntity *)planDetail;
- (BOOL)deletePlanDetail:(NSString *)code;
- (PlanDetailEntity *)findPlanDetailByCode:(NSString*)Code;

@end
