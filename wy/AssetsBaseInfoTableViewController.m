//
//  AssetsBaseInfoTableViewController.m
//  wy
//
//  Created by wangyilu on 16/9/27.
//  Copyright © 2016年 ___PURANG___. All rights reserved.
//

#import "AssetsBaseInfoTableViewController.h"

@interface AssetsBaseInfoTableViewController ()

@end

@implementation AssetsBaseInfoTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    self.tableView.estimatedRowHeight = 44;
//    self.tableView.rowHeight = UITableViewAutomaticDimension;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section==0) {
        return 4;
    } else if (section==1) {
        return self.paramList.count;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 44;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 5;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger section = indexPath.section;
    if (section == 0) {
        return 44;
    } else if (section == 1) {
        return 96;
    }
    return CGFLOAT_MIN;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 44)];
    if (section == 0) {
        header.backgroundColor = [UIColor whiteColor];
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, (44-21)/2, 200, 21)];
        titleLabel.text = @"基本信息";
        [header addSubview:titleLabel];
        return header;
    } else if (section == 1) {
        header.backgroundColor = [UIColor whiteColor];
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, (44-21)/2, 200, 21)];
        titleLabel.text = @"参数信息";
        [header addSubview:titleLabel];
        return header;
    }
    return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    NSString *CELLID;
    if (section==0) {
        CELLID = @"BASEINFOCELL";
    } else if (section==1) {
        CELLID = @"PARAMETERCELL";
    }
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CELLID forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CELLID];
    }
    
    if (section==0) {
        UILabel *keyLabel = [cell viewWithTag:1];
        UILabel *valueLabel = [cell viewWithTag:2];
        if (row==0) {
            keyLabel.text = @"设备编号";
            valueLabel.text = self.assetsDic[@"Code"];
        } else if (row==1) {
            keyLabel.text = @"设备名称";
            valueLabel.text = self.assetsDic[@"Name"];
        } else if (row==2) {
            keyLabel.text = @"系统分类";
            valueLabel.text = self.assetsDic[@"ClassName"];
        } else if (row==3) {
            keyLabel.text = @"设备状态";
            valueLabel.text = self.assetsDic[@"Status"];
        }
    } else if (section == 1) {
        NSDictionary *param = self.paramList[row];
        UILabel *nameLabel = [cell viewWithTag:1];
        UILabel *defaultValueLabel = [cell viewWithTag:2];
        UILabel *rangeLabel = [cell viewWithTag:3];
        nameLabel.text = param[@"Name"];
        defaultValueLabel.text = param[@"Value"];
        rangeLabel.text = param[@"Range"];
    }
    
    return cell;
}

@end
