//
//  TaskXunjianBaseInfo2TableViewController.m
//  wy
//
//  Created by wangyilu on 16/9/8.
//  Copyright © 2016年 ___PURANG___. All rights reserved.
//

#import "TaskXunjianBaseInfo2TableViewController.h"

@interface TaskXunjianBaseInfo2TableViewController ()
{
    
}

@end

@implementation TaskXunjianBaseInfo2TableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewWillLayoutSubviews {
    NSArray<NSIndexPath *> *indexPaths = [self.tableView indexPathsForVisibleRows];
    for (NSIndexPath *indexPath in indexPaths) {
        NSInteger section = indexPath.section;
        if (section == 2) {
            UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
            UILabel *statusLabel = [cell viewWithTag:2];
            UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:statusLabel.bounds byRoundingCorners:(UIRectCornerTopLeft | UIRectCornerBottomLeft) cornerRadii:CGSizeMake(17.0, 17.0)];
            CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
            maskLayer.frame = statusLabel.bounds;
            maskLayer.path  = maskPath.CGPath;
            statusLabel.layer.mask = maskLayer;
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    } else if (section == 1) {
        return 4;
    } else if (section == 2) {
        return 4;   //变量,后面替换
    }
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 2) {
        UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 50)];
        header.backgroundColor = [UIColor whiteColor];
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, (50-21)/2, 200, 21)];
        titleLabel.text = @"DCS抄表";
        [header addSubview:titleLabel];
        UIImageView *openImageView = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-35, (50-25)/2, 25, 25)];
        openImageView.contentMode =  UIViewContentModeCenter;
        openImageView.image = [UIImage imageNamed:@"arrow-down"];
        UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(openRecord:)];
        [openImageView addGestureRecognizer:gesture];
        [openImageView setUserInteractionEnabled:YES];
        [header addSubview:openImageView];
        return header;
    }
    return nil;
}

- (void)openRecord:(UITapGestureRecognizer *)recognizer {
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 6;
    }
    if (section == 2) {
        return 50;
    }
    return CGFLOAT_MIN;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == 0 || section == 1) {
        return 6;
    }
    return CGFLOAT_MIN;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 90;
    }
    return 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    NSString *CELLID;
    if (section == 0) {
        CELLID = @"TITLEIDENTITY";
    } else if (section == 1) {
        CELLID = @"BASEIDENTITY";
    } else if (section == 2) {
        CELLID = @"PROBLEMIDENTITY";
    }
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CELLID forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CELLID];
    }
    
    if (section == 0) {
        UIView *dashLine1 = [cell viewWithTag:11];
        [self drawDashLine:dashLine1];
        UIView *dashLine2 = [cell viewWithTag:12];
        [self drawDashLine:dashLine2];
    } else if (section == 1) {
        UILabel *descLabel = [cell viewWithTag:1];
        UILabel *valueLabel = [cell viewWithTag:2];
        if (row == 0) {
            descLabel.text = @"巡检人员";
            valueLabel.text = @"叶雨";
        } else if (row == 1) {
            descLabel.text = @"巡检周期";
            valueLabel.text = @"1天";
        } else if (row == 2) {
            descLabel.text = @"计划时间";
            valueLabel.text = @"2016-09-20 12:00:00 - 2016-09-21 12:00:00";
        } else if (row == 3) {
            descLabel.text = @"实际实际";
            valueLabel.text = @"2016-09-20 12:00:00 - 2016-09-21 12:00:00";
        }
    } else if (section == 2) {
        UILabel *nameLabel = [cell viewWithTag:1];
        nameLabel.text = @"#1锅炉机组(00001)";
        UILabel *statusLabel = [cell viewWithTag:2];
        statusLabel.backgroundColor = [UIColor colorFromHexCode:@"FF6F55"];   //报修：009EDA 漏检：FF6F55 异常：F53D5A
        statusLabel.text = @"漏检";
        //必须在viewWillLayoutSubviews中去设置，否则不准
        /*
        UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:statusLabel.bounds byRoundingCorners:(UIRectCornerTopLeft | UIRectCornerBottomLeft) cornerRadii:CGSizeMake(17.0, 17.0)];
        CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
        maskLayer.frame = statusLabel.bounds;
        maskLayer.path  = maskPath.CGPath;
        statusLabel.layer.mask = maskLayer;
         */
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (void)drawDashLine:(UIView *)dashLine
{
    CAShapeLayer *shapelayer = [CAShapeLayer layer];
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(0.0, 1)];
    [path addLineToPoint:CGPointMake(0, dashLine.frame.size.height)];
    UIColor *fill = [UIColor colorWithRed:0.80f green:0.80f blue:0.80f alpha:1.00f];
    shapelayer.strokeStart = 0.0;
    shapelayer.strokeColor = fill.CGColor;
    shapelayer.lineWidth = 1.0;
    shapelayer.lineJoin = kCALineJoinRound;
    shapelayer.lineDashPattern = [NSArray arrayWithObjects:[NSNumber numberWithInt:2],[NSNumber numberWithInt:3 ], nil];
    shapelayer.path = path.CGPath;
    [dashLine.layer addSublayer:shapelayer];
}

@end
