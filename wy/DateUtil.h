//
//  DateUtil.h
//  PurangFinanceVillage
//
//  Created by wangyilu on 16/1/5.
//  Copyright © 2016年 ___PURANG___. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DateUtil : NSObject

+(NSDate*)addMonthDate:(NSDate*) now withMonths:(NSInteger) months;

+(NSString *)formatDateString:(NSDate *)date withFormatter:(NSString *)formatter;

@end
