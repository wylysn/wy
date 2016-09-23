//
//  TaskJiedanViewController.m
//  wy
//
//  Created by wangyilu on 16/8/16.
//  Copyright © 2016年 ___PURANG___. All rights reserved.
//

#import "TaskJiedanViewController.h"
#import "PersonEntity.h"

@interface TaskJiedanViewController ()

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *ct1;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *ct2;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *ct3;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *ct4;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *ct5;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *ct6;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *personInExcuteView;
@property (weak, nonatomic) IBOutlet UIView *excuteTitleView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *excuteViewHeightConstraint;

@end

@implementation TaskJiedanViewController {
    NSMutableArray *personsList;
    
    float personTitleViewHeight;
    float scrollViewContentHeight;
    int personHeight;
    
    NSMutableDictionary *excutePersonDics;
    UIView *excutePersonsView;
    NSMutableArray *excutePersons;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    float ht = 1.f/[UIScreen mainScreen].scale;
    self.ct1.constant = ht;
    self.ct2.constant = ht;
    self.ct3.constant = ht;
    self.ct4.constant = ht;
    self.ct5.constant = ht;
    self.ct6.constant = ht;
    
    personsList = [[NSMutableArray alloc] init];
    PersonEntity *p1 = [[PersonEntity alloc] initWithDictionary:@{@"id":@"P000000001",@"name":@"张三",@"phone":@"18621122732",@"isInCharge":@"1"}];
    PersonEntity *p2 = [[PersonEntity alloc] initWithDictionary:@{@"id":@"P000000002",@"name":@"李思思四",@"phone":@"18621122732",@"isInCharge":@"0"}];
    [personsList addObject:p1];
    [personsList addObject:p2];
    
    excutePersonDics = [[NSMutableDictionary alloc] init];
    excutePersons = [[NSMutableArray alloc] init];
    personTitleViewHeight = self.excuteTitleView.frame.size.height;
    personHeight = 30;
    scrollViewContentHeight = self.scrollView.contentSize.height;
    excutePersonsView = [[UIView alloc] initWithFrame:CGRectMake(0, personTitleViewHeight, SCREEN_WIDTH, 0)];
    [self.personInExcuteView addSubview:excutePersonsView];
    
    [self doExcutePerson:personsList];
}

- (void)doExcutePerson:(NSArray *)persons {
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
    
    for (NSInteger i=0; i<persons.count; i++) {
        PersonEntity *person = persons[i];
        
        UIView *personView = [[UIView alloc] initWithFrame:CGRectMake(0, personHeight*i, SCREEN_WIDTH, personHeight)];
        
        UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 80, personHeight)];
        nameLabel.text = person.EmployeeName;
        nameLabel.font = [UIFont systemFontOfSize:14];
        nameLabel.textColor = [UIColor colorFromHexCode:@"555555"];
        [personView addSubview:nameLabel];
        
        if ([person.isInCharge isEqualToString:@"1"]) {
            UIButton *chargeBtn = [[UIButton alloc] initWithFrame:CGRectMake(110, (personHeight-20)/2, 50, 20)];
            [chargeBtn setTitle:@"负责人" forState:UIControlStateNormal];
            chargeBtn.titleLabel.font = [UIFont systemFontOfSize:12];
            chargeBtn.tintColor = [UIColor whiteColor];
            chargeBtn.backgroundColor = [UIColor colorFromHexCode:@"7aff67"];
            chargeBtn.layer.cornerRadius = 3;
            [personView addSubview:chargeBtn];
        }
        
        
        UIButton *statusBtn = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-60, (personHeight-20)/2, 50, 20)];
        //暂时这么做，后面改条件判断
        [statusBtn setTitle:[person.isInCharge isEqualToString:@"1"]?@"已接单":@"未接单" forState:UIControlStateNormal];
        statusBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        statusBtn.tintColor = [UIColor whiteColor];
        statusBtn.backgroundColor = [UIColor redColor];
        statusBtn.layer.cornerRadius = 3;
        [personView addSubview:statusBtn];
        
        if (i!=persons.count-1) {
            UIView *splitView = [[UIView alloc] initWithFrame:CGRectMake(10, 30, SCREEN_WIDTH, 1/[UIScreen mainScreen].scale)];
            splitView.backgroundColor = [UIColor colorFromHexCode:SPLITLINE_COLOR];
            [personView addSubview:splitView];
        }
        
        [excutePersonsView addSubview:personView];
        
    }
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
