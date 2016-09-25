//
//  TaskService.h
//  wy
//
//  Created by wangyilu on 16/8/11.
//  Copyright © 2016年 ___PURANG___. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TaskEntity.h"
#import "TaskListEntity.h"

@interface TaskService : NSObject

//@property (nonatomic, strong) UIViewController *rtController;

@property (retain,nonatomic) NSMutableArray *taskList;

- (NSMutableArray *)getTaskListEntityArr:(NSMutableDictionary *)filterDic success:(void (^)())success failure:(void (^)(NSString *message))failure;

- (TaskEntity *)getTaskEntity:(NSString *)code success:(void (^)(TaskEntity *taskEntity))success failure:(void (^)(NSString *message))failure;

- (void)getTaskDevices:(NSString *)code success:(void (^)(NSArray *taskDevices))success failure:(void (^)(NSString *message))failure;

- (void)submitAction:(NSMutableDictionary *)dataDic withEntity:(TaskEntity *)taskEntity success:(void (^)())success failure:(void (^)(NSString *message))failure;

- (void) updateLocalTaskEntity:(TaskEntity *)taskEntity;

@end
