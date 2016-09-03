//
//  TaskTableViewCell.m
//  wy
//
//  Created by wangyilu on 16/8/11.
//  Copyright © 2016年 ___PURANG___. All rights reserved.
//

#import "TaskTableViewCell.h"
#import "NSString+Extensions.h"
#import "TaskPaiGongViewController.h"
#import "TaskJiedanViewController.h"
#import "TaskChuli1ViewController.h"
#import "TaskHandleViewController.h"
#import "AppDelegate.h"

@implementation TaskTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.seprateContraint.constant = 1.f/[UIScreen mainScreen].scale;
}

- (void)setEntity:(TaskListEntity *)entity
{
    _entity = entity;
    
    if (![entity.Code isBlankString]) {
        self.CodeLabel.text = entity.Code;
    } else {
        self.CodeLabel.text = @"";
    }
    
    
    if (![entity.ServiceType isBlankString]) {
        self.ServiceTypeLabel.text = [serviceTypeDic objectForKey:entity.ShortTitle];
    } else {
        self.ServiceTypeLabel.text = @"";
    }
    
    if (![entity.ShortTitle isBlankString]) {
        self.ShortTitleLabel.text = [shortTitleDic objectForKey:entity.ShortTitle];
    } else {
        self.ShortTitleLabel.text = @"";
    }
    if (![entity.TaskStatus isBlankString]) {
        self.TaskStatusLabel.text = [taskStatusShowDic objectForKey:entity.TaskStatus];
        NSString *color = @"ffffff";
        if ([@"0" isEqualToString:entity.TaskStatus]) {
            color = BUTTON_ORANGE_COLOR;
        } else if ([@"1" isEqualToString:entity.TaskStatus]) {
            color = BUTTON_RED_COLOR;
        } else if ([@"2" isEqualToString:entity.TaskStatus]) {
            color = BUTTON_GREEN_COLOR;
        } else if ([@"3" isEqualToString:entity.TaskStatus]) {
            color = BUTTON_BLUE_COLOR;
        } else if ([@"4" isEqualToString:entity.TaskStatus]) {
            color = BUTTON_DARKGRAY_COLOR;
        } else if ([@"5" isEqualToString:entity.TaskStatus]) {
            color = BUTTON_DARKGRAY_COLOR;
        } else if ([@"6" isEqualToString:entity.TaskStatus]) {
            color = BUTTON_DARKGRAY_COLOR;
        } else if ([@"7" isEqualToString:entity.TaskStatus]) {
            color = BUTTON_DARKGRAY_COLOR;
        }
        self.taskStatusView.bgColor = color;
    } else {
        self.TaskStatusLabel.text = @"";
    }
    if (![entity.Priority isBlankString]) {
        self.PriorityLabel.text = [priorityDic objectForKey:entity.Priority];
        NSString *color = @"ffffff";
        if ([@"1" isEqualToString:entity.Priority]) {
            color = BUTTON_GREEN_COLOR;
        } else if ([@"2" isEqualToString:entity.Priority]) {
            color = BUTTON_BLUE_COLOR;
        } else if ([@"3" isEqualToString:entity.Priority]) {
            color = BUTTON_ORANGE_COLOR;
        } else if ([@"4" isEqualToString:entity.Priority]) {
            color = BUTTON_RED_COLOR;
        }
        self.PriorityLabel.backgroundColor = [UIColor colorFromHexCode:color];
    } else {
        self.PriorityLabel.text = @"";
    }
    
    if (![entity.ReceiveTime isBlankString]) {
        self.ReceiveTimeLabel.text = entity.ReceiveTime;
    } else {
        self.ReceiveTimeLabel.text = @"";
    }
    
    if (![entity.Subject isBlankString]) {
        self.SubjectLabel.text = entity.Subject;
    } else {
        self.SubjectLabel.text = @"";
    }
    
    if (![entity.Position isBlankString]) {
        self.PositionLabel.text = entity.Position;
    } else {
        self.PositionLabel.text = @"";
    }
    
}

- (CGSize)sizeThatFits:(CGSize)size {
    CGFloat totalHeight = 0;
    totalHeight += [self.CodeLabel sizeThatFits:size].height;
    totalHeight += [self.ShortTitleLabel sizeThatFits:size].height;
    totalHeight += [self.ServiceTypeLabel sizeThatFits:size].height;
    totalHeight += [self.SubjectLabel sizeThatFits:size].height;
    totalHeight += [self.PositionLabel sizeThatFits:size].height;
    
    totalHeight += 25; // margins
    return CGSizeMake(size.width, totalHeight);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
