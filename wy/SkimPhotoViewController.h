//
//  SkimPhotoViewController.h
//  PurangFinanceVillage
//
//  Created by zhiujunchun on 16/1/4.
//  Copyright © 2016年 ___PURANG___. All rights reserved.
//

@protocol SkimPhotoViewDelegate <NSObject>

- (void)usePhoto:(NSMutableArray*)imageArray;

@end

@interface SkimPhotoViewController : UIViewController

@property (nonatomic,retain) NSMutableArray * imageArray;

@property (nonatomic,assign) NSInteger  index;

@property(retain,nonatomic)id<SkimPhotoViewDelegate> delegate;

@end
