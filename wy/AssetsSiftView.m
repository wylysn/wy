//
//  AssetsSiftView.m
//  wy
//
//  Created by 王益禄 on 16/10/7.
//  Copyright © 2016年 ___PURANG___. All rights reserved.
//

#import "AssetsSiftView.h"
#import "PositionEntity.h"
#import "PositionDBservice.h"

@implementation AssetsSiftView {
    
}

- (void)drawRect:(CGRect)rect {
    self.siftTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.contentView.frame.size.width, self.contentView.frame.size.height) style:UITableViewStyleGrouped];
    self.siftTableView.delegate=self;
    self.siftTableView.dataSource=self;
    self.siftTableView.backgroundColor = [UIColor whiteColor];
    self.siftTableView.scrollEnabled = YES;
    self.siftTableView.bounces = NO;
    self.siftTableView.allowsMultipleSelection = YES;
    if ([self.siftTableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.siftTableView setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([self.siftTableView respondsToSelector:@selector(setLayoutMargins:)])  {
        [self.siftTableView setLayoutMargins:UIEdgeInsetsZero];
    }
    [self.contentView addSubview:self.siftTableView];
    
    PositionEntity *parent = [[PositionEntity alloc] initWithDictionary:@{@"id":@0}];
    parent.level = 0;
    self.positionList = [[PositionDBservice getSharedInstance] findPositionsByParent:parent];;
    
    self.selectedlocationDic = [[NSMutableDictionary alloc] init];
    
    self.classListData = [NSArray arrayWithObjects:@"4",@"5",@"6",@"7", nil];
}

- (void)showPositionsWithParent:(PositionEntity *)parent andIndexPath:(NSIndexPath *)indexPath {
    NSArray *newPositionList = [[PositionDBservice getSharedInstance] findPositionsByParent:parent];
    NSInteger row = indexPath.row;
    NSRange range = NSMakeRange(row+1, [newPositionList count]);
    NSIndexSet *indexSet = [NSIndexSet indexSetWithIndexesInRange:range];
    [self.positionList insertObjects:newPositionList atIndexes:indexSet];
    
    [self.siftTableView reloadData];
}

- (void)hidePositionsWithParent:(PositionEntity *)parent andIndexPath:(NSIndexPath *)indexPath {
    NSInteger row = indexPath.row;
    PositionEntity *headPosition = self.positionList[row];
    NSRange range = NSMakeRange(row+1, headPosition.childNum);
    NSIndexSet *indexSet = [NSIndexSet indexSetWithIndexesInRange:range];
    [self.positionList removeObjectsAtIndexes:indexSet];
    
    [self.siftTableView reloadData];
}

- (PositionEntity *)getPostionByIndexPath:(NSIndexPath *)indexPath {
    NSInteger row = indexPath.row;
    PositionEntity *position = self.positionList[row];
    return position;
}

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return self.positionList.count;
    } else {
        return [self.classListData count];
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 120, 44)];
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, (44-21)/2, 100, 21)];
    NSString *title;
    if (section==0) {
        title = @"安装位置";
    } else if (section==1) {
        title = @"系统分类";
    }
    titleLabel.text = title;
    [header addSubview:titleLabel];
    return header;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 44)];
    header.backgroundColor = [UIColor groupTableViewBackgroundColor];
    return header;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *TableSampleIdentifier = @"TableSampleIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:TableSampleIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:TableSampleIdentifier];
    } else {
        while ([cell.contentView.subviews lastObject ]!=nil) {
            [(UIView*)[cell.contentView.subviews lastObject] removeFromSuperview];
        }
    }
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    if (section == 0) {
        float siftViewWidth = self.frame.size.width;
        PositionEntity *position = [self getPostionByIndexPath:indexPath];
        UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, (44-21)/2, siftViewWidth-20, 21)];
        nameLabel.tag = 1;
        nameLabel.font = [UIFont systemFontOfSize:16];
        nameLabel.text = position.Name;
        for (int i=1; i<position.level; i++) {
            nameLabel.text = [NSString stringWithFormat:@"      %@", nameLabel.text];
        }
        if (self.selectedlocationDic[position.Code]) {
            nameLabel.textColor = [UIColor whiteColor];
            cell.backgroundColor = [UIColor colorFromHexCode:@"8dc351"];
            [self.siftTableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
        } else {
            nameLabel.textColor = [UIColor colorFromHexCode:@"555555"];
            cell.backgroundColor = [UIColor whiteColor];
        }
        
        [cell.contentView addSubview:nameLabel];
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(siftViewWidth-17, (44-12)/2, 12, 12)];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        imageView.tag = 2;
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
        [cell.contentView addSubview:imageView];
    } else if(section == 1) {
        UILabel *label = [[UILabel alloc] initWithFrame:cell.contentView.frame];
        label.tag = 1;
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont systemFontOfSize:16];
        NSArray *tempArr;
        NSArray *tempListData;
        NSString *text;
        tempArr = self.classArr;
        tempListData = self.classListData;
        text = priorityDic[self.classListData[row]];
        if (!tempArr || tempArr.count<1 || [tempArr indexOfObject:tempListData[row]]==NSNotFound) {
            cell.selected = NO;
            [self.siftTableView deselectRowAtIndexPath:indexPath animated:NO];
            cell.backgroundColor = [UIColor clearColor];
            label.textColor = [UIColor colorFromHexCode:@"999999"];
        } else {
            cell.selected = YES;
            [self.siftTableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
            cell.backgroundColor = [UIColor colorFromHexCode:BUTTON_GREEN_COLOR];
            label.textColor = [UIColor whiteColor];
        }
        label.text = text;
        
        [cell.contentView addSubview:label];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 44;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == 0) {
        return 6;
    }
    return CGFLOAT_MIN;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [tableView setLayoutMargins:UIEdgeInsetsZero];
    }
    if ([tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        cell.preservesSuperviewLayoutMargins = NO;
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]){
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger section = indexPath.section;
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (section == 0) {
        PositionEntity *position = [self getPostionByIndexPath:indexPath];
        if (position.childNum>0) {
            if (position.hasChildDisplay) {
                [self hidePositionsWithParent:position andIndexPath:indexPath];
                position.hasChildDisplay = NO;
            } else {
                [self showPositionsWithParent:position andIndexPath:indexPath];
                position.hasChildDisplay = YES;
            }
            [self.siftTableView deselectRowAtIndexPath:indexPath animated:NO];
        } else {
            [self.selectedlocationDic setObject:position forKey:position.Code]; //非父节点才可以选中
            UILabel *nameLabel = [cell viewWithTag:1];
            
            nameLabel.textColor = [UIColor whiteColor];
            cell.backgroundColor = [UIColor colorFromHexCode:@"8dc351"];
        }
    } else {
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        cell.backgroundColor = [UIColor colorFromHexCode:BUTTON_GREEN_COLOR];
        UILabel *label = [cell viewWithTag:1];
        label.textColor = [UIColor whiteColor];
    }
    
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger section = indexPath.section;
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (section == 0) {
        PositionEntity *position = [self getPostionByIndexPath:indexPath];
        [self.selectedlocationDic removeObjectForKey:position.Code];
        UILabel *nameLabel = [cell viewWithTag:1];
        NSString *color = @"555555";
        nameLabel.textColor = [UIColor colorFromHexCode:color];
        cell.backgroundColor = [UIColor whiteColor];
    } else {
        cell.backgroundColor = [UIColor clearColor];
        UILabel *label = [cell viewWithTag:1];
        label.textColor = [UIColor colorFromHexCode:@"999999"];
    }
}

@end
