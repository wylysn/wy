//
//  ToolsEntity.h
//  wy
//
//  Created by 王益禄 on 2016/10/22.
//  Copyright © 2016年 ___PURANG___. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ToolsEntity : NSObject

- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

- (instancetype)initWithNetDictionary:(NSDictionary *)dictionary;

- (NSDictionary *)toDictionary;

@property (nonatomic, copy, readonly) NSString *Code;
@property (nonatomic, copy, readonly) NSString *Name;
@property (nonatomic) float Number;

@end
