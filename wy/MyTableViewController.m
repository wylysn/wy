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
#import "WarningView.h"
#import "AboutViewController.h"

@interface MyTableViewController ()

@end

@implementation MyTableViewController {
    UIWindow *window;
    UIWebView *callWebview;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)viewWillAppear:(BOOL)animated {
    
    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - Table view data source

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
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
    
    UIStoryboard* mySB = [UIStoryboard storyboardWithName:@"My" bundle:[NSBundle mainBundle]];
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"我的" style:UIBarButtonItemStylePlain target:nil action:nil];
    
    if (section == 0) {
        if (row == 0) {
            UIViewController *loginViewController = [mySB instantiateViewControllerWithIdentifier:@"LOGIN"];
            [self presentViewController:loginViewController animated:YES completion:nil];
        }
    } else if (section == 1 && row == 0) {
        if (!window) {
            window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
            window.rootViewController = self;
            window.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
            
            UIView *backView = [[UIView alloc] initWithFrame:window.frame];
            backView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
            [window addSubview:backView];
            UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideWarningView:)];
            [backView addGestureRecognizer:gesture];
            [backView setUserInteractionEnabled:YES];
            
            NSArray *views = [[NSBundle mainBundle] loadNibNamed:@"WarningView" owner:nil options:nil];
            WarningView *warningView = views[0];
            CGRect newFrame = warningView.frame;
            newFrame.origin.x = (window.frame.size.width-newFrame.size.width)/2;
            newFrame.origin.y = (window.frame.size.height-newFrame.size.height)/2;
            warningView.frame = newFrame;
            [window addSubview:warningView];
            
            UITapGestureRecognizer *callgesture1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(call:)];
            [warningView.fireView addGestureRecognizer:callgesture1];
            [warningView.fireView setUserInteractionEnabled:YES];
            UITapGestureRecognizer *callgesture2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(call:)];
            [warningView.waterView addGestureRecognizer:callgesture2];
            [warningView.waterView setUserInteractionEnabled:YES];
            UITapGestureRecognizer *callgesture3 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(call:)];
            [warningView.otherView addGestureRecognizer:callgesture3];
            [warningView.otherView setUserInteractionEnabled:YES];
            UITapGestureRecognizer *callgesture4 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(call:)];
            [warningView.cancelView addGestureRecognizer:callgesture4];
            [warningView.cancelView setUserInteractionEnabled:YES];
        }
        [window makeKeyAndVisible];
        [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    } else if (section == 3) {
        if (row == 0) {
            ModifyPasswordViewController *modifyPassWordViewController = [mySB instantiateViewControllerWithIdentifier:@"MODIFYPASSWORD"];
            self.navigationItem.backBarButtonItem = backButton;
            NSString *title = @"修改密码";
            [modifyPassWordViewController setTitle:title];
            [self.navigationController pushViewController:modifyPassWordViewController animated:YES];
        }
    } else if (section == 4) {
        if (row == 0) {
            AboutViewController *aboutViewController = [mySB instantiateViewControllerWithIdentifier:@"ABOUT"];
            self.navigationItem.backBarButtonItem = backButton;
            NSString *title = @"关于";
            [aboutViewController setTitle:title];
            [self.navigationController pushViewController:aboutViewController animated:YES];
        }
    }
}


- (void)hideWarningView:(UITapGestureRecognizer *)recognizer {
    window.hidden = YES;
}

- (void)call:(UITapGestureRecognizer *)recognizer {
    UIView *view = (UIView *)recognizer.view;
    if (view.tag == 4) {
        window.hidden = YES;
    } else {
        NSString *tel;
        if (view.tag == 1) {
            tel = @"tel:119";
        } else if (view.tag == 2) {
            tel = @"tel:110";
        } else if (view.tag == 3) {
            tel = @"tel:110";
        }
        if (!callWebview) {
            callWebview =[[UIWebView alloc] init];
            [self.view addSubview:callWebview];
        }
        NSURL *telURL =[NSURL URLWithString:tel];
        [callWebview loadRequest:[NSURLRequest requestWithURL:telURL]];
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
