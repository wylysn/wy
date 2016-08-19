//
//  WorkOrderTableViewCell.h
//  wy
//
//  Created by wangyilu on 16/8/19.
//  Copyright © 2016年 ___PURANG___. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TaskEntity.h"
#import "PRLabel.h"
#import "WorkOrderViewController.h"

@interface WorkOrderTableViewCell : UITableViewCell

@property (nonatomic, strong) TaskEntity *entity;
@property (nonatomic, strong) WorkOrderViewController *parentController;
@property (weak, nonatomic) IBOutlet UIView *titleView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet PRLabel *priorityLabel;
@property (weak, nonatomic) IBOutlet UILabel *orderStatusLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@property (weak, nonatomic) IBOutlet UILabel *typeLabel;
@property (weak, nonatomic) IBOutlet UILabel *descLabel;
@property (weak, nonatomic) IBOutlet UILabel *positionLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *ct1;

@end
