//
//  MyTableViewController.m
//  wy
//
//  Created by wangyilu on 16/8/26.
//  Copyright © 2016年 ___PURANG___. All rights reserved.
//

#import "MyTableViewController.h"
#import "ModifyMobileViewController.h"
#import "ModifyPasswordViewController.h"
#import "FeedbackViewController.h"
#import "FeedbackChildTableViewController.h"

@interface MyTableViewController ()

@end

@implementation MyTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewWillAppear:(BOOL)animated {
    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - Table view data source

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 20;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"我的" style:UIBarButtonItemStylePlain target:nil action:nil];
    
    UIStoryboard* mainSB = [UIStoryboard storyboardWithName:@"My" bundle:[NSBundle mainBundle]];
    if (section == 1) {
        if (row == 0) {
            ModifyMobileViewController *modifyPhoneViewController = [mainSB instantiateViewControllerWithIdentifier:@"MODIFYMOBILE"];
            self.navigationItem.backBarButtonItem = backButton;
            NSString *title = @"修改手机号";
            [modifyPhoneViewController setTitle:title];
            modifyPhoneViewController.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:modifyPhoneViewController animated:YES];
        } else if (row == 1) {
            ModifyPasswordViewController *modifyPassWordViewController = [mainSB instantiateViewControllerWithIdentifier:@"MODIFYPASSWORD"];
            self.navigationItem.backBarButtonItem = backButton;
            NSString *title = @"修改密码";
            [modifyPassWordViewController setTitle:title];
            modifyPassWordViewController.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:modifyPassWordViewController animated:YES];
        }
    }
    if (section == 4) {
        if (row == 0) {
            FeedbackViewController *feedbackViewController = [mainSB instantiateViewControllerWithIdentifier:@"FEEDBACK"];
            self.navigationItem.backBarButtonItem = backButton;
            NSString *title = @"反馈";
            [feedbackViewController setTitle:title];
            feedbackViewController.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:feedbackViewController animated:YES];
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
