//
//  TaskTableViewCell.h
//  wy
//
//  Created by wangyilu on 16/8/11.
//  Copyright © 2016年 ___PURANG___. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TaskListEntity.h"
#import "TaskTableViewController.h"
#import "TaskStatusView.h"
#import "PriorityLabel.h"
#import "PriorityWrapView.h"
#import "PRLabel.h"

@interface TaskTableViewCell : UITableViewCell

@property (nonatomic, strong) TaskListEntity *entity;
@property (nonatomic, strong) TaskTableViewController *parentController;
@property (weak, nonatomic) IBOutlet UILabel *CodeLabel;
@property (weak, nonatomic) IBOutlet PriorityLabel *PriorityLabel;
@property (weak, nonatomic) IBOutlet UILabel *ReceiveTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *ServiceTypeLabel;
@property (weak, nonatomic) IBOutlet UILabel *ShortTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *SubjectLabel;
@property (weak, nonatomic) IBOutlet UILabel *TaskStatusLabel;
@property (weak, nonatomic) IBOutlet TaskStatusView *taskStatusView;
@property (weak, nonatomic) IBOutlet UILabel *PositionLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *seprateContraint;
@property (weak, nonatomic) IBOutlet UIView *splitView;

@end
