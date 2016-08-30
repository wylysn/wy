//
//  PersonDBService.h
//  wy
//
//  Created by wangyilu on 16/8/30.
//  Copyright © 2016年 ___PURANG___. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>
#import "PersonEntity.h"
#import "DBManager.h"

@interface PersonDBService : NSObject

+ (PersonDBService*) getSharedInstance;
- (BOOL) saveData:(PersonEntity *)person;
- (PersonEntity *) findById:(NSString*)id;

@end
