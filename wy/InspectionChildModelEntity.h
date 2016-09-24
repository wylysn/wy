//
//  InspectionChildModelEntity.h
//  wy
//
//  Created by wangyilu on 16/9/14.
//  Copyright © 2016年 ___PURANG___. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface InspectionChildModelEntity : NSObject

- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

@property (nonatomic, copy) NSString *ParentCode;
@property (nonatomic, copy) NSString *ItemName;
@property (nonatomic) NSInteger ItemType;
@property (nonatomic, copy) NSString *InputMax;
@property (nonatomic, copy) NSString *InputMin;
@property (nonatomic, copy) NSString *ItemValues;
@property (nonatomic, copy) NSString *UnitName;
@property (nonatomic, copy) NSString *ItemValue;
@property (nonatomic, copy) NSString *DataValid;

@end
