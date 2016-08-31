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
    
    if (![entity.priority isBlankString]) {
        self.priorityLabel.text = entity.priority;
    } else {
        self.priorityLabel.text = @"";
    }
    
    if ([@"1" isEqualToString:entity.type]) {
        self.taskStatusView.bgColor = @"fc6721";
        self.taskStatusLabel.text = @"接单";
    } else if ([@"2" isEqualToString:entity.type]) {
        self.taskStatusView.bgColor = @"fc291c";
        self.taskStatusLabel.text = @"处理";
    } else if ([@"3" isEqualToString:entity.type]) {
        self.taskStatusView.bgColor = @"4ec030";
        self.taskStatusLabel.text = @"派工";
    } else if ([@"4" isEqualToString:entity.type]) {
        self.taskStatusView.bgColor = @"808080";
        self.taskStatusLabel.text = @"作废";
    }
    
    if ([@"1" isEqualToString:entity.priority]) {
        self.priorityLabel.backgroundColor = [UIColor colorFromHexCode:@"fc6721"];
        self.priorityLabel.text = @"低";
    } else if ([@"2" isEqualToString:entity.type]) {
        self.priorityLabel.backgroundColor = [UIColor colorFromHexCode:@"fc291c"];
        self.priorityLabel.text = @"中";
    } else if ([@"3" isEqualToString:entity.type]) {
        self.priorityLabel.backgroundColor = [UIColor colorFromHexCode:@"4ec030"];
        self.priorityLabel.text = @"高";
    } else if ([@"4" isEqualToString:entity.type]) {
        self.priorityLabel.backgroundColor = [UIColor colorFromHexCode:@"808080"];
        self.priorityLabel.text = @"紧急";
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
    totalHeight += [self.idLabel sizeThatFits:size].height;
    totalHeight += [self.typeLabel sizeThatFits:size].height;
    totalHeight += [self.descLabel sizeThatFits:size].height;
    totalHeight += [self.positionLabel sizeThatFits:size].height;
    
    totalHeight += 25; // margins
    return CGSizeMake(size.width, totalHeight);
}

/*
- (IBAction)doTask:(id)sender {
    UIStoryboard* taskSB = [UIStoryboard storyboardWithName:@"Task" bundle:[NSBundle mainBundle]];
    UIViewController *viewController;
    if ([@"1" isEqualToString:_entity.type]) {
        viewController = [taskSB instantiateViewControllerWithIdentifier:@"TASK_JIEDAN"];
        ((TaskJiedanViewController *)viewController).id = _entity.id;
    } else if ([@"2" isEqualToString:_entity.type]) {
        viewController = [taskSB instantiateViewControllerWithIdentifier:@"TASK_CHULI1"];
        ((TaskChuli1ViewController *)viewController).id = _entity.id;
    } else if ([@"3" isEqualToString:_entity.type]) {
        viewController = [taskSB instantiateViewControllerWithIdentifier:@"TASK_PAIGONG"];
        ((TaskPaiGongViewController *)viewController).id = _entity.id;
    } else if ([@"4" isEqualToString:_entity.type]) {
        viewController = [taskSB instantiateViewControllerWithIdentifier:@"TASKHANDLE"];
        ((TaskHandleViewController *)viewController).id = _entity.id;
    }
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"任务" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.parentController.navigationItem.backBarButtonItem = backButton;
    viewController.hidesBottomBarWhenPushed = YES;
    [self.parentController.navigationController pushViewController:viewController animated:YES];
}
 */

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
