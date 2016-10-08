//
//  PlanListEntity.h
//  wy
//
//  Created by wangyilu on 16/10/8.
//  Copyright © 2016年 ___PURANG___. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PlanListEntity : NSObject

- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

@property (nonatomic, copy, readonly) NSString *Code;
@property (nonatomic, copy, readonly) NSString *Name;
@property (nonatomic, copy, readonly) NSString *ExecuteTime;
@property (nonatomic, copy, readonly) NSString *TaskStatus;
@property (nonatomic, copy, readonly) NSString *GDCode;

@end
