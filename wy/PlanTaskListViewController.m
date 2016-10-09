//
//  PlanTaskListViewController.m
//  wy
//
//  Created by wangyilu on 16/10/8.
//  Copyright © 2016年 ___PURANG___. All rights reserved.
//

#import "PlanTaskListViewController.h"
#import "PRActionSheetPickerView.h"
#import "PlanListEntity.h"
#import "PlanDetailViewController.h"

@interface PlanTaskListViewController ()<UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout, PRActionSheetPickerViewDelegate, UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *collectionViewHeightConstraint;
@property (weak, nonatomic) IBOutlet PRButton *dateBtn;
@property (weak, nonatomic) IBOutlet PRButton *unProgressBtn;
@property (weak, nonatomic) IBOutlet PRButton *progressBtn;
@property (weak, nonatomic) IBOutlet PRButton *doneBtn;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableViewheightConstraint;

@end

@implementation PlanTaskListViewController {
    float wh;
    UIWindow *window;
    NSDate *defaultDate;
    
    NSMutableArray *daysArr;
    NSMutableArray *planListArr;
    NSMutableDictionary *planListDic;
    NSMutableDictionary *planStatusDic;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    wh = (SCREEN_WIDTH-6)/7;
    self.collectionViewHeightConstraint.constant = SCREEN_WIDTH-wh;
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    planListArr = [[NSMutableArray alloc] init];
    daysArr = [[NSMutableArray alloc] init];
    defaultDate = [NSDate date];
    [self changeDateBtnText];
    [self refreshDataByDate];
}

- (IBAction)dateClick:(id)sender {
    window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    window.rootViewController = self;
    window.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.2];
    [window makeKeyAndVisible];
    
    PRActionSheetPickerView *pickerView = [[PRActionSheetPickerView alloc] init];
    pickerView.delegate = self;
    pickerView.defaultDate = [DateUtil formatDateString:defaultDate withFormatter:@"yyyy-MM-dd"];
    [pickerView showDatePickerInView:window withType:4 withBackId:3];
}

- (IBAction)preDateClick:(id)sender {
    defaultDate = [DateUtil addMonthDate:defaultDate withMonths:-1];
    [self changeDateBtnText];
    [self refreshDataByDate];
}

- (IBAction)nextDateClick:(id)sender {
    defaultDate = [DateUtil addMonthDate:defaultDate withMonths:1];
    [self changeDateBtnText];
    [self refreshDataByDate];
}

- (void)changeDateBtnText {
    NSString *title = [DateUtil formatDateString:defaultDate withFormatter:@"yyyy年MM月"];
    [self.dateBtn setTitle:title forState:UIControlStateNormal];
}

