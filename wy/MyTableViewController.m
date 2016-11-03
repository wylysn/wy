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
#import "DownloadViewController.h"
#import "ClearCacheViewController.h"
#import "BaseInfoEntity.h"

@interface MyTableViewController ()

@property (weak, nonatomic) IBOutlet UILabel *cacheSizeLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;
@property (weak, nonatomic) IBOutlet UILabel *departmentLabel;

@end

@implementation MyTableViewController {
    UIWindow *window;
    UIWebView *callWebview;
    DownloadViewController *downloadViewController;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)viewWillAppear:(BOOL)animated {
    
    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)viewDidAppear:(BOOL)animated {
    double cacheSize = 0;
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSDictionary *downloadDic = [userDefaults objectForKey:@"downloads"];
    NSEnumerator *enumeratorObject = [downloadDic objectEnumerator];
    for (NSDictionary *objDic in enumeratorObject) {
        cacheSize += [objDic[@"size"] doubleValue];
    }
    self.cacheSizeLabel.text = [NSString getFileSizeString:[NSNumber numberWithDouble:cacheSize]];
    
    NSString *name = [userDefaults objectForKey:@"Name"];
    NSString *department = [userDefaults objectForKey:@"Department"];
    NSString *phone = [userDefaults objectForKey:@"Mobile"];
    self.nameLabel.text = name;
    self.departmentLabel.text = department;
    self.phoneLabel.text = phone;
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
    } else if (section == 2) {
        if (row == 0) {
            if (!downloadViewController) {
                downloadViewController = [mySB instantiateViewControllerWithIdentifier:@"DOWNLOAD"];
                self.navigationItem.backBarButtonItem = backButton;
                NSString *title = @"离线数据下载";
                [downloadViewController setTitle:title];
            }
            [self.navigationController pushViewController:downloadViewController animated:YES];
        } else if (row == 1) {
            ClearCacheViewController *clearController = [mySB instantiateViewControllerWithIdentifier:@"CLEARCACHE"];
            [self.navigationController pushViewController:clearController animated:YES];
        }
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
    } else if (section == 5) {
        UIViewController *loginViewController = [mySB instantiateViewControllerWithIdentifier:@"LOGIN"];
        [self presentViewController:loginViewController animated:YES completion:nil];
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
        PRHTTPSessionManager *manager = [PRHTTPSessionManager sharePRHTTPSessionManager];
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        NSString *userName = [userDefaults objectForKey:@"userName"];
        NSMutableDictionary *condition = [[NSMutableDictionary alloc] init];
        [condition setObject:@"putappnotice" forKey:@"action"];
        [condition setObject:[DateUtil getCurrentTimestamp] forKey:@"tick"];
        [condition setObject:[NSString getDeviceId] forKey:@"imei"];
        [condition setObject:userName?userName:@"" forKey:@"username"];
        [condition setObject:[NSString stringWithFormat:@"%ld", view.tag] forKey:@"type"];
        [manager GET:[[URLManager getSharedInstance] getURL:@""] parameters:condition progress:^(NSProgress * _Nonnull downloadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            window.hidden = YES;
            if (responseObject[@"success"]) {
                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"报警成功" preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:nil];
                [alertController addAction:okAction];
                [self presentViewController:alertController animated:YES completion:nil];
            } else {
                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:responseObject[@"message"] preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:nil];
                [alertController addAction:okAction];
                [self presentViewController:alertController animated:YES completion:nil];
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            window.hidden = YES;
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"网络错误" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:nil];
            [alertController addAction:okAction];
            [self presentViewController:alertController animated:YES completion:nil];
        }];
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
