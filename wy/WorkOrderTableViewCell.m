//
//  WorkOrderTableViewCell.m
//  wy
//
//  Created by wangyilu on 16/8/19.
//  Copyright © 2016年 ___PURANG___. All rights reserved.
//

#import "WorkOrderTableViewCell.h"
#import "NSString+Extensions.h"

@implementation WorkOrderTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.ct1.constant = 1.f/[UIScreen mainScreen].scale;
}

- (void)setEntity:(TaskEntity *)entity
{
    _entity = entity;
    
    if (![entity.id isBlankString]) {
        self.nameLabel.text = entity.id;
    } else {
        self.nameLabel.text = @"";
    }
    
    if (![entity.priority isBlankString]) {
        self.priorityLabel.text = entity.priority;
    } else {
        self.priorityLabel.text = @"";
    }
    
    if (![entity.orderStatus isBlankString]) {
        self.orderStatusLabel.text = entity.orderStatus;
    } else {
        self.orderStatusLabel.text = @"";
    }
    
    if (![entity.type isBlankString]) {
        self.typeLabel.text = entity.type;
    } else {
        self.typeLabel.text = @"";
    }
    
    if (![entity.time isBlankString]) {
        self.timeLabel.text = entity.time;
    } else {
        self.timeLabel.text = @"";
    }
    
    if (![entity.desc isBlankString]) {
        self.descLabel.text = entity.desc;
    } else {
        self.descLabel.text = @"";
    }
    
    if (![entity.position isBlankString]) {
        self.positionLabel.text = entity.position;
    } else {
        self.positionLabel.text = @"";
    }
    
}

- (CGSize)sizeThatFits:(CGSize)size {
    CGFloat totalHeight = 0;
    totalHeight += [self.titleView sizeThatFits:size].height;
    totalHeight += [self.typeLabel sizeThatFits:size].height;
    totalHeight += [self.descLabel sizeThatFits:size].height;
    totalHeight += [self.positionLabel sizeThatFits:size].height;
    totalHeight += 46;
    return CGSizeMake(size.width, totalHeight);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
