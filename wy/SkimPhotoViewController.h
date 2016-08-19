//
//  SkimPhotoViewController.h
//  PurangFinanceVillage
//
//  Created by zhiujunchun on 16/1/4.
//  Copyright © 2016年 ___PURANG___. All rights reserved.
//

@protocol SkimPhotoViewDelegate <NSObject>

- (void)deletePhoto:(NSInteger)index;

@end

@interface SkimPhotoViewController : UIViewController

@property (nonatomic,retain) NSMutableArray * imageArray;

@property (nonatomic,assign) NSInteger  index;

@property (assign,nonatomic) id<SkimPhotoViewDelegate> delegate;

@end
