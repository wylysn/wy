//
//  ChoosePositionViewController.m
//  wy
//
//  Created by wangyilu on 16/9/1.
//  Copyright © 2016年 ___PURANG___. All rights reserved.
//

#import "ChoosePositionViewController.h"

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
    
    UIButton *confirmBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 60, 28)];
    confirmBtn.layer.cornerRadius = 3;
    confirmBtn.titleLabel.font = [UIFont fontWithName:@"System" size:15];
    confirmBtn.backgroundColor = [UIColor colorFromHexCode:@"FF6F55"];
    [confirmBtn setTitle:@"确定" forState:UIControlStateNormal];
    [confirmBtn addTarget:self action:@selector(confirmPosition) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *confirmItem = [[UIBarButtonItem alloc]
                                    initWithCustomView:confirmBtn];
    self.navigationItem.rightBarButtonItem = confirmItem;
    
    positionDics = [[NSMutableDictionary alloc] init];
    //最初显示第一级地址
    PositionEntity *parent = [[PositionEntity alloc] initWithDictionary:@{@"id":@0}];
    parent.level = 0;
    positionList = [[PositionDBservice getSharedInstance] findPositionsByParent:parent];
    for (PositionEntity *position in positionList) {
        position.level = 1;
        NSMutableArray *childArr = [[NSMutableArray alloc] initWithObjects:position, nil];
        [positionDics setObject:childArr forKey:@(position.ID)];
    }
}

- (void)confirmPosition {
    NSArray<NSIndexPath *> *indexPathsOfSelectedRows = [self.tableView indexPathsForSelectedRows];
    PositionEntity *position = [self getPostionByIndexPath:indexPathsOfSelectedRows[0]];
    if (position.childNum>0) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"请选择地址！" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:nil];
        [alertController addAction:okAction];
        [self presentViewController:alertController animated:YES completion:nil];
        return;
    }
    [self.navigationController popViewControllerAnimated:YES];
    
    if (_delegate && [_delegate respondsToSelector:@selector(showSelectedPositions:)]) {
        [_delegate showSelectedPositions:position];
    }
}

- (void)showPositionsWithParent:(PositionEntity *)parent andIndexPath:(NSIndexPath *)indexPath {
    NSArray *newPositionList = [[PositionDBservice getSharedInstance] findPositionsByParent:parent];
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    PositionEntity *headPosition = positionList[section];
    NSRange range = NSMakeRange(row+1, [newPositionList count]);
    NSIndexSet *indexSet = [NSIndexSet indexSetWithIndexesInRange:range];
    [(NSMutableArray *)positionDics[@(headPosition.ID)] insertObjects:newPositionList atIndexes:indexSet];
    
    [self.tableView reloadData];
}

- (void)hidePositionsWithParent:(PositionEntity *)parent andIndexPath:(NSIndexPath *)indexPath {
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    PositionEntity *headPosition = positionList[section];
    NSMutableArray *allChilds = (NSMutableArray *)positionDics[@(headPosition.ID)];

    NSInteger length=0;
    for (NSInteger i = row+1; i<allChilds.count; i++) {
        PositionEntity *position = allChilds[i];
        if (position.level>parent.level) {
            length += 1;
        } else {
            break;
        }
    }
    NSRange range = NSMakeRange(row+1, length);
    NSIndexSet *indexSet = [NSIndexSet indexSetWithIndexesInRange:range];
    [allChilds removeObjectsAtIndexes:indexSet];
    
    [self.tableView reloadData];
}

- (PositionEntity *)getPostionByIndexPath:(NSIndexPath *)indexPath {
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    PositionEntity *headPosition = positionList[section];
    NSArray *childPositions = (NSArray *)positionDics[@(headPosition.ID)];
    PositionEntity *position = childPositions[row];
    return position;
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
    NSArray *childPositions = (NSArray *)positionDics[@(position.ID)];
    return childPositions.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *CELLID = @"POSITIONIDENTITY1";
    PositionEntity *position = [self getPostionByIndexPath:indexPath];
    if (indexPath.row!=0) {
        CELLID = @"POSITIONIDENTITY2";
    }
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CELLID forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CELLID];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    UILabel *nameLabel = [cell viewWithTag:1];
    nameLabel.text = position.Name;
    for (int i=1; i<position.level; i++) {
        nameLabel.text = [NSString stringWithFormat:@"      %@", nameLabel.text];
    }
    UIImageView *imageView = [cell viewWithTag:2];
    if (position.childNum<1) {
        imageView.hidden = YES;
    } else {
        imageView.hidden = NO;
        if (position.hasChildDisplay) {
            imageView.image = [UIImage imageNamed:position.level>1?@"subarrow-down":@"arrow-down"];
        } else {
            imageView.image = [UIImage imageNamed:position.level>1?@"subarrow-left":@"arrow-right"];
        }
    }
    
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
    PositionEntity *position = [self getPostionByIndexPath:indexPath];
    if (position.childNum>0) {
        if (position.hasChildDisplay) {
            [self hidePositionsWithParent:position andIndexPath:indexPath];
            position.hasChildDisplay = NO;
        } else {
            [self showPositionsWithParent:position andIndexPath:indexPath];
            position.hasChildDisplay = YES;
        }
    } else {
        UILabel *nameLabel = [cell viewWithTag:1];
        nameLabel.textColor = [UIColor whiteColor];
        cell.backgroundColor = [UIColor colorFromHexCode:@"8dc351"];
    }
    
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    UILabel *nameLabel = [cell viewWithTag:1];
    NSString *color = @"555555";
    if (indexPath.row!=0) {
        color = @"999999";
    }
    nameLabel.textColor = [UIColor colorFromHexCode:color];
    cell.backgroundColor = [UIColor whiteColor];
}

@end
