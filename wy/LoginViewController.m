//
//  LoginViewController.m
//  wy
//
//  Created by 王益禄 on 16/9/4.
//  Copyright © 2016年 ___PURANG___. All rights reserved.
//

#import "LoginViewController.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)login:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)serverSet:(id)sender {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"请输入服务器IP地址" message:@"" preferredStyle:UIAlertControllerStyleAlert];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField){
        
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        UITextField *serverField = alertController.textFields.firstObject;
        //设置新服务器地址
        //1.获得NSUserDefaults文件
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        //2.向文件中写入内容
        [userDefaults setObject:serverField.text forKey:@"server"];
        //2.1立即同步
        [userDefaults synchronize];
        [[URLManager getSharedInstance] setURL_PATH:serverField.text];
    }];
    [alertController addAction:cancelAction];
    [alertController addAction:okAction];
    [self presentViewController:alertController animated:YES completion:nil];
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
