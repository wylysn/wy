//
//  TaskXunjianDeviceTableViewController.m
//  wy
//
//  Created by wangyilu on 16/8/29.
//  Copyright © 2016年 ___PURANG___. All rights reserved.
//

#import "TaskXunjianDeviceTableViewController.h"
#import "TaskService.h"
#import "TaskDeviceEntity.h"
#import "QRCodeScanViewController.h"

@interface TaskXunjianDeviceTableViewController ()

@end

@implementation TaskXunjianDeviceTableViewController {
    TaskService *taskService;
//    NSArray *taskDeviceArray;
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
    return self.taskDeviceArray.count;
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
    TaskDeviceEntity *device = (TaskDeviceEntity *)self.taskDeviceArray[section];
    if (device.isComplete) {
        cell.backgroundColor = [UIColor greenColor];
    } else {
        cell.backgroundColor = [UIColor whiteColor];
    }
    if (row == 0) {
        keyLabel.text = @"设备编码";
        valueLabel.text = device.Code;
    } else if (row == 1) {
        keyLabel.text = @"设备名称";
        valueLabel.text = device.Name;
    } else if (row == 2) {
        keyLabel.text = @"巡检点位";
        valueLabel.text = device.Position;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSArray *editFieldArr = [[[self.taskEntity.EditFields stringByReplacingOccurrencesOfString:@"[" withString:@""] stringByReplacingOccurrencesOfString:@"]" withString:@""] componentsSeparatedByString:@";"];
    if ([editFieldArr containsObject:@"SBCheckList"]) {
        QRCodeScanViewController *viewController = [[QRCodeScanViewController alloc] init];
        UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
        self.navigationItem.backBarButtonItem = backButton;
        [viewController setTitle:@"二维码/条码"];
        viewController.hidesBottomBarWhenPushed = YES;
        NSInteger section = [indexPath section];
        viewController.taskDeviceEntity = ((TaskDeviceEntity *)self.taskDeviceArray[section]);
        [self.navigationController pushViewController:viewController animated:YES];
    }
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
