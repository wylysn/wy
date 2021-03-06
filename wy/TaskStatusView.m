//
//  TaskStatusView.m
//  wy
//
//  Created by 王益禄 on 16/8/28.
//  Copyright © 2016年 ___PURANG___. All rights reserved.
//

#import "TaskStatusView.h"

@implementation TaskStatusView

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextMoveToPoint(context, 20, 0);
    CGContextAddLineToPoint(context, rect.size.width, 0);
    CGContextAddLineToPoint(context, rect.size.width, rect.size.height);
    CGContextAddLineToPoint(context, 0, rect.size.height);
    CGContextAddLineToPoint(context, 20, 0);
    CGContextSetFillColorWithColor(context, [UIColor colorFromHexCode:self.bgColor].CGColor);
    CGContextFillPath(context);
}

//- (void)setBgColor:(NSString *)bgColor {
//    CGContextRef context = UIGraphicsGetCurrentContext();
//    CGRect rect = self.frame;
//    CGContextMoveToPoint(context, 20, 0);
//    CGContextAddLineToPoint(context, rect.size.width, 0);
//    CGContextAddLineToPoint(context, rect.size.width, rect.size.height);
//    CGContextAddLineToPoint(context, 0, rect.size.height);
//    CGContextAddLineToPoint(context, 20, 0);
//    CGContextSetFillColorWithColor(context, [UIColor colorFromHexCode:bgColor].CGColor);
//    CGContextFillPath(context);
//}

@end
