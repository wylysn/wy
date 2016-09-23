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

@property (weak, nonatomic) IBOutlet UILabel *descLabel;
@property (weak, nonatomic) IBOutlet UIButton *startTimeBtn;
@property (weak, nonatomic) IBOutlet UIButton *endTimeBtn;
@property (weak, nonatomic) IBOutlet UILabel *timeDiffLabel;

@property (weak, nonatomic) IBOutlet UIView *personInExcuteView;
@property (weak, nonatomic) IBOutlet UIView *excuteTitleView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *excuteViewHeightConstraint;

@property (weak, nonatomic) IBOutlet UIView *personInChargeView;
@property (weak, nonatomic) IBOutlet UIView *chargeTitleView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *chargeViewHeightConstraint;


@end

@implementation TaskPaiGongViewController {
    UIWindow *window;
    NSInteger btnTag;
    NSInteger addTimes;
    
    float personTitleViewHeight;
    float scrollViewContentHeight;
    int personHeight;
    
    NSMutableDictionary *excutePersonDics;
    UIView *excutePersonsView;
    NSMutableArray *excutePersons;
    
    NSMutableDictionary *chargePersonDics;
    UIView *chargePersonsView;
    NSMutableArray *chargePersons;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.navigationItem setTitle:@"派工"];
    
    float ht = 1.f/[UIScreen mainScreen].scale;
    self.ct1.constant = ht;
    self.ct2.constant = ht;
    self.ct3.constant = ht;
    self.ct4.constant = ht;
    self.ct5.constant = ht;
    self.ct6.constant = ht;
    self.ct8.constant = ht;
    
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"派工" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.backBarButtonItem = backButton;
    
    chargePersonDics = [[NSMutableDictionary alloc] init];
    chargePersons = [[NSMutableArray alloc] init];
    excutePersonDics = [[NSMutableDictionary alloc] init];
    excutePersons = [[NSMutableArray alloc] init];
    
    personTitleViewHeight = self.excuteTitleView.frame.size.height;
    personHeight = 30;
    scrollViewContentHeight = self.scrollView.contentSize.height;
    chargePersonsView = [[UIView alloc] initWithFrame:CGRectMake(0, personTitleViewHeight, SCREEN_WIDTH, 0)];
    [self.personInChargeView addSubview:chargePersonsView];
    excutePersonsView = [[UIView alloc] initWithFrame:CGRectMake(0, personTitleViewHeight, SCREEN_WIDTH, 0)];
    [self.personInExcuteView addSubview:excutePersonsView];
    
    self.descLabel.text = @"定义一个父类FatherViewController 和一个子类SonViewController，其中子类继承父类";
//    CGRect newbaseFrame = self.baseInfoView.frame;
//    CGFloat labelHeight = [self.descLabel sizeThatFits:CGSizeMake(self.descLabel.frame.size.width, MAXFLOAT)].height;
//    newbaseFrame.size.height += (labelHeight-21);
//    [self.baseInfoView setFrame:newbaseFrame];
//    self.baseInfoHeightConstraint.constant = newbaseFrame.size.height;
//    CGFloat labelHeight = [self.descLabel sizeThatFits:CGSizeMake(self.descLabel.frame.size.width, MAXFLOAT)].height;
//    CGRect newFrame = self.descLabel.frame;
//    CGFloat oldLabelHeight = newFrame.size.height;
//    CGFloat diffHeight = labelHeight-oldLabelHeight;
//    newFrame.size.height = labelHeight;
//    self.descLabel.frame = newFrame;
//    self.descLabel.backgroundColor = [UIColor redColor];
    
//    self.descLabel
    
//    NSNumber *count = @((labelHeight) / self.descLabel.font.lineHeight);
//    NSLog(@"共 %td 行", [count integerValue]);
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
    [pickerView showDatePickerInView:window withType:UIDatePickerModeDateAndTime withBackId:1];
    
    
}

- (void)getDateWithDate:(NSDate *)date andId:(NSInteger)idNum {
    [self disMissBackView];
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
        self.timeDiffLabel.text = [NSString stringWithFormat:@"%ld", (long)df];
    }
}

