//
//  KnowledgeViewController.m
//  wy
//
//  Created by wangyilu on 16/8/31.
//  Copyright © 2016年 ___PURANG___. All rights reserved.
//

#import "KnowledgeViewController.h"
#import "KnowledgeEntity.h"
#import "KnowledgeDBService.h"

#define CELLID @"KNOWLEDGEIDENTIFIER"

@interface KnowledgeViewController ()<UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *searchField;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation KnowledgeViewController {
    NSArray *knowledgeList;
    NSString *keyWord;
    UIView *noDataView;
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

    knowledgeList = [[NSArray alloc] init];
    
}

- (void)viewDidAppear:(BOOL)animated {
    CGRect tableFrame = self.tableView.frame;
    float tableWidth = tableFrame.size.width;
    float tableHeight = tableFrame.size.height;
    noDataView = [[UIView alloc] initWithFrame:tableFrame];
    UIView *noView = [[UIView alloc] initWithFrame:CGRectMake((tableWidth-100)/2, (tableHeight-100)/2, 100, 100)];
    UIImageView *nodataImage = [[UIImageView alloc] initWithFrame:CGRectMake((100-65)/2, 0, 65, 57)];
    nodataImage.image = [UIImage imageNamed:@"nodata"];
    [noView addSubview:nodataImage];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 70, 100, 21)];
    label.text = @"暂无检索数据";
    label.font = [UIFont systemFontOfSize:15];
    label.textColor = [UIColor darkGrayColor];
    label.textAlignment = NSTextAlignmentCenter;
    [noView addSubview:label];
    
    [noDataView addSubview:noView];
    
    [self.view addSubview:noDataView];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return knowledgeList.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CELLID forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CELLID];
    }
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    KnowledgeEntity *knowledge = knowledgeList[section];
    UILabel *keyLabel = [cell viewWithTag:1];
    UILabel *valueLabel = [cell viewWithTag:2];
    if (row == 0) {
        keyLabel.text = @"关键字";
        valueLabel.text = keyWord;
    } else if (row == 1) {
        keyLabel.text = @"内容";
        valueLabel.text = knowledge.content;
    } else if (row == 2) {
        keyLabel.text = @"来源项目";
        valueLabel.text = knowledge.source;
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 44;
    }
    return CGFLOAT_MIN;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 6;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 44)];
    if (section == 0) {
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, (44-21)/2, 200, 21)];
        titleLabel.text = @"检索结果";
        [header addSubview:titleLabel];
        return header;
    }
    return nil;
}

//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
//    return 61;
//}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    keyWord = textField.text;
    knowledgeList = [[KnowledgeDBService getSharedInstance] findKnowledgeByKeyword:textField.text];
    [self.searchField resignFirstResponder];
    noDataView.hidden = knowledgeList.count>0;
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
