//
//  ChoosePositionViewController.m
//  wy
//
//  Created by wangyilu on 16/9/1.
//  Copyright © 2016年 ___PURANG___. All rights reserved.
//

#import "ChoosePositionViewController.h"
#import "PositionEntity.h"
#import "PositionDBservice.h"

@interface ChoosePositionViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation ChoosePositionViewController {
    NSArray *positionList;
    NSMutableDictionary *positionDics;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    positionDics = [[NSMutableDictionary alloc] init];
    positionList = [[PositionDBservice getSharedInstance] findPositionsByParentId:0];
    [positionDics setObject:positionList forKey:@0];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return positionList.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    PositionEntity *position = positionList[section];
    NSArray *childPositions = (NSArray *)positionDics[@(position.id)];
    return childPositions.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *CELLID = @"POSITIONIDENTITY1";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CELLID forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CELLID];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
//    PositionEntity *position = positionList[indexPath.row];
    UILabel *nameLabel = [cell viewWithTag:1];
    nameLabel.text = @"上海儿童艺术中心";//position.Name;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return CGFLOAT_MIN;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 6;
}

//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
//    return 61;
//}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    UILabel *nameLabel = [cell viewWithTag:1];
    nameLabel.textColor = [UIColor whiteColor];
    cell.backgroundColor = [UIColor colorFromHexCode:@"8dc351"];
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    UILabel *nameLabel = [cell viewWithTag:1];
    nameLabel.textColor = [UIColor colorFromHexCode:@"555555"];
    cell.backgroundColor = [UIColor whiteColor];
}

@end
