//
//  KnowledgeEntity.m
//  wy
//
//  Created by wangyilu on 16/8/31.
//  Copyright © 2016年 ___PURANG___. All rights reserved.
//

#import "KnowledgeEntity.h"

@implementation KnowledgeEntity

- (instancetype)initWithDictionary:(NSDictionary *)dictionary
{
    self = super.init;
    if (self) {
        _id = (int)[dictionary[@"id"] integerValue];
        _Code = dictionary[@"Code"];
        _Content = dictionary[@"Content"];
        _Lyxm = dictionary[@"Lyxm"];
        _createPerson = dictionary[@"createPerson"];
        _createTime = dictionary[@"createTime"];
    }
    return self;
}

@end
