//
//  TaskEntity.h
//  wy
//
//  Created by wangyilu on 16/8/11.
//  Copyright © 2016年 ___PURANG___. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TaskEntity : NSObject
- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

@property (nonatomic, copy, readonly) NSString *identifier;
@property (nonatomic, copy, readonly) NSString *Code;
@property (nonatomic, copy, readonly) NSString *Applyer;
@property (nonatomic, copy, readonly) NSString *ApplyerTel;
@property (nonatomic, copy, readonly) NSString *ServiceType;
@property (nonatomic, copy, readonly) NSString *Priority;
@property (nonatomic, copy, readonly) NSString *Location;
@property (nonatomic, copy, readonly) NSString *Description;
@property (nonatomic, copy, readonly) NSString *CreateDate;
@property (nonatomic, copy, readonly) NSString *Creator;

@property (nonatomic, copy, readonly) NSString *Executors;
@property (nonatomic, copy, readonly) NSString *Leader;
@property (nonatomic, copy, readonly) NSString *EStartTime;
@property (nonatomic, copy, readonly) NSString *EEndTime;
@property (nonatomic, copy, readonly) NSString *EWorkHours;
@property (nonatomic, copy, readonly) NSString *AStartTime;
@property (nonatomic, copy, readonly) NSString *AEndTime;
@property (nonatomic, copy, readonly) NSString *AWorkHours;
@property (nonatomic, copy, readonly) NSString *WorkContent;
@property (nonatomic, copy, readonly) NSString *EditFields;
@property (nonatomic, readonly) BOOL IsLocalSave;
@end
