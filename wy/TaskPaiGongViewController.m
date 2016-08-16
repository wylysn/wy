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
#import "ChoosePersonViewController.h"
#import "PersonEntity.h"

static NSString *startTimeBtnPlaceholder = @"请输入到场时间";
static NSString *endTimeBtnPlaceholder = @"请输入结束时间";

@interface TaskPaiGongViewController ()<PRActionSheetPickerViewDelegate, ChoosePersonViewDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *ct1;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *ct2;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *ct3;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *ct4;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *ct5;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *ct6;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *ct8;

@property (weak, nonatomic) IBOutlet UIButton *startTimeBtn;
@property (weak, nonatomic) IBOutlet UIButton *endTimeBtn;
@property (weak, nonatomic) IBOutlet UILabel *timeDiffLabel;

@property (weak, nonatomic) IBOutlet UIView *personInChargeView;
@property (weak, nonatomic) IBOutlet UIView *estimateTimeView;
@property (weak, nonatomic) IBOutlet UIView *chargeViewTitleView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *chargeViewHeightConstraint;

@end

@implementation TaskPaiGongViewController {
    UIWindow *window;
    NSInteger btnTag;
    NSInteger addTimes;
    NSMutableDictionary *personDics;
    UIView *personsView;
    float chargeTitleViewHeight;
    float scrollViewContentHeight;
    int personHeight;
    NSMutableArray *chargePersons;
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
    self.ct8.constant = ht;
    
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"派工" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.backBarButtonItem = backButton;
    
    personDics = [[NSMutableDictionary alloc] init];
    chargePersons = [[NSMutableArray alloc] init];
    
    chargeTitleViewHeight = self.chargeViewTitleView.frame.size.height;
    personHeight = 30;
    scrollViewContentHeight = self.scrollView.contentSize.height;
    personsView = [[UIView alloc] initWithFrame:CGRectMake(0, chargeTitleViewHeight, SCREEN_WIDTH, 0)];
    [self.personInChargeView addSubview:personsView];
}

- (IBAction)dateBtnClick:(id)sender {
    window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    window.rootViewController = self;
    window.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.2];
    [window makeKeyAndVisible];
    
    UIButton *btn = (UIButton *)sender;
    btnTag = btn.tag;
    
    PRActionSheetPickerView *pickerView = [[PRActionSheetPickerView alloc] init];
    pickerView.delegate = self;
    if (![btn.titleLabel.text isEqualToString:startTimeBtnPlaceholder] && ![btn.titleLabel.text isEqualToString:endTimeBtnPlaceholder]) {
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
    if (![fromTime isEqualToString:startTimeBtnPlaceholder] && ![toTime isEqualToString:endTimeBtnPlaceholder]) {
        NSDate *startD = [DateUtil dateFromString:fromTime withFormatter:@"yyyy-MM-dd HH:mm:00"];
        NSDate *endD = [DateUtil dateFromString:toTime withFormatter:@"yyyy-MM-dd HH:mm:00"];
        NSInteger df = [DateUtil intervalFromLastDate:startD toTheDate:endD];
        self.timeDiffLabel.text = [NSString stringWithFormat:@"%ld", df];
    }
}

- (IBAction)addPersonInCharge:(id)sender {
    UIStoryboard* taskSB = [UIStoryboard storyboardWithName:@"Task" bundle:[NSBundle mainBundle]];
    ChoosePersonViewController *choosePersonViewController = [taskSB instantiateViewControllerWithIdentifier:@"CHOOSEPERSON"];
    choosePersonViewController.delegate = self;
    choosePersonViewController.selectedPersonsDic = personDics;
    [self.navigationController pushViewController:choosePersonViewController animated:YES];
}

- (void)disMissBackView {
    window.hidden = YES;
    window.rootViewController = nil;
    window = nil;
}

