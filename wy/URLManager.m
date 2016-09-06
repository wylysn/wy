//
//  URLManager.m
//  wy
//
//  Created by wangyilu on 16/9/6.
//  Copyright © 2016年 ___PURANG___. All rights reserved.
//

#import "URLManager.h"

static URLManager *sharedInstance = nil;
static NSString *newURL_PATH = URL_PATH;

@implementation URLManager

+ (URLManager*)getSharedInstance {
    if (!sharedInstance) {
        sharedInstance = [[super allocWithZone:NULL] init];
    }
    return sharedInstance;
}

- (void)setURL_PATH:(NSString *) path {
    newURL_PATH = path;
}

- (NSString *)getURL:(NSString *)url {
    return [newURL_PATH stringByAppendingString:@"/mobile/queryBankLastYear.htm"];
}

@end
