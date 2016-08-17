//
//  PhotoPreviewController.m
//  PurangFinanceVillage
//
//  Created by wangyilu on 16/1/12.
//  Copyright © 2016年 ___PURANG___. All rights reserved.
//

#import "PhotoPreviewController.h"
#import "PhotoViewController.h"
static NSInteger COMER;
@interface PhotoPreviewController ()



@end



@implementation PhotoPreviewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if (self.image) {
        self.imagePreview.image = self.image;
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    COMER = _isComer;
}

- (IBAction)resetCamera:(id)sender {
    [self.view removeFromSuperview];
//    [self.imageArray removeObject:self.imagePreview.image];
}
- (IBAction)usePhoto:(id)sender {
    
    self.navigationController.navigationBarHidden = YES;
    
//    if (COMER != 0) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"addPhotos" object:self.image];
    
        [self dismissViewControllerAnimated:YES completion:nil];
        
//    }else{
//        UIStoryboard* mainSB = [UIStoryboard storyboardWithName:@"Camera" bundle:[NSBundle mainBundle]];
//        PhotoViewController* photoViewController = [mainSB instantiateViewControllerWithIdentifier:@"photo"];
//        photoViewController.imageArray = self.imageArray;
//        
//       [self.navigationController pushViewController:photoViewController animated:YES];
//    }
    
//    [self.view removeFromSuperview];
    
}



@end
