//
//  DownloadViewController.m
//  wy
//
//  Created by wangyilu on 16/9/6.
//  Copyright © 2016年 ___PURANG___. All rights reserved.
//

#import "DownloadViewController.h"
#import "AppDelegate.h"
#import "BaseInfoEntity.h"
#import "PersonEntity.h"
#import "PersonDBService.h"
#import "DeviceEntity.h"
#import "DeviceDBService.h"
#import "KnowledgeEntity.h"
#import "KnowledgeDBService.h"
#import "InspectionModelEntity.h"
#import "InspectionChildModelEntity.h"
#import "InspectionModelDBService.h"
#import "PositionEntity.h"
#import "PositionDBservice.h"

@interface DownloadViewController ()<UITableViewDataSource,UITableViewDelegate, NSURLSessionDelegate,NSURLSessionTaskDelegate,NSURLSessionDownloadDelegate,UIDocumentInteractionControllerDelegate>

@end

@implementation DownloadViewController {
    NSMutableArray *filesArray;
    NSMutableArray *templateidArray;
    
    NSMutableDictionary *downloadResultDic;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    filesArray = [[NSMutableArray alloc] init];
    /*测试数据，后期删除*/
    BaseInfoEntity *file1 = [[BaseInfoEntity alloc] initWithDictionary:@{@"templateid":@"2",@"Name":@"人员信息"}];
    BaseInfoEntity *file2 = [[BaseInfoEntity alloc] initWithDictionary:@{@"templateid":@"3",@"Name":@"设备信息"}];
    BaseInfoEntity *file3 = [[BaseInfoEntity alloc] initWithDictionary:@{@"templateid":@"4",@"Name":@"巡检模版"}];
    BaseInfoEntity *file4 = [[BaseInfoEntity alloc] initWithDictionary:@{@"templateid":@"5",@"Name":@"知识库信息"}];
    BaseInfoEntity *file5 = [[BaseInfoEntity alloc] initWithDictionary:@{@"templateid":@"6",@"Name":@"位置信息"}];
    [filesArray addObject:file1];
    [filesArray addObject:file2];
    [filesArray addObject:file3];
    [filesArray addObject:file4];
    [filesArray addObject:file5];
    
    templateidArray = [[NSMutableArray alloc] init];
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSDictionary *downloadDic = [userDefaults objectForKey:@"downloads"];
    for (BaseInfoEntity *info in filesArray) {
        [templateidArray addObject:info.templateid];
        if ([downloadDic objectForKey:info.templateid]) {
            info.hasDownLoad = YES;
        }
    }
    /*end*/
    
    downloadResultDic = [[NSMutableDictionary alloc] init];
    
    ((AppDelegate *)[[UIApplication sharedApplication] delegate]).downloadViewController = self;
    self.completionHandlerDictionary = [NSMutableDictionary dictionaryWithCapacity:0];
}

- (void)viewDidAppear:(BOOL)animated {
    //刷新下载列表页面
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSDictionary *downloadDic = [userDefaults objectForKey:@"downloads"];
    for (BaseInfoEntity *info in filesArray) {
        [templateidArray addObject:info.templateid];
        if ([downloadDic objectForKey:info.templateid]) {
            info.hasDownLoad = YES;
        } else {
            info.hasDownLoad = NO;
        }
    }
    [self.tableView reloadData];
    
    [self resetDownloadAllBtn];
}

/*一键下载状态重置*/
- (void)resetDownloadAllBtn {
    int noDownNum = 0;
    for (BaseInfoEntity *info in filesArray) {
        if (!info.hasDownLoad) {
            noDownNum += 1;
        }
    }
    if (noDownNum<1) {
        self.downloadAllBtn.enabled = FALSE;
        self.downloadAllBtn.backgroundColor = [UIColor colorFromHexCode:BUTTON_DARKGRAY_COLOR];
    } else {
        self.downloadAllBtn.enabled = TRUE;
        self.downloadAllBtn.backgroundColor = [UIColor colorFromHexCode:BUTTON_GREEN_COLOR];
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return filesArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return CGFLOAT_MIN;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *CELLID = @"DOWNLOADCELL";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CELLID forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CELLID];
    }
    NSInteger row = indexPath.row;
    BaseInfoEntity *info = filesArray[row];
    
    UILabel *nameLabel = [cell viewWithTag:1];
    nameLabel.text = info.Name;
    
    UIButton *button = [cell viewWithTag:2];
    [button setTitle:info.hasDownLoad?@"已下载":@"下载" forState:UIControlStateNormal];
    
    return cell;
}

