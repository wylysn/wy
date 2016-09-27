//
//  AssetsRepaireRecordTableViewController.m
//  wy
//
//  Created by wangyilu on 16/9/27.
//  Copyright © 2016年 ___PURANG___. All rights reserved.
//

#import "AssetsRepaireRecordTableViewController.h"

@interface AssetsRepaireRecordTableViewController ()

@end

@implementation AssetsRepaireRecordTableViewController {
    UIView *noDataView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.repairList.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    NSString *CELLID = @"REPAIRECELL";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CELLID forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CELLID];
    }
    
    UILabel *keyLabel = [cell viewWithTag:1];
    UILabel *valueLabel = [cell viewWithTag:2];
    if (row==0) {
        keyLabel.text = @"维修日期";
        valueLabel.text = self.repairList[section][@"Work_Date"];
    } else if (row==1) {
        keyLabel.text = @"维修单位";
        valueLabel.text = self.repairList[section][@"Maintain_Org"];
    }
    
    return cell;
}

@end
