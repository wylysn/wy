//
//  TaskXunjianBaseInfoTableViewController.m
//  wy
//
//  Created by wangyilu on 16/8/29.
//  Copyright © 2016年 ___PURANG___. All rights reserved.
//

#import "TaskXunjianBaseInfoTableViewController.h"

@interface TaskXunjianBaseInfoTableViewController ()
@property (weak, nonatomic) IBOutlet UILabel *createTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *serviceTypeLabel;
@property (weak, nonatomic) IBOutlet UILabel *shortTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *priorityLabel;
@property (weak, nonatomic) IBOutlet UILabel *positionLabel;

@end

@implementation TaskXunjianBaseInfoTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 44)];
    if (section == 0) {
        header.backgroundColor = [UIColor whiteColor];
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, (44-21)/2, 200, 21)];
        titleLabel.text = self.taskEntity.Code;
        [header addSubview:titleLabel];
        return header;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 44;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [super tableView:tableView cellForRowAtIndexPath:indexPath];
    UILabel *textlabel = [cell viewWithTag:2];
    NSInteger row = indexPath.row;
    if (row == 0) {
        textlabel.text = self.taskEntity.CreateDate;
    } else if (row == 1) {
        textlabel.text = self.taskEntity.ServiceType;
    } else if (row == 2) {
        textlabel.text = shortTitleDic[self.ShortTitle];
    } else if (row == 3) {
        textlabel.text = self.taskEntity.Priority;
    } else if (row == 4) {
        textlabel.text = self.taskEntity.Location;
    }
    return cell;
}

@end
