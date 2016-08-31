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

+ (KnowledgeDBService*) getSharedInstance;
- (BOOL) saveKnowledge:(KnowledgeEntity *)knowledge;
- (KnowledgeEntity *) findKnowledgeById:(int)id;
- (NSArray *) findKnowledgeByKeyword:(NSString*)keyword;

@end
