//
//  InspectionModelDBService.h
//  wy
//
//  Created by wangyilu on 16/9/5.
//  Copyright © 2016年 ___PURANG___. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "InspectionModelEntity.h"

@interface InspectionModelDBService : NSObject

+ (InspectionModelDBService*) getSharedInstance;

- (BOOL) saveInspectionModel:(InspectionModelEntity *)inspection;
- (InspectionModelEntity *) findInspectionModelByCode:(NSString*)Code;

@end
