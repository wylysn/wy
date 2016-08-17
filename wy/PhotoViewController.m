//
//  PhotoViewController.m
//  PurangFinance
//
//  Created by liumingkui on 15/4/20.
//  Copyright (c) 2015年 ___PURANG___. All rights reserved.
//

#import "PhotoViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "SkimPhotoViewController.h"
#import "PhotoViewCell.h"
#import "UIImage+Resolution.h"
#import "CameraViewController.h"
#import "ELCImagePickerController.h"
#import "AAPLCameraViewController.h"

#define cellWith (SCREEN_WIDTH-40)/3
@interface PhotoViewController ()<UIAlertViewDelegate,SkimPhotoViewDelegate,UICollectionViewDelegate,UICollectionViewDataSource,UIActionSheetDelegate,ELCImagePickerControllerDelegate>

@property (nonatomic,strong) UICollectionView * collectionView;


@end

@implementation PhotoViewController
{
    NSInteger selectImageNum;
    NSMutableDictionary * selectImageDic;
    NSMutableArray * selectArray;
}
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
    selectArray = [NSMutableArray array];
    [self creatCollectionView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(add:) name:@"addPhotos" object:nil];
    
}

- (void)add:(NSNotification *)not
{
    UIImage * image = not.object;
    [self.imageArray addObject:image];
    [selectArray removeAllObjects];
    [_collectionView reloadData];
}

- (void)creatCollectionView{
    
    UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc] init];
    //确定UICollectionView的滑动方向
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 74, SCREEN_WIDTH, SCREEN_HEIGHT- 74) collectionViewLayout:layout];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.backgroundColor = [UIColor clearColor];
    [_collectionView registerClass:[PhotoViewCell class] forCellWithReuseIdentifier:@"ID"];
    
    [self.view addSubview:_collectionView];
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return self.imageArray.count+1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    PhotoViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ID" forIndexPath:indexPath];
    
    
    if (indexPath.row == self.imageArray.count) {
        cell.iconView.image = [UIImage imageNamed:@"tianjia"];
    }else{
      cell.iconView.image = [self.imageArray[indexPath.row] imageScaledToSize2:CGSizeMake((SCREEN_WIDTH - 40)/3, (SCREEN_WIDTH - 40)/3)];
        
        UIImage * image = self.imageArray[indexPath.row];
        [selectArray addObject:image];
//        image = [self resize:image to:CGSizeMake((WIDTH - 40)/3, (WIDTH - 40)/3)];
        
//    ALAssetsLibrary *assetsLibrary=[[ALAssetsLibrary alloc]init];
//    [assetsLibrary writeImageToSavedPhotosAlbum:[image CGImage] orientation:(ALAssetOrientation)[image imageOrientation] completionBlock:^(NSURL *assetURL, NSError *error) {
//            
//        NSDictionary * dic = @{UIImagePickerControllerMediaType:ALAssetTypePhoto,UIImagePickerControllerOriginalImage:image,UIImagePickerControllerReferenceURL:assetURL};
//        [selectArray addObject:dic];
//            
//        }];

    }
    
    return cell;
}
-(UIImage *) imageCompressForWidth:(UIImage *)sourceImage targetWidth:(CGFloat)defineWidth
{
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = defineWidth;
    CGFloat targetHeight = (targetWidth / width) * height;
    UIGraphicsBeginImageContext(CGSizeMake(targetWidth, targetHeight));
    [sourceImage drawInRect:CGRectMake(0,0,targetWidth,  targetHeight)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    return CGSizeMake(cellWith, cellWith);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    
    return UIEdgeInsetsMake(10, 8, 0, 8);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    //横向，item的宽度和再加上item之间的距离再加上据两边屏幕的距离和，不能超过屏幕的宽度
    return 4;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == self.imageArray.count) {
        if (self.imageArray.count >= 5) {
            UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"最多只能选择5张照片" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
        }else{
            
            if (_isComer == 1) {
               
                UIActionSheet* changeImageSheet = [[UIActionSheet alloc]initWithTitle:@"请选择" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"相机",@"从相册中选取", nil];
                changeImageSheet.tag = 3;
                [changeImageSheet showInView:self.view];
                
                
            }else{
                [self.navigationController popViewControllerAnimated:YES];
            }
            
        }
    }else{
        
        UIStoryboard* mainSB = [UIStoryboard storyboardWithName:@"Camera" bundle:[NSBundle mainBundle]];
        SkimPhotoViewController * skim = [mainSB instantiateViewControllerWithIdentifier:@"SkimPhoto"];
        skim.imageArray = self.imageArray;
        skim.delegate = self;
        skim.index = indexPath.row;
        [self.navigationController pushViewController:skim animated:YES];

        
    }
    
    
}

