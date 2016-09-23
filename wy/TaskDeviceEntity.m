//
//  TaskDeviceEntity.m
//  wy
//
//  Created by wangyilu on 16/9/20.
//  Copyright © 2016年 ___PURANG___. All rights reserved.
//

#import "TaskDeviceEntity.h"
#import <objc/runtime.h>

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

- (id)jsonObject
{
    return @{@"Code"                   : self.Code,
             @"ParentID"               : self.ParentID,
             @"Name"                   : self.Name,
             @"Position"               : self.Position,
             @"PatrolTemplateCode"     : self.PatrolTemplateCode,
             @"IsLocalSave"            : @(self.IsLocalSave)};
}

- (NSDictionary *) dictionaryWithPropertiesOfObject:(id)obj
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    unsigned count;
    objc_property_t *properties = class_copyPropertyList([obj class], &count);
    
    for (int i = 0; i < count; i++) {
        NSString *key = [NSString stringWithUTF8String:property_getName(properties[i])];
        [dict setObject:[obj valueForKey:key] forKey:key];
    }
    
    free(properties);
    
    return [NSDictionary dictionaryWithDictionary:dict];
}

@end
