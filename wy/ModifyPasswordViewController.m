//
//  ModifyPasswordViewController.m
//  wy
//
//  Created by wangyilu on 16/8/26.
//  Copyright © 2016年 ___PURANG___. All rights reserved.
//

#import "ModifyPasswordViewController.h"
#import "ModifyPasswordChildViewController.h"

@interface ModifyPasswordViewController ()

@end

@implementation ModifyPasswordViewController {
    ModifyPasswordChildViewController *passwordTableViewController;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (IBAction)btnClick:(id)sender {
    NSString *originalPassword = passwordTableViewController.originalPassword.text;
    NSString *yourNewPassword = passwordTableViewController.yourNewPassword.text;
    NSString *confirmPassword = passwordTableViewController.confirmPassword.text;
    NSLog(@"原密码：%@", originalPassword);
    NSLog(@"新密码：%@", yourNewPassword);
    NSLog(@"确认密码：%@", confirmPassword);
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:nil];
    [alertController addAction:okAction];
    if (![yourNewPassword isEqualToString:confirmPassword]) {
        alertController.message = @"密码填写不一致！";
        [self presentViewController:alertController animated:YES completion:nil];
        return;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([@"PasswordEmbedSegue" isEqualToString:segue.identifier]) {
        passwordTableViewController = segue.destinationViewController;
    }
}

@end
