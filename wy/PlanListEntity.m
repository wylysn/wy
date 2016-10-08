//
//  PlanListEntity.m
//  wy
//
//  Created by wangyilu on 16/10/8.
//  Copyright © 2016年 ___PURANG___. All rights reserved.
//

#import "PlanListEntity.h"

@implementation PlanListEntity

- (instancetype)initWithDictionary:(NSDictionary *)dictionary
{
    self = super.init;
    if (self) {
        _Code = dictionary[@"Code"];
        _Name = dictionary[@"Name"];
        _ExecuteTime = dictionary[@"ExecuteTime"];
        _TaskStatus = dictionary[@"TaskStatus"];
        _GDCode = dictionary[@"GDCode"];
    }
    return self;
}

@end
