//
//  ReportImpaireService.h
//  wy
//
//  Created by 王益禄 on 16/9/25.
//  Copyright © 2016年 ___PURANG___. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ReportImpaireService : NSObject

- (void)submitImpaire:(NSMutableDictionary *)dataDic withImage:(NSArray *)ImageArray success:(void (^)())success failure:(void (^)(NSString *message))failure;

@end
