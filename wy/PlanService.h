//
//  PlanService.h
//  wy
//
//  Created by wangyilu on 16/10/10.
//  Copyright © 2016年 ___PURANG___. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PlanDetailEntity.h"

@interface PlanService : NSObject

- (void)getPlanDetail:(NSString *)code success:(void (^)(PlanDetailEntity *planDetail))success failure:(void (^)(NSString *message))failure;

@end
