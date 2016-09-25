//
//  TaskXunjian2ViewController.h
//  wy
//
//  Created by wangyilu on 16/9/8.
//  Copyright © 2016年 ___PURANG___. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TaskXunjian2ViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIView *titleView;
@property (weak, nonatomic) IBOutlet UIView *buttonSrollView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollBackView;
@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomViewConstraint;

@property (nonatomic, strong) NSString *code;
@property (nonatomic, strong) NSString *taskStatus;
@property (nonatomic, strong) NSString *ShortTitle; //工单类型，列表传过来
@property (nonatomic, assign) BOOL isLocalSave; //本地存储，列表传过来

@property (nonatomic, strong) NSMutableDictionary *deviceCheckInfoDic;

@end
