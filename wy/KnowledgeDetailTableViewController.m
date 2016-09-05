//
//  KnowledgeDetailTableViewController.m
//  wy
//
//  Created by 王益禄 on 16/8/31.
//  Copyright © 2016年 ___PURANG___. All rights reserved.
//

#import "KnowledgeDetailTableViewController.h"

@interface KnowledgeDetailTableViewController ()

@end

@implementation KnowledgeDetailTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //卧槽，这个太屌，ios8以上支持，折磨简单就解决以前很复杂的问题，帅气
    self.tableView.estimatedRowHeight = 44;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section==0) {
        return 1;
    }
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    NSString *CELLID;
    if (section==0) {
        CELLID = @"TITLEIDENTIFY";
    } else if(section==1) {
        if (row==0) {
            CELLID = @"CONTENTIDENTIFY2";
        } else {
            CELLID = @"CONTENTIDENTIFY1";
        }
    }
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CELLID forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CELLID];
    }
    
    if (section == 0) {
        UILabel *keywordLabel = [cell viewWithTag:1];
        keywordLabel.text = _keyword;
    } else if(section == 1) {
        if (row==0) {
            UITextView *textView = [cell viewWithTag:1];
            textView.text = _knowlwdge.Content;//@"这里是畅行中国合肥站（che.ah122.cn），秉承122交通网“交通安全、文明出行”的传统，为合肥送上本地权威汽车信息。这里有最权威汽车资讯";//
        } else {
            UILabel *keyLabel = [cell viewWithTag:1];
            UILabel *valueLabel = [cell viewWithTag:2];
            if(row==1) {
                keyLabel.text = @"来源项目";
                valueLabel.text = _knowlwdge.Lyxm;
            } else if(row==2) {
                keyLabel.text = @"录入人";
                valueLabel.text = _knowlwdge.createPerson;
            } else if(row==3) {
                keyLabel.text = @"录入时间";
                valueLabel.text = _knowlwdge.createTime;
            }
            
        }
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 44;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 44)];
    NSString *title;
    if (section == 0) {
        title = @"关键字";
    } else {
        title = @"内容";
    }
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, (44-21)/2, 200, 21)];
    titleLabel.text = title;
    [header addSubview:titleLabel];
    return header;
}

@end
