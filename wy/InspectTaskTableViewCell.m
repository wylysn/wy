//
//  InspectTaskTableViewCell.m
//  wy
//
//  Created by wangyilu on 16/8/23.
//  Copyright © 2016年 ___PURANG___. All rights reserved.
//

#import "InspectTaskTableViewCell.h"
#import "NSString+Extensions.h"

@implementation InspectTaskTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.c1Constraint.constant = 1.f/[UIScreen mainScreen].scale;
}

- (void)setEntity:(InspectTaskEntity *)entity
{
    _entity = entity;
    
    if (![entity.name isBlankString]) {
        self.nameLabel.text = entity.name;
    } else {
        self.nameLabel.text = @"";
    }
    if ([@"1" isEqualToString:entity.status]) {
        self.statusLabel.backgroundColor = [UIColor colorFromHexCode:@"8EC158"];
        self.statusLabel.text = @"正常";
    } else if ([@"2" isEqualToString:entity.status]) {
        self.statusLabel.backgroundColor = [UIColor colorFromHexCode:@"1380B8"];
        self.statusLabel.text = @"报修";
    } else if ([@"3" isEqualToString:entity.status]) {
        self.statusLabel.backgroundColor = [UIColor colorFromHexCode:@"FD705A"];
        self.statusLabel.text = @"漏检";
    } else if ([@"4" isEqualToString:entity.status]) {
        self.statusLabel.backgroundColor = [UIColor colorFromHexCode:@"F53D5A"];
        self.statusLabel.text = @"异常";
    }
    if (![entity.startTime isBlankString]) {
        self.startTimeLabel.text = entity.startTime;
    } else {
        self.startTimeLabel.text = @"";
    }
    if (![entity.endTime isBlankString]) {
        self.endTimeLabel.text = entity.endTime;
    } else {
        self.endTimeLabel.text = @"";
    }
    if (![entity.dianwei isBlankString]) {
        self.dianweiLabel.text = entity.dianwei;
        self.dianweiUnitLabel.hidden = NO;
    } else {
        self.dianweiLabel.text = @"";
        self.dianweiUnitLabel.hidden = YES;
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
