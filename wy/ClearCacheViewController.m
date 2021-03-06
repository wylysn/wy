//
//  ClearCacheViewController.m
//  wy
//
//  Created by wangyilu on 16/9/7.
//  Copyright © 2016年 ___PURANG___. All rights reserved.
//

#import "ClearCacheViewController.h"
#import "BaseInfoEntity.h"
#import "PersonDBService.h"
#import "PositionDBservice.h"
#import "KnowledgeDBService.h"
#import "InspectionModelDBService.h"
#import "DeviceDBService.h"
#import "DeviceClassDBService.h"
#import "MaterialsDBService.h"
#import "ToolsDBService.h"

@interface ClearCacheViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation ClearCacheViewController {
    NSMutableArray *cacheArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    cacheArray = [[NSMutableArray alloc] init];
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSDictionary *downloadDic = [userDefaults objectForKey:@"downloads"];
    NSEnumerator *enumeratorObject = [downloadDic keyEnumerator];
    for (NSString *keyId in enumeratorObject) {
        NSDictionary *info = downloadDic[keyId];
        [cacheArray addObject:info];
    }
}

- (IBAction)checkAllClick:(id)sender {
    UIButton *checkAllBtn = (UIButton *)sender;
    checkAllBtn.selected = !checkAllBtn.selected;
    if (checkAllBtn.selected) {
        for (int i = 0; i < cacheArray.count; i ++) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:0];
            [self.tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
            UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
            UIButton *btn = [cell viewWithTag:3];
            btn.selected = YES;
        }
    } else  {
        for (int i = 0; i < cacheArray.count; i ++) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:0];
            [self.tableView deselectRowAtIndexPath:indexPath animated:NO];
            UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
            UIButton *btn = [cell viewWithTag:3];
            btn.selected = NO;
        }
    }
}

- (IBAction)deleteClick:(id)sender {
    NSArray *indexPathArr = [self.tableView indexPathsForSelectedRows];
    NSMutableIndexSet *idxSet = [[NSMutableIndexSet alloc] init];
    for (NSIndexPath *indexPath in indexPathArr) {
        NSInteger row = indexPath.row;
        [idxSet addIndex:row];
        NSDictionary *objDic = cacheArray[row];
        NSString *templateid = objDic[@"templateid"];
        NSString *dbName = objDic[@"dbName"];
        
        //删除缓存表
        NSFileManager *fileManager = [NSFileManager defaultManager];
        NSString *docsDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        NSString *filePath = [docsDir stringByAppendingPathComponent:dbName];
        NSURL *docsDirURL = [NSURL fileURLWithPath:filePath];
        [fileManager removeItemAtURL:docsDirURL error:NULL];
        
        //修改存储信息
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        NSDictionary *downloadDic = [userDefaults objectForKey:@"downloads"];
        NSMutableDictionary *newDic = [[NSMutableDictionary alloc] initWithDictionary:downloadDic];
        [newDic removeObjectForKey:templateid];
        [userDefaults setObject:newDic forKey:@"downloads"];
        [userDefaults synchronize];
        
        //清除dbservice单例
        if ([@"2" isEqualToString:templateid]) {
            [[PersonDBService getSharedInstance] setSharedInstanceNull];
        } else if ([@"3" isEqualToString:templateid]) {
            [[DeviceDBService getSharedInstance] setSharedInstanceNull];
        } else if ([@"4" isEqualToString:templateid]) {
            [[InspectionModelDBService getSharedInstance] setSharedInstanceNull];
        } else if ([@"5" isEqualToString:templateid]) {
            [[KnowledgeDBService getSharedInstance] setSharedInstanceNull];
        } else if ([@"6" isEqualToString:templateid]) {
            [[PositionDBservice getSharedInstance] setSharedInstanceNull];
        } else if ([@"7" isEqualToString:templateid]) {
            [[DeviceClassDBService getSharedInstance] setSharedInstanceNull];
        } else if ([@"8" isEqualToString:templateid]) {
            [[MaterialsDBService getSharedInstance] setSharedInstanceNull];
        } else if ([@"9" isEqualToString:templateid]) {
            [[ToolsDBService getSharedInstance] setSharedInstanceNull];
        }
    }
    [cacheArray removeObjectsAtIndexes:idxSet];
    [self.tableView reloadData];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return cacheArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return CGFLOAT_MIN;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 61;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *CELLID = @"CLEARIDENTIFIER";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CELLID forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CELLID];
    }
    NSInteger row = indexPath.row;
    NSDictionary *info = cacheArray[row];
    
    UILabel *nameLabel = [cell viewWithTag:1];
    nameLabel.text = info[@"Name"];
    
    UILabel *sizeLabel = [cell viewWithTag:2];
    sizeLabel.text = [NSString getFileSizeString:info[@"size"]];
    
    UIButton *check = [cell viewWithTag:3];
    check.selected = NO;
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    UIButton *btn = [cell viewWithTag:3];
    btn.selected = !btn.selected;
    
}

-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    UIButton *btn = [cell viewWithTag:3];
    btn.selected = !btn.selected;
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