- (void)downloadWithIdentifier:(NSString *)identifier {
    NSArray *foo = [identifier componentsSeparatedByString: @"."];
    NSString *templateid = [foo lastObject];
    NSString *urlString = [NSString stringWithFormat:@"%@?action=getformdatalist&tick=%@&imei=%@&templateid=%ld&start=1&pagesize=1000", [[URLManager getSharedInstance] getURL:@""], [DateUtil getCurrentTimestamp], [NSString getDeviceId], [templateid integerValue]];
    NSURL * url = [NSURL URLWithString:urlString];
    //http://down.sandai.net/xljiasu/XlaccSetup3.13.0.8950_jsqgw.exe
    //@"http://down.sandai.net/xljiasu/XlaccSetup3.13.0.8950_jsqgw.exe"
    NSURLSessionConfiguration * backgroundConfig = [NSURLSessionConfiguration backgroundSessionConfigurationWithIdentifier:identifier];
    
    NSURLSession *backgroundSeesion = [NSURLSession sessionWithConfiguration: backgroundConfig delegate:self delegateQueue: [NSOperationQueue mainQueue]];
    
    NSURLSessionDownloadTask *downloadTask =[backgroundSeesion downloadTaskWithURL:url];
    [downloadTask resume];
    NSLog(@"%@下载启动", identifier);
}

- (IBAction)downloadOne:(id)sender {
    UITableViewCell *cell = (UITableViewCell *)[[sender superview] superview];
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    BaseInfoEntity *info = filesArray[indexPath.row];
    if (!info.hasDownLoad) {
        UILabel *progressLabel = [cell viewWithTag:3];
        progressLabel.text = @"等待下载";
        [self downloadWithIdentifier:[NSString stringWithFormat:@"com.purang.%@", info.templateid]];
    }
}

- (IBAction)downloadAll:(id)sender {
    for (BaseInfoEntity *info in filesArray) {
        if (!info.hasDownLoad) {
            NSInteger index = [templateidArray indexOfObject:info.templateid];
            //获取对应cell
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
            UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
            UILabel *progressLabel = [cell viewWithTag:3];
            progressLabel.text = @"等待下载";
            [self downloadWithIdentifier:[NSString stringWithFormat:@"com.purang.%@", info.templateid]];
        }
    }
}