- (IBAction)submitPhotoes:(id)sender {
    
    
//    self.navigationController.navigationBarHidden = NO;
    if (_isComer == 1) {
        [self.navigationController popViewControllerAnimated :YES];
    }else{
        
        //    UIViewController * viewC = self.navigationController.viewControllers[1];
        
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    [self dispatchNotification];
    
//    [self.navigationController popToViewController:viewC animated:YES];
    
}


- (void)dispatchNotification
{
     [[NSNotificationCenter defaultCenter] postNotificationName:@"photo" object:selectArray];
}

#pragma mark - actionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0)
    {
        UIStoryboard* mainSB = [UIStoryboard storyboardWithName:@"Camera" bundle:[NSBundle mainBundle]];
        
        AAPLCameraViewController* cameraViewController = [mainSB instantiateViewControllerWithIdentifier:@"camera"];
//        cameraViewController.isComer = 1;
        
        [self presentViewController:cameraViewController animated:YES completion:nil];
        //            [self.navigationController pushViewController:cameraViewController animated:YES];
        NSLog(@"相机");
    }
    else if (buttonIndex == 1)
    {
        ELCImagePickerController * elcPicker = [[ELCImagePickerController alloc] initImagePicker];
        
        elcPicker.maximumImagesCount = 5 - self.imageArray.count; //Set the maximum number of images to select to 100
        elcPicker.returnsOriginalImage = YES; //Only return the fullScreenImage, not the fullResolutionImage
        elcPicker.returnsImage = YES; //Return UIimage if YES. If NO, only return asset location information
        elcPicker.onOrder = YES; //For multiple image selection, display and return order of selected images
        elcPicker.isTrim = YES;
        elcPicker.mediaTypes = @[(NSString *)kUTTypeImage]; //Supports image and movie types
        elcPicker.imagePickerDelegate = self;
        
        [self presentViewController:elcPicker animated:YES completion:nil];
        NSLog(@"相册");
    }

}


#pragma mark - ELCImagePickerControllerDelegate Methods

- (void)elcImagePickerController:(ELCImagePickerController *)picker didFinishPickingMediaWithInfo:(NSArray *)info
{
    NSLog(@"%@",info);
    for (NSDictionary * dic in info) {
        [self.imageArray addObject:dic[@"UIImagePickerControllerOriginalImage"]];
    }
    [selectArray removeAllObjects];
    [self dismissViewControllerAnimated:YES completion:nil];
    [_collectionView reloadData];
}

- (void)elcImagePickerControllerDidCancel:(ELCImagePickerController *)picker
{
    NSLog(@"pick---->%@",picker);
    [self dismissViewControllerAnimated:YES completion:nil];
}



- (void)usePhoto:(NSMutableArray *)imageArray
{
    self.imageArray = imageArray;
    [selectArray removeAllObjects];
    [_collectionView reloadData];
    
}

- (IBAction)addPhoto:(id)sender {
   
    
}


- (IBAction)backRootView:(id)sender {
    
    if (_isComer == 1) {
        [self.navigationController popViewControllerAnimated:YES];
//        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:nil message:@"清除已选照片?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
//        [alert show];
        
    }else{
        
        [self dismissViewControllerAnimated:YES completion:^{
        }];

        
//        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:nil message:@"放弃上传照片?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
//        [alert show];
    
    }
    [self dispatchNotification]; 
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1){
        
//        self.navigationController.navigationBarHidden = NO;

        
        if (_isComer == 1) {
            [selectArray removeAllObjects];
            [self dispatchNotification];
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            [self dismissViewControllerAnimated:YES completion:^{
            }];
        }
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - 状态栏白色

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

@end
