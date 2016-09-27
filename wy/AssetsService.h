//
//  AssetsService.h
//  wy
//
//  Created by 王益禄 on 16/9/27.
//  Copyright © 2016年 ___PURANG___. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AssetsService : NSObject

- (void)getAssets:(NSString *)code success:(void (^)(NSDictionary *assetsDic))success failure:(void (^)(NSString *message))failure;

@end
