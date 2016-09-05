//
//  TaskDevicesService.m
//  wy
//
//  Created by wangyilu on 16/8/29.
//  Copyright © 2016年 ___PURANG___. All rights reserved.
//

#import "TaskDevicesService.h"
#import "DeviceListEntity.h"

@implementation TaskDevicesService

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.taskDevicesList = [[NSMutableArray alloc] init];
        
        DeviceListEntity *device1 = [[DeviceListEntity alloc] initWithDictionary:@{@"code":@"000268",@"name":@"冷却塔饮水设备",@"position":@"非电力系统/化水/化水设备"}];
        DeviceListEntity *device2 = [[DeviceListEntity alloc] initWithDictionary:@{@"code":@"000269",@"name":@"冷却塔饮水设备",@"position":@"非电力系统/化水/化水设备"}];
        DeviceListEntity *device3 = [[DeviceListEntity alloc] initWithDictionary:@{@"code":@"000270",@"name":@"冷却塔饮水设备",@"position":@"非电力系统/化水/化水设备"}];
        
        [self.taskDevicesList addObject:device1];
        [self.taskDevicesList addObject:device2];
        [self.taskDevicesList addObject:device3];
    }
    return self;
}

@end