//前台下载的代理方法
-(void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didFinishDownloadingToURL:(NSURL *)location
{
    NSLog(@"Temporary File :%@\n", location);
    NSError *err = nil;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *docsDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
//    NSURL *originalURL = [[downloadTask originalRequest] URL];
    NSString *filePath = [docsDir stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.%@", [[session configuration] identifier], @"json"]];
    NSURL *docsDirURL = [NSURL fileURLWithPath:filePath];
    [fileManager removeItemAtURL:docsDirURL error:NULL];
    if ([fileManager moveItemAtURL:location toURL:docsDirURL error: &err])
    {
        NSLog(@"文件存储到 =%@",docsDirURL);
        NSFileManager* manager = [NSFileManager defaultManager];
        if ([manager fileExistsAtPath:filePath]){
            NSString *identifier = [[session configuration] identifier];
            NSArray *foo = [identifier componentsSeparatedByString: @"."];
            NSString *templateid = [foo lastObject];
            BaseInfoEntity *info = filesArray[[templateidArray indexOfObject:templateid]];
            
            //解析json，看是否success
            NSData *data=[NSData dataWithContentsOfFile:filePath];
            NSError *error;
            NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
//            NSDictionary *json = @{@"success":@0,@"message":@""};
            BOOL success = [(NSNumber *)json[@"success"] boolValue];
            if (error) {
                NSLog(@"解析失败--%@", error);
                NSInteger index = [templateidArray indexOfObject:templateid];
                //获取对应cell
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
                UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
                UILabel *progressLabel = [cell viewWithTag:3];
                progressLabel.text = @"解析失败";
                [downloadResultDic setObject:@"0" forKey:templateid];
            } else if (!success) {
                NSLog(@"请求失败--%@", json[@"message"]);
                NSInteger index = [templateidArray indexOfObject:templateid];
                //获取对应cell
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
                UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
                UILabel *progressLabel = [cell viewWithTag:3];
                progressLabel.text = @"请求失败";
                [downloadResultDic setObject:@"0" forKey:templateid];
            } else {
                unsigned long long size = (double)[[manager attributesOfItemAtPath:filePath error:nil] fileSize];
                //记录文件下载情况及文件大小
                NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
                NSDictionary *downloadDic = [userDefaults objectForKey:@"downloads"];
                NSMutableDictionary *newDic;
                if (downloadDic) {
                    newDic = [[NSMutableDictionary alloc] initWithDictionary:downloadDic];
                } else {
                    newDic = [[NSMutableDictionary alloc] init];
                }
                NSString *dbName;
                if ([@"2" isEqualToString:templateid]) {
                    dbName = @"wy-person.db";
                } else if ([@"3" isEqualToString:templateid]) {
                    dbName = @"wy-device.db";
                } else if ([@"4" isEqualToString:templateid]) {
                    dbName = @"wy-inspection.db";
                } else if ([@"5" isEqualToString:templateid]) {
                    dbName = @"wy-knowledge.db";
                } else if ([@"6" isEqualToString:templateid]) {
                    dbName = @"wy-position.db";
                }
                NSDictionary *objDic = @{@"templateid":info.templateid,@"Name":info.Name,@"size":[NSNumber numberWithDouble:size],@"dbName":dbName};
                [newDic setObject:objDic forKey:templateid];
                [userDefaults setObject:newDic forKey:@"downloads"];
                [userDefaults synchronize];
                
                //保存到库
                NSArray *dataArray = json[@"data"];
                for (NSDictionary *dic in dataArray) {
                    if ([@"2" isEqualToString:templateid]) {
                        PersonEntity *person = [[PersonEntity alloc] initWithDictionary:dic];
                        PersonDBService *dbService = [PersonDBService getSharedInstance];
                        [dbService saveData:person];
                    } else if ([@"3" isEqualToString:templateid]) {
                        DeviceEntity *device = [[DeviceEntity alloc] initWithDictionary:dic];
                        DeviceDBService *dbService = [DeviceDBService getSharedInstance];
                        [dbService saveDevice:device];
                    } else if ([@"4" isEqualToString:templateid]) {
                        InspectionModelEntity *model = [[InspectionModelEntity alloc] initWithDictionary:dic];
                        InspectionModelDBService *dbService = [InspectionModelDBService getSharedInstance];
                        [dbService saveInspectionModel:model];
                        NSArray *itemDicArray = dic[@"DetailList"];
                        for (NSDictionary *itemDic in itemDicArray) {
                            InspectionChildModelEntity *item = [[InspectionChildModelEntity alloc] initWithDictionary:itemDic];
                            item.ParentCode = model.Code;
                            [dbService saveInspectionChildModel:item];
                        }
                    } else if ([@"5" isEqualToString:templateid]) {
                        KnowledgeEntity *knowledge = [[KnowledgeEntity alloc] initWithDictionary:dic];
                        KnowledgeDBService *dbService = [KnowledgeDBService getSharedInstance];
                        [dbService saveKnowledge:knowledge];
                    } else if ([@"6" isEqualToString:templateid]) {
                        PositionEntity *position = [[PositionEntity alloc] initWithDictionary:dic];
                        PositionDBservice *dbService = [PositionDBservice getSharedInstance];
                        [dbService savePosition:position];
                    }
                }
                [downloadResultDic setObject:@"1" forKey:templateid];
            }
            
            [fileManager removeItemAtURL:docsDirURL error:NULL];
            
        }
    }
    else
    {
        NSLog(@"failed to move: %@",[err userInfo]);
    }
    
}

//下载进度
-(void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didWriteData:(int64_t)bytesWritten totalBytesWritten:(int64_t)totalBytesWritten totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite
{
    dispatch_async(dispatch_get_main_queue(), ^{
        NSString *identifier = [[session configuration] identifier];
        NSArray *foo = [identifier componentsSeparatedByString: @"."];
        NSString *templateid = [foo lastObject];
        NSInteger index = [templateidArray indexOfObject:templateid];
        //获取对应cell
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
        UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
        UILabel *progressLabel = [cell viewWithTag:3];
        double progress = ((double)totalBytesWritten/(double)totalBytesExpectedToWrite)*100;
        
        progressLabel.text = [NSString stringWithFormat:@"%.1f%%", progress];
    });
}

#pragma mark - NSURLSessionTaskDelegate
//下载完成 UI操作只能放这里，URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didFinishDownloadingToURL:(NSURL *)location不能操作UI
- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error
{
    NSString *identifier = [[session configuration] identifier];
    NSArray *foo = [identifier componentsSeparatedByString: @"."];
    NSString *templateid = [foo lastObject];
    NSInteger index = [templateidArray indexOfObject:templateid];
    //获取对应cell
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    if (error == nil && [@"1" isEqualToString:downloadResultDic[templateid]]) {
        UILabel *progressLabel = [cell viewWithTag:3];
        progressLabel.text = @"";//[NSString stringWithFormat:@"100.0%%"];
        UIButton *button = [cell viewWithTag:2];
        ((BaseInfoEntity *)[filesArray objectAtIndex:index]).hasDownLoad = YES;
        [button setTitle:@"已下载" forState:UIControlStateNormal];
    } else {
        UILabel *progressLabel = [cell viewWithTag:3];
        progressLabel.text = @"下载失败";
    }
    [self resetDownloadAllBtn];
    [session finishTasksAndInvalidate];
}
//
#pragma mark - NSURLSessionDelegate
//后台运行必须要加的
- (void)URLSessionDidFinishEventsForBackgroundURLSession:(NSURLSession *)session
{
    NSLog(@"Background URL session %@ finished events.\n", session);
    
    if (session.configuration.identifier)
        [self callCompletionHandlerForSession: session.configuration.identifier];
}

- (void) addCompletionHandler: (CompletionHandlerType) handler forSession: (NSString *)identifier
{
    if ([ self.completionHandlerDictionary objectForKey: identifier]) {
        NSLog(@"Error: Got multiple handlers for a single session identifier.  This should not happen.\n");
    }
    
    [ self.completionHandlerDictionary setObject:handler forKey: identifier];
}

- (void) callCompletionHandlerForSession: (NSString *)identifier
{
    CompletionHandlerType handler = [self.completionHandlerDictionary objectForKey: identifier];
    
    if (handler) {
        [self.completionHandlerDictionary removeObjectForKey: identifier];
        NSLog(@"Calling completion handler.\n");
        
        handler();
    }
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
