//
//  TaskBaseInfoViewController.m
//  wy
//
//  Created by 王益禄 on 16/8/28.
//  Copyright © 2016年 ___PURANG___. All rights reserved.
//

#import "TaskBaseInfoViewController.h"

@interface TaskBaseInfoViewController ()

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *ct1;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *ct2;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *ct3;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *ct4;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *ct5;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *ct6;
@property (weak, nonatomic) IBOutlet UILabel *descLabel;

@end

@implementation TaskBaseInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    float ht = 1.f/[UIScreen mainScreen].scale;
    self.ct1.constant = ht;
    self.ct2.constant = ht;
    self.ct3.constant = ht;
    self.ct4.constant = ht;
    self.ct5.constant = ht;
    self.ct6.constant = ht;
    
    self.descLabel.text = @"定义一个父类FatherViewController 和一个子类SonViewController，其中子类继承父类";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
