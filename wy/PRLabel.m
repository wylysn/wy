//
//  PRLabel.m
//  wy
//
//  Created by wangyilu on 16/8/19.
//  Copyright © 2016年 ___PURANG___. All rights reserved.
//

#import "PRLabel.h"

@implementation PRLabel

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

@end
