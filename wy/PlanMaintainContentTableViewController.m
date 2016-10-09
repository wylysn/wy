//
//  PlanMaintainContentTableViewController.m
//  wy
//
//  Created by wangyilu on 16/10/9.
//  Copyright © 2016年 ___PURANG___. All rights reserved.
//

#import "PlanMaintainContentTableViewController.h"

@interface PlanMaintainContentTableViewController ()

@end

@implementation PlanMaintainContentTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.estimatedRowHeight = 44;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 5;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 3;
    } else if (section == 1) {
        return 2;
    } else if (section == 2) {
        return 6;
    } else if (section == 3) {
        return 3;
    } else if (section == 4) {
        return 2;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 44;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 5;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 44)];
    if (section == 0) {
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, (44-21)/2, 200, 21)];
        titleLabel.text = @"基本信息";
        [header addSubview:titleLabel];
        return header;
    } else if (section == 1) {
        header.backgroundColor = [UIColor whiteColor];
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, (44-21)/2, 200, 21)];
        titleLabel.text = @"重点工作";
        [header addSubview:titleLabel];
        return header;
    } else if (section == 2) {
        header.backgroundColor = [UIColor whiteColor];
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, (44-21)/2, 200, 21)];
        titleLabel.text = @"物资需求";
        [header addSubview:titleLabel];
        return header;
    } else if (section == 3) {
        header.backgroundColor = [UIColor whiteColor];
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, (44-21)/2, 200, 21)];
        titleLabel.text = @"维护工具";
        [header addSubview:titleLabel];
        return header;
    } else if (section == 4) {
        header.backgroundColor = [UIColor whiteColor];
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, (44-21)/2, 200, 21)];
        titleLabel.text = @"空间位置";
        [header addSubview:titleLabel];
        return header;
    }
    return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger row = indexPath.row;
    NSString *CELLID = @"PLANDETAILCELL";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CELLID forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CELLID];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

@end
