//
//  ChooseMaterialViewController.m
//  wy
//
//  Created by 王益禄 on 2016/10/23.
//  Copyright © 2016年 ___PURANG___. All rights reserved.
//

#import "ChooseMaterialViewController.h"
#import "MaterialsDBService.h"
#import "MaterialsEntity.h"

@interface ChooseMaterialViewController ()<UITableViewDataSource,UITableViewDelegate, UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *searchField;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation ChooseMaterialViewController {
    NSArray *materialList;
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
    self.tableView.allowsMultipleSelection = TRUE;
    
    materialList = [[MaterialsDBService getSharedInstance] findAllMaterials];
    
    UIButton *confirmBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 60, 28)];
    confirmBtn.layer.cornerRadius = 3;
    confirmBtn.titleLabel.font = [UIFont fontWithName:@"System" size:15];
    confirmBtn.backgroundColor = [UIColor colorFromHexCode:@"FF6F55"];
    [confirmBtn setTitle:@"确定" forState:UIControlStateNormal];
    [confirmBtn addTarget:self action:@selector(confirmMaterial) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *confirmItem = [[UIBarButtonItem alloc]
                                    initWithCustomView:confirmBtn];
    self.navigationItem.rightBarButtonItem = confirmItem;
}

- (void)confirmMaterial {
    NSArray<NSIndexPath *> *indexPathsOfSelectedRows = [self.tableView indexPathsForSelectedRows];
    NSMutableArray *materialArr = [[NSMutableArray alloc] init];
    for (NSIndexPath *indexPath in indexPathsOfSelectedRows) {
        MaterialsEntity *material = materialList[indexPath.row];
        if (self.selectedMaterialsDic[material.Code]) {
            material = self.selectedMaterialsDic[material.Code];
        } else {
            material.Number = 0;
        }
        [materialArr addObject:material];
    }
    [self.navigationController popViewControllerAnimated:YES];
    
    if (_delegate && [_delegate respondsToSelector:@selector(showSelectedMaterials:)]) {
        [_delegate showSelectedMaterials:materialArr];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return materialList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *CELLID = @"MATERIALIDENTIFIER";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CELLID forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CELLID];
    }
    MaterialsEntity *material = materialList[indexPath.row];
    UILabel *nameLabel = [cell viewWithTag:1];
    nameLabel.text = material.Name;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    //已选中样式设置
    if (self.selectedMaterialsDic[material.Code]) {
        UIImage *image = [UIImage imageNamed:@"checkbox-checked"];
        UIImageView *checkImageView = [cell viewWithTag:3];
        [checkImageView setImage:image];
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
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    UIImage *image = [UIImage imageNamed:@"checkbox-checked"];
    UIImageView *checkImageView = [cell viewWithTag:3];
    [checkImageView setImage:image];
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    UIImage *image = [UIImage imageNamed:@"checkbox-unchecked"];
    UIImageView *checkImageView = [cell viewWithTag:3];
    [checkImageView setImage:image];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    materialList = [[MaterialsDBService getSharedInstance] findMaterialsByName:textField.text];
    [self.searchField resignFirstResponder];
    [self.tableView reloadData];
    return YES;
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
