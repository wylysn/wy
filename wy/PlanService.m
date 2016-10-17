//
//  PlanService.m
//  wy
//
//  Created by wangyilu on 16/10/10.
//  Copyright © 2016年 ___PURANG___. All rights reserved.
//

#import "PlanService.h"

@implementation PlanService

- (void)getPlanList:(NSMutableDictionary *)condition success:(void (^)(NSArray *planListArr))success failure:(void (^)(NSString *message))failure {
    PRHTTPSessionManager *manager = [PRHTTPSessionManager sharePRHTTPSessionManager];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *userName = [userDefaults objectForKey:@"userName"];
    [condition setObject:@"getschedulelist" forKey:@"action"];
    [condition setObject:userName forKey:@"userName"];
    [condition setObject:[DateUtil getCurrentTimestamp] forKey:@"tick"];
    [condition setObject:[NSString getDeviceId] forKey:@"imei"];
    [manager GET:[[URLManager getSharedInstance] getURL:@""] parameters:condition progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (responseObject[@"success"]) {
            NSArray* response = responseObject[@"data"];
            NSMutableArray *planListArr = [[NSMutableArray alloc] init];
            for (NSDictionary *obj in response) {
                PlanListEntity *planListEntity = [[PlanListEntity alloc] initWithDictionary:obj];
                [planListArr addObject:planListEntity];
            }
            success(planListArr);
        } else {
            failure(responseObject[@"message"]);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(@"网络请求错误");
    }];
}

- (void)getPlanDetail:(NSString *)code success:(void (^)(PlanDetailEntity *planDetail))success failure:(void (^)(NSString *message))failure {
    PRHTTPSessionManager *manager = [PRHTTPSessionManager sharePRHTTPSessionManager];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *userName = [userDefaults objectForKey:@"userName"];
    NSMutableDictionary *condition = [[NSMutableDictionary alloc] init];
    [condition setObject:@"getscheduledata" forKey:@"action"];
    [condition setObject:userName forKey:@"userName"];
    [condition setObject:[DateUtil getCurrentTimestamp] forKey:@"tick"];
    [condition setObject:[NSString getDeviceId] forKey:@"imei"];
    [condition setObject:code forKey:@"code"];
    [manager GET:[[URLManager getSharedInstance] getURL:@""] parameters:condition progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (responseObject[@"success"]) {
            PlanDetailEntity *planDetail = [[PlanDetailEntity alloc] initWithDictionary:responseObject[@"data"][0]];
            success(planDetail);
        } else {
            failure(responseObject[@"message"]);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(@"网络请求错误");
    }];
}

- (void)getPlanTask:(NSString *)code success:(void (^)(PlanDetailEntity *planDetail))success failure:(void (^)(NSString *message))failure {
    PRHTTPSessionManager *manager = [PRHTTPSessionManager sharePRHTTPSessionManager];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *userName = [userDefaults objectForKey:@"userName"];
    NSMutableDictionary *condition = [[NSMutableDictionary alloc] init];
    [condition setObject:@"gettaskdata" forKey:@"action"];
    [condition setObject:userName forKey:@"userName"];
    [condition setObject:[DateUtil getCurrentTimestamp] forKey:@"tick"];
    [condition setObject:[NSString getDeviceId] forKey:@"imei"];
    [condition setObject:code forKey:@"code"];
    [manager GET:[[URLManager getSharedInstance] getURL:@""] parameters:condition progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (responseObject[@"success"]) {
            PlanDetailEntity *planDetail = [[PlanDetailEntity alloc] initWithDictionary:responseObject[@"data"][0]];
            success(planDetail);
        } else {
            failure(responseObject[@"message"]);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(@"网络请求错误");
    }];
}

@end
