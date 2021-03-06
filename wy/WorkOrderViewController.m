//
//  WorkOrderViewController.m
//  wy
//
//  Created by wangyilu on 16/8/19.
//  Copyright © 2016年 ___PURANG___. All rights reserved.
//

#import "WorkOrderViewController.h"
#import "WorkOrderTableViewCell.h"
#import <UITableView+FDTemplateLayoutCell.h>
#import "PRActionSheetPickerView.h"
#import "DateUtil.h"
#import "PRButton.h"
#import <MJRefresh.h>
#import "TaskTableViewController.h"
#import "WorkOrderSiftView.h"

#define CELLID @"WORKORDERENTIFIER_CELL"

typedef NS_OPTIONS(NSUInteger, FilterViewHideType) {
    FilterViewHideByCancel       = 0,
    FilterViewHideByConfirm      = 1 << 0
};

@interface WorkOrderViewController ()<PRActionSheetPickerViewDelegate>

@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet PRButton *dateBtn;

@end

@implementation WorkOrderViewController {
    TaskTableViewController *taskListViewController;
    
    UIWindow *window;
    UIWindow *filterWindow;
    UIView *filterView;
    WorkOrderSiftView *siftView;
    NSDate *defaultDate;
    UIView *priorityView;
    UIView *orderStatusView;
    
    NSMutableDictionary *filterDic;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIImageView *filterImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 25, 25)];
    filterImageView.image = [UIImage imageNamed:@"filter"];
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(filterorders:)];
    [filterImageView addGestureRecognizer:gesture];
    [filterImageView setUserInteractionEnabled:YES];
    UIBarButtonItem *filterItem = [[UIBarButtonItem alloc]
                                    initWithCustomView:filterImageView];
    self.navigationItem.rightBarButtonItem = filterItem;
    
    [self changeDateBtnText];
}

