//
//  PRView.m
//  wy
//
//  Created by 王益禄 on 16/9/4.
//  Copyright © 2016年 ___PURANG___. All rights reserved.
//

#import "PRView.h"

@implementation PRView

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

@end
