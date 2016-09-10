//
//  NSDate+Extensions.h
//  PurangFinanceVillage-Bank
//
//  Created by wangyilu on 16/1/27.
//  Copyright © 2016年 ___PURANG___. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (Extensions)

+(NSDate*)addMonthDate:(NSDate*) now withMonths:(NSInteger) months;

+(NSDate*)addDayDate:(NSDate*) now withDays:(NSInteger) days;

+(NSString *)getCurrentyear;

+(NSString *)getCurrentMonth;

+(NSString *)getCurrentDateString;

-(NSString *)formatDateString;

@end
