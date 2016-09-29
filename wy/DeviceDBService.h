//
//  DeviceDBService.h
//  wy
//
//  Created by wangyilu on 16/8/30.
//  Copyright © 2016年 ___PURANG___. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>
#import "DeviceListEntity.h"
#import "DeviceEntity.h"

@interface DeviceDBService : NSObject

+ (DeviceDBService*) getSharedInstance;
- (void)setSharedInstanceNull;

- (BOOL) saveDeviceList:(DeviceListEntity *)deviceList;
- (DeviceListEntity *) findDeviceListByCode:(NSString*)Code;
- (NSArray *) findAllDeviceLists;
- (NSArray *) findDeviceListsByName:(NSString*)name;

- (BOOL) saveDevice:(DeviceEntity *)device;
- (NSArray *)findAllDevices;
- (NSArray *) findDevicesByName:(NSString*)name;
- (NSArray *) findAssetsByKeyword:(NSString*)keyWord;
- (DeviceEntity *) findDeviceByCode:(NSString*)Code;

@end