- (void)refreshDataByDate {
    [daysArr removeAllObjects];
    NSString *monthStr = [DateUtil formatDateString:defaultDate withFormatter:@"yyyy-MM"];
    
    NSString *startDateStr = [DateUtil formatDateString:defaultDate withFormatter:@"yyyy-MM-01"];
    NSString *endDateStr = [DateUtil getLastDateOfMonth:defaultDate];
    
    NSInteger days = [DateUtil getDaysOfMonth:defaultDate];
    NSDate *startDate = [DateUtil dateFromString:startDateStr withFormatter:@"yyyy-MM-dd"];
    NSDate *endDate = [DateUtil dateFromString:endDateStr withFormatter:@"yyyy-MM-dd"];
    
    NSInteger weekOfFirstDay = [DateUtil getWeekOfDay:startDate];
    NSInteger weekOfLastDay = [DateUtil getWeekOfDay:endDate];
    
    for (int i=1; i<=days; i++) {
        [daysArr addObject:[NSString stringWithFormat:@"%@-%@%d", monthStr, i<10?@"0":@"", i]];
    }
    //第一天不是周日,补上前一月的日期
    if (weekOfFirstDay!=1) {
        NSInteger addPreDays = weekOfFirstDay-1;
        for (int i=1; i<=addPreDays; i++) {
            NSString *preDateStr = [DateUtil formatDateString:[DateUtil addDayDate:startDate withDays:-i] withFormatter:@"yyyy-MM-dd"];
            [daysArr insertObject:preDateStr atIndex:0];
        }
    }
    //最后一天不是周六,补上后一月的日期
    if (weekOfLastDay!=7 || daysArr.count<=35) {
        NSInteger addNextDays = 7-weekOfLastDay;
        if (daysArr.count<=35) { //不满6行补一行
            addNextDays += 7;
        }
        for (int i=1; i<=addNextDays; i++) {
            NSString *nextDateStr = [DateUtil formatDateString:[DateUtil addDayDate:endDate withDays:i] withFormatter:@"yyyy-MM-dd"];
            [daysArr addObject:nextDateStr];
        }
    }
    [self.collectionView reloadData];
    
    //测试数据，后续删除
    [planListArr removeAllObjects];
    PlanListEntity *plan1 = [[PlanListEntity alloc] initWithDictionary:@{@"Code":@"1",@"Name":@"#1锅炉机组(00001)",@"ExecuteTime":@"2016-10-01",@"TaskStatus":@"1",@"GDCode":@"1"}];
    [planListArr addObject:plan1];
    PlanListEntity *plan2 = [[PlanListEntity alloc] initWithDictionary:@{@"Code":@"2",@"Name":@"#1锅炉机组",@"ExecuteTime":@"2016-10-01",@"TaskStatus":@"0",@"GDCode":@""}];
    [planListArr addObject:plan2];
    PlanListEntity *plan3 = [[PlanListEntity alloc] initWithDictionary:@{@"Code":@"3",@"Name":@"#1锅炉机组",@"ExecuteTime":@"2016-10-20",@"TaskStatus":@"1",@"GDCode":@"3"}];
    [planListArr addObject:plan3];
    PlanListEntity *plan4 = [[PlanListEntity alloc] initWithDictionary:@{@"Code":@"4",@"Name":@"#1锅炉机组",@"ExecuteTime":@"2016-10-21",@"TaskStatus":@"2",@"GDCode":@"4"}];
    [planListArr addObject:plan4];
    PlanListEntity *plan5 = [[PlanListEntity alloc] initWithDictionary:@{@"Code":@"5",@"Name":@"#1锅炉机组",@"ExecuteTime":@"2016-10-21",@"TaskStatus":@"1",@"GDCode":@"5"}];
    [planListArr addObject:plan5];
    
    planListDic = [[NSMutableDictionary alloc] init];
    for (PlanListEntity *plan in planListArr) {
        if (planListDic[plan.ExecuteTime]) {
            NSMutableArray *planArr = planListDic[plan.ExecuteTime];
            [planArr addObject:plan];
        } else {
            NSMutableArray *planArr = [[NSMutableArray alloc] init];
            [planArr addObject:plan];
            [planListDic setObject:planArr forKey:plan.ExecuteTime];
        }
    }
    [self.collectionView reloadData];
    
    [self changeStatusView];
    
    self.tableViewheightConstraint.constant = 44*planListArr.count;
    [self.tableView reloadData];
}

//更改状态
- (void)changeStatusView {
    planStatusDic = [[NSMutableDictionary alloc] init];
    for (PlanListEntity *plan in planListArr) {
        if (planStatusDic[plan.TaskStatus]) {
            NSMutableArray *planArr = planStatusDic[plan.TaskStatus];
            [planArr addObject:plan];
        } else {
            NSMutableArray *planArr = [[NSMutableArray alloc] init];
            [planArr addObject:plan];
            [planStatusDic setObject:planArr forKey:plan.TaskStatus];
        }
    }
    [self.unProgressBtn setTitle:[NSString stringWithFormat:@"未处理(%lu)", (unsigned long)((NSMutableArray *)planStatusDic[@"0"]).count] forState:UIControlStateNormal];
    [self.progressBtn setTitle:[NSString stringWithFormat:@"已处理(%lu)", (unsigned long)((NSMutableArray *)planStatusDic[@"1"]).count] forState:UIControlStateNormal];
    [self.doneBtn setTitle:[NSString stringWithFormat:@"已完成(%lu)", (unsigned long)((NSMutableArray *)planStatusDic[@"2"]).count] forState:UIControlStateNormal];
}

- (void)getDateWithDate:(NSDate *)date andId:(NSInteger)idNum {
    [self disMissBackView];//startTimeView
    if (idNum == 3) {
        defaultDate = date;
        NSString *title = [DateUtil formatDateString:date withFormatter:@"yyyy年MM月"];
        [self.dateBtn setTitle:title forState:UIControlStateNormal];
        
        [self refreshDataByDate];
    }
}