-(void)filterorders:(UITapGestureRecognizer *)recognizer
{
    float px;
    if (SCREEN_WIDTH<=320) {
        px = 50;
    } else if (SCREEN_WIDTH<=375) {
        px = 80;
    } else {
        px = 100;
    }
    float pwidth = SCREEN_WIDTH-px;
    if (filterWindow) {
        filterWindow.hidden = NO;
        [UIView animateWithDuration:0.2 animations:^{
            CGRect newFrame = siftView.frame;
            newFrame.origin.x = px;
            siftView.frame = newFrame;
        } completion:^(BOOL finished) {
            
        }];
    } else {
        filterWindow = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
        filterWindow.rootViewController = self;
        filterWindow.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
        [filterWindow makeKeyAndVisible];
        
        UIView *backView = [[UIView alloc] initWithFrame:filterWindow.frame];
        backView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
        [filterWindow addSubview:backView];
        
        UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideFilterView:)];
        [backView addGestureRecognizer:gesture];
        [backView setUserInteractionEnabled:YES];
        
        NSArray *views = [[NSBundle mainBundle] loadNibNamed:@"WorkOrderSiftView" owner:nil options:nil];
        siftView = views[0];
        
        siftView.frame = CGRectMake(SCREEN_WIDTH, 0, pwidth, SCREEN_HEIGHT);
        [filterWindow addSubview:siftView];
        
        [siftView.cancelButton addTarget:self action:@selector(filterCancelBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [siftView.confirmButton addTarget:self action:@selector(filterConfirmBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        [UIView animateWithDuration:0.2 animations:^{
            CGRect newFrame = siftView.frame;
            newFrame.origin.x = px;
            siftView.frame = newFrame;
        } completion:^(BOOL finished) {
            
        }];
    }         
}

- (IBAction)filterCancelBtnClick:(id)sender
{
    [self filterViewHideWithTye:FilterViewHideByCancel];
}

- (IBAction)filterConfirmBtnClick:(id)sender
{
    [self filterViewHideWithTye:FilterViewHideByConfirm];
    NSArray<NSIndexPath *> *indexPathsOfSelectedRows = [siftView.siftTableView indexPathsForSelectedRows];
    NSMutableArray *taskStatusArr = [[NSMutableArray alloc] init];
    NSMutableArray *priorityArr = [[NSMutableArray alloc] init];
    for (NSIndexPath *indexPath in indexPathsOfSelectedRows) {
        if (indexPath.section==0) {
            NSString *status = siftView.taskStatusListData[indexPath.row];
            [taskStatusArr addObject:status];
        } else if (indexPath.section==1) {
            NSString *status = siftView.priorityListData[indexPath.row];
            [priorityArr addObject:status];
        }
    }
    if (taskStatusArr.count>0) {
        [filterDic setObject:[taskStatusArr componentsJoinedByString:@","] forKey:@"TaskStatus"];
    } else {
        [filterDic setObject:@"1,2,3,4,5,6,7" forKey:@"TaskStatus"];
    }
    if (priorityArr.count>0) {
        [filterDic setObject:[priorityArr componentsJoinedByString:@","] forKey:@"Priority"];
    }
    
    [self refreshDataByDate];
}

- (void)hideFilterView:(UITapGestureRecognizer *)recognizer {
    [self filterViewHideWithTye:FilterViewHideByCancel];
}

- (void)filterViewHideWithTye:(FilterViewHideType) type {
    if (type == FilterViewHideByCancel) {
        //重置筛选条件
        NSString *TaskStatus = filterDic[@"TaskStatus"];
        NSArray *taskStatusArr = [TaskStatus componentsSeparatedByString:@","];
        siftView.taskStatusArr = taskStatusArr;
        NSString *Priority = filterDic[@"Priority"];
        NSArray *priorityArr = [Priority componentsSeparatedByString:@","];
        siftView.priorityArr = priorityArr;
        [siftView.siftTableView reloadData];
    }
    
    [UIView animateWithDuration:0.2 animations:^{
        CGRect newFrame = siftView.frame;
        newFrame.origin.x = SCREEN_WIDTH;
        siftView.frame = newFrame;
    } completion:^(BOOL finished) {
        filterWindow.hidden = YES;
    }];
}

- (IBAction)dateClick:(id)sender {
    window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    window.rootViewController = self;
    window.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.2];
    [window makeKeyAndVisible];
    
    PRActionSheetPickerView *pickerView = [[PRActionSheetPickerView alloc] init];
    pickerView.delegate = self;
    pickerView.defaultDate = [DateUtil formatDateString:defaultDate withFormatter:@"yyyy-MM-dd"];
    [pickerView showDatePickerInView:window withType:4 withBackId:1];
}

- (IBAction)preDateClick:(id)sender {
    defaultDate = [DateUtil addMonthDate:defaultDate withMonths:-1];
    [self changeDateBtnText];
    [self refreshDataByDate];
}

- (IBAction)nextDateClick:(id)sender {
    defaultDate = [DateUtil addMonthDate:defaultDate withMonths:1];
    [self changeDateBtnText];
    [self refreshDataByDate];
}

- (void)getDateWithDate:(NSDate *)date andId:(NSInteger)idNum {
    [self disMissBackView];
    defaultDate = date;
    NSString *title = [DateUtil formatDateString:date withFormatter:@"yyyy年MM月"];
    [self.dateBtn setTitle:title forState:UIControlStateNormal];
    
    [self refreshDataByDate];
}

- (void)changeDateBtnText {
    NSString *title = [DateUtil formatDateString:defaultDate withFormatter:@"yyyy年MM月"];
    [self.dateBtn setTitle:title forState:UIControlStateNormal];
}

- (void)refreshDataByDate {
    NSString *startDate = [DateUtil formatDateString:defaultDate withFormatter:@"yyyy-MM-01"];
    NSString *endDate = [DateUtil getLastDateOfMonth:defaultDate];
    [filterDic setObject:startDate forKey:@"StartDate"];
    [filterDic setObject:endDate forKey:@"EndDate"];
    taskListViewController.filterDic = filterDic;
    [taskListViewController.tableView.mj_header beginRefreshing];
}

- (void)disMissBackView {
    window.hidden = YES;
    window.rootViewController = nil;
    window = nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

// 获取子控制器
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([@"EMBED_TASKLIST" isEqualToString:segue.identifier]) {
        taskListViewController = segue.destinationViewController;
        if (!filterDic) {
            filterDic = [[NSMutableDictionary alloc] init];
        }
        if (!defaultDate) {
            defaultDate = [NSDate date];
        }
        NSString *startDate = [DateUtil formatDateString:defaultDate withFormatter:@"yyyy-MM-01"];
        NSString *endDate = [DateUtil getLastDateOfMonth:defaultDate];
        [filterDic setObject:startDate forKey:@"StartDate"];
        [filterDic setObject:endDate forKey:@"EndDate"];
        [filterDic setObject:@"1" forKey:@"ShortTitle"];
        [filterDic setObject:@"1,2,3,4,5,6,7" forKey:@"TaskStatus"];
        taskListViewController.filterDic = [[NSMutableDictionary alloc] initWithDictionary:filterDic];
    }
}


@end
