//
//  DeviceClassEntity.m
//  wy
//
//  Created by 王益禄 on 2016/10/22.
//  Copyright © 2016年 ___PURANG___. All rights reserved.
//

#import "DeviceClassEntity.h"

@implementation DeviceClassEntity

- (instancetype)initWithDictionary:(NSDictionary *)dictionary
{
    self = super.init;
    if (self) {
        _ID = [dictionary[@"ID"] integerValue];
        _Code = dictionary[@"Code"];
        _Name = dictionary[@"Name"];
        _ParentID = [dictionary[@"ParentID"] integerValue];
    }
    return self;
}

@end
