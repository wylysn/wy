//
//  ChoosePersonViewController.m
//  wy
//
//  Created by wangyilu on 16/8/15.
//  Copyright © 2016年 ___PURANG___. All rights reserved.
//

#define CELLID @"PERSONIDENTIFIER"

#import "ChoosePersonViewController.h"
#import "ChoosePersonService.h"
#import "PersonEntity.h"
#import "ChoosePersonTableViewCell.h"

@interface ChoosePersonViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITextField *searchField;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation ChoosePersonViewController{
    ChoosePersonService *personService;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIImageView *image1=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"search"]];
    image1.frame=CGRectMake(0, 0, 25, 25);
    self.searchField.leftView=image1;
    self.searchField.leftViewMode=UITextFieldViewModeAlways;
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    if (self.type == 2) {
        self.tableView.allowsMultipleSelection = TRUE;
    }
    
    personService = [[ChoosePersonService alloc] init];
    
    UIButton *confirmBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 60, 28)];
    confirmBtn.layer.cornerRadius = 3;
    confirmBtn.titleLabel.font = [UIFont fontWithName:@"System" size:15];
    confirmBtn.backgroundColor = [UIColor colorFromHexCode:@"FF6F55"];
    [confirmBtn setTitle:@"确定" forState:UIControlStateNormal];
    [confirmBtn addTarget:self action:@selector(confirmPerson) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *confirmItem = [[UIBarButtonItem alloc]
                                   initWithCustomView:confirmBtn];
    self.navigationItem.rightBarButtonItem = confirmItem;
}

- (void)confirmPerson {
    NSArray<NSIndexPath *> *indexPathsOfSelectedRows = [self.tableView indexPathsForSelectedRows];
    NSMutableArray *personArr = [[NSMutableArray alloc] init];
    for (NSIndexPath *indexPath in indexPathsOfSelectedRows) {
        PersonEntity *person = personService.deptsList[indexPath.section][@"persons"][indexPath.row];
        [personArr addObject:person];
    }
    [self.navigationController popViewControllerAnimated:YES];
    
    if (_delegate && [_delegate respondsToSelector:@selector(getSelectedPersons:withType:)]) {
        [_delegate getSelectedPersons:personArr withType:self.type];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return personService.deptsList.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *persons = personService.deptsList[section][@"persons"];
    return persons.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ChoosePersonTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CELLID forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[ChoosePersonTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CELLID];
    }
    NSArray *persons = personService.deptsList[indexPath.section][@"persons"];
    PersonEntity *person = persons[indexPath.row];
    cell.nameLabel.text = person.name;
    cell.phoneLabel.text = person.phone;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    //已选中样式设置
    if (self.selectedPersonsDic[person.id]) {
        UIImage *image = [UIImage imageNamed:@"checkbox-checked"];
        [cell.checkImageView setImage:image];
        [self.tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
    }
        
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 40;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 40;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    ChoosePersonTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    UIImage *image = [UIImage imageNamed:@"checkbox-checked"];
    [cell.checkImageView setImage:image];
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    ChoosePersonTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    UIImage *image = [UIImage imageNamed:@"checkbox-unchecked"];
    [cell.checkImageView setImage:image];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    int emptyViewWidth = 17;
    UIView *view = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, emptyViewWidth)];
    UIView *view1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, emptyViewWidth, 40)];
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(emptyViewWidth, 0, SCREEN_WIDTH-emptyViewWidth, 40)];
    [view addSubview:view1];
    [view addSubview:titleLabel];
    titleLabel.text = personService.deptsList[section][@"dept"];
    return view;
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
