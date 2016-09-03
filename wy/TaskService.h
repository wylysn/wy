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

- (NSMutableArray *)getTaskListEntityArr:(NSDictionary *)condition;

- (TaskEntity *)getTaskEntity:(NSString *)code;

@end
