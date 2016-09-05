//
//  InspectionModelEntity.m
//  wy
//
//  Created by wangyilu on 16/9/5.
//  Copyright © 2016年 ___PURANG___. All rights reserved.
//

#import "InspectionModelEntity.h"

@implementation InspectionModelEntity

- (instancetype)initWithDictionary:(NSDictionary *)dictionary
{
    self = super.init;
    if (self) {
        _Code = dictionary[@"Code"];
        _Name = dictionary[@"Name"];
        _CompayCode = dictionary[@"CompayCode"];
        _Memo = dictionary[@"Memo"];
        _ItemName = dictionary[@"ItemName"];
        _ItemType = (int)[dictionary[@"ItemType"] integerValue];
        _InputMax = [dictionary[@"InputMax"] floatValue];
        _InputMin = [dictionary[@"InputMin"] floatValue];
        _ItemValues = dictionary[@"ItemValues"];
        _UnitName = dictionary[@"UnitName"];
    }
    return self;
}

@end
