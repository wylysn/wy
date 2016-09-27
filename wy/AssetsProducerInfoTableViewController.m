//
//  AssetsProducerInfoTableViewController.m
//  wy
//
//  Created by wangyilu on 16/9/27.
//  Copyright © 2016年 ___PURANG___. All rights reserved.
//

#import "AssetsProducerInfoTableViewController.h"

@interface AssetsProducerInfoTableViewController ()

@end

@implementation AssetsProducerInfoTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.producerList.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 44;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 10;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 44)];
    if (section == 0) {
        header.backgroundColor = [UIColor whiteColor];
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, (44-21)/2, 60, 21)];
        titleLabel.text = @"生产商";
        [header addSubview:titleLabel];
        
        UILabel *companyNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(10+60+10, (44-21)/2, SCREEN_WIDTH-10-60-10-10, 21)];
        companyNameLabel.textColor = [UIColor colorFromHexCode:@"555555"];
        companyNameLabel.textAlignment = NSTextAlignmentRight;
        companyNameLabel.font = [UIFont systemFontOfSize:16];
        companyNameLabel.text = self.producerList[section][@"Supplier"];
        [header addSubview:companyNameLabel];
        return header;
    }
    return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    NSString *CELLID = @"PRODUCERCELL";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CELLID forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CELLID];
    }
    
    UILabel *keyLabel = [cell viewWithTag:1];
    UILabel *valueLabel = [cell viewWithTag:2];
    if (row==0) {
        keyLabel.text = @"联系人";
        valueLabel.text = self.producerList[section][@"Contact"];
    } else if (row==1) {
        keyLabel.text = @"电话";
        valueLabel.text = self.producerList[section][@"Contact_Tel"];
    } else if (row==2) {
        keyLabel.text = @"地址";
        valueLabel.text = self.producerList[section][@"Contract_Brief"];
    }
    
    return cell;
}

@end
