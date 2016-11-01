//
//  LoginService.m
//  wy
//
//  Created by 王益禄 on 16/9/15.
//  Copyright © 2016年 ___PURANG___. All rights reserved.
//

#import "LoginService.h"

@implementation LoginService

- (void)loginWithUserInfo:(NSDictionary *)userInfoDic success:(void (^)(NSDictionary *userDic))success failure:(void (^)(NSString *message))failure {
    Reachability *reach = [Reachability reachabilityForInternetConnection];
    if (reach.isReachable) {
        PRHTTPSessionManager *manager = [PRHTTPSessionManager sharePRHTTPSessionManager];
        NSMutableDictionary *condition = [[NSMutableDictionary alloc] init];
        [condition setObject:@"checklogin" forKey:@"action"];
        [condition setObject:[DateUtil getCurrentTimestamp] forKey:@"tick"];
        [condition setObject:[NSString getDeviceId] forKey:@"imei"];
        [condition setObject:userInfoDic[@"userName"] forKey:@"name"];
        [condition setObject:userInfoDic[@"password"] forKey:@"password"];
        [condition setObject:userInfoDic[@"deviceToken"] forKey:@"token"];
        [manager GET:[[URLManager getSharedInstance] getURL:@""] parameters:condition progress:^(NSProgress * _Nonnull downloadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            if ([responseObject[@"success"] boolValue]) {
                success(responseObject[@"data"]);
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

- (void)modifyPasswordWithOldPwd:(NSString *)oldpwd newPwd:(NSString *)newpwd success:(void (^)())success failure:(void (^)(NSString *message))failure {
    Reachability *reach = [Reachability reachabilityForInternetConnection];
    if (reach.isReachable) {
        PRHTTPSessionManager *manager = [PRHTTPSessionManager sharePRHTTPSessionManager];
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        NSString *userName = [userDefaults objectForKey:@"userName"];
        NSMutableDictionary *condition = [[NSMutableDictionary alloc] init];
        [condition setObject:@"modifypwd" forKey:@"action"];
        [condition setObject:[DateUtil getCurrentTimestamp] forKey:@"tick"];
        [condition setObject:[NSString getDeviceId] forKey:@"imei"];
        [condition setObject:userName forKey:@"username"];
        [condition setObject:oldpwd forKey:@"oldpwd"];
        [condition setObject:newpwd forKey:@"newpwd"];
        [manager GET:[[URLManager getSharedInstance] getURL:@""] parameters:condition progress:^(NSProgress * _Nonnull downloadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            if ([responseObject[@"success"] boolValue]) {
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
