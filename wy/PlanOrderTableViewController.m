//
//  PlanOrderTableViewController.m
//  wy
//
//  Created by wangyilu on 16/10/11.
//  Copyright © 2016年 ___PURANG___. All rights reserved.
//

#import "PlanOrderTableViewController.h"
#import "PlanOperateNaviViewController.h"

@interface PlanOrderTableViewController ()

@end

@implementation PlanOrderTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.estimatedRowHeight = 44;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 4;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger row = indexPath.row;
    NSString *CELLID = @"PLANDETAILCELL";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CELLID forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CELLID];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    UILabel *keyLabel = [cell viewWithTag:1];
    UILabel *valueLabel = [cell viewWithTag:2];
    NSDictionary *taskInfo = self.planDetail.TaskInfo;
    if (row == 0) {
        keyLabel.text = @"任务编码";
        valueLabel.text = taskInfo[@"Code"];
    } else if (row == 1) {
        keyLabel.text = @"任务类型";
        valueLabel.text = taskInfo[@"ShortTitle"];
    } else if (row == 2) {
        keyLabel.text = @"描述";
        valueLabel.text = (NSNull *)taskInfo[@"Subject"]==[NSNull null]?@"":taskInfo[@"Subject"];
    } else if (row == 3) {
        keyLabel.text = @"位置";
        valueLabel.text = taskInfo[@"Location"];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UIStoryboard* featureSB = [UIStoryboard storyboardWithName:@"Feature" bundle:[NSBundle mainBundle]];
    
    NSDictionary *taskInfo = self.planDetail.TaskInfo;
    if(!taskInfo || [taskInfo[@"Code"] isBlankString]) {
        return;
    }
    PlanOperateNaviViewController *planOperateViewController = [featureSB instantiateViewControllerWithIdentifier:@"PLANOPERATENAVI"];
    planOperateViewController.Code = taskInfo[@"Code"];
    [self.navigationController presentViewController:planOperateViewController animated:YES completion:^{
        
    }];
}

@end
