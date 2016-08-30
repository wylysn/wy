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
        _name = dictionary[@"name"];
        _department = dictionary[@"department"];
        _position = dictionary[@"position"];
        _phone = dictionary[@"phone"];
        _isInCharge = dictionary[@"isInCharge"];
        _isChecked = FALSE;
    }
    return self;
}

@end
