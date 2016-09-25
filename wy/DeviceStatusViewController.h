//
//  DeviceStatusViewController.h
//  wy
//
//  Created by wangyilu on 16/9/19.
//  Copyright © 2016年 ___PURANG___. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "InspectionModelEntity.h"
#import "InspectionChildModelEntity.h"

@interface DeviceStatusViewController : UIViewController

@property (nonatomic, strong) InspectionModelEntity *inspectionModel;
@property (nonatomic, strong) NSArray *childModelsArray;
@property (nonatomic, strong) NSString *taskDeviceCode;


@property (nonatomic, assign) NSInteger num;

@end
