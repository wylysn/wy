//
//  PhotoViewCell.m
//  PurangFinanceVillage
//
//  Created by zhiujunchun on 16/1/4.
//  Copyright © 2016年 ___PURANG___. All rights reserved.
//

#import "PhotoViewCell.h"

@implementation PhotoViewCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self creatUI];
    }
    return self;
}

- (void)creatUI{
    
    CGFloat width = (SCREEN_WIDTH - 40)/3;
    self.iconView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, width, width)];
    [self.contentView addSubview:self.iconView];
    
}

@end
