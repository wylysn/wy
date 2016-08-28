//
//  PriorityLabel.m
//  wy
//
//  Created by 王益禄 on 16/8/28.
//  Copyright © 2016年 ___PURANG___. All rights reserved.
//

#define PADDING 3.0

#import "PriorityLabel.h"

@implementation PriorityLabel

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
//- (void)drawRect:(CGRect)rect {
//    CGContextRef context = UIGraphicsGetCurrentContext();
//    
//        CGContextSetLineWidth(context, 1);
//        CGContextSetStrokeColorWithColor(context, [UIColor redColor].CGColor);
//    
//    CGContextMoveToPoint(context, 5, 0);
//    CGContextAddLineToPoint(context, rect.size.width, 0);
//    CGContextAddLineToPoint(context, rect.size.width-5, rect.size.height);
//    CGContextAddLineToPoint(context, 0, rect.size.height);
//    CGContextAddLineToPoint(context, 5, 0);
//    CGContextSetFillColorWithColor(context, [UIColor colorFromHexCode:self.bgColor].CGColor);
////    CGContextFillPath(context);
//    
//        CGContextStrokePath(context);
//}

//- (void)drawTextInRect:(CGRect)rect {
//    UIEdgeInsets insets = {0, PADDING, 0, PADDING};
//    [super drawTextInRect:UIEdgeInsetsInsetRect(rect, insets)];
//}
//

- (void)setCornerRadius:(CGFloat)cornerRadius
{
    self.layer.cornerRadius = cornerRadius;
}

- (void)setBorderWidth:(CGFloat)borderWidth
{
    self.layer.borderWidth = borderWidth;
}

- (void)setBorderColor:(UIColor *)borderColor
{
    self.layer.borderColor = borderColor.CGColor;
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    self.clipsToBounds = YES;
}

- (CGSize) intrinsicContentSize {
    CGSize intrinsicSuperViewContentSize = [super intrinsicContentSize] ;
    intrinsicSuperViewContentSize.width += PADDING * 2 ;
    return intrinsicSuperViewContentSize ;
}

@end
