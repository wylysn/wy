//
//  ChooseDeviceViewController.h
//  wy
//
//  Created by wangyilu on 16/8/30.
//  Copyright © 2016年 ___PURANG___. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ChooseDeviceViewDelegate <NSObject>

- (void)getSelectedDevices:(NSArray *) deviceArray;

@end

@interface ChooseDeviceViewController : UIViewController

@property(assign,nonatomic) id<ChooseDeviceViewDelegate> delegate;

@property(assign,nonatomic) NSMutableDictionary *selectedDevicesDic;

@end
