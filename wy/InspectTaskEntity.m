//
//  InspectTaskEntity.m
//  wy
//
//  Created by wangyilu on 16/8/23.
//  Copyright © 2016年 ___PURANG___. All rights reserved.
//

#import "InspectTaskEntity.h"

@implementation InspectTaskEntity

- (instancetype)initWithDictionary:(NSDictionary *)dictionary
{
    self = super.init;
    if (self) {
        _id = dictionary[@"id"];
        _name = dictionary[@"name"];
        _status = dictionary[@"status"];
        _startTime = dictionary[@"startTime"];
        _endTime = dictionary[@"endTime"];
        _dianwei = dictionary[@"dianwei"];
    }
    return self;
}

@end
