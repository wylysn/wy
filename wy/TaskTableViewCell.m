//
//  TaskTableViewCell.m
//  wy
//
//  Created by wangyilu on 16/8/11.
//  Copyright © 2016年 ___PURANG___. All rights reserved.
//

#import "TaskTableViewCell.h"
#import "NSString+Extensions.h"

@implementation TaskTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.seprateContraint.constant = 1.f/[UIScreen mainScreen].scale;
}

- (void)setEntity:(TaskEntity *)entity
{
    _entity = entity;
    
    if (![entity.id isBlankString]) {
        self.idLabel.text = entity.id;
    } else {
        self.idLabel.text = @"";
    }
    
    if (![entity.type isBlankString]) {
        self.typeLabel.text = entity.type;
    } else {
        self.typeLabel.text = @"";
    }
    if ([@"1" isEqualToString:entity.type]) {
        self.typeNextLabel.text = @"接单";
        self.typeNextView.backgroundColor = [UIColor colorWithRed:252/255.0 green:103/255.0 blue:33/255.0 alpha:1.0];
    } else if ([@"2" isEqualToString:entity.type]) {
        self.typeNextLabel.text = @"处理";
        self.typeNextView.backgroundColor = [UIColor colorWithRed:252/255.0 green:41/255.0 blue:28/255.0 alpha:1.0];
    } else if ([@"3" isEqualToString:entity.type]) {
        self.typeNextLabel.text = @"派工";
        self.typeNextView.backgroundColor = [UIColor colorWithRed:78/255.0 green:192/255.0 blue:48/255.0 alpha:1.0];
    } else if ([@"4" isEqualToString:entity.type]) {
        self.typeNextLabel.text = @"作废";
        self.typeNextView.backgroundColor = [UIColor colorWithRed:128/255.0 green:128/255.0 blue:128/255.0 alpha:1.0];
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
    totalHeight += [self.typeLabel sizeThatFits:size].height;
    totalHeight += [self.typeLabel sizeThatFits:size].height;
    totalHeight += [self.descLabel sizeThatFits:size].height;
    totalHeight += [self.positionLabel sizeThatFits:size].height;
    
    totalHeight += 25; // margins
    return CGSizeMake(size.width, totalHeight);
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
