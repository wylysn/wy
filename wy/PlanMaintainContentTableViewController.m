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
    return 2+(self.planDetail.MaterialList.count<1?1:self.planDetail.MaterialList.count)+(self.planDetail.ToolList.count<1?1:self.planDetail.ToolList.count)+(self.planDetail.PositionList.count<1?1:self.planDetail.PositionList.count);
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 3;
    } else if (section == 1) {
        return 2;
    } else if (section>=2 && section<2+(self.planDetail.MaterialList.count<1?1:self.planDetail.MaterialList.count)) {
        if (section==2 && self.planDetail.MaterialList.count<1) {
            return 0;
        }
        return 6;
    } else if (section>=2+(self.planDetail.MaterialList.count<1?1:self.planDetail.MaterialList.count) && section<2+(self.planDetail.MaterialList.count<1?1:self.planDetail.MaterialList.count)+(self.planDetail.ToolList.count<1?1:self.planDetail.ToolList.count)) {
        if (section==2+(self.planDetail.MaterialList.count<1?1:self.planDetail.MaterialList.count) && self.planDetail.ToolList.count<1) {
            return 0;
        }
        return 3;
    } else if (section >= 2+(self.planDetail.MaterialList.count<1?1:self.planDetail.MaterialList.count)+(self.planDetail.ToolList.count<1?1:self.planDetail.ToolList.count)) {
        if (section==2+(self.planDetail.MaterialList.count<1?1:self.planDetail.MaterialList.count)+(self.planDetail.ToolList.count<1?1:self.planDetail.ToolList.count) && self.planDetail.PositionList.count<1) {
            return 0;
        }
        return 2;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0 || section == 1 || section == 2 || section == 2+(self.planDetail.MaterialList.count<1?1:self.planDetail.MaterialList.count) || section == 2+(self.planDetail.MaterialList.count<1?1:self.planDetail.MaterialList.count)+(self.planDetail.ToolList.count<1?1:self.planDetail.ToolList.count)) {
        return 44;
    }
    return CGFLOAT_MIN;
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
    } else if (section == 2+(self.planDetail.MaterialList.count<1?1:self.planDetail.MaterialList.count)) {
        header.backgroundColor = [UIColor whiteColor];
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, (44-21)/2, 200, 21)];
        titleLabel.text = @"维护工具";
        [header addSubview:titleLabel];
        return header;
    } else if (section == 2+(self.planDetail.MaterialList.count<1?1:self.planDetail.MaterialList.count)+(self.planDetail.ToolList.count<1?1:self.planDetail.ToolList.count)) {
        header.backgroundColor = [UIColor whiteColor];
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, (44-21)/2, 200, 21)];
        titleLabel.text = @"空间位置";
        [header addSubview:titleLabel];
        return header;
    }
    return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    NSString *CELLID = @"PLANDETAILCELL";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CELLID forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CELLID];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    UILabel *keyLabel = [cell viewWithTag:1];
    UILabel *valueLabel = [cell viewWithTag:2];
    if (section == 0) {
        if (row == 0) {
            keyLabel.text = @"维保名称";
            valueLabel.text = self.planDetail.Name;
        } else if (row == 1) {
            keyLabel.text = @"优先级";
            valueLabel.text = self.planDetail.Priority;
        } else if (row == 2) {
            keyLabel.text = @"时间";
            valueLabel.text = self.planDetail.ExecuteTime;
        }
    } else if (section == 1) {
        for (NSDictionary *workDic in self.planDetail.StepList) {
            keyLabel.text = @"维护内容";
            valueLabel.text = workDic[@"Content"];
        }
    } else if (section>=2 && section<2+(self.planDetail.MaterialList.count<1?1:self.planDetail.MaterialList.count)) {
        if (self.planDetail.MaterialList.count>0) {
            NSDictionary *materialDic = self.planDetail.MaterialList[section-2];
            if (row == 0) {
                keyLabel.text = @"物资名称";
                valueLabel.text = materialDic[@"WzName"];
            } else if (row == 1) {
                keyLabel.text = @"品牌";
                valueLabel.text = materialDic[@"Wzpinp"];
            } else if (row == 2) {
                keyLabel.text = @"型号";
                valueLabel.text = materialDic[@"Wztype"];
            } else if (row == 3) {
                keyLabel.text = @"单位";
                valueLabel.text = materialDic[@"WzUnitName"];
            } else if (row == 4) {
                keyLabel.text = @"数量";
                valueLabel.text = materialDic[@"Wznumber"];
            }
        }
    } else if (section>=2+(self.planDetail.MaterialList.count<1?1:self.planDetail.MaterialList.count) && section<2+(self.planDetail.MaterialList.count<1?1:self.planDetail.MaterialList.count)+(self.planDetail.ToolList.count<1?1:self.planDetail.ToolList.count)) {
        NSDictionary *toolDic = self.planDetail.ToolList[section-(2+(self.planDetail.MaterialList.count<1?1:self.planDetail.MaterialList.count))];
        if (row == 0) {
            keyLabel.text = @"工具名称";
            valueLabel.text = toolDic[@"GjName"];
        } else if (row == 1) {
            keyLabel.text = @"型号/规格";
            valueLabel.text = toolDic[@"Gjtype"];
        } else if (row == 2) {
            keyLabel.text = @"数量";
            valueLabel.text = toolDic[@"Gjnumber"];
        }
    } else if (section >= 2+(self.planDetail.MaterialList.count<1?1:self.planDetail.MaterialList.count)+(self.planDetail.ToolList.count<1?1:self.planDetail.ToolList.count)) {
        NSDictionary *positionDic = self.planDetail.PositionList[section-(2+(self.planDetail.MaterialList.count<1?1:self.planDetail.MaterialList.count)+(self.planDetail.ToolList.count<1?1:self.planDetail.ToolList.count))];
        if (row == 0) {
            keyLabel.text = @"编码";
            valueLabel.text = positionDic[@"Code"];
        } else if (row == 1) {
            keyLabel.text = @"位置空间";
            valueLabel.text = positionDic[@"Name"];
        }
    }
    
    return cell;
}

@end
