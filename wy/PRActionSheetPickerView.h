//
//  PRActionSheetPickerView.h
//  PurangFinance
//
//  Created by liumingkui on 15/4/21.
//  Copyright (c) 2015年 ___PURANG___. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <UIKit/UIKit.h>

@protocol PRActionSheetPickerViewDelegate <NSObject>

- (void)getDateWithDate:(NSDate*)date andId:(NSInteger)idNum;
- (void)disMissBackView;

@end

@interface PRActionSheetPickerView : UIView

@property(assign,nonatomic) id<PRActionSheetPickerViewDelegate> delegate;

//@property(assign,nonatomic) UIDatePickerMode pickerMode;

@property (nonatomic, strong) NSString *defaultDate;

//- (void)showDatePickerInView:(UIView*)view withId:(NSInteger)idNum;

- (void)showDatePickerInView:(UIView*)view withType:(NSInteger)pickerMode withBackId:(NSInteger)idNum;


@end
