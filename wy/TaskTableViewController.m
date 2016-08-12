//
//  TaskTableViewController.m
//  wy
//
//  Created by wangyilu on 16/8/11.
//  Copyright © 2016年 ___PURANG___. All rights reserved.
//

#import "TaskTableViewController.h"
#import "TaskService.h"
#import "TaskTableViewCell.h"
#import <UITableView+FDTemplateLayoutCell.h>
#import <MJRefresh.h>

#define CELLID @"TASKENTIFIER_CELL"

@interface TaskTableViewController ()

@end

@implementation TaskTableViewController {
    TaskService *taskService;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    taskService = [[TaskService alloc] init];
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.fd_debugLogEnabled = NO;
    self.tableView.showsVerticalScrollIndicator = NO;
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self.tableView.mj_header endRefreshing];
    }];
    
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [self.tableView.mj_footer endRefreshing];
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return taskService.taskEntitysList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TaskTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CELLID forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[TaskTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CELLID];
    }
    
    [self configureCell:cell atIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)configureCell:(TaskTableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row > taskService.taskEntitysList.count) {
        return;
    }
    cell.fd_enforceFrameLayout = NO; // Enable to use "-sizeThatFits:"
    cell.entity = taskService.taskEntitysList[indexPath.row];
    cell.parentController = self;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    TaskEntity *entity = taskService.taskEntitysList[indexPath.row];
    
    return [tableView fd_heightForCellWithIdentifier:CELLID cacheByKey:entity.identifier configuration:^(TaskTableViewCell *cell) {
        [self configureCell:cell atIndexPath:indexPath];
    }];
}



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
