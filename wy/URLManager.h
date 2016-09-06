//
//  URLManager.h
//  wy
//
//  Created by wangyilu on 16/9/6.
//  Copyright © 2016年 ___PURANG___. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface URLManager : NSObject

+ (URLManager *)getSharedInstance;

- (void)setURL_PATH:(NSString *) path;

- (NSString *)getURL:(NSString *)url;

@end
