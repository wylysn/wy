//
//  InspectionChildModelEntity.m
//  wy
//
//  Created by wangyilu on 16/9/14.
//  Copyright © 2016年 ___PURANG___. All rights reserved.
//

#import "InspectionChildModelEntity.h"

@implementation InspectionChildModelEntity

- (instancetype)initWithDictionary:(NSDictionary *)dictionary
{
    self = super.init;
    if (self) {
        _ParentCode = dictionary[@"ParentCode"];
        _ItemName = dictionary[@"ItemName"];
        _ItemType = [dictionary[@"ItemType"] integerValue];
        _InputMax = dictionary[@"InputMax"];
        _InputMin = dictionary[@"InputMin"];
        _ItemValues = dictionary[@"ItemValues"];
        _UnitName = dictionary[@"UnitName"];
        _ItemValue = dictionary[@"ItemValue"];
        _DataValid = dictionary[@"DataValid"];
    }
    return self;
}

@end
