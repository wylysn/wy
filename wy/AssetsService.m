//
//  AssetsService.m
//  wy
//
//  Created by 王益禄 on 16/9/27.
//  Copyright © 2016年 ___PURANG___. All rights reserved.
//

#import "AssetsService.h"

@implementation AssetsService

- (void)getAssets:(NSString *)code success:(void (^)(NSDictionary *assetsDic))success failure:(void (^)(NSString *message))failure {
    PRHTTPSessionManager *manager = [PRHTTPSessionManager sharePRHTTPSessionManager];
    NSMutableDictionary *condition = [[NSMutableDictionary alloc] init];
    [condition setObject:@"getformdata" forKey:@"action"];
    [condition setObject:[DateUtil getCurrentTimestamp] forKey:@"tick"];
    [condition setObject:[NSString getDeviceId] forKey:@"imei"];
    [condition setObject:@"3" forKey:@"templateid"];
    [condition setObject:code forKey:@"keyid"];
    [manager GET:[[URLManager getSharedInstance] getURL:@""] parameters:condition progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([responseObject[@"success"] boolValue]) {
            success(responseObject[@"data"]);
        } else {
            failure(responseObject[@"message"]);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(@"网络请求错误");
    }];
}

@end
