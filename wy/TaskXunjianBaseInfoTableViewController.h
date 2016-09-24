//
//  TaskXunjianBaseInfoTableViewController.h
//  wy
//
//  Created by wangyilu on 16/8/29.
//  Copyright © 2016年 ___PURANG___. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TaskEntity.h"

@interface TaskXunjianBaseInfoTableViewController : UITableViewController

@property (nonatomic, strong) NSString *code;

@property (nonatomic, strong) NSString *ShortTitle; //工单类型，列表传过来

@property (nonatomic, strong) TaskEntity *taskEntity;

@end
