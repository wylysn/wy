//
//  InspectTaskListViewController.m
//  wy
//
//  Created by wangyilu on 16/8/23.
//  Copyright © 2016年 ___PURANG___. All rights reserved.
//

#import "InspectTaskListViewController.h"
#import "InspectTaskService.h"
#import "InspectTaskTableViewCell.h"
#import <UITableView+FDTemplateLayoutCell.h>
#import "PRActionSheetPickerView.h"
#import "DateUtil.h"
#import "PRButton.h"
#import <MJRefresh.h>
#import "TaskTableViewController.h"
#import "InspectTaskSiftView.h"

#define CELLID                 @"INSPECTTASKENTIFIER_CELL"
#define STARTTIME_PLACEHOLDER  @"请输入到场时间"
#define ENDTIME_PLACEHOLDER    @"请输入结束时间"

typedef NS_OPTIONS(NSUInteger, FilterViewHideType) {
    FilterViewHideByCancel       = 0,
    FilterViewHideByConfirm      = 1 << 0
};

@interface InspectTaskListViewController ()<PRActionSheetPickerViewDelegate>

@property (weak, nonatomic) IBOutlet PRButton *dateBtn;

@end

@implementation InspectTaskListViewController {
    TaskTableViewController *taskListViewController;
    
    InspectTaskService *inspectTaskService;
    UIWindow *window;
    UIWindow *filterWindow;
    UIView *filterView;
    InspectTaskSiftView *siftView;
    NSDate *defaultDate;
    UIView *inspectTimeView;
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
    
    inspectTaskService = [[InspectTaskService alloc] init];
    
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
        
        NSArray *views = [[NSBundle mainBundle] loadNibNamed:@"InspectTaskListSiftView" owner:nil options:nil];
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

- (IBAction)conditionBtnClick:(id)sender
{
    UIButton *button = (UIButton *)sender;
    if (!button.selected) {
        [button setBackgroundColor:button.currentTitleColor];
    } else {
        [button setBackgroundColor:[UIColor whiteColor]];
    }
    button.selected = !button.selected;
    
}

- (IBAction)filterCancelBtnClick:(id)sender
{
    [self filterViewHideWithTye:FilterViewHideByCancel];
}

- (IBAction)filterConfirmBtnClick:(id)sender
{
    [self filterViewHideWithTye:FilterViewHideByConfirm];
    NSArray<NSIndexPath *> *indexPathsOfSelectedRows = [siftView.siftTableView indexPathsForSelectedRows];
    NSMutableArray *statusArr = [[NSMutableArray alloc] init];
    for (NSIndexPath *indexPath in indexPathsOfSelectedRows) {
        NSString *status = siftView.listData[indexPath.row];
        [statusArr addObject:status];
    }
    if (statusArr.count>0) {
        [filterDic setObject:[statusArr componentsJoinedByString:@","] forKey:@"PositionStatus"];
    }
    
    [self refreshDataByDate];
}

- (IBAction)selectTime:(id)sender {
    window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    window.rootViewController = self;
    window.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.2];
    [window makeKeyAndVisible];
    
    PRActionSheetPickerView *pickerView = [[PRActionSheetPickerView alloc] init];
    pickerView.delegate = self;
    UIButton *btn = (UIButton *)sender;
    NSInteger tag = btn.tag;
    NSString *title = btn.titleLabel.text;
    if (![STARTTIME_PLACEHOLDER isEqualToString:title] && ![ENDTIME_PLACEHOLDER isEqualToString:title]) {
        pickerView.defaultDate = title;
    }
    [pickerView showDatePickerInView:window withType:UIDatePickerModeDateAndTime withBackId:tag];
}

- (void)hideFilterView:(UITapGestureRecognizer *)recognizer {
    [self filterViewHideWithTye:FilterViewHideByCancel];
}

- (void)filterViewHideWithTye:(FilterViewHideType) type {
    if (type == FilterViewHideByCancel) {
        //重置筛选条件
        NSString *PositionStatus = filterDic[@"PositionStatus"];
        NSArray *positionStatusArr = [PositionStatus componentsSeparatedByString:@","];
        siftView.positionStatusArr = positionStatusArr;
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
    [pickerView showDatePickerInView:window withType:4 withBackId:3];
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
    [self disMissBackView];//startTimeView
    if (idNum == 1) {
        UIButton *startbtn = [inspectTimeView viewWithTag:1];
        NSString *title = [DateUtil formatDateString:date withFormatter:@"yyyy-MM-dd HH:mm:00"];
        [startbtn setTitle:title forState:UIControlStateNormal];
    } else if (idNum == 2) {
        UIButton *endbtn = [inspectTimeView viewWithTag:2];
        NSString *title = [DateUtil formatDateString:date withFormatter:@"yyyy-MM-dd HH:mm:00"];
        [endbtn setTitle:title forState:UIControlStateNormal];
    } else if (idNum == 3) {
        defaultDate = date;
        NSString *title = [DateUtil formatDateString:date withFormatter:@"yyyy年MM月"];
        [self.dateBtn setTitle:title forState:UIControlStateNormal];
        
        [self refreshDataByDate];
    }
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
        [filterDic setObject:@"2" forKey:@"ShortTitle"];
        taskListViewController.filterDic = [[NSMutableDictionary alloc] initWithDictionary:filterDic];
    }
}

@end
