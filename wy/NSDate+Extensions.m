//
//  NSDate+Extensions.m
//  PurangFinanceVillage-Bank
//
//  Created by wangyilu on 16/1/27.
//  Copyright © 2016年 ___PURANG___. All rights reserved.
//

#import "NSDate+Extensions.h"

@implementation NSDate (Extensions)

+(NSDate *)addMonthDate:(NSDate *)now withMonths:(NSInteger)months {
    NSDateComponents *monthBeforeDateComponents = [[NSDateComponents alloc] init];
    monthBeforeDateComponents.month = months;
    NSDate *rsDate = [[NSCalendar currentCalendar]dateByAddingComponents:monthBeforeDateComponents toDate:now options:0];
    return rsDate;
}

+(NSDate *)addDayDate:(NSDate *)now withDays:(NSInteger)days {
    NSDateComponents *dayBeforeDateComponents = [[NSDateComponents alloc] init];
    dayBeforeDateComponents.day = days;
    NSDate *rsDate = [[NSCalendar currentCalendar]dateByAddingComponents:dayBeforeDateComponents toDate:now options:0];
    return rsDate;
}

+(NSString *)getCurrentyear {
    NSDate *date = [NSDate date];
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    NSInteger interval = [zone secondsFromGMTForDate: date];
    NSDate *localDate = [date  dateByAddingTimeInterval: interval];
    NSDateFormatter *dateFormatter =[[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"YYYY"];
    NSString *dateString = [dateFormatter stringFromDate:localDate];
    return dateString;
}

+(NSString *)getCurrentMonth {
    NSDate *date = [NSDate date];
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    NSInteger interval = [zone secondsFromGMTForDate: date];
    NSDate *localDate = [date  dateByAddingTimeInterval: interval];
    NSDateFormatter *dateFormatter =[[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MM"];
    NSString *dateString = [dateFormatter stringFromDate:localDate];
    return dateString;
}

+(NSString *)getCurrentDateString {
    NSDate *now = [NSDate date];//根据当前系统的时区产生当前的时间，绝对时间，所以同为中午12点，不同的时区，这个时间是不同的。
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    df.timeZone = [NSTimeZone systemTimeZone];//系统所在时区
    df.dateFormat = @"yyyyMMdd";
    NSString *systemTimeZoneStr =  [df stringFromDate:now];
    
    return systemTimeZoneStr;
}

-(NSString *)formatDateString {
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    df.timeZone = [NSTimeZone systemTimeZone];//系统所在时区
    df.dateFormat = @"yyyy-MM-dd";
    NSString *systemTimeZoneStr =  [df stringFromDate:self];
    
    return systemTimeZoneStr;
}

@end
