//
//  CameraViewController.m
//  PurangFinance
//
//  Created by liumingkui on 15/4/20.
//  Copyright (c) 2015年 ___PURANG___. All rights reserved.
//

#import "CameraViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "PhotoViewController.h"


typedef void(^PropertyChangeBlock)(AVCaptureDevice *captureDevice);

@interface CameraViewController ()<PhotoViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UIButton *flashAutoButton;
@property (weak, nonatomic) IBOutlet UIButton *flashOnButton;

@property (weak, nonatomic) IBOutlet UIView *backPhotoView;

@property (weak, nonatomic) IBOutlet UIImageView *photoImage;


@property (weak, nonatomic) IBOutlet UIButton *imageBtn;
//显示最新拍摄的照片
@property (nonatomic,strong) NSMutableArray * imageArray;
@property (strong,nonatomic) AVCaptureSession *captureSession;//负责输入和输出设备之间的数据传递
@property (strong,nonatomic) AVCaptureDeviceInput *captureDeviceInput;//负责从AVCaptureDevice获得输入数据
@property (strong,nonatomic) AVCaptureStillImageOutput *captureStillImageOutput;//照片输出流
@property (strong,nonatomic) AVCaptureVideoPreviewLayer *captureVideoPreviewLayer;//相机拍摄预览图层
@property (weak, nonatomic) IBOutlet UIView *viewContainer;

@property (retain, nonatomic) UIImageView *focusCursor; //聚焦光标

@end

@implementation CameraViewController


- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = NO;
    self.backPhotoView.hidden = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.imageBtn.hidden = YES;
    self.imageArray = [NSMutableArray array];
    self.backPhotoView.hidden = YES;
    // Do any additional setup after loading the view.
}

- (IBAction)flashAuto:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)flashOn:(UIButton *)button
{
    button.selected = !button.selected;
    
    if (button.selected == NO) {
        
        [self setFlashMode:AVCaptureFlashModeOff];
        //        [self setFlashModeButtonStatus];
        
    }else{
        
        [self setFlashMode:AVCaptureFlashModeOn];
        //        [self setFlashModeButtonStatus];
        
    }
    
    
    
}


- (IBAction)takePhoto:(id)sender
{
    NSLog(@"take");
    //根据设备输出获得连接
    AVCaptureConnection *captureConnection = [self.captureStillImageOutput connectionWithMediaType:AVMediaTypeVideo];
    //根据连接取得设备输出的数据
    [self.captureStillImageOutput captureStillImageAsynchronouslyFromConnection:captureConnection completionHandler:^(CMSampleBufferRef imageDataSampleBuffer, NSError *error) {
        if (imageDataSampleBuffer) {
            NSData *imageData = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageDataSampleBuffer];
            UIImage *image = [UIImage imageWithData:imageData];
            self.backPhotoView.hidden = NO;
            self.photoImage.image = image;
            [self.imageArray addObject:image];
            
        }
        
    }];
}

- (IBAction)buttonclick:(UIButton *)button
{
    
    self.backPhotoView.hidden = YES;
    
}
//- (IBAction)changeImageBtn:(id)sender {
//
//    UIStoryboard* mainSB = [UIStoryboard storyboardWithName:@"Notice" bundle:[NSBundle mainBundle]];
//    PhotoViewController* photoViewController = [mainSB instantiateViewControllerWithIdentifier:@"photo"];
//    photoViewController.delegate = self;
//    NSLog(@"%@",self.imageArray);
//    photoViewController.imageArray = self.imageArray;
//    [self.navigationController pushViewController:photoViewController animated:YES];
//
//
//
//}
- (IBAction)useImage:(id)sender {
    
    UIStoryboard* mainSB = [UIStoryboard storyboardWithName:@"Notice" bundle:[NSBundle mainBundle]];
    PhotoViewController* photoViewController = [mainSB instantiateViewControllerWithIdentifier:@"photo"];
    photoViewController.delegate = self;
    NSLog(@"%@",self.imageArray);
    photoViewController.imageArray = self.imageArray;
    [self.navigationController pushViewController:photoViewController animated:YES];
    
}

