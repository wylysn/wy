//
//  DeviceEntity.h
//  wy
//
//  Created by wangyilu on 16/9/5.
//  Copyright © 2016年 ___PURANG___. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DeviceEntity : NSObject

- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

@property (nonatomic, copy, readonly) NSString *Code;
@property (nonatomic, copy, readonly) NSString *Name;
//@property (nonatomic, copy, readonly) NSString *QRCode;
//@property (nonatomic, copy, readonly) NSString *Class;
@property (nonatomic, copy, readonly) NSString *Model;
@property (nonatomic, copy, readonly) NSString *Brand;
@property (nonatomic, copy, readonly) NSString *Xlhao;
@property (nonatomic, copy, readonly) NSString *Pro_Date;
@property (nonatomic, copy, readonly) NSString *Weight;
@property (nonatomic, copy, readonly) NSString *Des_Life;
@property (nonatomic, copy, readonly) NSString *Pos;
@property (nonatomic, copy, readonly) NSString *Description;
@property (nonatomic, copy, readonly) NSString *Patrol_Tpl;
@property (nonatomic, copy, readonly) NSString *Status;
@property (nonatomic, copy, readonly) NSString *Picture;
@property (nonatomic, copy, readonly) NSString *Attachment;
@property (nonatomic, copy, readonly) NSString *Organizationid;

@property (nonatomic, copy, readonly) NSString *ClassName;

@property (nonatomic, copy, readonly) NSString *PosID;
@property (nonatomic, copy, readonly) NSString *ClassID;

@end
