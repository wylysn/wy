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
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
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
@property (weak, nonatomic) IBOutlet UILabel *timeDiffLabel;

@property (weak, nonatomic) IBOutlet UIView *personInChargeView;
@property (weak, nonatomic) IBOutlet UIView *estimateTimeView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *chargeViewHeightConstraint;

@end

@implementation TaskPaiGongViewController {
    UIWindow *window;
    NSInteger btnTag;
    NSInteger addTimes;
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
    
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"派工" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.backBarButtonItem = backButton;
}

- (IBAction)dateBtnClick:(id)sender {
    window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
//    window.hidden = NO;
//    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
//    window.rootViewController = appDelegate.window.rootViewController;
    window.rootViewController = self;
    window.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.2];
    [window makeKeyAndVisible];
    
    UIButton *btn = (UIButton *)sender;
    btnTag = btn.tag;
    
    PRActionSheetPickerView *pickerView = [[PRActionSheetPickerView alloc] init];
    pickerView.delegate = self;
    if (![btn.titleLabel.text isEqualToString:@"请输入到场时间"] && ![btn.titleLabel.text isEqualToString:@"请输入结束时间"]) {
        pickerView.defaultDate = btn.titleLabel.text;
    }
    [pickerView showDatePickerInView:window withId:2];
    
    
}

- (void)getDateWithDate:(NSDate *)date andId:(NSInteger)idNum {
    window.hidden = YES;
    window.rootViewController = nil;
    window = nil;
    NSString *title = [DateUtil formatDateString:date withFormatter:@"yyyy-MM-dd HH:mm:00"];
    if (btnTag == 10) {
        [self.startTimeBtn setTitle:title forState:UIControlStateNormal];
        [self calculateTimeDiffrence:title toTheTime:self.endTimeBtn.titleLabel.text];
    } else if(btnTag == 11) {
        [self.endTimeBtn setTitle:title forState:UIControlStateNormal];
        [self calculateTimeDiffrence:self.startTimeBtn.titleLabel.text toTheTime:title];
    }
    
}

- (void)calculateTimeDiffrence:(NSString *)fromTime toTheTime:(NSString *)toTime {
    if (![fromTime isEqualToString:@"请输入到场时间"] && ![toTime isEqualToString:@"请输入结束时间"]) {
        NSDate *startD = [DateUtil dateFromString:fromTime withFormatter:@"yyyy-MM-dd HH:mm:00"];
        NSDate *endD = [DateUtil dateFromString:toTime withFormatter:@"yyyy-MM-dd HH:mm:00"];
        NSInteger df = [DateUtil intervalFromLastDate:startD toTheDate:endD];
        self.timeDiffLabel.text = [NSString stringWithFormat:@"%ld", df];
    }
}

- (IBAction)addPersonInCharge:(id)sender {
    int HEIGHT = 30;
    addTimes += 1;
//    UIView *splitView = [[UIView alloc] initWithFrame:CGRectMake(0, 41, SCREEN_WIDTH, 1/[UIScreen mainScreen].scale)];
//    splitView.backgroundColor = [UIColor colorFromHexCode:@"aaaaaa"];
//    [self.personInChargeView addSubview:splitView];
    
    UIView *personView = [[UIView alloc] initWithFrame:CGRectMake(0, self.personInChargeView.frame.size.height, SCREEN_WIDTH, HEIGHT)];
    personView.backgroundColor = [UIColor redColor];
    
    CGRect newFrame = self.personInChargeView.frame;
    newFrame.size.height = newFrame.size.height+HEIGHT;
    [self.personInChargeView setFrame:newFrame];
    //修改约束,防止滚动条滚动将view的的frame重置为storyboard重的设置值
    self.chargeViewHeightConstraint.constant = newFrame.size.height;
    
    CGRect newFrame2 = self.estimateTimeView.frame;
    newFrame2.origin.y = newFrame2.origin.y+HEIGHT;
    [self.estimateTimeView setFrame:newFrame2];
    
    [self.personInChargeView addSubview:personView];
    
    self.scrollView.contentSize = CGSizeMake(SCREEN_WIDTH, self.scrollView.contentSize.height+HEIGHT);
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
