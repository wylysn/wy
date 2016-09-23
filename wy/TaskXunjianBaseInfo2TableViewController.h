//
//  TaskXunjianBaseInfo2TableViewController.h
//  wy
//
//  Created by wangyilu on 16/9/8.
//  Copyright © 2016年 ___PURANG___. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TaskXunjian2ViewController.h"
#import "TaskEntity.h"

@interface TaskXunjianBaseInfo2TableViewController : UITableViewController

@property (nonatomic, strong) NSString *code;

@property (nonatomic, strong) TaskEntity *taskEntity;

@end
