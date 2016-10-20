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

- (TaskEntity *)getTaskEntity:(NSString *)code fromLocal:(BOOL)isLocal success:(void (^)(TaskEntity *taskEntity))success failure:(void (^)(NSString *message))failure;

- (void)getTaskDevices:(NSString *)code success:(void (^)(NSArray *taskDevices))success failure:(void (^)(NSString *message))failure;

- (void)submitAction:(NSMutableDictionary *)dataDic withCode:(NSString *)Code success:(void (^)())success failure:(void (^)(NSString *message))failure;

- (BOOL) updateLocalTaskEntity:(TaskEntity *)taskEntity;

@end
