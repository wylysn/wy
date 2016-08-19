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

#define CELLID @"WORKORDERENTIFIER_CELL"

@interface WorkOrderViewController ()<UITableViewDataSource,UITableViewDelegate,PRActionSheetPickerViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet PRButton *dateBtn;

@end

@implementation WorkOrderViewController {
    WorkOrderService *workOrderService;
    UIWindow *window;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    workOrderService = [[WorkOrderService alloc] init];
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.fd_debugLogEnabled = NO;
    self.tableView.showsVerticalScrollIndicator = NO;
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
    [pickerView showDatePickerInView:window withId:2];
}

- (void)getDateWithDate:(NSDate *)date andId:(NSInteger)idNum {
    [self disMissBackView];
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