- (void)usePhoto:(NSDictionary *)imageDictionary
{
    
    
    //    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBarHidden = YES;
    //初始化会话
    
    //    if (_captureDeviceInput == nil)
    //    {
    //        _captureSession = [[AVCaptureSession alloc]init];
    //    }
    //
    //    if ([_captureSession canSetSessionPreset:AVCaptureSessionPreset1280x720]) {//设置分辨率
    //        _captureSession.sessionPreset = AVCaptureSessionPreset1280x720;
    //    }
    _captureSession = [AVCaptureSession new];
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
        [_captureSession setSessionPreset:AVCaptureSessionPreset640x480];
    else
        [_captureSession setSessionPreset:AVCaptureSessionPresetPhoto];
    //获得输入设备
    AVCaptureDevice *captureDevice=[self getCameraDeviceWithPosition:AVCaptureDevicePositionBack];//取得后置摄像头
    if (!captureDevice) {
        NSLog(@"取得后置摄像头时出现问题.");
        return;
    }
    
    NSError *error=nil;
    //根据输入设备初始化设备输入对象，用于获得输入数据
    _captureDeviceInput = [[AVCaptureDeviceInput alloc]initWithDevice:captureDevice error:&error];
    if (error) {
        NSLog(@"取得设备输入对象时出错，错误原因：%@",error.localizedDescription);
        return;
    }
    //初始化设备输出对象，用于获得输出数据
    if (_captureStillImageOutput == nil)
    {
        _captureStillImageOutput = [AVCaptureStillImageOutput new];//[[AVCaptureStillImageOutput alloc]init];
    }
    NSDictionary *outputSettings = @{AVVideoCodecKey:AVVideoCodecJPEG};
    [_captureStillImageOutput setOutputSettings:outputSettings];//输出设置
    
    //将设备输入添加到会话中
    if ([_captureSession canAddInput:_captureDeviceInput]) {
        [_captureSession addInput:_captureDeviceInput];
    }
    
    //将设备输出添加到会话中
    if ([_captureSession canAddOutput:_captureStillImageOutput]) {
        [_captureSession addOutput:_captureStillImageOutput];
    }
    
    //创建视频预览层，用于实时展示摄像头状态
    _captureVideoPreviewLayer = [[AVCaptureVideoPreviewLayer alloc]initWithSession:self.captureSession];
    
    CALayer *layer = self.view.layer;
    layer.masksToBounds = YES;
    
    //    _captureVideoPreviewLayer.frame = layer.bounds;
    _captureVideoPreviewLayer.frame = CGRectMake(layer.bounds.origin.x, layer.bounds.origin.y, layer.bounds.size.width, layer.bounds.size.height-64);
    
    _captureVideoPreviewLayer.videoGravity = AVLayerVideoGravityResizeAspect;//填充模式
    //将视频预览层添加到界面中
//    [layer addSublayer:_captureVideoPreviewLayer];
        [layer insertSublayer:_captureVideoPreviewLayer below:self.backPhotoView.layer];
    
    [self addNotificationToCaptureDevice:captureDevice];
    [self addGenstureRecognizer];
    [self setFlashModeButtonStatus];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self.captureSession startRunning];
}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [self.captureSession stopRunning];
}

-(void)dealloc{
    [self removeNotification];
}


#pragma mark - 通知
/**
 *  给输入设备添加通知
 */
-(void)addNotificationToCaptureDevice:(AVCaptureDevice *)captureDevice{
    //注意添加区域改变捕获通知必须首先设置设备允许捕获
    [self changeDeviceProperty:^(AVCaptureDevice *captureDevice) {
        captureDevice.subjectAreaChangeMonitoringEnabled=YES;
    }];
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    //捕获区域发生改变
    [notificationCenter addObserver:self selector:@selector(areaChange:) name:AVCaptureDeviceSubjectAreaDidChangeNotification object:captureDevice];
}
-(void)removeNotificationFromCaptureDevice:(AVCaptureDevice *)captureDevice{
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    [notificationCenter removeObserver:self name:AVCaptureDeviceSubjectAreaDidChangeNotification object:captureDevice];
}
/**
 *  移除所有通知
 */
-(void)removeNotification{
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    [notificationCenter removeObserver:self];
}

-(void)addNotificationToCaptureSession:(AVCaptureSession *)captureSession{
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    //会话出错
    [notificationCenter addObserver:self selector:@selector(sessionRuntimeError:) name:AVCaptureSessionRuntimeErrorNotification object:captureSession];
}

/**
 *  设备连接成功
 *
 *  @param notification 通知对象
 */
- (void)deviceConnected:(NSNotification *)notification
{
    NSLog(@"设备已连接...");
}
/**
 *  设备连接断开
 *
 *  @param notification 通知对象
 */
- (void)deviceDisconnected:(NSNotification *)notification
{
    NSLog(@"设备已断开.");
}
/**
 *  捕获区域改变
 *
 *  @param notification 通知对象
 */
- (void)areaChange:(NSNotification *)notification
{
    //    NSLog(@"捕获区域改变...");
}

/**
 *  会话出错
 *
 *  @param notification 通知对象
 */
- (void)sessionRuntimeError:(NSNotification *)notification
{
    NSLog(@"会话发生错误.");
}

#pragma mark - 私有方法

/**
 *  取得指定位置的摄像头
 *
 *  @param position 摄像头位置
 *
 *  @return 摄像头设备
 */
- (AVCaptureDevice *)getCameraDeviceWithPosition:(AVCaptureDevicePosition )position
{
    NSArray *cameras = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    for (AVCaptureDevice *camera in cameras)
    {
        if ([camera position] == position)
        {
            return camera;
        }
    }
    return nil;
}

/**
 *  改变设备属性的统一操作方法
 *
 *  @param propertyChange 属性改变操作
 */
