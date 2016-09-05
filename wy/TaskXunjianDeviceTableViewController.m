//
//  TaskXunjianDeviceTableViewController.m
//  wy
//
//  Created by wangyilu on 16/8/29.
//  Copyright © 2016年 ___PURANG___. All rights reserved.
//

#import "TaskXunjianDeviceTableViewController.h"
#import "TaskDevicesService.h"
#import "DeviceListEntity.h"

@interface TaskXunjianDeviceTableViewController ()

@end

@implementation TaskXunjianDeviceTableViewController {
    TaskDevicesService *deviceService;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    deviceService = [[TaskDevicesService alloc] init];
    
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableView setSeparatorInset:UIEdgeInsetsMake(0,10,0,0)];
    }
    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)])  {
        [self.tableView setLayoutMargins:UIEdgeInsetsZero];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return deviceService.taskDevicesList.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 6;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *CELLID = @"DEVICEDETAILCELL";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CELLID forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CELLID];
    }
    
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    UILabel *keyLabel = [cell viewWithTag:1];
    UILabel *valueLabel = [cell viewWithTag:2];
    DeviceListEntity *device = (DeviceListEntity *)deviceService.taskDevicesList[section];
    if (row == 0) {
        keyLabel.text = @"设备编码";
        valueLabel.text = device.Code;
    } else if (row == 1) {
        keyLabel.text = @"设备名称";
        valueLabel.text = device.Name;
    } else if (row == 2) {
        keyLabel.text = @"巡检点位";
        valueLabel.text = device.Location;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
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
