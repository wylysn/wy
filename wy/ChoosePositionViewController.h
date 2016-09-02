//
//  ChoosePositionViewController.h
//  wy
//
//  Created by wangyilu on 16/9/1.
//  Copyright © 2016年 ___PURANG___. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PositionEntity.h"
#import "PositionDBservice.h"

@protocol ChoosePositionViewDelegate <NSObject>

- (void)showSelectedPositions:(PositionEntity *) position;

@end

@interface ChoosePositionViewController : UIViewController

@property(assign,nonatomic) id<ChoosePositionViewDelegate> delegate;

@end
