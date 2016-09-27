//
//  TaskListEntity.h
//  wy
//
//  Created by 王益禄 on 16/9/3.
//  Copyright © 2016年 ___PURANG___. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TaskListEntity : NSObject

- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

@property (nonatomic, copy, readonly) NSString *identifier;
@property (nonatomic, copy, readonly) NSString *Code;
@property (nonatomic, copy, readonly) NSString *ShortTitle;
@property (nonatomic, copy, readonly) NSString *Subject;
@property (nonatomic, copy, readonly) NSString *ReceiveTime;
@property (nonatomic, copy, readonly) NSString *TaskStatus;
@property (nonatomic, copy, readonly) NSString *ServiceType;
@property (nonatomic, copy, readonly) NSString *Priority;
@property (nonatomic, copy, readonly) NSString *Location;
@property (nonatomic) BOOL IsLocalSave;

@end
