//
//  AssetsMaintainRecordTableViewController.m
//  wy
//
//  Created by wangyilu on 16/9/27.
//  Copyright © 2016年 ___PURANG___. All rights reserved.
//

#import "AssetsMaintainRecordTableViewController.h"

@interface AssetsMaintainRecordTableViewController ()

@end

@implementation AssetsMaintainRecordTableViewController {
    UIView *noDataView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    if (self.maintainList.count<1) {
        if (noDataView) {
            noDataView.hidden = NO;
        } else {
            CGRect tableFrame = self.tableView.frame;
            float tableWidth = tableFrame.size.width;
            float tableHeight = tableFrame.size.height;
            noDataView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableWidth, tableHeight)];
            UIView *noView = [[UIView alloc] initWithFrame:CGRectMake((tableWidth-100)/2, (tableHeight-100)/2-64, 100, 100)];
            UIImageView *nodataImage = [[UIImageView alloc] initWithFrame:CGRectMake((100-50)/2, 0, 50, 65)];
            nodataImage.image = [UIImage imageNamed:@"nolist"];
            [noView addSubview:nodataImage];
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 70, 100, 21)];
            label.text = @"暂无记录";
            label.font = [UIFont systemFontOfSize:15];
            label.textColor = [UIColor darkGrayColor];
            label.textAlignment = NSTextAlignmentCenter;
            [noView addSubview:label];
            
            [noDataView addSubview:noView];
            
            [self.view addSubview:noDataView];
        }
    } else {
        noDataView.hidden = YES;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.maintainList.count;
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
    NSString *CELLID = @"MAINTAINCELL";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CELLID forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CELLID];
    }
    
    UILabel *keyLabel = [cell viewWithTag:1];
    UILabel *valueLabel = [cell viewWithTag:2];
    if (row==0) {
        keyLabel.text = @"维保日期";
        valueLabel.text = self.maintainList[section][@"Work_Date"];
    } else if (row==1) {
        keyLabel.text = @"维保单位";
        valueLabel.text = self.maintainList[section][@"Maintain_Org"];
    }
    
    return cell;
}
@end
