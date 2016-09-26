//
//  TaskListEntity.m
//  wy
//
//  Created by 王益禄 on 16/9/3.
//  Copyright © 2016年 ___PURANG___. All rights reserved.
//

#import "TaskListEntity.h"

@implementation TaskListEntity

- (instancetype)initWithDictionary:(NSDictionary *)dictionary
{
    self = super.init;
    if (self) {
        _identifier = [self uniqueIdentifier];
        _Code = dictionary[@"Code"];
        _ShortTitle = dictionary[@"ShortTitle"];
        _Subject = dictionary[@"Subject"];
        _ReceiveTime = dictionary[@"ReceiveTime"];
        _TaskStatus = dictionary[@"TaskStatus"];
        _ServiceType = dictionary[@"ServiceType"];
        _Priority = dictionary[@"Priority"];
        _Location = dictionary[@"Location"];
        _IsLocalSave = [dictionary[@"IsLocalSave"] boolValue];
    }
    return self;
}

- (NSString *)uniqueIdentifier
{
    static NSInteger counter = 0;
    return [NSString stringWithFormat:@"unique-id-%@", @(counter++)];
}

@end
