//
//  WorkOrderSiftView.m
//  wy
//
//  Created by 王益禄 on 16/9/12.
//  Copyright © 2016年 ___PURANG___. All rights reserved.
//

#import "WorkOrderSiftView.h"

@implementation WorkOrderSiftView

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    self.siftTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.contentView.frame.size.width, self.contentView.frame.size.height) style:UITableViewStyleGrouped];
    self.siftTableView.delegate=self;
    self.siftTableView.dataSource=self;
    self.siftTableView.backgroundColor = [UIColor whiteColor];
    self.siftTableView.scrollEnabled = FALSE;
    self.siftTableView.allowsMultipleSelection = YES;
    if ([self.siftTableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.siftTableView setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([self.siftTableView respondsToSelector:@selector(setLayoutMargins:)])  {
        [self.siftTableView setLayoutMargins:UIEdgeInsetsZero];
    }
    [self.contentView addSubview:self.siftTableView];
    
    self.priorityListData = [NSArray arrayWithObjects:@"1",@"2",@"3",@"4", nil];
    self.taskStatusListData = [NSArray arrayWithObjects:@"4",@"5",@"6",@"7", nil];
}

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return self.taskStatusListData.count;
    } else {
        return [self.priorityListData count];
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 120, 44)];
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, (44-21)/2, 100, 21)];
    NSString *title;
    if (section==0) {
        title = @"工单状态";
    } else if (section==1) {
        title = @"优先级";
    }
    titleLabel.text = title;
    titleLabel.textColor = [UIColor colorFromHexCode:@"555555"];
    [header addSubview:titleLabel];
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
            [(UIView*)[cell.contentView.subviews lastObject]removeFromSuperview];
        }
    }
    NSUInteger section = [indexPath section];
    NSUInteger row = [indexPath row];
    UILabel *label = [[UILabel alloc] initWithFrame:cell.contentView.frame];
    label.tag = 1;
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:16];
    NSArray *tempArr;
    NSArray *tempListData;
    NSString *text;
    if (section==0) {
        tempArr = self.taskStatusArr;
        tempListData = self.taskStatusListData;
        text = taskStatusDic[self.taskStatusListData[row]];
    } else if (section==1) {
        tempArr = self.priorityArr;
        tempListData = self.priorityListData;
        text = priorityDic[self.priorityListData[row]];
    }
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
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 44;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
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
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.backgroundColor = [UIColor colorFromHexCode:BUTTON_GREEN_COLOR];
    UILabel *label = [cell viewWithTag:1];
    label.textColor = [UIColor whiteColor];
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.backgroundColor = [UIColor clearColor];
    UILabel *label = [cell viewWithTag:1];
    label.textColor = [UIColor colorFromHexCode:@"999999"];
}

@end
