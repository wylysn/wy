//
//  ChooseToolViewController.h
//  wy
//
//  Created by 王益禄 on 2016/10/23.
//  Copyright © 2016年 ___PURANG___. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ChooseToolViewDelegate <NSObject>

- (void)showSelectedTools:(NSArray *) materials;

@end

@interface ChooseToolViewController : UIViewController

@property(assign,nonatomic) id<ChooseToolViewDelegate> delegate;

@property(assign,nonatomic) NSMutableDictionary *selectedToolsDic;

@end
