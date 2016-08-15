//
//  ChoosePersonService.m
//  wy
//
//  Created by wangyilu on 16/8/15.
//  Copyright © 2016年 ___PURANG___. All rights reserved.
//

#import "ChoosePersonService.h"
#import "PersonEntity.h"

@implementation ChoosePersonService

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.deptsList = [[NSMutableArray alloc] init];
        
        //测试数据，后期删除
        PersonEntity *p1 = [[PersonEntity alloc] initWithDictionary:@{@"id":@"P000000001",@"name":@"张三",@"phone":@"18621122732"}];
        NSMutableArray *persons1 = [[NSMutableArray alloc] init];
        PersonEntity *p2 = [[PersonEntity alloc] initWithDictionary:@{@"id":@"P000000002",@"name":@"李四",@"phone":@"18621122732"}];
        [persons1 addObject:p1];
        [persons1 addObject:p2];
        NSDictionary *d1 = @{@"dept":@"上海儿童艺术剧场",@"persons":persons1};
        
        //测试数据，后期删除
        PersonEntity *p3 = [[PersonEntity alloc] initWithDictionary:@{@"id":@"P000000003",@"name":@"王五",@"phone":@"18621122732"}];
        NSMutableArray *persons2 = [[NSMutableArray alloc] init];
        PersonEntity *p4 = [[PersonEntity alloc] initWithDictionary:@{@"id":@"P000000004",@"name":@"周八",@"phone":@"18621122732"}];
        [persons2 addObject:p3];
        [persons2 addObject:p4];
        NSDictionary *d2 = @{@"dept":@"上海世博馆",@"persons":persons2};
        
        [self.deptsList addObject:d1];
        [self.deptsList addObject:d2];
        
    }
    return self;
}

@end
