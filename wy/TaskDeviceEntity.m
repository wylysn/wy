//
//  TaskDeviceEntity.m
//  wy
//
//  Created by wangyilu on 16/9/20.
//  Copyright © 2016年 ___PURANG___. All rights reserved.
//

#import "TaskDeviceEntity.h"

@implementation TaskDeviceEntity

- (instancetype)initWithDictionary:(NSDictionary *)dictionary
{
    self = super.init;
    if (self) {
        _Code = dictionary[@"Code"];
        _ParentID = dictionary[@"ParentID"];
        _Name = dictionary[@"Name"];
        _Position = dictionary[@"Position"];
        _PatrolTemplateCode = dictionary[@"PatrolTemplateCode"];
        _IsLocalSave = [dictionary[@"IsLocalSave"] boolValue];
    }
    return self;
}

@end
