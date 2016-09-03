//
//  TaskTableViewController.h
//  wy
//
//  Created by wangyilu on 16/8/11.
//  Copyright © 2016年 ___PURANG___. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TaskTableViewController : UITableViewController

@property (nonatomic, strong) NSDictionary *filterDic; //为了不同入口进来使用的过滤条件

@end
