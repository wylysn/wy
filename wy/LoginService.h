//
//  LoginService.h
//  wy
//
//  Created by 王益禄 on 16/9/15.
//  Copyright © 2016年 ___PURANG___. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LoginService : NSObject

- (void)loginWithUserName:(NSString *)userName password:(NSString *)password success:(void (^)(NSDictionary *userDic))success failure:(void (^)(NSString *message))failure;

@end
