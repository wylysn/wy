//
//  InspectTaskTableViewCell.h
//  wy
//
//  Created by wangyilu on 16/8/23.
//  Copyright © 2016年 ___PURANG___. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PRLabel.h"
#import "InspectTaskEntity.h"
#import "InspectTaskListViewController.h"

@interface InspectTaskTableViewCell : UITableViewCell

@property (nonatomic, strong) InspectTaskEntity *entity;
@property (nonatomic, strong) InspectTaskListViewController *parentController;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet PRLabel *statusLabel;
@property (weak, nonatomic) IBOutlet UILabel *startTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *endTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *dianweiLabel;
@property (weak, nonatomic) IBOutlet UILabel *dianweiUnitLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *c1Constraint;


@end
