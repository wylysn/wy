//
//  DeviceDBService.h
//  wy
//
//  Created by wangyilu on 16/8/30.
//  Copyright © 2016年 ___PURANG___. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>
#import "DeviceEntity.h"

@interface DeviceDBService : NSObject

+ (DeviceDBService*) getSharedInstance;
- (BOOL) saveDevice:(DeviceEntity *)device;
- (DeviceEntity *) findDeviceById:(NSString*)id;
- (NSArray *) findAll;
- (NSArray *) findDevicesByName:(NSString*)name;

@end
