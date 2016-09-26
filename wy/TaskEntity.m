//
//  TaskEntity.m
//  wy
//
//  Created by wangyilu on 16/8/11.
//  Copyright © 2016年 ___PURANG___. All rights reserved.
//

#import "TaskEntity.h"

@implementation TaskEntity
- (instancetype)initWithDictionary:(NSDictionary *)dictionary
{
    self = super.init;
    if (self) {
        _Code = dictionary[@"Code"];
        _Applyer = dictionary[@"Applyer"];
        _ApplyerTel = dictionary[@"ApplyerTel"];
        _ApplyerTel = dictionary[@"ApplyerTel"];
        _ServiceType = dictionary[@"ServiceType"];
        _Priority = dictionary[@"Priority"];
        _Location = dictionary[@"Location"];
        _Description = [dictionary[@"Description"] isBlankString]?@"":dictionary[@"Description"];
        _CreateDate = dictionary[@"CreateDate"];
        _Creator = dictionary[@"Creator"];
        _Department = dictionary[@"Department"];
        if ((NSNull *)dictionary[@"Executors"]==[NSNull null]) {
            _Executors = @"";
        } else {
            _Executors = [dictionary[@"Executors"] isKindOfClass:[NSArray class]]?[NSString convertArrayToString:dictionary[@"Executors"]]:dictionary[@"Executors"];
        }
        if ((NSNull *)dictionary[@"Leader"]==[NSNull null]) {
            _Leader = @"";
        } else {
            _Leader = [dictionary[@"Leader"] isKindOfClass:[NSArray class]]?[NSString convertArrayToString:dictionary[@"Leader"]]:dictionary[@"Leader"];
        }
        _EStartTime = dictionary[@"EStartTime"];
        _EEndTime = dictionary[@"EEndTime"];
        _EEndTime = dictionary[@"EEndTime"];
        _EWorkHours = [dictionary[@"EWorkHours"] isBlankString]?@"":dictionary[@"EWorkHours"];
        _AStartTime = dictionary[@"AStartTime"];
        _AEndTime = dictionary[@"AEndTime"];
        _AWorkHours = [dictionary[@"AWorkHours"] isBlankString]?@"":dictionary[@"AWorkHours"];
        _WorkContent = [dictionary[@"WorkContent"] isBlankString]?@"":dictionary[@"WorkContent"];
        _EditFields = dictionary[@"EditFields"];
        _IsLocalSave = [dictionary[@"IsLocalSave"] boolValue];
        
        if ((NSNull *)dictionary[@"TaskNotice"]==[NSNull null]) {
            _TaskNotice = @"";
        } else {
            _TaskNotice = [dictionary[@"TaskNotice"] isKindOfClass:[NSArray class]]?[NSString convertArrayToString:dictionary[@"TaskNotice"]]:dictionary[@"TaskNotice"];
        }
        if ((NSNull *)dictionary[@"SBList"]==[NSNull null]) {
            _SBList = @"";
        } else {
            _SBList = [dictionary[@"SBList"] isKindOfClass:[NSArray class]]?[NSString convertArrayToString:dictionary[@"SBList"]]:dictionary[@"SBList"];
        }
        if ((NSNull *)dictionary[@"TaskAction"]==[NSNull null]) {
            _TaskAction = @"";
        } else {
            _TaskAction = [dictionary[@"TaskAction"] isKindOfClass:[NSArray class]]?[NSString convertArrayToString:dictionary[@"TaskAction"]]:dictionary[@"TaskAction"];
        }
        _PicContent1 = dictionary[@"PicContent1"];
        _PicContent2 = dictionary[@"PicContent2"];
        _PicContent3 = dictionary[@"PicContent3"];
        _PicContent4 = dictionary[@"PicContent4"];
        if ((NSNull *)dictionary[@"SBCheckLists"]==[NSNull null]) {
            _SBCheckList = @"";
        } else {
            _SBCheckList = [dictionary[@"SBCheckLists"] isKindOfClass:[NSArray class]]?[NSString convertArrayToString:dictionary[@"SBCheckLists"]]:dictionary[@"SBCheckLists"];
        }
    }
    return self;
}

- (NSString *)uniqueIdentifier
{
    static NSInteger counter = 0;
    return [NSString stringWithFormat:@"unique-id-%@", @(counter++)];
}
@end
