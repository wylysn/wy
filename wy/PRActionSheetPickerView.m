//
//  PRActionSheetPickerView.m
//  PurangFinance
//
//  Created by liumingkui on 15/4/21.
//  Copyright (c) 2015年 ___PURANG___. All rights reserved.
//

#import "PRActionSheetPickerView.h"
#import "DateUtil.h"
#import "NTMonthYearPicker.h"

@implementation PRActionSheetPickerView
{
    UIDatePicker* datePicker;
    UIView* backView;
    UIView* buttomView;
    
    CGFloat width;
    CGFloat height;
    UIButton* cancelButton;
    UIButton* doneButton;
    NSInteger _idNum;
    
    NTMonthYearPicker *ntPicker;
    
    NSInteger pickerMode;
}


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        width = [UIDevice width];
        height = [UIDevice height];
        //        self.alpha = 0.5;
        self.frame = CGRectMake(0, 0, width, height);
        self.backgroundColor = [UIColor clearColor];
        
        backView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, width, height - 300)];
        backView.backgroundColor = [UIColor blackColor];
        backView.alpha = 0;
        [self addSubview:backView];
        
        UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap:)];
        [backView addGestureRecognizer:tap];
        
        buttomView = [[UIView alloc]initWithFrame:CGRectMake(0, height, width, 300)];
        buttomView.backgroundColor = [UIColor whiteColor];
        [self addSubview:buttomView];
        
        datePicker = [[UIDatePicker alloc]initWithFrame:CGRectMake(0, height + 40, width, 0)];
        datePicker.datePickerMode = UIDatePickerModeDateAndTime;
        datePicker.backgroundColor = [UIColor whiteColor];
        //        datePicker.backgroundColor = [UIColor redColor];
        
        [datePicker addTarget:self action:@selector(dateChanged:) forControlEvents:UIControlEventValueChanged];
        [self addSubview:datePicker];
        
        //        cancelButton = [UIButton buttonWithType:UIButtonTypeSystem];
        //        cancelButton.frame = CGRectMake(10, height - 300, 60, 40);
        //        [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
        //        [cancelButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        ////        cancelButton.backgroundColor = [UIColor blueColor];
        //        cancelButton.layer.masksToBounds = YES;
        //        cancelButton.layer.cornerRadius = 5;
        //        [self addSubview:cancelButton];
        
        doneButton = [UIButton buttonWithType:UIButtonTypeSystem];
        doneButton.frame = CGRectMake(width - 70, height, 50, 40);
        [doneButton setTitle:@"完成" forState:UIControlStateNormal];
        [doneButton setTitleColor:[UIColor colorFromHexCode:@"4E98D5"] forState:UIControlStateNormal];
        //        doneButton.backgroundColor = [UIColor blueColor];
        doneButton.layer.masksToBounds = YES;
        doneButton.layer.cornerRadius = 5;
        [doneButton addTarget:self action:@selector(doneButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:doneButton];
    }
    return self;
}

- (void)dateChanged:(id)sender
{
    //    UIDatePicker* picker = (UIDatePicker*)sender;
    //    NSDate* date = picker.date;
    //    NSLog(@"%@",date);
}

