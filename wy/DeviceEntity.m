//
//  DeviceEntity.m
//  wy
//
//  Created by wangyilu on 16/8/29.
//  Copyright © 2016年 ___PURANG___. All rights reserved.
//

#import "DeviceEntity.h"

@implementation DeviceEntity

- (instancetype)initWithDictionary:(NSDictionary *)dictionary
{
    self = super.init;
    if (self) {
        _code = dictionary[@"code"];
        _name = dictionary[@"name"];
        _position = dictionary[@"position"];
    }
    return self;
}

@end
