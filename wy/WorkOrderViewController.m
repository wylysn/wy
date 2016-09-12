//
//  WorkOrderViewController.m
//  wy
//
//  Created by wangyilu on 16/8/19.
//  Copyright © 2016年 ___PURANG___. All rights reserved.
//

#import "WorkOrderViewController.h"
#import "WorkOrderService.h"
#import "WorkOrderTableViewCell.h"
#import <UITableView+FDTemplateLayoutCell.h>
#import "PRActionSheetPickerView.h"
#import "DateUtil.h"
#import "PRButton.h"
#import <MJRefresh.h>
#import "TaskTableViewController.h"

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
    
    WorkOrderService *workOrderService;
    UIWindow *window;
    UIWindow *filterWindow;
    UIView *filterView;
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
    
    workOrderService = [[WorkOrderService alloc] init];
    
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
        [UIView animateWithDuration:0.2 animations:^{
            CGRect newFrame = filterView.frame;
            newFrame.origin.x = px;
            filterView.frame = newFrame;
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
        f1titleLabel.text = @"优先级";
        [f1titleView addSubview:f1titleLabel];
        [scrollView addSubview:f1titleView];
        //分割线2
        float SPLITVIEW2_HEIGHT = 1/[UIScreen mainScreen].scale;
        UIView *splitView2 = [[UIView alloc] initWithFrame:CGRectMake(0, TITLEVIEW_HEIGHT+SPLITVIEW_HEIGHT+F1VIEW_HEIGHT, pwidth, SPLITVIEW2_HEIGHT)];
        splitView2.backgroundColor = [UIColor colorFromHexCode:SPLITLINE_COLOR];
        [scrollView addSubview:splitView2];
        //条件
        float PRIORITY_HEIGHT = 60;
        priorityView = [[UIView alloc] initWithFrame:CGRectMake(0, TITLEVIEW_HEIGHT+SPLITVIEW_HEIGHT+F1VIEW_HEIGHT+SPLITVIEW2_HEIGHT, pwidth, PRIORITY_HEIGHT)];
        float sp;
        if (SCREEN_WIDTH<=320) {
            sp = 10;
        } else if (SCREEN_WIDTH<=375) {
            sp = 15;
        } else {
            sp = 15;
        }
        for (NSInteger i=1; i<=4; i++) {
            NSString *color;
            float x;
            float width;
            NSString *title;
            if (i==1) {
                x = 15;
                title = @"低";
                width = 27;
                color = @"8EC158";
            } else if(i==2) {
                x = 15+27+sp;
                title = @"中";
                width = 27;
                color = @"1380B8";
            } else if(i==3) {
                x = 15+27+sp+27+sp;
                title = @"高";
                width = 27;
                color = @"FD705A";
            } else if(i==4) {
                x = 15+27+sp+27+sp+27+sp;
                title = @"紧急";
                width = 44;
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
            [priorityView addSubview:btn1];
        }
        [scrollView addSubview:priorityView];
        
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
        float ORDERSTATUS_HEIGHT = 60;
        orderStatusView = [[UIView alloc] initWithFrame:CGRectMake(0, TITLEVIEW_HEIGHT+SPLITVIEW_HEIGHT+F1VIEW_HEIGHT+SPLITVIEW2_HEIGHT+PRIORITY_HEIGHT+SPLITVIEW3_HEIGHT+F2VIEW_HEIGHT+SPLITVIEW4_HEIGHT, pwidth, ORDERSTATUS_HEIGHT)];
        for (NSInteger i=1; i<=4; i++) {
            NSString *color;
            float x;
            float width;
            NSString *title;
            if (i==1) {
                x = 15;
                title = @"终止";
                width = 44;
                color = @"8EC158";
            } else if(i==2) {
                x = 15+44+sp;
                title = @"完成";
                width = 44;
                color = @"1380B8";
            } else if(i==3) {
                x = 15+44+sp+44+sp;
                title = @"已验证";
                width = 62;
                color = @"FD705A";
            } else if(i==4) {
                x = 15+44+sp+44+sp+62+sp;
                title = @"已存档";
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
    NSMutableArray *priorityArr = [[NSMutableArray alloc] init];
    NSMutableArray *orderStatusArr = [[NSMutableArray alloc] init];
    for (UIButton *btn in priorityView.subviews) {
        if (btn.selected) {
            [priorityArr addObject:[NSString stringWithFormat:@"%ld", (long)btn.tag]];
        }
    }
    for (UIButton *btn in orderStatusView.subviews) {
        if (btn.selected) {
            [orderStatusArr addObject:[NSString stringWithFormat:@"%ld", (long)btn.tag]];
        }
    }
    [filterDic setObject:priorityArr forKey:@"prioritys"];
    [filterDic setObject:orderStatusArr forKey:@"orderStatus"];
    
    NSLog(@"筛选条件：%@", filterDic);
    taskListViewController.filterDic = filterDic;
    [taskListViewController.tableView.mj_header beginRefreshing];
}

- (void)hideFilterView:(UITapGestureRecognizer *)recognizer {
    [self filterViewHideWithTye:FilterViewHideByCancel];
}

- (void)filterViewHideWithTye:(FilterViewHideType) type {
    if (type == FilterViewHideByCancel) {
        //重置筛选条件
        for (UIButton *btn in priorityView.subviews) {
            NSArray *pArr = filterDic[@"prioritys"];
            if (!pArr) {
                btn.selected = FALSE;
                [btn setBackgroundColor:[UIColor whiteColor]];
            } else {
                if (![pArr containsObject:[NSString stringWithFormat:@"%ld", (long)btn.tag]]) {
                    btn.selected = FALSE;
                    [btn setBackgroundColor:[UIColor whiteColor]];
                }
            }
        }
        
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
    }
    
    [UIView animateWithDuration:0.2 animations:^{
        CGRect newFrame = filterView.frame;
        newFrame.origin.x = SCREEN_WIDTH;
        filterView.frame = newFrame;
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

- (void)getDateWithDate:(NSDate *)date andId:(NSInteger)idNum {
    [self disMissBackView];
    defaultDate = date;
    NSString *title = [DateUtil formatDateString:date withFormatter:@"yyyy年MM月"];
    [self.dateBtn setTitle:title forState:UIControlStateNormal];
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
        NSDictionary *dic = @{};
        taskListViewController.filterDic = dic;
    }
}


@end
