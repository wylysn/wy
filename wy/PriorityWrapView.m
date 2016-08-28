//
//  PriorityWrapView.m
//  wy
//
//  Created by 王益禄 on 16/8/28.
//  Copyright © 2016年 ___PURANG___. All rights reserved.
//

#import "PriorityWrapView.h"

@implementation PriorityWrapView

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextMoveToPoint(context, 7, 0);
    CGContextAddLineToPoint(context, rect.size.width-2, 0);
    CGContextAddArcToPoint(context, rect.size.width, 0, rect.size.width, 2, 2);
    CGContextAddLineToPoint(context, rect.size.width-3, rect.size.height-2);
    CGContextAddArcToPoint(context, rect.size.width-5, rect.size.height, rect.size.width-7, rect.size.height, 5);
    CGContextAddLineToPoint(context, 2, rect.size.height);
    CGContextAddArcToPoint(context, 0, rect.size.height, 0, rect.size.height-2, 2);
    CGContextAddLineToPoint(context, 3, 2);
    CGContextAddArcToPoint(context, 5, 0, 7, 0, 5);
    CGContextSetFillColorWithColor(context, [UIColor colorFromHexCode:self.bgColor].CGColor);
    
    CGContextFillPath(context);
}

@end
