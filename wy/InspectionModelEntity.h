//
//  InspectionModelEntity.h
//  wy
//
//  Created by wangyilu on 16/9/5.
//  Copyright © 2016年 ___PURANG___. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface InspectionModelEntity : NSObject

- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

@property (nonatomic, copy) NSString *Code;
@property (nonatomic, copy) NSString *Name;
@property (nonatomic, copy) NSString *CompayCode;
@property (nonatomic, copy) NSString *Memo;

@end
