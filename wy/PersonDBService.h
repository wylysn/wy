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

@interface PersonDBService : NSObject

+ (PersonDBService*) getSharedInstance;
- (void)setSharedInstanceNull;
- (BOOL) saveData:(PersonEntity *)person;
- (PersonEntity *) findByAppUserName:(NSString*)AppUserName;
- (NSArray *) findAllPersons;
- (NSArray *) findPersonsByEmployeeName:(NSString*)AppUserName;

@end