- (void)toChoosePerson:(int)type {
    UIStoryboard* taskSB = [UIStoryboard storyboardWithName:@"Task" bundle:[NSBundle mainBundle]];
    ChoosePersonViewController *choosePersonViewController = [taskSB instantiateViewControllerWithIdentifier:@"CHOOSEPERSON"];
    choosePersonViewController.delegate = self;
    choosePersonViewController.type = type;
    if (type==1) {
        choosePersonViewController.selectedPersonsDic = chargePersonDics;
    } else {
        choosePersonViewController.selectedPersonsDic = excutePersonDics;
    }
    [self.navigationController pushViewController:choosePersonViewController animated:YES];
}
    

- (IBAction)addPersonInCharge:(id)sender {
    [self toChoosePerson:1];
}
- (IBAction)addPersonInExcute:(id)sender {
    [self toChoosePerson:2];
}

- (void)disMissBackView {
    window.hidden = YES;
    window.rootViewController = nil;
    window = nil;
}

- (void)getSelectedPersons:(NSArray *)persons withType:(int)type {
    if (type == 1) {
        [self doChargePersons:persons];
    } else {
        [self doExcutePersons:persons];
    }
}

- (void)doChargePersons:(NSArray *)persons {
    UIView *splitView = [self.chargeTitleView viewWithTag:1];
    if (chargePersonDics.count < 1 && !splitView) {
        splitView = [[UIView alloc] initWithFrame:CGRectMake(0, 40, SCREEN_WIDTH, 1/[UIScreen mainScreen].scale)];
        splitView.tag = 1;
        splitView.backgroundColor = [UIColor colorFromHexCode:SPLITLINE_COLOR];
        [self.chargeTitleView addSubview:splitView];
    }
    
    [chargePersons removeAllObjects];
    [chargePersons addObjectsFromArray:persons];
    
    [chargePersonDics removeAllObjects];
    for (unsigned i = 0; i < persons.count; i++) {
        PersonEntity *person = (PersonEntity*)persons[i];
        [chargePersonDics setObject:person forKey:person.AppUserName];
    }
    
    for(UIView *subView in [chargePersonsView subviews])
    {
        [subView removeFromSuperview];
    }
    
    NSInteger ADDHEIGHT = persons.count*personHeight;
    
    CGRect newFrame2 = chargePersonsView.frame;
    newFrame2.size.height = ADDHEIGHT;
    [chargePersonsView setFrame:newFrame2];
    
    CGRect newFrame = self.personInChargeView.frame;
    newFrame.size.height = personTitleViewHeight+ADDHEIGHT;
    [self.personInChargeView setFrame:newFrame];
    //修改约束,防止滚动条滚动将view的的frame重置为storyboard重的设置值
    self.chargeViewHeightConstraint.constant = newFrame.size.height;
    self.scrollView.contentSize = CGSizeMake(SCREEN_WIDTH, scrollViewContentHeight+ADDHEIGHT);
    
    int j = 100;
    for (NSInteger i=0; i<persons.count; i++) {
        PersonEntity *person = persons[i];
        
        UIView *personView = [[UIView alloc] initWithFrame:CGRectMake(0, personHeight*i, SCREEN_WIDTH, personHeight)];
        
        UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 80, personHeight)];
        nameLabel.text = person.EmployeeName;
        nameLabel.font = [UIFont systemFontOfSize:14];
        nameLabel.textColor = [UIColor colorFromHexCode:@"555555"];
        [personView addSubview:nameLabel];
        
        UIImageView *deleteView = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-30, 8, 14, 14)];
        deleteView.image = [UIImage imageNamed:@"delete"];
        UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(deleteChargePerson:)];
        [deleteView addGestureRecognizer:gesture];
        [deleteView setUserInteractionEnabled:YES];
        deleteView.tag = j+i;
        [personView addSubview:deleteView];
        
        if (i!=persons.count-1) {
            UIView *splitView = [[UIView alloc] initWithFrame:CGRectMake(10, 30, SCREEN_WIDTH, 1/[UIScreen mainScreen].scale)];
            splitView.backgroundColor = [UIColor colorFromHexCode:SPLITLINE_COLOR];
            [personView addSubview:splitView];
        }
        
        [chargePersonsView addSubview:personView];
        
    }
}

