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

#define CELLID @"WORKORDERENTIFIER_CELL"

@interface WorkOrderViewController ()<UITableViewDataSource,UITableViewDelegate,PRActionSheetPickerViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet PRButton *dateBtn;

@end

@implementation WorkOrderViewController {
    WorkOrderService *workOrderService;
    UIWindow *window;
    NSDate *defaultDate;
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
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.fd_debugLogEnabled = NO;
    self.tableView.showsVerticalScrollIndicator = NO;
    
    defaultDate = [NSDate date];
}

-(void)filterorders:(UITapGestureRecognizer *)recognizer
{
    window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    window.rootViewController = self;
    window.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.2];
    [window makeKeyAndVisible];

    float x = 100;
    float width = SCREEN_WIDTH-x;
    UIView *filterView = [[UIView alloc] initWithFrame:CGRectMake(x, 0, width, SCREEN_HEIGHT)];
    filterView.backgroundColor = [UIColor whiteColor];
    //主体内容
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, width, SCREEN_HEIGHT-60)];
    
    //顶部标题
    float TITLEVIEW_HEIGHT = 40;
    UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, width, TITLEVIEW_HEIGHT)];
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake((width-42)/2, (TITLEVIEW_HEIGHT-21)/2, 42, 21)];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = [UIFont systemFontOfSize:17];
    titleLabel.text = @"筛选";
    [titleView addSubview:titleLabel];
    [scrollView addSubview:titleView];
    
    //分割线1
    NSString *SPLITVIEW_COLOR = @"EFEFF4";
    float SPLITVIEW_HEIGHT = 6;
    UIView *splitView1 = [[UIView alloc] initWithFrame:CGRectMake(0, TITLEVIEW_HEIGHT, width, SPLITVIEW_HEIGHT)];
    splitView1.backgroundColor = [UIColor colorFromHexCode:SPLITVIEW_COLOR];
    [scrollView addSubview:splitView1];
    
    //优先级title
    float F1VIEW_HEIGHT = 40;
    UIView *f1titleView = [[UIView alloc] initWithFrame:CGRectMake(0, TITLEVIEW_HEIGHT+SPLITVIEW_HEIGHT, width, F1VIEW_HEIGHT)];
    UILabel *f1titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, (F1VIEW_HEIGHT-21)/2, 100, 21)];
    f1titleLabel.textAlignment = NSTextAlignmentLeft;
    f1titleLabel.font = [UIFont systemFontOfSize:17];
    f1titleLabel.text = @"优先级";
    [f1titleView addSubview:f1titleLabel];
    [scrollView addSubview:f1titleView];
    //分割线2
    float SPLITVIEW2_HEIGHT = 1/[UIScreen mainScreen].scale;
    UIView *splitView2 = [[UIView alloc] initWithFrame:CGRectMake(0, TITLEVIEW_HEIGHT+SPLITVIEW_HEIGHT+F1VIEW_HEIGHT, width, SPLITVIEW2_HEIGHT)];
    splitView2.backgroundColor = [UIColor colorFromHexCode:SPLITLINE_COLOR];
    [scrollView addSubview:splitView2];
    //条件
    float c1_HEIGHT = 60;
    UIView *c1View = [[UIView alloc] initWithFrame:CGRectMake(0, TITLEVIEW_HEIGHT+SPLITVIEW_HEIGHT+F1VIEW_HEIGHT+SPLITVIEW2_HEIGHT, width, c1_HEIGHT)];
//    for (NSInteger i=1; i<7; i++) {
        UIButton *btn1 = [[UIButton alloc] initWithFrame:CGRectMake(15, (c1_HEIGHT-21)/2, 27, 21)];
        [btn1 setTitle:@"低" forState:UIControlStateNormal];
    [btn1 setTitleColor:[UIColor colorFromHexCode:@"8EC158"] forState:UIControlStateNormal];
        btn1.layer.cornerRadius = 3;
        btn1.layer.borderWidth = 1;
        btn1.layer.borderColor = [UIColor colorFromHexCode:@"8EC158"].CGColor;
    [c1View addSubview:btn1];
//    }
    [scrollView addSubview:c1View];
    
    [filterView addSubview:scrollView];
    [window addSubview:filterView];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return workOrderService.taskEntitysList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WorkOrderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CELLID forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[WorkOrderTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CELLID];
    }
    
    [self configureCell:cell atIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)configureCell:(WorkOrderTableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row > workOrderService.taskEntitysList.count) {
        return;
    }
    cell.fd_enforceFrameLayout = NO; // Enable to use "-sizeThatFits:"
    cell.entity = workOrderService.taskEntitysList[indexPath.row];
    cell.parentController = self;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    TaskEntity *entity = workOrderService.taskEntitysList[indexPath.row];
    
    return [tableView fd_heightForCellWithIdentifier:CELLID cacheByKey:entity.identifier configuration:^(WorkOrderTableViewCell *cell) {
        [self configureCell:cell atIndexPath:indexPath];
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
    [pickerView showDatePickerInView:window withType:4];
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
