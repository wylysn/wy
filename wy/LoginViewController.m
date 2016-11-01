//
//  LoginViewController.m
//  wy
//
//  Created by 王益禄 on 16/9/4.
//  Copyright © 2016年 ___PURANG___. All rights reserved.
//

#import "LoginViewController.h"
#import "LoginService.h"
#import "AppDelegate.h"

@interface LoginViewController ()

@property (weak, nonatomic) IBOutlet UITextField *userNameField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;
@property (weak, nonatomic) IBOutlet UIButton *rememberBtn;

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
    LoginService *loginService = [[LoginService alloc] init];
    AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSMutableDictionary *userInfoDic = [[NSMutableDictionary alloc] init];
    NSString *userName = self.userNameField.text;
    NSString *password = self.passwordField.text;
    NSString *deviceToken = [userDefaults objectForKey:@"deviceToken"];
    [userInfoDic setObject:userName forKey:@"userName"];
    [userInfoDic setObject:password forKey:@"password"];
    [userInfoDic setObject:deviceToken?deviceToken:@"" forKey:@"deviceToken"];
    [loginService loginWithUserInfo:userInfoDic success:^(NSDictionary *userDic){
        app.isLogin = YES;
        [userDefaults setObject:userName forKey:@"userName"];
        if (self.rememberBtn.isSelected) {
            [userDefaults setObject:password forKey:@"password"];
        }
        [userDefaults setObject:userDic[@"Name"] forKey:@"Name"];
        [userDefaults setObject:userDic[@"Department"] forKey:@"Department"];
        [userDefaults setObject:userDic[@"Mobile"] forKey:@"Mobile"];
        [userDefaults synchronize];
        [self dismissViewControllerAnimated:YES completion:nil];
    } failure:^(NSString *message) {
        app.isLogin = NO;
        [userDefaults removeObjectForKey:@"userName"];
        [userDefaults removeObjectForKey:@"password"];
        [userDefaults removeObjectForKey:@"Name"];
        [userDefaults removeObjectForKey:@"Department"];
        [userDefaults removeObjectForKey:@"Mobile"];
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"登陆失败" message:message preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:nil];
        [alertController addAction:okAction];
        [self presentViewController:alertController animated:YES completion:nil];
    }];
}

- (IBAction)serverSet:(id)sender {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *serverStr = [[userDefaults objectForKey:@"server"] isBlankString]?@"":URL_PATH;
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"请输入服务器IP地址" message:@"" preferredStyle:UIAlertControllerStyleAlert];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField){
        textField.text = serverStr;
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        UITextField *serverField = alertController.textFields.firstObject;
        [userDefaults setObject:serverField.text forKey:@"server"];
        [userDefaults synchronize];
        //设置新服务器
        [[URLManager getSharedInstance] setURL_PATH:serverField.text];
    }];
    [alertController addAction:cancelAction];
    [alertController addAction:okAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (IBAction)rememberBtnClick:(id)sender {
    self.rememberBtn.selected = !self.rememberBtn.selected;
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