- (void)changeDeviceProperty:(PropertyChangeBlock)propertyChange
{
    AVCaptureDevice *captureDevice= [self.captureDeviceInput device];
    NSError *error;
    //注意改变设备属性前一定要首先调用lockForConfiguration:调用完之后使用unlockForConfiguration方法解锁
    if ([captureDevice lockForConfiguration:&error])
    {
        propertyChange(captureDevice);
        [captureDevice unlockForConfiguration];
    }
    else
    {
        NSLog(@"设置设备属性过程发生错误，错误信息：%@",error.localizedDescription);
    }
}

/**
 *  设置闪光灯模式
 *
 *  @param flashMode 闪光灯模式
 */
- (void)setFlashMode:(AVCaptureFlashMode )flashMode
{
    [self changeDeviceProperty:^(AVCaptureDevice *captureDevice)
     {
         if ([captureDevice isFlashModeSupported:flashMode])
         {
             [captureDevice setFlashMode:flashMode];
         }
     }];
}
/**
 *  设置聚焦模式
 *
 *  @param focusMode 聚焦模式
 */
- (void)setFocusMode:(AVCaptureFocusMode )focusMode
{
    [self changeDeviceProperty:^(AVCaptureDevice *captureDevice)
     {
         if ([captureDevice isFocusModeSupported:focusMode])
         {
             [captureDevice setFocusMode:focusMode];
         }
     }];
}
/**
 *  设置曝光模式
 *
 *  @param exposureMode 曝光模式
 */
- (void)setExposureMode:(AVCaptureExposureMode)exposureMode
{
    [self changeDeviceProperty:^(AVCaptureDevice *captureDevice)
     {
         if ([captureDevice isExposureModeSupported:exposureMode])
         {
             [captureDevice setExposureMode:exposureMode];
         }
     }];
}
/**
 *  设置聚焦点
 *
 *  @param point 聚焦点
 */
- (void)focusWithMode:(AVCaptureFocusMode)focusMode exposureMode:(AVCaptureExposureMode)exposureMode atPoint:(CGPoint)point
{
    [self changeDeviceProperty:^(AVCaptureDevice *captureDevice)
     {
         if ([captureDevice isFocusModeSupported:focusMode])
         {
             [captureDevice setFocusMode:AVCaptureFocusModeAutoFocus];
         }
         if ([captureDevice isFocusPointOfInterestSupported])
         {
             [captureDevice setFocusPointOfInterest:point];
         }
         if ([captureDevice isExposureModeSupported:exposureMode])
         {
             [captureDevice setExposureMode:AVCaptureExposureModeAutoExpose];
         }
         if ([captureDevice isExposurePointOfInterestSupported])
         {
             [captureDevice setExposurePointOfInterest:point];
         }
     }];
}

/**
 *  添加点按手势，点按时聚焦
 */
- (void)addGenstureRecognizer
{
    UITapGestureRecognizer *tapGesture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapScreen:)];
    [self.viewContainer addGestureRecognizer:tapGesture];
}
- (void)tapScreen:(UITapGestureRecognizer *)tapGesture
{
    CGPoint point= [tapGesture locationInView:self.viewContainer];
    //将UI坐标转化为摄像头坐标
    CGPoint cameraPoint= [self.captureVideoPreviewLayer captureDevicePointOfInterestForPoint:point];
    [self setFocusCursorWithPoint:point];
    [self focusWithMode:AVCaptureFocusModeAutoFocus exposureMode:AVCaptureExposureModeAutoExpose atPoint:cameraPoint];
}

/**
 *  设置闪光灯按钮状态
 */
- (void)setFlashModeButtonStatus
{
    //    AVCaptureDevice *captureDevice=[self.captureDeviceInput device];
    //    AVCaptureFlashMode flashMode=captureDevice.flashMode;
    //    if([captureDevice isFlashAvailable]){
    ////        self.flashAutoButton.hidden=NO;
    ////        self.flashOnButton.hidden=NO;
    ////
    ////        self.flashAutoButton.enabled=YES;
    ////        self.flashOnButton.enabled=YES;
    ////        self.flashOffButton.enabled=YES;
    //        switch (flashMode)
    //        {
    ////            case AVCaptureFlashModeAuto:
    ////                self.flashAutoButton.enabled=NO;
    ////                break;
    //            case AVCaptureFlashModeOn:
    //                self.flashOnButton.selected = NO;
    //                break;
    ////            case AVCaptureFlashModeOff:
    ////                self.flashOffButton.enabled=NO;
    ////                break;
    //            default:
    //                break;
    //        }
    //    }
    //    else
    //    {
    ////        self.flashAutoButton.hidden=YES;
    //        self.flashOnButton.hidden=YES;
    //
    //    }
}

/**
 *  设置聚焦光标位置
 *
 *  @param point 光标位置
 */
- (void)setFocusCursorWithPoint:(CGPoint)point
{
    self.focusCursor.center=point;
    self.focusCursor.transform=CGAffineTransformMakeScale(1.5, 1.5);
    self.focusCursor.alpha=1.0;
    [UIView animateWithDuration:1.0 animations:^{
        self.focusCursor.transform=CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
        self.focusCursor.alpha=0;
        
    }];
}


- (void)didReceiveMemoryWarning
{
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
