//
//  QRCodeScanViewController.h
//  wy
//
//  Created by 王益禄 on 16/9/16.
//  Copyright © 2016年 ___PURANG___. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TaskDeviceEntity.h"

@interface QRCodeScanViewController : UIViewController

@property (nonatomic, strong) TaskDeviceEntity *taskDeviceEntity;

@property (nonatomic) BOOL hasNotDeviceCode;
@property (nonatomic, strong) NSArray *taskDeviceArray;

@end
