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

@interface DownloadViewController ()<UITableViewDataSource,UITableViewDelegate, NSURLSessionDelegate,NSURLSessionTaskDelegate,NSURLSessionDownloadDelegate,UIDocumentInteractionControllerDelegate>

@end

@implementation DownloadViewController {
    NSMutableArray *filesArray;
    NSMutableArray *keyIdArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    filesArray = [[NSMutableArray alloc] init];
    /*测试数据，后期删除*/
    BaseInfoEntity *file1 = [[BaseInfoEntity alloc] initWithDictionary:@{@"KeyId":@"1",@"Name":@"人员信息"}];
    BaseInfoEntity *file2 = [[BaseInfoEntity alloc] initWithDictionary:@{@"KeyId":@"2",@"Name":@"设备信息"}];
    BaseInfoEntity *file3 = [[BaseInfoEntity alloc] initWithDictionary:@{@"KeyId":@"3",@"Name":@"巡检模版"}];
    BaseInfoEntity *file4 = [[BaseInfoEntity alloc] initWithDictionary:@{@"KeyId":@"4",@"Name":@"知识库信息"}];
    BaseInfoEntity *file5 = [[BaseInfoEntity alloc] initWithDictionary:@{@"KeyId":@"5",@"Name":@"位置信息"}];
    [filesArray addObject:file1];
    [filesArray addObject:file2];
    [filesArray addObject:file3];
    [filesArray addObject:file4];
    [filesArray addObject:file5];
    
    keyIdArray = [[NSMutableArray alloc] init];
    [keyIdArray addObject:@"1"];
    [keyIdArray addObject:@"2"];
    [keyIdArray addObject:@"3"];
    [keyIdArray addObject:@"4"];
    [keyIdArray addObject:@"5"];
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSDictionary *downloadDic = [userDefaults objectForKey:@"downloads"];
    for (BaseInfoEntity *info in filesArray) {
        [keyIdArray addObject:info.KeyId];
        if ([downloadDic objectForKey:info.KeyId]) {
            info.hasDownLoad = YES;
        }
    }
    /*end*/
    
    ((AppDelegate *)[[UIApplication sharedApplication] delegate]).downloadViewController = self;
    self.completionHandlerDictionary = [NSMutableDictionary dictionaryWithCapacity:0];
}

- (void)viewDidAppear:(BOOL)animated {
    //刷新下载列表页面
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSDictionary *downloadDic = [userDefaults objectForKey:@"downloads"];
    for (BaseInfoEntity *info in filesArray) {
        [keyIdArray addObject:info.KeyId];
        if ([downloadDic objectForKey:info.KeyId]) {
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
    NSURL * url = [NSURL URLWithString:@"http://down.sandai.net/xljiasu/XlaccSetup3.13.0.8950_jsqgw.exe"];
    //http://down.sandai.net/xljiasu/XlaccSetup3.13.0.8950_jsqgw.exe
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
        [self downloadWithIdentifier:[NSString stringWithFormat:@"com.purang.%@", info.KeyId]];
    }
}

- (IBAction)downloadAll:(id)sender {
    for (BaseInfoEntity *info in filesArray) {
        if (!info.hasDownLoad) {
            NSInteger index = [keyIdArray indexOfObject:info.KeyId];
            //获取对应cell
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
            UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
            UILabel *progressLabel = [cell viewWithTag:3];
            progressLabel.text = @"等待下载";
            [self downloadWithIdentifier:[NSString stringWithFormat:@"com.purang.%@", info.KeyId]];
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
    NSURL *originalURL = [[downloadTask originalRequest] URL];
    NSString *filePath = [docsDir stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.%@", [[session configuration] identifier], [originalURL pathExtension]]];
    NSURL *docsDirURL = [NSURL fileURLWithPath:filePath];
    [fileManager removeItemAtURL:docsDirURL error:NULL];
    if ([fileManager moveItemAtURL:location toURL:docsDirURL error: &err])
    {
        NSLog(@"文件存储到 =%@",docsDirURL);
        NSFileManager* manager = [NSFileManager defaultManager];
        if ([manager fileExistsAtPath:filePath]){
            double size = (double)[[manager attributesOfItemAtPath:filePath error:nil] fileSize]/(double)(1024*1024);
            
            NSString *identifier = [[session configuration] identifier];
            NSArray *foo = [identifier componentsSeparatedByString: @"."];
            NSString *keyId = [foo lastObject];
            BaseInfoEntity *info = filesArray[[keyIdArray indexOfObject:keyId]];
            
            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
            NSDictionary *downloadDic = [userDefaults objectForKey:@"downloads"];
            NSMutableDictionary *newDic;
            if (downloadDic) {
                newDic = [[NSMutableDictionary alloc] initWithDictionary:downloadDic];
            } else {
                newDic = [[NSMutableDictionary alloc] init];
            }
            NSDictionary *objDic = @{@"KeyId":info.KeyId,@"Name":info.Name,@"size":[NSNumber numberWithDouble:size]};
            [newDic setObject:objDic forKey:keyId];
            [userDefaults setObject:newDic forKey:@"downloads"];
            [userDefaults synchronize];
            
            //写入到库操作，后面加上
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
        NSString *keyId = [foo lastObject];
        NSInteger index = [keyIdArray indexOfObject:keyId];
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
    NSString *keyId = [foo lastObject];
    NSInteger index = [keyIdArray indexOfObject:keyId];
    //获取对应cell
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    if (error == nil) {
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
