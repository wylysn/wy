//
//  DateUtil.h
//  PurangFinanceVillage
//
//  Created by wangyilu on 16/1/5.
//  Copyright © 2016年 ___PURANG___. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DateUtil : NSObject

+ (NSDate*)addMonthDate:(NSDate*) now withMonths:(NSInteger) months;

+ (NSString *)formatDateString:(NSDate *)date withFormatter:(NSString *)formatter;

+ (NSDate *)dateFromString:(NSString *)dateString withFormatter:(NSString *)formatterString;

+ (NSInteger)intervalFromLastDate: (NSDate *) date1  toTheDate:(NSDate *) date2;

+ (NSString *)getCurrentTimestamp;

#pragma mark - 获取月最后一天
+ (NSString *)getLastDateOfMonth:(NSDate *)date;

@end
