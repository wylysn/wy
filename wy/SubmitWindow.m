//
//  SubmitWindow.m
//  wy
//
//  Created by wangyilu on 16/10/26.
//  Copyright © 2016年 ___PURANG___. All rights reserved.
//

#import "SubmitWindow.h"

@implementation SubmitWindow

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
        UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        // 设置指示器位置
        indicator.center = CGPointMake(self.frame.size.width * 0.5, self.frame.size.height * 0.5);
        // 开启动画，必须调用，否则无法显示
        [indicator startAnimating];
        [self addSubview:indicator];
    }
    return self;
}

@end
