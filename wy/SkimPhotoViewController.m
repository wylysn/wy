//
//  SkimPhotoViewController.m
//  PurangFinanceVillage
//
//  Created by zhiujunchun on 16/1/4.
//  Copyright © 2016年 ___PURANG___. All rights reserved.
//

#import "SkimPhotoViewController.h"
#import "UIImage+Resolution.h"

@interface SkimPhotoViewController ()<UIActionSheetDelegate,UIScrollViewDelegate>

@property (nonatomic,strong) UIScrollView * scrollView;

@end

@implementation SkimPhotoViewController


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
//    self.navigationController.navigationBarHidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self creatUI];
    
    
    
}

- (void)creatUI{
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-64)];
    [self.view addSubview:self.scrollView];
    
    for (int i = 0; i<self.imageArray.count; i++) {
        UIImageView * photoImage = [[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH*i, 10, SCREEN_WIDTH, SCREEN_HEIGHT-74-64)];
        photoImage.image = [self.imageArray[i] imageScaledToSize2:CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT-74-64)];
        [self.scrollView addSubview:photoImage];
        
    }
    
    self.scrollView.pagingEnabled = YES;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.contentOffset = CGPointMake(SCREEN_WIDTH*self.index, 0);
    self.scrollView.contentSize = CGSizeMake(SCREEN_WIDTH*self.imageArray.count, 0);
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)detete:(id)sender {
    
    UIActionSheet * sheet = [[UIActionSheet alloc]initWithTitle:@"要删除这张照片吗?" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"删除", nil];

    [sheet showInView:self.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSLog(@"%ld",buttonIndex);
    if (buttonIndex == 0) {
        
        NSInteger  x = self.scrollView.contentOffset.x/SCREEN_WIDTH;
        [self.imageArray removeObjectAtIndex:x];
        if (_delegate && [_delegate respondsToSelector:@selector(deletePhoto:)]) {
            [self.delegate deletePhoto:x];
        }
        if (self.imageArray.count>0) {
            [self creatUI];
        }else{
           [self.navigationController popViewControllerAnimated:YES];
        }
    
        
    }
}

- (IBAction)backClick:(id)sender {
//    if (_delegate && [_delegate respondsToSelector:@selector(usePhoto:)]) {
//        
//        [self.delegate usePhoto:self.imageArray];
//    }
    [self.navigationController popViewControllerAnimated:YES];
}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
