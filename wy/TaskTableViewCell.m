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
        [self.typeNextBtn setTitle:@"接单" forState:UIControlStateNormal];
        self.typeNextBtn.backgroundColor = [UIColor colorWithRed:252/255.0 green:103/255.0 blue:33/255.0 alpha:1.0];
    } else if ([@"2" isEqualToString:entity.type]) {
        [self.typeNextBtn setTitle:@"处理" forState:UIControlStateNormal];
        self.typeNextBtn.backgroundColor = [UIColor colorWithRed:252/255.0 green:41/255.0 blue:28/255.0 alpha:1.0];
    } else if ([@"3" isEqualToString:entity.type]) {
        [self.typeNextBtn setTitle:@"派工" forState:UIControlStateNormal];
        self.typeNextBtn.backgroundColor = [UIColor colorWithRed:78/255.0 green:192/255.0 blue:48/255.0 alpha:1.0];
    } else if ([@"4" isEqualToString:entity.type]) {
        [self.typeNextBtn setTitle:@"作废" forState:UIControlStateNormal];
        self.typeNextBtn.backgroundColor = [UIColor colorWithRed:128/255.0 green:128/255.0 blue:128/255.0 alpha:1.0];
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

- (IBAction)doTask:(id)sender {
    UIStoryboard* taskSB = [UIStoryboard storyboardWithName:@"Task" bundle:[NSBundle mainBundle]];
    UIViewController *viewController;
    if ([@"1" isEqualToString:_entity.type]) {
        viewController = [taskSB instantiateViewControllerWithIdentifier:@"TASK_JIEDAN"];
        ((TaskJiedanViewController *)viewController).id = _entity.id;
    } else if ([@"2" isEqualToString:_entity.type]) {
        viewController = [taskSB instantiateViewControllerWithIdentifier:@"TASK_CHULI2"];
        ((TaskChuli1ViewController *)viewController).id = _entity.id;
    } else if ([@"3" isEqualToString:_entity.type]) {
        viewController = [taskSB instantiateViewControllerWithIdentifier:@"TASK_PAIGONG"];
        ((TaskPaiGongViewController *)viewController).id = _entity.id;
    } else if ([@"4" isEqualToString:_entity.type]) {
        
    }
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"任务" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.parentController.navigationItem.backBarButtonItem = backButton;
    viewController.hidesBottomBarWhenPushed = YES;
    [self.parentController.navigationController pushViewController:viewController animated:YES];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
