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
    
    defaultDate = [NSDate date];
    
    filterDic = [[NSMutableDictionary alloc] init];
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
        /*
        [UIView animateWithDuration:0.2 animations:^{
            CGRect newFrame = filterView.frame;
            newFrame.origin.x = px;
            filterView.frame = newFrame;
        } completion:^(BOOL finished) {
            
        }];
         */
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
        
        /*
        float bottomHeight = 66;
        filterView = [[UIView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH, 0, pwidth, SCREEN_HEIGHT)];
        filterView.backgroundColor = [UIColor whiteColor];
        //主体内容
        UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, pwidth, SCREEN_HEIGHT-bottomHeight)];
        
        //顶部标题
        float TITLEVIEW_HEIGHT = 40;
        UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, pwidth, TITLEVIEW_HEIGHT)];
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake((pwidth-42)/2, (TITLEVIEW_HEIGHT-21)/2, 42, 21)];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.font = [UIFont systemFontOfSize:17];
        titleLabel.text = @"筛选";
        [titleView addSubview:titleLabel];
        [scrollView addSubview:titleView];
        
        //分割线1
        NSString *SPLITVIEW_COLOR = @"EFEFF4";
        float SPLITVIEW_HEIGHT = 6;
        UIView *splitView1 = [[UIView alloc] initWithFrame:CGRectMake(0, TITLEVIEW_HEIGHT, pwidth, SPLITVIEW_HEIGHT)];
        splitView1.backgroundColor = [UIColor colorFromHexCode:SPLITVIEW_COLOR];
        [scrollView addSubview:splitView1];
        
        //优先级title
        float F1VIEW_HEIGHT = 40;
        UIView *f1titleView = [[UIView alloc] initWithFrame:CGRectMake(0, TITLEVIEW_HEIGHT+SPLITVIEW_HEIGHT, pwidth, F1VIEW_HEIGHT)];
        UILabel *f1titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, (F1VIEW_HEIGHT-21)/2, 100, 21)];
        f1titleLabel.textAlignment = NSTextAlignmentLeft;
        f1titleLabel.font = [UIFont systemFontOfSize:17];
        f1titleLabel.text = @"巡检时间";
        [f1titleView addSubview:f1titleLabel];
        [scrollView addSubview:f1titleView];
        //分割线2
        float SPLITVIEW2_HEIGHT = 1/[UIScreen mainScreen].scale;
        UIView *splitView2 = [[UIView alloc] initWithFrame:CGRectMake(0, TITLEVIEW_HEIGHT+SPLITVIEW_HEIGHT+F1VIEW_HEIGHT, pwidth, SPLITVIEW2_HEIGHT)];
        splitView2.backgroundColor = [UIColor colorFromHexCode:SPLITLINE_COLOR];
        [scrollView addSubview:splitView2];
        //条件
        float PRIORITY_HEIGHT = 60;
        inspectTimeView = [[UIView alloc] initWithFrame:CGRectMake(0, TITLEVIEW_HEIGHT+SPLITVIEW_HEIGHT+F1VIEW_HEIGHT+SPLITVIEW2_HEIGHT, pwidth, PRIORITY_HEIGHT)];
        //到场时间
        UIView *startTimeView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, pwidth, 30)];
        UILabel *startDescLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, (30-21)/2, 100, 21)];
        startDescLabel.text = @"到场时间";
        startDescLabel.font = [UIFont systemFontOfSize:14];
        startDescLabel.textColor = [UIColor colorFromHexCode:@"555555"];
        [startTimeView addSubview:startDescLabel];
        UIButton *startTimeBtn = [[UIButton alloc] initWithFrame:CGRectMake(15+100, (30-21)/2, pwidth-100-15-8, 21)];
        startTimeBtn.tag = 1;
        [startTimeBtn setTitle:STARTTIME_PLACEHOLDER forState:UIControlStateNormal];
//        startTimeBtn.HorizontalAlignment = UIControlContentHorizontalAlignment.Right;
        startTimeBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [startTimeBtn setTitleColor:[UIColor colorFromHexCode:@"555555"] forState:UIControlStateNormal];
        [startTimeView addSubview:startTimeBtn];
        UIView *splitView22 = [[UIView alloc] initWithFrame:CGRectMake(0, 30, pwidth, 1/[UIScreen mainScreen].scale)];
        splitView22.backgroundColor = [UIColor colorFromHexCode:SPLITLINE_COLOR];
        [startTimeView addSubview:splitView22];
        [inspectTimeView addSubview:startTimeView];
        //结束时间
        UIView *endTimeView = [[UIView alloc] initWithFrame:CGRectMake(0, 30, pwidth, 30)];
        UILabel *endDescLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, (30-21)/2, 100, 21)];
        endDescLabel.text = @"结束时间";
        endDescLabel.font = [UIFont systemFontOfSize:14];
        endDescLabel.textColor = [UIColor colorFromHexCode:@"555555"];
        [endTimeView addSubview:endDescLabel];
        UIButton *endTimeBtn = [[UIButton alloc] initWithFrame:CGRectMake(15+100, (30-21)/2, pwidth-100-15-8, 21)];
        endTimeBtn.tag = 2;
        [endTimeBtn setTitle:ENDTIME_PLACEHOLDER forState:UIControlStateNormal];
        endTimeBtn.titleLabel.textAlignment = NSTextAlignmentRight;
        endTimeBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [endTimeBtn setTitleColor:[UIColor colorFromHexCode:@"555555"] forState:UIControlStateNormal];
        [endTimeView addSubview:endTimeBtn];
        [inspectTimeView addSubview:endTimeView];
        [scrollView addSubview:inspectTimeView];
        
        [startTimeBtn addTarget:self action:@selector(selectTime:) forControlEvents:UIControlEventTouchUpInside];
        [endTimeBtn addTarget:self action:@selector(selectTime:) forControlEvents:UIControlEventTouchUpInside];
        
        //分割线3
        float SPLITVIEW3_HEIGHT = 6;
        UIView *splitView3 = [[UIView alloc] initWithFrame:CGRectMake(0, TITLEVIEW_HEIGHT+SPLITVIEW_HEIGHT+F1VIEW_HEIGHT+SPLITVIEW2_HEIGHT+PRIORITY_HEIGHT, pwidth, SPLITVIEW3_HEIGHT)];
        splitView3.backgroundColor = [UIColor colorFromHexCode:SPLITVIEW_COLOR];
        [scrollView addSubview:splitView3];
        //订单状态title
        float F2VIEW_HEIGHT = 40;
        UIView *f2titleView = [[UIView alloc] initWithFrame:CGRectMake(0, TITLEVIEW_HEIGHT+SPLITVIEW_HEIGHT+F1VIEW_HEIGHT+SPLITVIEW2_HEIGHT+PRIORITY_HEIGHT+SPLITVIEW3_HEIGHT, pwidth, F1VIEW_HEIGHT)];
        UILabel *f2titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, (F2VIEW_HEIGHT-21)/2, 100, 21)];
        f2titleLabel.textAlignment = NSTextAlignmentLeft;
        f2titleLabel.font = [UIFont systemFontOfSize:17];
        f2titleLabel.text = @"订单状态";
        [f2titleView addSubview:f2titleLabel];
        [scrollView addSubview:f2titleView];
        //分割线4
        float SPLITVIEW4_HEIGHT = 1/[UIScreen mainScreen].scale;
        UIView *splitView4 = [[UIView alloc] initWithFrame:CGRectMake(0, TITLEVIEW_HEIGHT+SPLITVIEW_HEIGHT+F1VIEW_HEIGHT+SPLITVIEW2_HEIGHT+PRIORITY_HEIGHT+SPLITVIEW3_HEIGHT+F2VIEW_HEIGHT, pwidth, SPLITVIEW4_HEIGHT)];
        splitView4.backgroundColor = [UIColor colorFromHexCode:SPLITLINE_COLOR];
        [scrollView addSubview:splitView4];
        
        //条件
        float sp;
        if (SCREEN_WIDTH<=320) {
            sp = 10;
        } else if (SCREEN_WIDTH<=375) {
            sp = 15;
        } else {
            sp = 15;
        }
        float ORDERSTATUS_HEIGHT = 60;
        orderStatusView = [[UIView alloc] initWithFrame:CGRectMake(0, TITLEVIEW_HEIGHT+SPLITVIEW_HEIGHT+F1VIEW_HEIGHT+SPLITVIEW2_HEIGHT+PRIORITY_HEIGHT+SPLITVIEW3_HEIGHT+F2VIEW_HEIGHT+SPLITVIEW4_HEIGHT, pwidth, ORDERSTATUS_HEIGHT)];
        for (NSInteger i=1; i<=4; i++) {
            NSString *color;
            float x;
            float width;
            NSString *title;
            if (i==1) {
                x = 15;
                title = @"正常";
                width = 44;
                color = @"8EC158";
            } else if(i==2) {
                x = 15+44+sp;
                title = @"漏检";
                width = 44;
                color = @"1380B8";
            } else if(i==3) {
                x = 15+44+sp+44+sp;
                title = @"报修";
                width = 44;
                color = @"FD705A";
            } else if(i==4) {
                x = 15+44+sp+44+sp+44+sp;
                title = @"异常";
                width = 62;
                color = @"F53D5A";
            }
            UIButton *btn1 = [[UIButton alloc] initWithFrame:CGRectMake(x, (PRIORITY_HEIGHT-21)/2, width, 21)];
            btn1.titleLabel.font = [UIFont systemFontOfSize:15];
            btn1.tag = i;
            [btn1 setTitle:title forState:UIControlStateNormal];
            [btn1 setTitleColor:[UIColor colorFromHexCode:color] forState:UIControlStateNormal];
            [btn1 setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
            [btn1 addTarget:self action:@selector(conditionBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            btn1.layer.borderColor = [UIColor colorFromHexCode:color].CGColor;
            btn1.layer.cornerRadius = 3;
            btn1.layer.borderWidth = 1;
            [orderStatusView addSubview:btn1];
        }
        [scrollView addSubview:orderStatusView];
        [filterView addSubview:scrollView];
        
        //底部
        UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT-bottomHeight, pwidth, bottomHeight)];
        //分割线5
        float SPLITVIEW5_HEIGHT = 6;
        UIView *splitView5 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, pwidth, SPLITVIEW5_HEIGHT)];
        splitView5.backgroundColor = [UIColor colorFromHexCode:SPLITVIEW_COLOR];
        [bottomView addSubview:splitView5];
        //底部按钮
        float BOTTOM_HEIGHT = bottomHeight-SPLITVIEW5_HEIGHT;
        UIView *btnGroupView = [[UIView alloc] initWithFrame:CGRectMake(0, SPLITVIEW5_HEIGHT, pwidth, BOTTOM_HEIGHT)];
        float btnHeight = 30;
        float leading = 15;
        float trailing = 15;
        float space = 10;
        float cancelWidth = ((pwidth-leading-trailing-space)/5)*2;//取消确认宽度比位2：3
        float confirmWidth = ((pwidth-leading-trailing-space)/5)*3;//取消确认宽度比位2：3
        UIButton *cancelBtn = [[UIButton alloc] initWithFrame:CGRectMake(leading, (BOTTOM_HEIGHT-btnHeight)/2, cancelWidth, btnHeight)];
        [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
        [cancelBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [cancelBtn setBackgroundColor:[UIColor colorFromHexCode:@"FD705A"]];
        cancelBtn.layer.cornerRadius = 5;
        [cancelBtn addTarget:self action:@selector(filterCancelBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [btnGroupView addSubview:cancelBtn];
        UIButton *confirmBtn = [[UIButton alloc] initWithFrame:CGRectMake(leading+cancelWidth+space, (BOTTOM_HEIGHT-btnHeight)/2, confirmWidth, btnHeight)];
        [confirmBtn setTitle:@"确认" forState:UIControlStateNormal];
        [confirmBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [confirmBtn setBackgroundColor:[UIColor colorFromHexCode:@"8EC158"]];
        confirmBtn.layer.cornerRadius = 5;
        [confirmBtn addTarget:self action:@selector(filterConfirmBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [btnGroupView addSubview:confirmBtn];
        [bottomView addSubview:btnGroupView];
        [filterView addSubview:bottomView];
        
        [filterWindow addSubview:filterView];
        [UIView animateWithDuration:0.2 animations:^{
            CGRect newFrame = filterView.frame;
            newFrame.origin.x = px;
            filterView.frame = newFrame;
        } completion:^(BOOL finished) {
            
        }];
         */
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
//    NSString *startTime;
//    NSString *endTime;
//    NSMutableArray *orderStatusArr = [[NSMutableArray alloc] init];
//    UIButton *startTimeBtn = [inspectTimeView viewWithTag:1];
//    UIButton *endTimeBtn = [inspectTimeView viewWithTag:2];
//    startTime = [STARTTIME_PLACEHOLDER isEqualToString:startTimeBtn.titleLabel.text]?@"":startTimeBtn.titleLabel.text;
//    endTime = [ENDTIME_PLACEHOLDER isEqualToString:endTimeBtn.titleLabel.text]?@"":endTimeBtn.titleLabel.text;
//    for (UIButton *btn in orderStatusView.subviews) {
//        if (btn.selected) {
//            [orderStatusArr addObject:[NSString stringWithFormat:@"%ld", (long)btn.tag]];
//        }
//    }
//    [filterDic setObject:startTime forKey:@"startTime"];
//    [filterDic setObject:endTime forKey:@"endTime"];
//    [filterDic setObject:orderStatusArr forKey:@"orderStatus"];
//    
//    NSLog(@"筛选条件：%@", filterDic);
    NSArray<NSIndexPath *> *indexPathsOfSelectedRows = [siftView.siftTableView indexPathsForSelectedRows];
    NSMutableArray *statusArr = [[NSMutableArray alloc] init];
    for (NSIndexPath *indexPath in indexPathsOfSelectedRows) {
        NSString *status = siftView.listData[indexPath.row];
        [statusArr addObject:status];
    }
    [filterDic setObject:[statusArr componentsJoinedByString:@","] forKey:@"PositionStatus"];
    taskListViewController.filterDic = filterDic;
    [taskListViewController.tableView.mj_header beginRefreshing];
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
        /*
        UIButton *startTimeBtn = [inspectTimeView viewWithTag:1];
        UIButton *endTimeBtn = [inspectTimeView viewWithTag:2];
        NSString *startTime = [@"" isEqualToString:filterDic[@"startTime"]]?STARTTIME_PLACEHOLDER:filterDic[@"startTime"];
        NSString *endTime = [@"" isEqualToString:filterDic[@"endTime"]]?ENDTIME_PLACEHOLDER:filterDic[@"endTime"];
        [startTimeBtn setTitle:startTime forState:UIControlStateNormal];
        [endTimeBtn setTitle:endTime forState:UIControlStateNormal];
        
        for (UIButton *btn in orderStatusView.subviews) {
            NSArray *oArr = filterDic[@"orderStatus"];
            if (!oArr) {
                btn.selected = FALSE;
                [btn setBackgroundColor:[UIColor whiteColor]];
            } else {
                if (![oArr containsObject:[NSString stringWithFormat:@"%ld", (long)btn.tag]]) {
                    btn.selected = FALSE;
                    [btn setBackgroundColor:[UIColor whiteColor]];
                }
            }
        }
         */
        NSString *PositionStatus = filterDic[@"PositionStatus"];
        NSArray *positionStatusArr = [PositionStatus componentsSeparatedByString:@","];
        siftView.positionStatusArr = positionStatusArr;
        [siftView.siftTableView reloadData];
    }
    /*
    [UIView animateWithDuration:0.2 animations:^{
        CGRect newFrame = filterView.frame;
        newFrame.origin.x = SCREEN_WIDTH;
        filterView.frame = newFrame;
    } completion:^(BOOL finished) {
        filterWindow.hidden = YES;
    }];
    */
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
    }
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
        taskListViewController.filterDic = [[NSMutableDictionary alloc] initWithDictionary:@{@"ShortTitle":@"2"}];
    }
}

@end
