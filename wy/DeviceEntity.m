//
//  DeviceEntity.m
//  wy
//
//  Created by wangyilu on 16/9/5.
//  Copyright © 2016年 ___PURANG___. All rights reserved.
//

#import "DeviceEntity.h"

@implementation DeviceEntity

- (instancetype)initWithDictionary:(NSDictionary *)dictionary
{
    self = super.init;
    if (self) {
        _Code = dictionary[@"Code"];
        _Name = dictionary[@"Name"];
        _Class = dictionary[@"Class"];
        _QRCode = dictionary[@"QRCode"];
        _Model = dictionary[@"Model"];
        
        _Brand = dictionary[@"Brand"];
        _Xlhao = dictionary[@"Xlhao"];
        _Pro_Date = dictionary[@"Pro_Date"];
        _Weight = dictionary[@"Weight"];
        _Des_Life = dictionary[@"Des_Life"];
        _Pos = dictionary[@"Pos"];
        _Description = dictionary[@"Description"];
        _Patrol_Tpl = dictionary[@"Patrol_Tpl"];
        _Status = [dictionary[@"Status"] integerValue];
        _Picture = dictionary[@"Picture"];
        _Attachment = dictionary[@"Attachment"];
        _Organizationid = dictionary[@"Organizationid"];
    }
    return self;
}

@end
