//
//  DeviceEntity.m
//  wy
//
//  Created by wangyilu on 16/8/29.
//  Copyright © 2016年 ___PURANG___. All rights reserved.
//

#import "DeviceListEntity.h"

@implementation DeviceListEntity

- (instancetype)initWithDictionary:(NSDictionary *)dictionary
{
    self = super.init;
    if (self) {
        _Code = dictionary[@"Code"];
        _Name = dictionary[@"Name"];
        _Class = dictionary[@"Class"];
        _Location = dictionary[@"Location"];
        _KeyId = dictionary[@"KeyId"];
    }
    return self;
}

@end
