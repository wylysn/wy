//
//  DateUtil.m
//  PurangFinanceVillage
//
//  Created by wangyilu on 16/1/5.
//  Copyright © 2016年 ___PURANG___. All rights reserved.
//

#import "DateUtil.h"

@implementation DateUtil
+(NSDate *)addMonthDate:(NSDate *)now withMonths:(NSInteger)months {
    NSDateComponents *monthBeforeDateComponents = [[NSDateComponents
                                                   alloc] init];
    monthBeforeDateComponents.month = months;
    NSDate *rsDate = [[NSCalendar currentCalendar]dateByAddingComponents:monthBeforeDateComponents toDate:now options:0];
    return rsDate;
}

+(NSString *)formatDateString:(NSDate *)date withFormatter:(NSString *)formatter {
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    df.timeZone = [NSTimeZone systemTimeZone];//系统所在时区
    df.dateFormat = formatter;
    NSString *systemTimeZoneStr =  [df stringFromDate:date];
    
    return systemTimeZoneStr;
}

@end
