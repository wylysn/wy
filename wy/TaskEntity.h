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

@property (nonatomic, copy) NSString *identifier;
@property (nonatomic, copy) NSString *Code;
@property (nonatomic, copy) NSString *Applyer;
@property (nonatomic, copy) NSString *ApplyerTel;
@property (nonatomic, copy) NSString *ServiceType;
@property (nonatomic, copy) NSString *Priority;
@property (nonatomic, copy) NSString *Location;
@property (nonatomic, copy) NSString *Description;
@property (nonatomic, copy) NSString *CreateDate;
@property (nonatomic, copy) NSString *Creator;
@property (nonatomic, copy) NSString *Department;

@property (nonatomic, copy) NSString *Executors;
@property (nonatomic, copy) NSString *Leader;
@property (nonatomic, copy) NSString *EStartTime;
@property (nonatomic, copy) NSString *EEndTime;
@property (nonatomic, copy) NSString *EWorkHours;
@property (nonatomic, copy) NSString *AStartTime;
@property (nonatomic, copy) NSString *AEndTime;
@property (nonatomic, copy) NSString *AWorkHours;
@property (nonatomic, copy) NSString *WorkContent;
@property (nonatomic, copy) NSString *EditFields;
@property (nonatomic) BOOL IsLocalSave;

@property (nonatomic, copy) NSString *TaskNotice;
@property (nonatomic, copy) NSString *TaskAction;

@property (nonatomic, copy) NSString *SBList;
@property (nonatomic, copy) NSString *PicContent1;
@property (nonatomic, copy) NSString *PicContent2;
@property (nonatomic, copy) NSString *PicContent3;
@property (nonatomic, copy) NSString *PicContent4;

@property (nonatomic, copy) NSString *PicContent5;
@property (nonatomic, copy) NSString *PicContent6;
@property (nonatomic, copy) NSString *PicContent7;
@property (nonatomic, copy) NSString *PicContent8;

@property (nonatomic, copy) NSString *SBCheckList;//扩展字段 巡检任务设备检测保存字段
@end
