//
//  InspectTaskService.m
//  wy
//
//  Created by wangyilu on 16/8/23.
//  Copyright © 2016年 ___PURANG___. All rights reserved.
//

#import "InspectTaskService.h"
#import "InspectTaskEntity.h"

@implementation InspectTaskService

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.taskEntitysList = [[NSMutableArray alloc] init];
        //测试数据，后期删除
        InspectTaskEntity *e1 = [[InspectTaskEntity alloc] initWithDictionary:@{@"id":@"1",@"name":@"测试1",@"status":@"1",@"startTime":@"08-11 16:00",@"endTime":@"08-11 17:00",@"dianwei":@""}];
        InspectTaskEntity *e2 = [[InspectTaskEntity alloc] initWithDictionary:@{@"id":@"1",@"name":@"测试1",@"status":@"2",@"startTime":@"08-11 16:00",@"endTime":@"08-11 17:00",@"dianwei":@"3"}];
        InspectTaskEntity *e3 = [[InspectTaskEntity alloc] initWithDictionary:@{@"id":@"1",@"name":@"测试1",@"status":@"3",@"startTime":@"08-11 16:00",@"endTime":@"08-11 17:00",@"dianwei":@"3"}];
        InspectTaskEntity *e4 = [[InspectTaskEntity alloc] initWithDictionary:@{@"id":@"1",@"name":@"测试1",@"status":@"4",@"startTime":@"08-11 16:00",@"endTime":@"08-11 17:00",@"dianwei":@"3"}];
        [self.taskEntitysList addObject:e1];
        [self.taskEntitysList addObject:e2];
        [self.taskEntitysList addObject:e3];
        [self.taskEntitysList addObject:e4];
    }
    return self;
}

@end
