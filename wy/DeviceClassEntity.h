//
//  DeviceClassEntity.h
//  wy
//
//  Created by 王益禄 on 2016/10/22.
//  Copyright © 2016年 ___PURANG___. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DeviceClassEntity : NSObject

- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

@property (nonatomic, readonly) NSInteger ID;
@property (nonatomic, copy, readonly) NSString *Code;
@property (nonatomic, copy, readonly) NSString *Name;
@property (nonatomic, readonly) NSInteger ParentID;

/*扩展属性*/
@property (nonatomic, assign) int level;
@property (nonatomic, assign) NSInteger childNum;    //有子节点
@property (nonatomic, assign) BOOL hasChildDisplay; //子节点已展示

@end
