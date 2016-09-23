//
//  ChoosePersonViewController.m
//  wy
//
//  Created by wangyilu on 16/8/15.
//  Copyright © 2016年 ___PURANG___. All rights reserved.
//

#define CELLID @"PERSONIDENTIFIER"

#import "ChoosePersonViewController.h"
#import "PersonDBService.h"
#import "PersonEntity.h"
#import "ChoosePersonTableViewCell.h"

@interface ChoosePersonViewController ()<UITableViewDataSource,UITableViewDelegate, UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *searchField;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation ChoosePersonViewController{
//    ChoosePersonService *personService;
    NSArray *personList;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIImageView *image1=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"search"]];
    image1.frame=CGRectMake(0, 0, 25, 25);
    self.searchField.leftView=image1;
    self.searchField.leftViewMode=UITextFieldViewModeAlways;
    self.searchField.delegate = self;
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    if (self.type == 2) {
        self.tableView.allowsMultipleSelection = TRUE;
    }
    
    personList = [[PersonDBService getSharedInstance] findAllPersons];
    
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
        PersonEntity *person = personList[indexPath.row];
        [personArr addObject:person];
    }
    [self.navigationController popViewControllerAnimated:YES];
    
    if (_delegate && [_delegate respondsToSelector:@selector(showSelectedPersons:withType:)]) {
        [_delegate showSelectedPersons:personArr withType:self.type];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return personList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ChoosePersonTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CELLID forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[ChoosePersonTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CELLID];
    }
    PersonEntity *person = personList[indexPath.row];
    cell.nameLabel.text = person.EmployeeName;
    cell.phoneLabel.text = person.Mobile;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    //已选中样式设置
    if (self.selectedPersonsDic[person.AppUserName]) {
        UIImage *image = [UIImage imageNamed:@"checkbox-checked"];
        [cell.checkImageView setImage:image];
        [self.tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
    }
        
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return CGFLOAT_MIN;//40;
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

/*
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
 */

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    personList = [[PersonDBService getSharedInstance] findPersonsByEmployeeName:textField.text];
    [self.searchField resignFirstResponder];
    [self.tableView reloadData];
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
