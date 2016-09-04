//
//  PRView.h
//  wy
//
//  Created by 王益禄 on 16/9/4.
//  Copyright © 2016年 ___PURANG___. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PRView : UIView

@property(assign,nonatomic)IBInspectable CGFloat cornerRadius;
@property(assign,nonatomic)IBInspectable CGFloat borderWidth;
@property(retain,nonatomic)IBInspectable UIColor* borderColor;

@end
