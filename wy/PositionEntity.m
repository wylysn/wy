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
        _ID = [dictionary[@"ID"] integerValue];
        _Code = dictionary[@"Code"];
        _Name = dictionary[@"Name"];
        _FullName = dictionary[@"FullName"];
        _Sort = dictionary[@"Sort"];
        _Status = dictionary[@"Status"];
        _Description = dictionary[@"Description"];
        _ParentID = (NSNull *)dictionary[@"ParentID"] == [NSNull null]?0:[dictionary[@"ParentID"] integerValue];
        _Prj_Code = dictionary[@"Prj_Code"];
    }
    return self;
}

@end
