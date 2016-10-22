//
//  MaterialsDBService.h
//  wy
//
//  Created by 王益禄 on 2016/10/22.
//  Copyright © 2016年 ___PURANG___. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>
#import "MaterialsEntity.h"

@interface MaterialsDBService : NSObject

+ (MaterialsDBService*) getSharedInstance;
- (void) setSharedInstanceNull;
- (BOOL) saveMaterial:(MaterialsEntity *)material;
- (MaterialsEntity *) findMaterialByCode:(NSString*)Code;
- (NSArray *) findAllMaterials;

@end