- (void)disMissBackView {
    window.hidden = YES;
    window.rootViewController = nil;
    window = nil;
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return daysArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = [indexPath row];
    static NSString* cellId = @"cellId";
    UICollectionViewCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellId forIndexPath:indexPath];
    if (cell == nil)
    {
        cell = [[UICollectionViewCell alloc]initWithFrame:CGRectMake(0, 0, 100, 100)];
    }
    
    UILabel *dayLabel = [cell viewWithTag:1];
    NSString *dateStr = daysArr[row];
    NSString *monthStr = [dateStr componentsSeparatedByString:@"-"][1];
    NSString *dayStr = [dateStr componentsSeparatedByString:@"-"][2];
    dayLabel.text = [@"0" isEqualToString:[dayStr substringToIndex:1]]?[dayStr substringFromIndex:1]:dayStr;
    NSString *defaultDateStr = [DateUtil formatDateString:defaultDate withFormatter:@"yyyy-MM-dd"];
    NSString *defaultMonthStr = [defaultDateStr componentsSeparatedByString:@"-"][1];
    if ([monthStr isEqualToString:defaultMonthStr]) {
        dayLabel.textColor = [UIColor colorFromHexCode:@"555555"];
    } else {
        dayLabel.textColor = [UIColor colorFromHexCode:@"999999"];
    }
    
    NSMutableArray *planArr = planListDic[dateStr];
    UILabel *tasknumLabel = [cell viewWithTag:2];
    if (planArr && planArr.count>0) {
        tasknumLabel.hidden = NO;
        tasknumLabel.text = [NSString stringWithFormat:@"%ld", planArr.count];
    } else {
        tasknumLabel.hidden = YES;
    }
    
    return cell;
}


#pragma mark - collectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = indexPath.row;
    planListArr = planListDic[daysArr[row]];
    UICollectionViewCell *cell = [self.collectionView cellForItemAtIndexPath:indexPath];
    cell.backgroundColor = [UIColor colorFromHexCode:@"f1f1f1"];
    
    [self changeStatusView];
    
    self.tableViewheightConstraint.constant = 44*planListArr.count;
    [self.tableView reloadData];
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [self.collectionView cellForItemAtIndexPath:indexPath];
    cell.backgroundColor = [UIColor whiteColor];
}

#pragma mark - UICollectionViewDelegateFlowLayout

//定义每个UICollectionView 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(wh, wh);
}

//定义每个UICollectionView 的 margin
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(CGFLOAT_MIN, CGFLOAT_MIN, CGFLOAT_MIN, CGFLOAT_MIN);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 1;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 1;
}

#pragma mark - UITableViewDataSource, UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return planListArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger row = indexPath.row;
    NSString *CELLID = @"PLANLISTCELL";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CELLID forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CELLID];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    PlanListEntity *plan = planListArr[row];
    UILabel *nameLabel = [cell viewWithTag:1];
    nameLabel.text = plan.Name;
    
    UILabel *typeLabel = [cell viewWithTag:2];
    if ([plan.GDCode isBlankString]) {
        typeLabel.hidden = YES;
    } else {
        typeLabel.hidden = NO;
    }
    
    UILabel *statusLabel = [cell viewWithTag:3];
    if ([@"0" isEqualToString:plan.TaskStatus]) {
        statusLabel.text = @"未开始";
        statusLabel.backgroundColor = [UIColor colorFromHexCode:@"ee5162"];
    } else if ([@"1" isEqualToString:plan.TaskStatus]) {
        statusLabel.text = @"处理中";
        statusLabel.backgroundColor = [UIColor colorFromHexCode:@"3dace1"];
    } else if ([@"2" isEqualToString:plan.TaskStatus]) {
        statusLabel.text = @"已完成";
        statusLabel.backgroundColor = [UIColor colorFromHexCode:@"8dc351"];
    }
    
    UILabel *timeLabel = [cell viewWithTag:4];
    timeLabel.text = plan.ExecuteTime;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger row = indexPath.row;
    PlanListEntity *plan = planListArr[row];
    UIStoryboard* featureSB = [UIStoryboard storyboardWithName:@"Feature" bundle:[NSBundle mainBundle]];
    PlanDetailViewController *planDetailViewController = [featureSB instantiateViewControllerWithIdentifier:@"PLANDETAIL"];
    planDetailViewController.Code = plan.Code;
    [self.navigationController pushViewController:planDetailViewController animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
