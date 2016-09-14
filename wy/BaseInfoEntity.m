//
//  BaseInfoEntity.m
//  wy
//
//  Created by wangyilu on 16/9/7.
//  Copyright © 2016年 ___PURANG___. All rights reserved.
//

#import "BaseInfoEntity.h"

@implementation BaseInfoEntity

- (instancetype)initWithDictionary:(NSDictionary *)dictionary
{
    self = super.init;
    if (self) {
        _templateid = dictionary[@"templateid"];
        _Name = dictionary[@"Name"];
    }
    return self;
}

@end
