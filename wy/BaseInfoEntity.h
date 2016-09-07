//
//  BaseInfoEntity.h
//  wy
//
//  Created by wangyilu on 16/9/7.
//  Copyright © 2016年 ___PURANG___. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BaseInfoEntity : NSObject

- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

@property (nonatomic, copy, readonly) NSString *KeyId;
@property (nonatomic, copy, readonly) NSString *Name;
@property (nonatomic, assign) BOOL hasDownLoad;

@end
