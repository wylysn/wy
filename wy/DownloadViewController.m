//
//  DownloadViewController.m
//  wy
//
//  Created by wangyilu on 16/9/6.
//  Copyright © 2016年 ___PURANG___. All rights reserved.
//

#import "DownloadViewController.h"
#import "AppDelegate.h"

@interface DownloadViewController ()<UITableViewDataSource,UITableViewDelegate, NSURLSessionDownloadDelegate>

@end

@implementation DownloadViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 8;
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
    
    return cell;
}



- (IBAction)downloadAll:(id)sender {
//    NSURLSessionConfiguration *sessionConfig =[NSURLSessionConfiguration backgroundSessionConfigurationWithIdentifier:@"com.purang.wy"];
//    NSURLSession *session =[NSURLSession sessionWithConfiguration:sessionConfig delegate:self delegateQueue:nil];
//    NSURLSessionDataTask *task = [session dataTaskWithURL:[NSURL URLWithString:[[URLManager getSharedInstance] getURL:URL_CALENDAR_LASTYEAR]]];
    
//    NSURLSessionConfiguration *sessionConfig =[NSURLSessionConfiguration defaultSessionConfiguration];
//
//    NSURLSession *session =[NSURLSession sessionWithConfiguration:sessionConfig
//                                                         delegate:self
//                                                    delegateQueue:nil];
//    NSURLSessionDownloadTask * task =[session downloadTaskWithURL:[NSURL URLWithString:@"http://img6.cache.netease.com/photo/0001/2016-09-06/C08AKTHD3R710001.jpg"]];
//    NSURLSessionDownloadTask * task =[session downloadTaskWithURL:[NSURL URLWithString:[[URLManager getSharedInstance] getURL:URL_CALENDAR_LASTYEAR]]];
//    NSURLSessionDataTask *task = [session dataTaskWithURL:[NSURL URLWithString:[[URLManager getSharedInstance] getURL:URL_CALENDAR_LASTYEAR]]
//                                            completionHandler:^(NSData *data,
//                                                                NSURLResponse *response,
//                                                                NSError *error) {
//                                                NSString *string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
//                                                NSLog(@"下载的数据：%@", string);
//                                            }];
//    NSURLSessionDataTask *task = [session dataTaskWithURL:[NSURL URLWithString:[[URLManager getSharedInstance] getURL:URL_CALENDAR_LASTYEAR]]];//
//    NSURLSessionDataTask *task = [session dataTaskWithURL:[NSURL URLWithString:@"http://img6.cache.netease.com/photo/0001/2016-09-06/C08AKTHD3R710001.jpg"] completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
//        if (!error) {
//            UIImage * image = [UIImage imageWithData:data];
//        }
//    }];
//    [task resume];
    
    NSURL * url = [NSURL URLWithString:@"http://img6.cache.netease.com/photo/0001/2016-09-06/C08AKTHD3R710001.jpg"];
    NSURLSessionConfiguration * backgroundConfig = [NSURLSessionConfiguration backgroundSessionConfigurationWithIdentifier:@"backgroundtask2"];
    
    NSURLSession *backgroundSeesion = [NSURLSession sessionWithConfiguration: backgroundConfig delegate:self delegateQueue: [NSOperationQueue mainQueue]];
    
    NSURLSessionDownloadTask * downloadTask =[ backgroundSeesion downloadTaskWithURL:url];
    [downloadTask resume];
}

//前台下载的代理方法
/*
-(void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didFinishDownloadingToURL:(NSURL *)location
{
    NSLog(@"Temporary File :%@\n", location);
    NSError *err = nil;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *docsDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    
    NSURL *docsDirURL = [NSURL fileURLWithPath:[docsDir stringByAppendingPathComponent:@"download.json"]];
    if ([fileManager moveItemAtURL:location
                             toURL:docsDirURL
                             error: &err])
    {
        NSLog(@"File is saved to =%@",docsDir);
    }
    else
    {
        NSLog(@"failed to move: %@",[err userInfo]);
    }
    
}

-(void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didWriteData:(int64_t)bytesWritten totalBytesWritten:(int64_t)totalBytesWritten totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite
{
    //You can get progress here
    NSLog(@"Received: %lld bytes (Downloaded: %lld bytes)  Expected: %lld bytes.\n",
          bytesWritten, totalBytesWritten, totalBytesExpectedToWrite);
}
*/
-(void)URLSessionDidFinishEventsForBackgroundURLSession:(NSURLSession *)session
{
    NSLog(@"Background URL session %@ finished events.\n", session);
    
    AppDelegate * delegate =(AppDelegate *)[[UIApplication sharedApplication] delegate];
//    if(delegate.completionHandler)
//    {
//        void (^handler)() = delegate.completionHandler;
//        handler();
//    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
