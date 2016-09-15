//
//  LoginService.m
//  wy
//
//  Created by 王益禄 on 16/9/15.
//  Copyright © 2016年 ___PURANG___. All rights reserved.
//

#import "LoginService.h"

@implementation LoginService

- (void)loginWithUserName:(NSString *)userName password:(NSString *)password success:(void (^)())success failure:(void (^)(NSString *message))failure {
    Reachability *reach = [Reachability reachabilityForInternetConnection];
    if (reach.isReachable) {
        PRHTTPSessionManager *manager = [PRHTTPSessionManager sharePRHTTPSessionManager];
        NSMutableDictionary *condition = [[NSMutableDictionary alloc] init];
        [condition setObject:@"checklogin" forKey:@"action"];
        [condition setObject:[DateUtil getCurrentTimestamp] forKey:@"tick"];
        [condition setObject:[NSString getDeviceId] forKey:@"imei"];
        [condition setObject:userName forKey:@"username"];
        [condition setObject:password forKey:@"password"];
        [manager GET:[[URLManager getSharedInstance] getURL:@""] parameters:condition progress:^(NSProgress * _Nonnull downloadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            if (responseObject[@"success"]) {
                success();
            } else {
                failure(responseObject[@"message"]);
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            failure(@"网络请求失败！");
        }];
    } else {
        failure(@"无网络连接！");
    }
}

@end
