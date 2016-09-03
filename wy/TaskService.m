//
//  TaskService.m
//  wy
//
//  Created by wangyilu on 16/8/11.
//  Copyright © 2016年 ___PURANG___. All rights reserved.
//

#import "TaskService.h"

@implementation TaskService

- (NSMutableArray *)getTaskListEntityArr:(NSDictionary *)condition {
    NSMutableArray *taskEntityArr = [[NSMutableArray alloc] init];
    //测试数据，后期删除
    TaskListEntity *e1 = [[TaskListEntity alloc] initWithDictionary:@{@"Code":@"PM000000001",@"ShortTitle":@"1",@"Subject":@"任务紧急，需尽快完成",@"ReceiveTime":@"2016-08-11 16:00",@"TaskStatus":@"1",@"ServiceType":@"1",@"Priority":@"1",@"IsLocalSave":@FALSE}];
    TaskListEntity *e2 = [[TaskListEntity alloc] initWithDictionary:@{@"Code":@"PM000000002",@"ShortTitle":@"2",@"Subject":@"任务紧急，需尽快完成",@"ReceiveTime":@"2016-08-11 16:00",@"TaskStatus":@"2",@"ServiceType":@"2",@"Priority":@"2",@"IsLocalSave":@FALSE}];
    TaskListEntity *e3 = [[TaskListEntity alloc] initWithDictionary:@{@"Code":@"PM000000003",@"ShortTitle":@"3",@"Subject":@"任务紧急，需尽快完成",@"ReceiveTime":@"2016-08-11 16:00",@"TaskStatus":@"3",@"ServiceType":@"3",@"Priority":@"3",@"IsLocalSave":@FALSE}];
    TaskListEntity *e4 = [[TaskListEntity alloc] initWithDictionary:@{@"Code":@"PM000000004",@"ShortTitle":@"1",@"Subject":@"任务紧急，需尽快完成",@"ReceiveTime":@"2016-08-11 16:00",@"TaskStatus":@"4",@"ServiceType":@"4",@"Priority":@"4",@"IsLocalSave":@FALSE}];
    TaskListEntity *e5 = [[TaskListEntity alloc] initWithDictionary:@{@"Code":@"PM000000005",@"ShortTitle":@"1",@"Subject":@"任务紧急，需尽快完成",@"ReceiveTime":@"2016-08-11 16:00",@"TaskStatus":@"5",@"ServiceType":@"1",@"Priority":@"1",@"IsLocalSave":@FALSE}];
    [taskEntityArr addObject:e1];
    [taskEntityArr addObject:e2];
    [taskEntityArr addObject:e3];
    [taskEntityArr addObject:e4];
    [taskEntityArr addObject:e5];
    return taskEntityArr;
}

- (TaskEntity *)getTaskEntity:(NSString *)code {
    TaskEntity *e1 = [[TaskEntity alloc] initWithDictionary:@{@"Code":@"PM000000001",@"Applyer":@"叶雨",@"ApplyerTel":@"13888888888",@"ServiceType":@"1",@"Priority":@"1",@"Location":@"",@"Description":@"",@"CreateDate":@"2016-09-03 17:00",@"Creator":@"系统",@"Executors":@"",@"Leader":@"",@"EStartTime":@"",@"EEndTime":@"",@"EWorkHours":@"",@"AStartTime":@"",@"AEndTime":@"",@"AWorkHours":@"",@"WorkContent":@"",@"EditFields":@"",@"IsLocalSave":@FALSE}];
    return e1;
}

@end
