//
//  PositionDBservice.h
//  wy
//
//  Created by wangyilu on 16/9/1.
//  Copyright © 2016年 ___PURANG___. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>
#import "PositionEntity.h"

@interface PositionDBservice : NSObject

+ (PositionDBservice*) getSharedInstance;
- (BOOL) savePosition:(PositionEntity *)position;
- (NSArray *) findAllPositions;
- (NSArray *) findPositionsByParentId:(int) parentId;

@end
