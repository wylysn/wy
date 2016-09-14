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
    }
    return self;
}

@end
