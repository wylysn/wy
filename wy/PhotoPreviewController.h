//
//  PhotoPreviewController.h
//  PurangFinanceVillage
//
//  Created by wangyilu on 16/1/12.
//  Copyright © 2016年 ___PURANG___. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PhotoPreviewController : UIViewController

@property (weak, nonatomic) IBOutlet UIImageView *imagePreview;
//@property (nonatomic,strong) NSMutableArray * imageArray;

@property (nonatomic,strong) UIImage *image;

@property (nonatomic,assign) NSInteger isComer;

@end
