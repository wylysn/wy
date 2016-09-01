//
//  FeaturesTableViewController.m
//  wy
//
//  Created by wangyilu on 16/7/11.
//  Copyright © 2016年 ___PURANG___. All rights reserved.
//

#import "FeaturesTableViewController.h"
#import "TaskTableViewController.h"
#import "WorkOrderViewController.h"
#import "InspectTaskListViewController.h"
#import "KnowledgeViewController.h"

@interface FeaturesTableViewController ()

@end

@implementation FeaturesTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
//        [self.tableView setSeparatorInset:UIEdgeInsetsMake(0,10,0,0)];
//    }
//    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)])  {
//        [self.tableView setLayoutMargins:UIEdgeInsetsMake(0,10,0,0)];
//    }
}

- (void)viewWillAppear:(BOOL)animated {
    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//    return 3;
//}

//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    if (section == 0) {
//        return 3;
//    } else if (section == 1) {
//        return 2;
//    }
//    return 0;
//}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return CGFLOAT_MIN;
    }
    return 20;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"功能" style:UIBarButtonItemStylePlain target:nil action:nil];
    if (section==0 && (row==0 || row==1 || row==2)) {
        UIStoryboard* mainSB = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
        TaskTableViewController *taskTableViewController = [mainSB instantiateViewControllerWithIdentifier:@"TASK_LIST"];
        self.navigationItem.backBarButtonItem = backButton;
        NSString *title;
        if (row==0) {
            title = @"待处理工单";
        } else if (row==1) {
            title = @"待派工工单";
        } else if (row==2) {
            title = @"待审批工单";
        }
        [taskTableViewController setTitle:title];
        taskTableViewController.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:taskTableViewController animated:YES];
    }
    if (section==0 && row==3) {
        UIStoryboard* mainSB = [UIStoryboard storyboardWithName:@"Feature" bundle:[NSBundle mainBundle]];
        WorkOrderViewController *workOrderViewController = [mainSB instantiateViewControllerWithIdentifier:@"WORKORDER"];
        self.navigationItem.backBarButtonItem = backButton;
        NSString *title = @"工单查询";
        [workOrderViewController setTitle:title];
        workOrderViewController.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:workOrderViewController animated:YES];
    }
    
    if (section==1 && row==0) {
        UIStoryboard* mainSB = [UIStoryboard storyboardWithName:@"Feature" bundle:[NSBundle mainBundle]];
        InspectTaskListViewController *inspectTaskViewController = [mainSB instantiateViewControllerWithIdentifier:@"INSPECT_TASKLIST"];
        self.navigationItem.backBarButtonItem = backButton;
        NSString *title = @"巡检任务";
        [inspectTaskViewController setTitle:title];
        inspectTaskViewController.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:inspectTaskViewController animated:YES];
    }
    
    if (section==4 && row==0) {
        UIStoryboard* mainSB = [UIStoryboard storyboardWithName:@"Feature" bundle:[NSBundle mainBundle]];
        KnowledgeViewController *knowledgeViewController = [mainSB instantiateViewControllerWithIdentifier:@"KNOWLEDGESEARCH"];
        self.navigationItem.backBarButtonItem = backButton;
        NSString *title = @"知识库查询";
        [knowledgeViewController setTitle:title];
        knowledgeViewController.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:knowledgeViewController animated:YES];
    }
}

//- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
//    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
//        [self.tableView setSeparatorInset:UIEdgeInsetsMake(0,10,0,0)];
//    }
//    if ([cell respondsToSelector:@selector(setLayoutMargins:)])  {
//        [self.tableView setLayoutMargins:UIEdgeInsetsMake(0,10,0,0)];
//    }
//}

/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
