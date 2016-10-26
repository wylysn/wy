//
//  TaskHandleViewController.h
//  wy
//
//  Created by wangyilu on 16/8/31.
//  Copyright © 2016年 ___PURANG___. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TaskHandleViewController : UIViewController

@property (nonatomic, strong) NSString *code;
@property (nonatomic, strong) NSString *ShortTitle; //工单类型，列表传过来
@property (nonatomic, strong) NSString *taskStatus;
@property (nonatomic, assign) BOOL isLocalSave; //本地存储，列表传过来

@property (nonatomic,strong) NSMutableArray * imageArray;
@property (nonatomic,strong) NSMutableArray * imageViewArray;

@property (nonatomic,strong) NSMutableArray * workImageArray;
@property (nonatomic,strong) NSMutableArray * workImageViewArray;

@end
