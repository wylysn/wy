//
//  AssetsSiftView.h
//  wy
//
//  Created by 王益禄 on 16/10/7.
//  Copyright © 2016年 ___PURANG___. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AssetsSiftView : UIView<UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet PRButton *cancelButton;
@property (weak, nonatomic) IBOutlet PRButton *confirmButton;

@property (strong,nonatomic) NSMutableDictionary *selectedlocationDic;
@property (strong,nonatomic) NSMutableArray *positionList;

@property (strong,nonatomic) NSMutableDictionary *selectedClassDic;
@property (strong,nonatomic) NSMutableArray *classList;

@property (strong,nonatomic) UITableView *siftTableView;

@property (strong,nonatomic) NSArray *classArr;
@property (strong,nonatomic) NSArray *locationArr;

@end
