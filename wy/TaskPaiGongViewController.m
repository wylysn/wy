//
//  TaskPaiGongViewController.m
//  wy
//
//  Created by wangyilu on 16/8/12.
//  Copyright © 2016年 ___PURANG___. All rights reserved.
//

#import "TaskPaiGongViewController.h"
#import "AppDelegate.h"
#import "PRActionSheetPickerView.h"
#import "DateUtil.h"

@interface TaskPaiGongViewController ()<PRActionSheetPickerViewDelegate>
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *ct1;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *ct2;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *ct3;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *ct4;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *ct5;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *ct6;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *ct7;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *ct8;

@property (weak, nonatomic) IBOutlet UIButton *startTimeBtn;
@property (weak, nonatomic) IBOutlet UIButton *endTimeBtn;


@end

@implementation TaskPaiGongViewController {
    UIWindow *window;
    NSInteger btnTag;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.navigationItem setTitle:@"派工"];
    
    float ht = 1.f/[UIScreen mainScreen].scale;;
    self.ct1.constant = ht;
    self.ct2.constant = ht;
    self.ct3.constant = ht;
    self.ct4.constant = ht;
    self.ct5.constant = ht;
    self.ct6.constant = ht;
    self.ct7.constant = ht;
    self.ct8.constant = ht;
}

- (IBAction)dateBtnClick:(id)sender {
    window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
//    window.hidden = NO;
//    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
//    window.rootViewController = appDelegate.window.rootViewController;
    window.rootViewController = self;
    window.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.2];
    [window makeKeyAndVisible];
    
    PRActionSheetPickerView *pickerView = [[PRActionSheetPickerView alloc] init];
    pickerView.delegate = self;
    [pickerView showDatePickerInView:window withId:2];
    
    UIButton *btn = (UIButton *)sender;
    btnTag = btn.tag;
}

- (void)getDateWithDate:(NSDate *)date andId:(NSInteger)idNum {
    window.hidden = YES;
    window.rootViewController = nil;
    window = nil;
    
    if (btnTag == 10) {
        [self.startTimeBtn setTitle:[DateUtil formatDateString:date withFormatter:@"yyyy-MM-dd HH:mm:ss"] forState:UIControlStateNormal];
    }
}

- (void)disMissBackView {
    window.hidden = YES;
    window.rootViewController = nil;
    window = nil;
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
