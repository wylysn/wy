//
//  TaskXunjianDeviceTableViewController.h
//  wy
//
//  Created by wangyilu on 16/8/29.
//  Copyright © 2016年 ___PURANG___. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TaskEntity.h"

@interface TaskXunjianDeviceTableViewController : UITableViewController

@property (nonatomic, strong) NSString *code;

@property (nonatomic, strong) TaskEntity *taskEntity;

@property (nonatomic, strong) NSArray *taskDeviceArray;



@end
