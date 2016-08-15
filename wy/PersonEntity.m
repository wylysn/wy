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
        _phone = dictionary[@"phone"];
        _isChecked = FALSE;
    }
    return self;
}

@end
