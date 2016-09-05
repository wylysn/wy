//
//  Person.m
//  wy
//
//  Created by wangyilu on 16/8/15.
//  Copyright © 2016年 ___PURANG___. All rights reserved.
//

#import "PersonEntity.h"

@implementation PersonEntity

- (instancetype)initWithDictionary:(NSDictionary *)dictionary
{
    self = super.init;
    if (self) {
        _id = dictionary[@"id"];
        _AppUserName = dictionary[@"AppUserName"];
        _EmployeeName = dictionary[@"EmployeeName"];
        _DepartName = dictionary[@"DepartName"];
        _SortIndex = [(NSString *)dictionary[@"SortIndex"] integerValue];
        _Phone = dictionary[@"Phone"];
        _Mobile = dictionary[@"Mobile"];
        _isInCharge = dictionary[@"isInCharge"];
        _isChecked = FALSE;
    }
    return self;
}

@end
