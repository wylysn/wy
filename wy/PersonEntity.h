//
//  Person.h
//  wy
//
//  Created by wangyilu on 16/8/15.
//  Copyright © 2016年 ___PURANG___. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PersonEntity : NSObject
- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

@property (nonatomic, copy, readonly) NSString *id;
@property (nonatomic, copy, readonly) NSString *name;
@property (nonatomic, copy, readonly) NSString *department;
@property (nonatomic, copy, readonly) NSString *position;
@property (nonatomic, copy, readonly) NSString *phone;
@property (nonatomic, assign) NSString *isInCharge;
@property (nonatomic, assign) BOOL isChecked;
@end
