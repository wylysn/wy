//
//  TaskEntity.m
//  wy
//
//  Created by wangyilu on 16/8/11.
//  Copyright © 2016年 ___PURANG___. All rights reserved.
//

#import "TaskEntity.h"

@implementation TaskEntity
- (instancetype)initWithDictionary:(NSDictionary *)dictionary
{
    self = super.init;
    if (self) {
        _identifier = [self uniqueIdentifier];
        _id = dictionary[@"id"];
        _name = dictionary[@"name"];
        _type = dictionary[@"type"];
        _desc = dictionary[@"desc"];
        _position = dictionary[@"position"];
        _priority = dictionary[@"priority"];
        _orderStatus = dictionary[@"orderStatus"];
        _time = dictionary[@"time"];
    }
    return self;
}

- (NSString *)uniqueIdentifier
{
    static NSInteger counter = 0;
    return [NSString stringWithFormat:@"unique-id-%@", @(counter++)];
}
@end
