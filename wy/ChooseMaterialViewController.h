//
//  ChooseMaterialViewController.h
//  wy
//
//  Created by 王益禄 on 2016/10/23.
//  Copyright © 2016年 ___PURANG___. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ChooseMaterialViewDelegate <NSObject>

- (void)showSelectedMaterials:(NSArray *) materials;

@end

@interface ChooseMaterialViewController : UIViewController

@property(assign,nonatomic) id<ChooseMaterialViewDelegate> delegate;

@property(assign,nonatomic) NSMutableDictionary *selectedMaterialsDic;

@end
