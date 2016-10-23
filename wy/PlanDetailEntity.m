//
//  PlanDetailEntity.m
//  wy
//
//  Created by wangyilu on 16/10/10.
//  Copyright © 2016年 ___PURANG___. All rights reserved.
//

#import "PlanDetailEntity.h"

@implementation PlanDetailEntity

- (instancetype)initWithDictionary:(NSDictionary *)dictionary
{
    self = super.init;
    if (self) {
        _Code = dictionary[@"Code"];
        _Name = dictionary[@"Name"];
        _Priority = dictionary[@"Priority"];
        _ExecuteTime = dictionary[@"ExecuteTime"];
        _StepList = dictionary[@"StepList"];
        _MaterialList = dictionary[@"MaterialList"];
        _ToolList = dictionary[@"ToolList"];
        _PositionList = dictionary[@"PositionList"];
        _SBList = dictionary[@"SBList"];
        _TaskAction = dictionary[@"TaskAction"];
        _TaskInfo = dictionary[@"TaskInfo"];
        _EditFields = dictionary[@"EditFields"];
        
        _IsLocalSave = [dictionary[@"IsLocalSave"] boolValue];
    }
    return self;
}

@end
