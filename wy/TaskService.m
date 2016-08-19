//
//  TaskService.m
//  wy
//
//  Created by wangyilu on 16/8/11.
//  Copyright © 2016年 ___PURANG___. All rights reserved.
//

#import "TaskService.h"
#import "TaskEntity.h"

@implementation TaskService

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.taskEntitysList = [[NSMutableArray alloc] init];
        //测试数据，后期删除
        TaskEntity *e1 = [[TaskEntity alloc] initWithDictionary:@{@"id":@"PM000000001",@"name":@"PM000000001",@"type":@"1",@"desc":@"",@"position":@"",@"time":@"08:11 16:00"}];
        TaskEntity *e2 = [[TaskEntity alloc] initWithDictionary:@{@"id":@"pm000000002",@"name":@"PM000000001",@"type":@"2",@"desc":@"",@"position":@"",@"time":@"08:11 16:00"}];
        TaskEntity *e3 = [[TaskEntity alloc] initWithDictionary:@{@"id":@"PM000000003",@"name":@"PM000000001",@"type":@"3",@"desc":@"222222222222233333333333333333333333333333333333333333344",@"position":@"",@"time":@"08:11 16:00"}];
        TaskEntity *e4 = [[TaskEntity alloc] initWithDictionary:@{@"id":@"PM000000004",@"name":@"PM000000001",@"type":@"4",@"desc":@"",@"position":@"",@"time":@"08:11 16:00"}];
        TaskEntity *e5 = [[TaskEntity alloc] initWithDictionary:@{@"id":@"PM000000005",@"name":@"PM000000001",@"type":@"1",@"desc":@"",@"position":@"",@"time":@"08:11 16:00"}];
        TaskEntity *e6 = [[TaskEntity alloc] initWithDictionary:@{@"id":@"PM000000006",@"name":@"PM000000001",@"type":@"2",@"desc":@"",@"position":@"",@"time":@"08:11 16:00"}];
        [self.taskEntitysList addObject:e1];
        [self.taskEntitysList addObject:e2];
        [self.taskEntitysList addObject:e3];
        [self.taskEntitysList addObject:e4];
        [self.taskEntitysList addObject:e5];
        [self.taskEntitysList addObject:e6];
    }
    return self;
}

@end
