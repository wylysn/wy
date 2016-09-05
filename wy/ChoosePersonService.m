//
//  ChoosePersonService.m
//  wy
//
//  Created by wangyilu on 16/8/15.
//  Copyright © 2016年 ___PURANG___. All rights reserved.
//

#import "ChoosePersonService.h"
#import "PersonEntity.h"
#import "PersonDBService.h"

@implementation ChoosePersonService

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.deptsList = [[NSMutableArray alloc] init];
        
        PersonDBService *dbService = [PersonDBService getSharedInstance];
        [self.deptsList addObjectsFromArray:[dbService findAllPersons]];
        
    }
    return self;
}

@end
