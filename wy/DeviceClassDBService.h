//
//  DeviceClassDBService.h
//  wy
//
//  Created by 王益禄 on 2016/10/22.
//  Copyright © 2016年 ___PURANG___. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>
#import "DeviceClassEntity.h"

@interface DeviceClassDBService : NSObject

+ (DeviceClassDBService *) getSharedInstance;
- (void)setSharedInstanceNull;
- (BOOL) saveDeviceClass:(DeviceClassEntity *)deviceClass;
- (NSArray *) findAllDeviceClass;
- (NSMutableArray *) findDeviceClassByParent:(DeviceClassEntity *)parent;

@end
