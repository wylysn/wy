//
//  WorkOrderSiftView.h
//  wy
//
//  Created by 王益禄 on 16/9/12.
//  Copyright © 2016年 ___PURANG___. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WorkOrderSiftView : UIView<UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet PRButton *cancelButton;
@property (weak, nonatomic) IBOutlet PRButton *confirmButton;

@property (strong,nonatomic) NSArray *priorityListData;
@property (strong,nonatomic) NSArray *taskStatusListData;
@property (strong,nonatomic) UITableView *siftTableView;

@property (strong,nonatomic) NSArray *taskStatusArr;
@property (strong,nonatomic) NSArray *priorityArr;

@end
