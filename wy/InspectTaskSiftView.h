//
//  inspectTaskSiftView.h
//  wy
//
//  Created by wangyilu on 16/9/12.
//  Copyright © 2016年 ___PURANG___. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TaskTableViewController.h"

@interface InspectTaskSiftView : UIView<UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet PRButton *cancelButton;
@property (weak, nonatomic) IBOutlet PRButton *confirmButton;

@property (strong,nonatomic) NSArray *listData;
@property (strong,nonatomic) NSArray *listLabelData;
@property (strong,nonatomic) UITableView *siftTableView;
@property (strong,nonatomic) UITableViewCell *tableViewCell;

@property (strong,nonatomic) NSArray *positionStatusArr;

@end
