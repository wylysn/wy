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
@property (nonatomic, strong) NSString *taskStatus;

@property (nonatomic,strong) NSMutableArray * imageArray;
@property (nonatomic,strong) NSMutableArray * imageViewArray;

@end