- (void)getSelectedPersons:(NSArray *)persons {
    UIView *splitView = [self.chargeViewTitleView viewWithTag:1];
    if (personDics.count < 1 && !splitView) {
        splitView = [[UIView alloc] initWithFrame:CGRectMake(0, 40, SCREEN_WIDTH, 1/[UIScreen mainScreen].scale)];
        splitView.tag = 1;
        splitView.backgroundColor = [UIColor colorFromHexCode:SPLITLINE_COLOR];
        [self.chargeViewTitleView addSubview:splitView];
    }
    
    [chargePersons removeAllObjects];
    [chargePersons addObjectsFromArray:persons];
    
    [personDics removeAllObjects];
    for (unsigned i = 0; i < persons.count; i++) {
        PersonEntity *person = (PersonEntity*)persons[i];
        [personDics setObject:person forKey:person.id];
    }
    
    for(UIView *subView in [personsView subviews])
    {
        [subView removeFromSuperview];
    }
    
    NSInteger ADDHEIGHT = persons.count*personHeight;
    
    CGRect newFrame2 = personsView.frame;
    newFrame2.size.height = ADDHEIGHT;
    [personsView setFrame:newFrame2];
    
    CGRect newFrame = self.personInChargeView.frame;
    newFrame.size.height = chargeTitleViewHeight+ADDHEIGHT;
    [self.personInChargeView setFrame:newFrame];
    //修改约束,防止滚动条滚动将view的的frame重置为storyboard重的设置值
    self.chargeViewHeightConstraint.constant = newFrame.size.height;
    self.scrollView.contentSize = CGSizeMake(SCREEN_WIDTH, scrollViewContentHeight+ADDHEIGHT);
    
    int j = 100;
    for (NSInteger i=0; i<persons.count; i++) {
        PersonEntity *person = persons[i];
        
        UIView *personView = [[UIView alloc] initWithFrame:CGRectMake(0, personHeight*i, SCREEN_WIDTH, personHeight)];
        
        UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 50, personHeight)];
        nameLabel.text = person.name;
        nameLabel.font = [UIFont systemFontOfSize:14];
        nameLabel.textColor = [UIColor colorFromHexCode:@"555555"];
        [personView addSubview:nameLabel];
        
        UIImageView *deleteView = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-30, 8, 14, 14)];
        deleteView.image = [UIImage imageNamed:@"delete"];
        UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(deletePerson:)];
        [deleteView addGestureRecognizer:gesture];
        [deleteView setUserInteractionEnabled:YES];
        deleteView.tag = j+i;
        [personView addSubview:deleteView];
        
        if (i!=persons.count-1) {
            UIView *splitView = [[UIView alloc] initWithFrame:CGRectMake(10, 30, SCREEN_WIDTH, 1/[UIScreen mainScreen].scale)];
            splitView.backgroundColor = [UIColor colorFromHexCode:SPLITLINE_COLOR];
            [personView addSubview:splitView];
        }
        
        [personsView addSubview:personView];
        
    }
}

- (void)deletePerson:(UITapGestureRecognizer *)recognizer
{
    if ([recognizer.view isKindOfClass:[UIImageView class]]) {
        UIImageView *imageView = (UIImageView *)recognizer.view;
        [chargePersons removeObjectAtIndex:imageView.tag-100];
        NSMutableArray *newPersons = [[NSMutableArray alloc] initWithArray:chargePersons];
        [self getSelectedPersons:newPersons];
    }
}

- (IBAction)releaseTask:(id)sender {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:nil];
    [alertController addAction:okAction];
    if (chargePersons.count<1) {
        alertController.message = @"请至少添加一位执行人！";
        [self presentViewController:alertController animated:YES completion:nil];
        return;
    }
    if ([self.startTimeBtn.titleLabel.text isEqualToString:startTimeBtnPlaceholder] || [self.endTimeBtn.titleLabel.text isEqualToString:endTimeBtnPlaceholder]) {
        alertController.message = @"请预估工作时间！";
        [self presentViewController:alertController animated:YES completion:nil];
        return;
    }
    
    UIAlertController *alertController2 = [UIAlertController alertControllerWithTitle:@"提示" message:@"确认派单？" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction2 = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //提交操作,在线
        NSLog(@"发布工单。。。。。。。。");
        
        [self.navigationController popViewControllerAnimated:YES];
    }];
    UIAlertAction *cancelAction2 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [alertController2 addAction:okAction2];
    [alertController2 addAction:cancelAction2];
    [self presentViewController:alertController2 animated:YES completion:nil];
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
