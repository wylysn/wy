//
//  KnowledgeDBService.h
//  wy
//
//  Created by wangyilu on 16/8/31.
//  Copyright © 2016年 ___PURANG___. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>
#import "KnowledgeEntity.h"

@interface KnowledgeDBService : NSObject

- (void)setSharedInstanceNull;
+ (KnowledgeDBService*) getSharedInstance;
- (void) createDB;
- (BOOL) saveKnowledge:(KnowledgeEntity *)knowledge;
- (KnowledgeEntity *) findKnowledgeByCode:(NSString *)Code;
- (NSArray *) findKnowledgeByKeyword:(NSString*)keyword;

@end
