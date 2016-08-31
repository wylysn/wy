//
//  ChooseDeviceViewController.m
//  wy
//
//  Created by wangyilu on 16/8/30.
//  Copyright © 2016年 ___PURANG___. All rights reserved.
//

#import "ChooseDeviceViewController.h"
#import "DeviceDBService.h"
#import "DeviceEntity.h"

#define CELLID @"DEVICEIDENTIFIER"

@interface ChooseDeviceViewController ()<UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *searchField;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation ChooseDeviceViewController {
    NSArray *deviceList;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIImageView *image1=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"search"]];
    image1.frame=CGRectMake(0, 0, 25, 25);
    self.searchField.leftView=image1;
    self.searchField.leftViewMode=UITextFieldViewModeAlways;
    self.searchField.delegate = self;
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableView setSeparatorInset:UIEdgeInsetsMake(0,10,0,0)];
    }
    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)])  {
        [self.tableView setLayoutMargins:UIEdgeInsetsMake(0,10,0,0)];
    }
    
    deviceList = [[DeviceDBService getSharedInstance] findAll];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return deviceList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CELLID forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CELLID];
    }
    DeviceEntity *device = deviceList[indexPath.row];
    UILabel *nameLabel = [cell viewWithTag:1];
    UILabel *codeLabel = [cell viewWithTag:2];
    UIImageView *checkImageView = [cell viewWithTag:3];
    nameLabel.text = device.name;
    codeLabel.text = device.code;

    if (self.selectedDevicesDic[device.code]) {
        UIImage *image = [UIImage imageNamed:@"checked_filled"];
        [checkImageView setImage:image];
        [self.tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return CGFLOAT_MIN;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 61;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    UIImage *image = [UIImage imageNamed:@"checked_filled"];
    UIImageView *checkImageView = [cell viewWithTag:3];
    [checkImageView setImage:image];
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    UIImage *image = [UIImage imageNamed:@"checked"];
    UIImageView *checkImageView = [cell viewWithTag:3];
    [checkImageView setImage:image];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableView setSeparatorInset:UIEdgeInsetsMake(0,10,0,0)];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)])  {
        [self.tableView setLayoutMargins:UIEdgeInsetsMake(0,10,0,0)];
    }
}

- (IBAction)confirmDeviceClick:(id)sender {
    NSArray<NSIndexPath *> *indexPathsOfSelectedRows = [self.tableView indexPathsForSelectedRows];
    NSMutableArray *deviceArr = [[NSMutableArray alloc] init];
    for (NSIndexPath *indexPath in indexPathsOfSelectedRows) {
        DeviceEntity *device = deviceList[indexPath.row];
        [deviceArr addObject:device];
    }
    [self.navigationController popViewControllerAnimated:YES];
    
    if (_delegate && [_delegate respondsToSelector:@selector(showSelectedDevices:)]) {
        [_delegate showSelectedDevices:deviceArr];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    deviceList = [[DeviceDBService getSharedInstance] findDevicesByName:textField.text];
    [self.searchField resignFirstResponder];
    [self.tableView reloadData];
    return YES;
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
