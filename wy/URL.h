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
#define URL_PATH @"http://114.55.249.114/mobile/usereq.aspx"
//#define URL_PATH @"http://d.bm21.com.cn:30002/mobile/usereq.aspx"
#define URL_HEAD(url) [URL_PATH stringByAppendingString:url]


#endif
