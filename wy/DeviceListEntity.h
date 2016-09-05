//
//  DeviceEntity.h
//  wy
//
//  Created by wangyilu on 16/8/29.
//  Copyright © 2016年 ___PURANG___. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DeviceListEntity : NSObject

- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

@property (nonatomic, copy, readonly) NSString *Code;
@property (nonatomic, copy, readonly) NSString *Name;
@property (nonatomic, copy, readonly) NSString *Class;
@property (nonatomic, copy, readonly) NSString *Location;
@property (nonatomic, copy, readonly) NSString *KeyId;

@end
