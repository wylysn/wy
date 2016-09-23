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

//@property (nonatomic, copy, readonly) NSString *id;
@property (nonatomic, copy, readonly) NSString *AppUserName;
@property (nonatomic, readonly) NSInteger EmployeeId;
@property (nonatomic, copy, readonly) NSString *EmployeeName;
@property (nonatomic, readonly) NSInteger DepartmentId;
@property (nonatomic, copy, readonly) NSString *DepartName;
@property (nonatomic, readonly) NSInteger SortIndex;
@property (nonatomic, copy, readonly) NSString *Phone;
@property (nonatomic, copy, readonly) NSString *Mobile;
@property (nonatomic, assign) NSString *isInCharge;
@property (nonatomic, assign) BOOL isChecked;
@end
