//
//  TaskChuli1ViewController.m
//  wy
//
//  Created by wangyilu on 16/8/17.
//  Copyright © 2016年 ___PURANG___. All rights reserved.
//

#import "TaskChuli1ViewController.h"
#import "PRPlaceHolderTextView.h"
#import "AAPLCameraViewController.h"

#define TITLE_HEIGHT 40
#define IMAGESPLIT_WIDTH 10
#define PICS_PER_LINE 4

@interface TaskChuli1ViewController ()<UIActionSheetDelegate, AAPLCameraViewDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet PRPlaceHolderTextView *contentTextView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *ct1;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *ct2;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *ct3;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *ct4;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *ct5;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *ct6;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *ct7;
@property (weak, nonatomic) IBOutlet UIView *imagesView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imagesViewHeightConstraint;

@end

@implementation TaskChuli1ViewController {
    int PIC_HEIGHT;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    float ht = 1.f/[UIScreen mainScreen].scale;
    self.ct1.constant = ht;
    self.ct2.constant = ht;
    self.ct3.constant = ht;
    self.ct4.constant = ht;
    self.ct5.constant = ht;
    self.ct6.constant = ht;
    self.ct7.constant = ht;
    
    self.contentTextView.placeholder=@"请输入工作内容，限100字";
    self.contentTextView.layer.borderColor=[UIColor lightGrayColor].CGColor;
    self.contentTextView.layer.borderWidth=1.0/[UIScreen mainScreen].scale;
    
//    if (SCREEN_WIDTH<=320) {
        PIC_HEIGHT = (SCREEN_WIDTH-50)/PICS_PER_LINE;
//    } else if (SCREEN_WIDTH<=375) {
//        PIC_HEIGHT = (SCREEN_WIDTH-60)/5;
//    } else {
//        PIC_HEIGHT = (SCREEN_WIDTH-70)/6;
//    }
    
    self.imageArray = [[NSMutableArray alloc] init];
    UIImageView *addImageView = [[UIImageView alloc] initWithFrame:CGRectMake(IMAGESPLIT_WIDTH, TITLE_HEIGHT+6, PIC_HEIGHT, PIC_HEIGHT)];
    addImageView.image = [UIImage imageNamed:@"tianjia"];
    addImageView.tag = 1;
    [self resetImagesViewFrameWithLines:1];
    [self.imagesView addSubview:addImageView];
    
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(addImage:)];
    [addImageView addGestureRecognizer:gesture];
    [addImageView setUserInteractionEnabled:YES];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showImage:) name:@"addPhotos" object:nil];
}

- (void)resetImagesViewFrameWithLines:(int)lines {
    NSInteger diffHeight = (6+6+PIC_HEIGHT)*lines;
    CGRect newFrame = self.imagesView.frame;
    NSInteger newHeight = newFrame.size.height+diffHeight;
    newFrame.size.height = newHeight;
    [self.imagesView setFrame:newFrame];
    self.imagesViewHeightConstraint.constant = newHeight;
}

- (void)addImage:(UITapGestureRecognizer *)recognizer
{
    UIActionSheet* changeImageSheet = [[UIActionSheet alloc]initWithTitle:@"请选择" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"相机",@"从相册中选取", nil];
    [changeImageSheet showInView:self.view];
}

#pragma mark - actionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0)
    {
        
        UIStoryboard* mainSB = [UIStoryboard storyboardWithName:@"Camera" bundle:[NSBundle mainBundle]];
        
        AAPLCameraViewController* cameraViewController = [mainSB instantiateViewControllerWithIdentifier:@"camera"];
        cameraViewController.delegate = self;
        
        [self presentViewController:cameraViewController animated:YES completion:nil];
    }
    else if (buttonIndex == 1)
    {
//        ELCImagePickerController * elcPicker = [[ELCImagePickerController alloc] initImagePicker];        
//        elcPicker.maximumImagesCount = 5 - self.imageArray.count; //Set the maximum number of images to select to 100
//        elcPicker.returnsOriginalImage = YES; //Only return the fullScreenImage, not the fullResolutionImage
//        elcPicker.returnsImage = YES; //Return UIimage if YES. If NO, only return asset location information
//        elcPicker.onOrder = YES; //For multiple image selection, display and return order of selected images
//        elcPicker.isTrim = YES;
//        elcPicker.mediaTypes = @[(NSString *)kUTTypeImage]; //Supports image and movie types
//        elcPicker.imagePickerDelegate = self;
//        
//        [self presentViewController:elcPicker animated:YES completion:nil];
//        NSLog(@"相册");
    }
    
}

- (void)showImageDate:(NSData *)imageData {
    UIImage *image = [UIImage imageWithData:imageData];
    [self.imageArray addObject:image];
    
    UIImageView *imageView;
    int lines = self.imageArray.count/PICS_PER_LINE+1;
    float X = PIC_HEIGHT*(self.imageArray.count%PICS_PER_LINE)+IMAGESPLIT_WIDTH*(self.imageArray.count%PICS_PER_LINE+1);
    float Y = TITLE_HEIGHT+(lines-1)*(PIC_HEIGHT+6)+6;
    imageView = [[UIImageView alloc] initWithFrame:CGRectMake(X, Y, PIC_HEIGHT, PIC_HEIGHT)];
    
    if (self.imageArray.count%PICS_PER_LINE==0) {
        [self resetImagesViewFrameWithLines:1];
    }
    imageView.image = image;
    [self.imagesView addSubview:imageView];
}

- (void)showImage:(NSNotification*) aNotification {
    UIImage *image = [aNotification object];
    [self.imageArray addObject:image];
    
    UIImageView *imageView;
    int lines = self.imageArray.count/PICS_PER_LINE+1;
    float X = PIC_HEIGHT*(self.imageArray.count%PICS_PER_LINE)+IMAGESPLIT_WIDTH*(self.imageArray.count%PICS_PER_LINE+1);
    float Y = TITLE_HEIGHT+(lines-1)*(PIC_HEIGHT+6)+6;
    imageView = [[UIImageView alloc] initWithFrame:CGRectMake(X, Y, PIC_HEIGHT, PIC_HEIGHT)];
    
    if (self.imageArray.count%PICS_PER_LINE==0) {
        [self resetImagesViewFrameWithLines:1];
    }
    imageView.image = image;
    [self.imagesView addSubview:imageView];
}

-(void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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

@end
