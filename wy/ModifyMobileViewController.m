//
//  ModifyMobileViewController.m
//  wy
//
//  Created by wangyilu on 16/8/26.
//  Copyright © 2016年 ___PURANG___. All rights reserved.
//

#import "ModifyMobileViewController.h"
#import "MobileNumberTableViewController.h"

@interface ModifyMobileViewController ()

@property (weak, nonatomic) IBOutlet UIView *containerView;

@end

@implementation ModifyMobileViewController {
    MobileNumberTableViewController *numberTableViewController;
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (IBAction)btnClick:(id)sender {
    NSLog(@"输入的手机号：%@", numberTableViewController.numberTextField.text);
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([@"MobileNumberSegue" isEqualToString:segue.identifier]) {
        numberTableViewController = segue.destinationViewController;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
