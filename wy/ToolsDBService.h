//
//  ToolsDBService.h
//  wy
//
//  Created by 王益禄 on 2016/10/22.
//  Copyright © 2016年 ___PURANG___. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>
#import "ToolsEntity.h"

@interface ToolsDBService : NSObject

+ (ToolsDBService *) getSharedInstance;
- (void) setSharedInstanceNull;
- (BOOL) saveTool:(ToolsEntity *)tool;
- (ToolsEntity *) findToolByCode:(NSString*)Code;
- (NSArray *) findAllTools;
- (NSArray *) findToolsByName:(NSString*)Name;

@end
