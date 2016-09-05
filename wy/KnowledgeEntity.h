//
//  KnowledgeEntity.h
//  wy
//
//  Created by wangyilu on 16/8/31.
//  Copyright © 2016年 ___PURANG___. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KnowledgeEntity : NSObject

- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

@property (nonatomic, readonly) int id;
@property (nonatomic, copy, readonly) NSString *Code;
@property (nonatomic, copy, readonly) NSString *KeyWord;
@property (nonatomic, copy, readonly) NSString *Content;
@property (nonatomic, copy, readonly) NSString *Lyxm;
@property (nonatomic, copy, readonly) NSString *createPerson;
@property (nonatomic, copy, readonly) NSString *createTime;

@end
