//
//  TaskDBService.h
//  wy
//
//  Created by wangyilu on 16/9/5.
//  Copyright © 2016年 ___PURANG___. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TaskListEntity.h"
#import "TaskEntity.h"

@interface TaskDBService : NSObject

+ (TaskDBService*) getSharedInstance;

- (BOOL) saveTaskList:(TaskListEntity *)taskList;
- (NSArray *) findTaskLists;

- (BOOL) saveTask:(TaskEntity *)device;
- (TaskEntity *) findTaskByCode:(NSString*)Code;

@end
