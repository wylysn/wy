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

- (TaskEntity *)getTaskEntity:(NSString *)code;

@end
