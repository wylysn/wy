//
//  WorkOrderService.m
//  wy
//
//  Created by wangyilu on 16/8/19.
//  Copyright © 2016年 ___PURANG___. All rights reserved.
//

#import "WorkOrderService.h"
#import "TaskEntity.h"

@implementation WorkOrderService

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.taskEntitysList = [[NSMutableArray alloc] init];
        //测试数据，后期删除
        TaskEntity *e1 = [[TaskEntity alloc] initWithDictionary:@{@"id":@"PM000000001",@"type":@"1",@"desc":@"张东路",@"position":@"张东路",@"time":@"08:11 16:00",@"priority":@"紧急",@"orderStatus":@"终止"}];
        TaskEntity *e2 = [[TaskEntity alloc] initWithDictionary:@{@"id":@"pm000000002",@"type":@"2",@"desc":@"张东路张东路，张东路，张东路，张东路，张东路，张东路",@"position":@"张东路",@"time":@"08:11 16:00",@"priority":@"高",@"orderStatus":@"已存单"}];
        TaskEntity *e3 = [[TaskEntity alloc] initWithDictionary:@{@"id":@"PM000000003",@"type":@"3",@"desc":@"张东路",@"position":@"张东路",@"time":@"08:11 16:00",@"priority":@"低",@"orderStatus":@"已完成"}];
        [self.taskEntitysList addObject:e1];
        [self.taskEntitysList addObject:e2];
        [self.taskEntitysList addObject:e3];
    }
    return self;
}

@end
