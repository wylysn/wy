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
//#import "TaskPaiGongViewController.h"
//#import "TaskJiedanViewController.h"
//#import "TaskChuli1ViewController.h"
#import "TaskHandleViewController.h"
#import "TaskXunjianViewController.h"
#import "TaskXunjian2ViewController.h"
#import "QRCodeScanViewController.h"

#define CELLID @"TASKENTIFIER_CELL"

@interface TaskTableViewController ()

@property (nonatomic) Reachability *hostReachability;

@end

@implementation TaskTableViewController {
    TaskService *taskService;
    NSMutableArray *taskListArray;
    UIView *noDataView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //判断真实服务器的连通
    /*
    dispatch_async(dispatch_get_main_queue(), ^{
        NSURL *url1 = [NSURL URLWithString:[[URLManager getSharedInstance] getURL:@""]];
        NSURLRequest *request = [NSURLRequest requestWithURL:url1 cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:2];
        NSHTTPURLResponse *response;
        [NSURLConnection sendSynchronousRequest:request returningResponse: &response error: nil];
        if (response == nil) {
            NSLog(@"没有网络");
        }
        else{
            NSLog(@"网络是通的");
        }
    });
     */
    
    taskService = [[TaskService alloc] init];
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.fd_debugLogEnabled = NO;
    self.tableView.showsVerticalScrollIndicator = NO;
    
    taskListArray = [[NSMutableArray alloc] init];
    
    if (!self.filterDic) {
        self.filterDic = [[NSMutableDictionary alloc] init];
    }
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [taskService getTaskListEntityArr:self.filterDic success:^{
            [self.tableView.mj_header endRefreshing];
            taskListArray = taskService.taskList;
            
            if (taskListArray.count<1) {
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
                    label.text = @"暂无任务";
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
            [self.tableView reloadData];
        } failure:^(NSString *message) {
            [self.tableView.mj_header endRefreshing];
            
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:message preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:nil];
            [alertController addAction:okAction];
            [self presentViewController:alertController animated:YES completion:nil];
        }];
    }];
}

- (void)viewWillAppear:(BOOL)animated {
    self.tabBarController.tabBar.hidden = NO;
}

- (void)viewDidAppear:(BOOL)animated {
    if (!self.tableView.mj_header.isRefreshing) {
        [self.tableView.mj_header beginRefreshing];
    }
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
    return taskListArray.count;
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
    if (indexPath.row > taskListArray.count) {
        return;
    }
//    cell.fd_enforceFrameLayout = NO; // Enable to use "-sizeThatFits:"
    cell.entity = taskListArray[indexPath.row];
    cell.parentController = self;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    TaskListEntity *entity = taskListArray[indexPath.row];
    UIStoryboard* taskSB = [UIStoryboard storyboardWithName:@"Task" bundle:[NSBundle mainBundle]];
    UIViewController *viewController;
    UIBarButtonItem *backButton;
    if ([@"2" isEqualToString:entity.ShortTitle] || [@"巡检任务" isEqualToString:entity.ShortTitle]) {
        /*
        viewController = [taskSB instantiateViewControllerWithIdentifier:@"TaskXunjianDetail"];
        ((TaskXunjianViewController *)viewController).code = entity.Code;
        ((TaskXunjianViewController *)viewController).taskStatus = entity.TaskStatus;
        backButton = [[UIBarButtonItem alloc] initWithTitle:@"巡检任务" style:UIBarButtonItemStylePlain target:nil action:nil];
         */
        
        //巡检任务查询详情
        viewController = [taskSB instantiateViewControllerWithIdentifier:@"TaskXunjianDetail2"];
        ((TaskXunjian2ViewController *)viewController).code = entity.Code;
        ((TaskXunjian2ViewController *)viewController).taskStatus = entity.TaskStatus;
        ((TaskXunjian2ViewController *)viewController).ShortTitle = entity.ShortTitle;
        ((TaskXunjian2ViewController *)viewController).isLocalSave = entity.IsLocalSave;
        backButton = [[UIBarButtonItem alloc] initWithTitle:@"巡检任务" style:UIBarButtonItemStylePlain target:nil action:nil];
    } else {
        viewController = [taskSB instantiateViewControllerWithIdentifier:@"TASKHANDLE"];
        ((TaskHandleViewController *)viewController).code = entity.Code;
        ((TaskHandleViewController *)viewController).ShortTitle = entity.ShortTitle;
        ((TaskHandleViewController *)viewController).taskStatus = entity.TaskStatus;
        ((TaskHandleViewController *)viewController).isLocalSave = entity.IsLocalSave;
        backButton = [[UIBarButtonItem alloc] initWithTitle:@"任务" style:UIBarButtonItemStylePlain target:nil action:nil];
        /*
        if ([@"1" isEqualToString:entity.TaskStatus]) {
            viewController = [taskSB instantiateViewControllerWithIdentifier:@"TASK_JIEDAN"];
            ((TaskJiedanViewController *)viewController).id = entity.Code;
        } else if ([@"2" isEqualToString:entity.TaskStatus]) {
            viewController = [taskSB instantiateViewControllerWithIdentifier:@"TASK_CHULI1"];
            ((TaskChuli1ViewController *)viewController).id = entity.Code;
        } else if ([@"3" isEqualToString:entity.TaskStatus]) {
            viewController = [taskSB instantiateViewControllerWithIdentifier:@"TASK_PAIGONG"];
            ((TaskPaiGongViewController *)viewController).id = entity.Code;
        } else if ([@"4" isEqualToString:entity.TaskStatus]) {
            viewController = [taskSB instantiateViewControllerWithIdentifier:@"TASKHANDLE"];
            ((TaskHandleViewController *)viewController).id = entity.Code;
        }
         */
    }
    
    self.navigationItem.backBarButtonItem = backButton;
    [self.navigationController pushViewController:viewController animated:YES];
}

- (IBAction)reportImpair:(id)sender {
    UIStoryboard* mainSB = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    UIViewController *viewController = [mainSB instantiateViewControllerWithIdentifier:@"REPORTIMPAIRE"];
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.backBarButtonItem = backButton;
//    viewController.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:viewController animated:YES];
}

- (IBAction)scanQRCode:(id)sender {
    QRCodeScanViewController *viewController = [[QRCodeScanViewController alloc] init];
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.backBarButtonItem = backButton;
    [viewController setTitle:@"二维码/条码"];
    viewController.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:viewController animated:YES];
}

@end
