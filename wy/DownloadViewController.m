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
    BaseInfoEntity *file1 = [[BaseInfoEntity alloc] initWithDictionary:@{@"KeyId":@"1",@"Name":@"人员信息"}];
    BaseInfoEntity *file2 = [[BaseInfoEntity alloc] initWithDictionary:@{@"KeyId":@"2",@"Name":@"设备信息"}];
    file2.hasDownLoad = YES;
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
    //@"http://down.sandai.net/thunder9/Thunder9.0.14.358.exe";//http://down.sandai.net/xljiasu/XlaccSetup3.13.0.8950_jsqgw.exe
    NSURLSessionConfiguration * backgroundConfig = [NSURLSessionConfiguration backgroundSessionConfigurationWithIdentifier:identifier];
    
    NSURLSession *backgroundSeesion = [NSURLSession sessionWithConfiguration: backgroundConfig delegate:self delegateQueue: [NSOperationQueue mainQueue]];
    
    NSURLSessionDownloadTask * downloadTask =[backgroundSeesion downloadTaskWithURL:url];
    [downloadTask resume];
    NSLog(@"%@下载启动", identifier);
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
    
//    NSURL *originalURL = [[downloadTask originalRequest] URL];
//    NSURL *docsDirURL = [NSURL fileURLWithPath:[docsDir stringByAppendingPathComponent:[originalURL lastPathComponent]]];
    NSURL *originalURL = [[downloadTask originalRequest] URL];
    NSURL *docsDirURL = [NSURL fileURLWithPath:[docsDir stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.%@", [[session configuration] identifier], [originalURL pathExtension]]]];
    [fileManager removeItemAtURL:docsDirURL error:NULL];
    if ([fileManager moveItemAtURL:location toURL:docsDirURL error: &err])
    {
        NSLog(@"文件存储到 =%@",docsDirURL);
        NSFileManager* manager = [NSFileManager defaultManager];
        
        if ([manager fileExistsAtPath:[docsDir stringByAppendingPathComponent:[originalURL lastPathComponent]]]){
            
            float size = [[manager attributesOfItemAtPath:[docsDir stringByAppendingPathComponent:[originalURL lastPathComponent]] error:nil] fileSize]/(1024*1024);
            NSLog(@"文件大小：%f", size);
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
//下载完成
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
        UIButton *button = [cell viewWithTag:2];
        ((BaseInfoEntity *)[filesArray objectAtIndex:index]).hasDownLoad = YES;
        [button setTitle:@"已下载" forState:UIControlStateNormal];
    } else {
        UILabel *progressLabel = [cell viewWithTag:3];
        progressLabel.text = @"下载失败";
    }
    [task cancel];
}

#pragma mark - NSURLSessionDelegate
//后台运行必须要加的
- (void)URLSessionDidFinishEventsForBackgroundURLSession:(NSURLSession *)session
{
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    if (appDelegate.backgroundSessionCompletionHandler) {
        void (^completionHandler)() = appDelegate.backgroundSessionCompletionHandler;
        appDelegate.backgroundSessionCompletionHandler = nil;
        completionHandler();
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
