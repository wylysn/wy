//
//  PositionEntity.h
//  wy
//
//  Created by wangyilu on 16/9/1.
//  Copyright © 2016年 ___PURANG___. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PositionEntity : NSObject

- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

@property (nonatomic, readonly) NSInteger ID;
@property (nonatomic, copy, readonly) NSString *Code;
@property (nonatomic, copy, readonly) NSString *Name;
@property (nonatomic, copy, readonly) NSString *FullName;
@property (nonatomic, readonly) NSString *Sort;
@property (nonatomic, readonly) NSString *Status;
@property (nonatomic, copy, readonly) NSString *Description;
@property (nonatomic, readonly) NSInteger ParentID;
@property (nonatomic, copy, readonly) NSString *Prj_Code;

/*扩展属性*/
@property (nonatomic, assign) int level;
@property (nonatomic, assign) NSInteger childNum;    //有子节点
@property (nonatomic, assign) BOOL hasChildDisplay; //子节点已展示

@end
