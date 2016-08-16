//
//  ChoosePersonViewController.h
//  wy
//
//  Created by wangyilu on 16/8/15.
//  Copyright © 2016年 ___PURANG___. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ChoosePersonViewDelegate <NSObject>

- (void)getSelectedPersons:(NSArray *) persons;

@end

@interface ChoosePersonViewController : UIViewController

@property(assign,nonatomic) id<ChoosePersonViewDelegate> delegate;

@property(assign,nonatomic) NSMutableDictionary *selectedPersonsDic;

@end
