//
//  PlanDetailEntity.h
//  wy
//
//  Created by wangyilu on 16/10/10.
//  Copyright © 2016年 ___PURANG___. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PlanDetailEntity : NSObject

- (instancetype)initWithDictionary:(NSDictionary *)dictionary withType:(NSInteger)type;

@property (nonatomic, copy) NSString *Code;
@property (nonatomic, copy) NSString *Name;
@property (nonatomic, copy) NSString *Priority;
@property (nonatomic, copy) NSString *ExecuteTime;
@property (nonatomic, copy) NSArray *StepList;
@property (nonatomic, copy) NSArray *MaterialList;
@property (nonatomic, copy) NSArray *ToolList;
@property (nonatomic, copy) NSArray *PositionList;
@property (nonatomic, copy) NSArray *SBList;
@property (nonatomic, copy) NSArray *TaskAction;
@property (nonatomic, copy) NSDictionary *TaskInfo;
@property (nonatomic, copy) NSString *EditFields;

@property (nonatomic) BOOL IsLocalSave;

@end
