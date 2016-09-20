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
        _Code = dictionary[@"Code"];
        _Applyer = dictionary[@"Applyer"];
        _ApplyerTel = dictionary[@"ApplyerTel"];
        _ApplyerTel = dictionary[@"ApplyerTel"];
        _ServiceType = dictionary[@"ServiceType"];
        _Priority = dictionary[@"Priority"];
        _Location = dictionary[@"Location"];
        _Description = dictionary[@"Description"];
        _CreateDate = dictionary[@"CreateDate"];
        _Creator = dictionary[@"Creator"];
        _Department = dictionary[@"Department"];
        _Executors = dictionary[@"Executors"];
        _Leader = dictionary[@"Leader"];
        _EStartTime = dictionary[@"EStartTime"];
        _EEndTime = dictionary[@"EEndTime"];
        _EEndTime = dictionary[@"EEndTime"];
        _EWorkHours = dictionary[@"EWorkHours"];
        _AStartTime = dictionary[@"AStartTime"];
        _AEndTime = dictionary[@"AEndTime"];
        _AWorkHours = dictionary[@"AWorkHours"];
        _WorkContent = dictionary[@"WorkContent"];
        _EditFields = dictionary[@"EditFields"];
        _IsLocalSave = [dictionary[@"IsLocalSave"] boolValue];
        
//        NSString *notice = [NSString convertArrayToString:dictionary[@"TaskNotice"]];
        _TaskNotice = [NSString convertArrayToString:dictionary[@"TaskNotice"]];//dictionary[@"TaskNotice"];
        _TaskAction = [NSString convertArrayToString:dictionary[@"TaskAction"]];//dictionary[@"TaskAction"];
    }
    return self;
}

- (NSString *)uniqueIdentifier
{
    static NSInteger counter = 0;
    return [NSString stringWithFormat:@"unique-id-%@", @(counter++)];
}
@end
