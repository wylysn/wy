//
//  DateUtil.m
//  PurangFinanceVillage
//
//  Created by wangyilu on 16/1/5.
//  Copyright © 2016年 ___PURANG___. All rights reserved.
//

#import "DateUtil.h"

@implementation DateUtil
+ (NSDate *)addMonthDate:(NSDate *)now withMonths:(NSInteger)months {
    NSDateComponents *monthBeforeDateComponents = [[NSDateComponents
                                                   alloc] init];
    monthBeforeDateComponents.month = months;
    NSDate *rsDate = [[NSCalendar currentCalendar]dateByAddingComponents:monthBeforeDateComponents toDate:now options:0];
    return rsDate;
}

+ (NSString *)formatDateString:(NSDate *)date withFormatter:(NSString *)formatter {
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    df.timeZone = [NSTimeZone systemTimeZone];//系统所在时区
    df.dateFormat = formatter;
    NSString *systemTimeZoneStr =  [df stringFromDate:date];
    
    return systemTimeZoneStr;
}

+ (NSDate *)dateFromString:(NSString *)dateString withFormatter:(NSString *)formatterString {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
    [formatter setDateFormat:formatterString];
    NSDate *date=[formatter dateFromString:dateString];
    return date;
}

+ (NSInteger)intervalFromLastDate: (NSDate *) date1  toTheDate:(NSDate *) date2
{
    NSTimeInterval time=[date2 timeIntervalSinceDate:date1];
    
    int hours=(int)(time/3600+0.5);
    
    return hours;
}

+ (NSString *)getCurrentTimestamp {
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval a=[dat timeIntervalSince1970];
    NSString *timeString = [NSString stringWithFormat:@"%0.f", a];
    return timeString;
}

+ (NSString *)getLastDateOfMonth:(NSDate *)date {
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];//[[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSRange range = [calendar rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:date];
    NSUInteger numberOfDaysInMonth = range.length;
    NSString *lastDate = [DateUtil formatDateString:date withFormatter:[NSString stringWithFormat:@"yyyy-MM-%ld", numberOfDaysInMonth]];
    return lastDate;
}

@end
