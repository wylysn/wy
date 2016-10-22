//
//  MaterialsEntity.h
//  wy
//
//  Created by 王益禄 on 2016/10/22.
//  Copyright © 2016年 ___PURANG___. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MaterialsEntity : NSObject

- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

@property (nonatomic, copy, readonly) NSString *Code;
@property (nonatomic, copy, readonly) NSString *Name;
@property (nonatomic, readonly) float Number;

@end