- (void)showDatePickerInView:(UIView*)view withType:(NSInteger)mode withBackId:(NSInteger)idNum
{
    _idNum = idNum;
    [view addSubview:self];
    NSString *formatter;
    pickerMode = mode;
    if (mode == 0) {
        datePicker.datePickerMode = UIDatePickerModeTime;
        formatter = @"HH:mm";
    } else if (mode == 1) {
        datePicker.datePickerMode = UIDatePickerModeDate;
        formatter = @"yyyy-MM-dd";
    } else if (mode == 2) {
        datePicker.datePickerMode = UIDatePickerModeDateAndTime;
        formatter = @"yyyy-MM-dd HH:mm:00";
    } else if (mode == 3) {
        datePicker.datePickerMode = UIDatePickerModeCountDownTimer;
        formatter = @"HH:mm";
    } else if (mode == 4) {
        // Initialize the picker
        ntPicker = [[NTMonthYearPicker alloc] initWithFrame:CGRectMake(0, [UIDevice height], [UIDevice width], 260)];
        [ntPicker addTarget:self action:@selector(onDatePicked:) forControlEvents:UIControlEventValueChanged];
        
//        NSDateComponents *comps = [[NSDateComponents alloc] init];
//        NSCalendar *cal = [NSCalendar currentCalendar];
        
        // Set mode to month + year
        // This is optional; default is month + year
        ntPicker.datePickerMode = NTMonthYearPickerModeMonthAndYear;
        
        // Set minimum date to January 2000
        // This is optional; default is no min date
//        [comps setDay:1];
//        [comps setMonth:1];
//        [comps setYear:2000];
//        picker.minimumDate = [cal dateFromComponents:comps];
        
        // Set maximum date to next month
        // This is optional; default is no max date
//        [comps setDay:0];
//        [comps setMonth:1];
//        [comps setYear:0];
//        picker.maximumDate = [cal dateByAddingComponents:comps toDate:[NSDate date] options:0];
        
        // Set initial date to last month
        // This is optional; default is current month/year
//        [comps setDay:0];
//        [comps setMonth:-1];
//        [comps setYear:0];
//        picker.date = [cal dateByAddingComponents:comps toDate:[NSDate date] options:0];
        [datePicker removeFromSuperview];
        [self addSubview:ntPicker];
        formatter = @"yyyy-MM-dd";
    }
    
    if (self.defaultDate) {
        NSDate* date = [DateUtil dateFromString:self.defaultDate withFormatter:formatter];
        if (mode == 4) {
            [ntPicker setDate:date];
        } else {
            [datePicker setDate:date animated:NO];
        }
        
    }
    
    [UIView animateWithDuration:0.2 animations:^{
        
        buttomView.frame = CGRectMake(0, height - 300, width, 300);
        datePicker.frame = CGRectMake(0, height - 260, width, 260);
        ntPicker.frame = CGRectMake(0, height - 260, width, 260);
        doneButton.frame = CGRectMake(width - 70, height - 300, 50, 40);
        backView.alpha = 0.5;
        
    }];
}

- (void)onDatePicked:(UITapGestureRecognizer *)gestureRecognizer {
//    NSDateFormatter *df = [[NSDateFormatter alloc] init];
//    if( ntPicker.datePickerMode == NTMonthYearPickerModeMonthAndYear ) {
//        [df setDateFormat:@"MMMM yyyy"];
//    } else {
//        [df setDateFormat:@"yyyy"];
//    }
//    NSString *dateStr = [df stringFromDate:ntPicker.date];
//    NSLog(@"========%@", dateStr);
}


- (void)tap:(UITapGestureRecognizer*)tap
{
    [self dismissFromSuperView];
}

- (void)doneButtonClick:(id)sender
{
    NSDate* date = datePicker.date;
    if (pickerMode == 4) {
        date = ntPicker.date;
    }
    //    NSLog(@"%@",date);
    if (_delegate && [_delegate respondsToSelector:@selector(getDateWithDate:andId:)]) {
        [_delegate getDateWithDate:date andId:_idNum];
    }
    [self dismissFromSuperView];
}

- (void)dismissFromSuperView
{
    [UIView animateWithDuration:0.2 animations:^{
        
        datePicker.frame = CGRectMake(0, height + 40, width, 0);
        doneButton.frame = CGRectMake(width - 70, height, 50, 40);
        buttomView.frame = CGRectMake(0, height, width, 300);
        backView.alpha = 0;
        
    } completion:^(BOOL finished) {
        
        [self removeFromSuperview];
        if (_delegate && [_delegate respondsToSelector:@selector(disMissBackView)]) {
            [_delegate disMissBackView];
        }
        
    }];
    
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

@end
