//
//  InspectionModelDBService.h
//  wy
//
//  Created by wangyilu on 16/9/5.
//  Copyright © 2016年 ___PURANG___. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "InspectionModelEntity.h"
#import "InspectionChildModelEntity.h"

@interface InspectionModelDBService : NSObject

+ (InspectionModelDBService*) getSharedInstance;
- (void)setSharedInstanceNull;

- (BOOL) saveInspectionModel:(InspectionModelEntity *)inspection;

- (BOOL) saveInspectionChildModel:(InspectionChildModelEntity *)inspectionChild;

- (InspectionModelEntity *) findInspectionModelByCode:(NSString*)Code;

- (NSArray *) findInspectionChildModelByCode:(NSString*)ParentCode;

@end
