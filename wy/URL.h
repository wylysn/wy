//
//  URL.h
//  PurangFinance
//
//  Created by liumingkui on 15/5/6.
//  Copyright (c) 2015年 ___PURANG___. All rights reserved.
//

#ifndef PurangFinance_URL_h
#define PurangFinance_URL_h

#define iPhone6 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(750, 1334), [[UIScreen mainScreen] currentMode].size) : NO)
#define iPhone6P ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1242, 2208), [[UIScreen mainScreen] currentMode].size) : NO)
//18621122732
//#define URL_PATH @"https://m3.purang.com:8050"
//#define URL_PATH @"http://10.10.29.6:8080"
//#define URL_PATH @"http://10.10.96.144:8088"//测试环境
//#define URL_PATH @"https://mobile.purang.com"
#define URL_PATH @"http://114.55.249.114/mobile/usereq.aspx"
//http://d.bm21.com.cn:30002/mobile/usereq.aspx
#define URL_HEAD(url) [URL_PATH stringByAppendingString:url]
//#define URL_HEAD(url) [NSString stringWithFormat:@"https://m3.purang.com:8050%@",url]
//#define URL_HEAD(url) [NSString stringWithFormat:@"http://10.10.96.144:8088%@",url]//测试环境
//#define URL_HEAD(url) [NSString stringWithFormat:@"http://10.10.96.139:8087%@",url]
//#define URL_HEAD(url) [NSString stringWithFormat:@"http://10.1.110.21:8088/",url]
//#define URL_HEAD(url) [NSString stringWithFormat:@"http://10.10.29.6:8080%@",url]//
//#define URL_HEAD(url) [NSString stringWithFormat:@"http://10.1.110.22:8088%@",url]//开发环境
//#define URL_HEAD(url) [NSString stringWithFormat:@"http://10.10.29.7:8080%@",url]//c      

#define URL_CALENDAR_LASTYEAR @"/mobile/queryBankLastYear.htm"    //查询最新年份


#endif
