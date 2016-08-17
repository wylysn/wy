//
//  TaskTableViewCell.h
//  wy
//
//  Created by wangyilu on 16/8/11.
//  Copyright © 2016年 ___PURANG___. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TaskEntity.h"
#import "TaskTableViewController.h"

@interface TaskTableViewCell : UITableViewCell

@property (nonatomic, strong) TaskEntity *entity;
@property (nonatomic, strong) TaskTableViewController *parentController;
@property (weak, nonatomic) IBOutlet UILabel *idLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *typeLabel;
@property (weak, nonatomic) IBOutlet UILabel *descLabel;
@property (weak, nonatomic) IBOutlet UILabel *positionLabel;
@property (weak, nonatomic) IBOutlet UIButton *typeNextBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *seprateContraint;
@property (weak, nonatomic) IBOutlet UIView *splitView;

@end