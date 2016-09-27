//
//  TaskDeviceEntity.h
//  wy
//
//  Created by wangyilu on 16/9/20.
//  Copyright © 2016年 ___PURANG___. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TaskDeviceEntity : NSObject

- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

@property (nonatomic, copy, readonly) NSString *Code;
@property (nonatomic, copy, readonly) NSString *ParentID;
@property (nonatomic, copy, readonly) NSString *Name;
@property (nonatomic, copy, readonly) NSString *Position;
@property (nonatomic, copy, readonly) NSString *PatrolTemplateCode;
@property (nonatomic) BOOL IsLocalSave;

- (id)jsonObject;

- (NSDictionary *) dictionaryWithPropertiesOfObject:(id)obj;

@end
