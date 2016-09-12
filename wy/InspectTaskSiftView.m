//
//  inspectTaskSiftView.m
//  wy
//
//  Created by wangyilu on 16/9/12.
//  Copyright © 2016年 ___PURANG___. All rights reserved.
//

#import "InspectTaskSiftView.h"

@implementation InspectTaskSiftView

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
    
    self.listData = [NSArray arrayWithObjects:@"1",@"2",@"3",@"4", nil];
    self.listLabelData = [NSArray arrayWithObjects:@"正常",@"异常",@"漏检",@"报修", nil];
}

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.listData count];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 120, 44)];
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, (44-21)/2, 100, 21)];
    titleLabel.text = @"点位状态";
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
    NSUInteger row = [indexPath row];
    UILabel *label = [[UILabel alloc] initWithFrame:cell.contentView.frame];
    label.tag = 1;
    label.textAlignment = NSTextAlignmentCenter;
    if (!self.positionStatusArr || self.positionStatusArr.count<1 || [self.positionStatusArr indexOfObject:self.listData[row]]==NSNotFound) {
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
    label.font = [UIFont systemFontOfSize:16];
    label.text = self.listLabelData[row];
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