- (void)doExcutePersons:(NSArray *)persons {
    UIView *splitView = [self.excuteTitleView viewWithTag:1];
    if (excutePersonDics.count < 1 && !splitView) {
        splitView = [[UIView alloc] initWithFrame:CGRectMake(0, 40, SCREEN_WIDTH, 1/[UIScreen mainScreen].scale)];
        splitView.tag = 1;
        splitView.backgroundColor = [UIColor colorFromHexCode:SPLITLINE_COLOR];
        [self.excuteTitleView addSubview:splitView];
    }
    
    [excutePersons removeAllObjects];
    [excutePersons addObjectsFromArray:persons];
    
    [excutePersonDics removeAllObjects];
    for (unsigned i = 0; i < persons.count; i++) {
        PersonEntity *person = (PersonEntity*)persons[i];
        [excutePersonDics setObject:person forKey:person.AppUserName];
    }
    
    for(UIView *subView in [excutePersonsView subviews])
    {
        [subView removeFromSuperview];
    }
    
    NSInteger ADDHEIGHT = persons.count*personHeight;
    
    CGRect newFrame2 = excutePersonsView.frame;
    newFrame2.size.height = ADDHEIGHT;
    [excutePersonsView setFrame:newFrame2];
    
    CGRect newFrame = self.personInExcuteView.frame;
    newFrame.size.height = personTitleViewHeight+ADDHEIGHT;
    [self.personInExcuteView setFrame:newFrame];
    //修改约束,防止滚动条滚动将view的的frame重置为storyboard重的设置值
    self.excuteViewHeightConstraint.constant = newFrame.size.height;
    self.scrollView.contentSize = CGSizeMake(SCREEN_WIDTH, scrollViewContentHeight+ADDHEIGHT);
    
    int j = 100;
    for (NSInteger i=0; i<persons.count; i++) {
        PersonEntity *person = persons[i];
        
        UIView *personView = [[UIView alloc] initWithFrame:CGRectMake(0, personHeight*i, SCREEN_WIDTH, personHeight)];
        
        UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 80, personHeight)];
        nameLabel.text = person.EmployeeName;
        nameLabel.font = [UIFont systemFontOfSize:14];
        nameLabel.textColor = [UIColor colorFromHexCode:@"555555"];
        [personView addSubview:nameLabel];
        
        UIImageView *deleteView = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-30, 8, 14, 14)];
        deleteView.image = [UIImage imageNamed:@"delete"];
        UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(deleteExcutePerson:)];
        [deleteView addGestureRecognizer:gesture];
        [deleteView setUserInteractionEnabled:YES];
        deleteView.tag = j+i;
        [personView addSubview:deleteView];
        
        if (i!=persons.count-1) {
            UIView *splitView = [[UIView alloc] initWithFrame:CGRectMake(10, 30, SCREEN_WIDTH, 1/[UIScreen mainScreen].scale)];
            splitView.backgroundColor = [UIColor colorFromHexCode:SPLITLINE_COLOR];
            [personView addSubview:splitView];
        }
        
        [excutePersonsView addSubview:personView];
        
    }
}

- (void)deleteChargePerson:(UITapGestureRecognizer *)recognizer
{
    if ([recognizer.view isKindOfClass:[UIImageView class]]) {
        UIImageView *imageView = (UIImageView *)recognizer.view;
        [chargePersons removeObjectAtIndex:imageView.tag-100];
        NSMutableArray *newPersons = [[NSMutableArray alloc] initWithArray:chargePersons];
        [self getSelectedPersons:newPersons withType:1];
    }
}

- (void)deleteExcutePerson:(UITapGestureRecognizer *)recognizer
{
    if ([recognizer.view isKindOfClass:[UIImageView class]]) {
        UIImageView *imageView = (UIImageView *)recognizer.view;
        [excutePersons removeObjectAtIndex:imageView.tag-100];
        NSMutableArray *newPersons = [[NSMutableArray alloc] initWithArray:excutePersons];
        [self getSelectedPersons:newPersons withType:2];
    }
}

- (IBAction)releaseTask:(id)sender {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:nil];
    [alertController addAction:okAction];
    if (excutePersons.count<1) {
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
