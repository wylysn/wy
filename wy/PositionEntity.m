//
//  PositionEntity.m
//  wy
//
//  Created by wangyilu on 16/9/1.
//  Copyright © 2016年 ___PURANG___. All rights reserved.
//

#import "PositionEntity.h"

@implementation PositionEntity

- (instancetype)initWithDictionary:(NSDictionary *)dictionary
{
    self = super.init;
    if (self) {
        _id = (int)[dictionary[@"id"] integerValue];
        _Code = dictionary[@"Code"];
        _Name = dictionary[@"Name"];
        _FullName = dictionary[@"FullName"];
        _Sort = [dictionary[@"Sort"] integerValue];
        _Status = [dictionary[@"Status"] integerValue];
        _Description = dictionary[@"Description"];
        _ParentID = (int)[dictionary[@"ParentID"] integerValue];
        _Prj_Code = dictionary[@"Prj_Code"];
    }
    return self;
}

@end
