//
//  MaterialsEntity.m
//  wy
//
//  Created by 王益禄 on 2016/10/22.
//  Copyright © 2016年 ___PURANG___. All rights reserved.
//

#import "MaterialsEntity.h"

@implementation MaterialsEntity

- (instancetype)initWithDictionary:(NSDictionary *)dictionary
{
    self = super.init;
    if (self) {
        _Code = dictionary[@"Code"];
        _Name = dictionary[@"Name"];
        _Number = [dictionary[@"Number"] floatValue];
    }
    return self;
}

@end
