//
//  ReportImpaireViewController.m
//  wy
//
//  Created by wangyilu on 16/8/29.
//  Copyright © 2016年 ___PURANG___. All rights reserved.
//

#import "ReportImpaireViewController.h"
#import "PRPlaceHolderTextView.h"
#import "DeviceEntity.h"
#import "AAPLCameraViewController.h"
#import "SkimPhotoViewController.h"
#import "ELCImagePickerController.h"
#import "UIImage+Resolution.h"

#define IMAGESPLIT_WIDTH 10
#define MAX_IMAGES_NUM 5
#define PICS_PER_LINE 4

@interface ReportImpaireViewController ()<UITableViewDataSource,UITableViewDelegate, UIActionSheetDelegate, SkimPhotoViewDelegate, ELCImagePickerControllerDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation ReportImpaireViewController {
    NSMutableArray *deviceArr;
    NSInteger PIC_WIDTH_HEIGHT;
//    NSInteger allLines;
    UITableViewCell *picCell;
    UIImageView *addImageView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableView setSeparatorInset:UIEdgeInsetsMake(0,10,0,0)];
    }
    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)])  {
        [self.tableView setLayoutMargins:UIEdgeInsetsZero];
    }
    
    deviceArr = [[NSMutableArray alloc] init];
    
    self.imageArray = [[NSMutableArray alloc] init];
    self.imageViewArray = [[NSMutableArray alloc] init];
    PIC_WIDTH_HEIGHT = (SCREEN_WIDTH-IMAGESPLIT_WIDTH*PICS_PER_LINE-10)/PICS_PER_LINE;

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showImage:) name:@"addPhotos" object:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    self.navigationController.navigationBarHidden = NO;
}

- (void)showAddImageView {
    if (!addImageView) {
        addImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, PIC_WIDTH_HEIGHT, PIC_WIDTH_HEIGHT)];
        addImageView.image = [UIImage imageNamed:@"tianjia"];
        addImageView.tag = 1;
        [picCell.contentView addSubview:addImageView];
        
        UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(addImage:)];
        [addImageView addGestureRecognizer:gesture];
        [addImageView setUserInteractionEnabled:YES];
    }
}

- (void)showImage:(NSNotification*) aNotification {
    UIImage *image = [aNotification object];
    [self showImageWithImage:image];
}

- (void)addImage:(UITapGestureRecognizer *)recognizer
{
    if (self.imageArray.count>=5) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message: [NSString stringWithFormat:@"最多上传%d张照片",MAX_IMAGES_NUM] preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:nil];
        [alertController addAction:okAction];
        [self presentViewController:alertController animated:YES completion:nil];
        return;
    }
    
    UIActionSheet* changeImageSheet = [[UIActionSheet alloc]initWithTitle:@"请选择" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"相机",@"从相册中选取", nil];
    changeImageSheet.tag=1;
    [changeImageSheet showInView:self.view];
}

#pragma mark - actionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0)
    {
        
        UIStoryboard* mainSB = [UIStoryboard storyboardWithName:@"Camera" bundle:[NSBundle mainBundle]];
        
        AAPLCameraViewController* cameraViewController = [mainSB instantiateViewControllerWithIdentifier:@"camera"];
        
        [self presentViewController:cameraViewController animated:YES completion:nil];
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
    }
}

- (void)showImageWithImage:(UIImage*) image {
    [self.imageArray addObject:image];
    UIImageView *imageView;
    NSInteger lines = self.imageArray.count/PICS_PER_LINE+1;
    float X = PIC_WIDTH_HEIGHT*(self.imageArray.count%PICS_PER_LINE)+IMAGESPLIT_WIDTH*(self.imageArray.count%PICS_PER_LINE)+10;
    float Y = (lines-1)*(PIC_WIDTH_HEIGHT+10)+10;
    imageView = [[UIImageView alloc] initWithFrame:CGRectMake(X, Y, PIC_WIDTH_HEIGHT, PIC_WIDTH_HEIGHT)];
    imageView.tag = self.imageArray.count;
    imageView.image = [image imageScaledToSize2:CGSizeMake(PIC_WIDTH_HEIGHT, PIC_WIDTH_HEIGHT)];
    [picCell.contentView addSubview:imageView];
    
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageClick:)];
    [imageView addGestureRecognizer:gesture];
    [imageView setUserInteractionEnabled:YES];
    
    [self.imageViewArray addObject:imageView];
}

- (void)imageClick:(UITapGestureRecognizer *)recognizer
{
    UIImageView *imageView = (UIImageView *)recognizer.view;
    UIStoryboard* mainSB = [UIStoryboard storyboardWithName:@"Camera" bundle:[NSBundle mainBundle]];
    SkimPhotoViewController * skim = [mainSB instantiateViewControllerWithIdentifier:@"SkimPhoto"];
    skim.imageArray = self.imageArray;
    skim.delegate = self;
    skim.index = imageView.tag-1;
    [self.navigationController pushViewController:skim animated:YES];
}

#pragma mark - SkimPhotoViewDelegate Methods

- (void)deletePhoto:(NSInteger)index {
    //删除对应的imageview，并重置其他imageview的位置
    [self.imageViewArray[index] removeFromSuperview];
    [self.imageViewArray removeObjectAtIndex:index];
    for (NSInteger i=index; i<self.imageViewArray.count; i++) {
        UIImageView *imageView = self.imageViewArray[i];
        imageView.tag = imageView.tag-1;
        CGRect newFrame = imageView.frame;
        float newX = PIC_WIDTH_HEIGHT*((i+1)%PICS_PER_LINE)+IMAGESPLIT_WIDTH*((i+1)%PICS_PER_LINE)+10;
        newFrame.origin.x = newX;
        if ((i+2)%4 == 0) {
            float newY = newFrame.origin.y-PIC_WIDTH_HEIGHT-10;
            newFrame.origin.y = newY;
        }
        imageView.frame = newFrame;
    }
    [self.tableView reloadData];
}

#pragma mark - ELCImagePickerControllerDelegate Methods

- (void)elcImagePickerController:(ELCImagePickerController *)picker didFinishPickingMediaWithInfo:(NSArray *)info
{
    for (NSInteger i=0; i<info.count; i++) {
        UIImage *image = info[i][UIImagePickerControllerOriginalImage];
        [self showImageWithImage:image];
    }
    [self.tableView reloadData];
}

- (void)elcImagePickerControllerDidCancel:(ELCImagePickerController *)picker
{
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)addDevice:(UITapGestureRecognizer *)recognizer
{
    NSDictionary *deviceDic1 = @{@"code":@"000001",@"name":@"加药棒"};
    NSDictionary *deviceDic2 = @{@"code":@"000002",@"name":@"冷却塔"};
    DeviceEntity *d1 = [[DeviceEntity alloc] initWithDictionary:deviceDic1];
    DeviceEntity *d2 = [[DeviceEntity alloc] initWithDictionary:deviceDic2];
    [deviceArr addObject:d1];
    [deviceArr addObject:d2];
    [self.tableView reloadData];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 7;
    } else if (section == 1) {
        return deviceArr.count;
    } else if (section == 2) {
        return 1;
    } else if (section == 3) {
        return 1;
    }
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 44)];
    if (section == 1) {
        header.backgroundColor = [UIColor whiteColor];
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, (44-21)/2, 200, 21)];
        titleLabel.text = @"添加故障设备";
        [header addSubview:titleLabel];
        UIImageView *plusImageView = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-35, (44-25)/2, 25, 25)];
        plusImageView.image = [UIImage imageNamed:@"plus50"];
        UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(addDevice:)];
        [plusImageView addGestureRecognizer:gesture];
        [plusImageView setUserInteractionEnabled:YES];
        [header addSubview:plusImageView];
        return header;
    }
    if (section == 2) {
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, (44-21)/2, 200, 21)];
        titleLabel.text = @"图片(提供问题截图)";
        [header addSubview:titleLabel];
        return header;
    }
    if (section == 3) {
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, (44-21)/2, 200, 21)];
        titleLabel.text = @"问题描述";
        [header addSubview:titleLabel];
        return header;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 1 || section == 2 || section == 3) {
        return 44;
    }
    return CGFLOAT_MIN;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == 0) {
        return 6;
    }
    return CGFLOAT_MIN;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger section = indexPath.section;
    if (section == 2) {
        return (self.imageArray.count/PICS_PER_LINE+1)*PIC_WIDTH_HEIGHT+(self.imageArray.count/PICS_PER_LINE+1+1)*10;
    }
    if (section == 3) {
        return 96;
    }
    return 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *CELLID;
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    if (section == 0) {
        CELLID = @"BASEINFOCELL";
    } else if (section == 1) {
        CELLID = @"DEVICECELL";
    } else if (section == 2) {
        CELLID = @"PICCELL";
    } else if (section == 3) {
        CELLID = @"PROBLEMCELL";
    }
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CELLID forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CELLID];
    }
    if (section == 0) {
        UILabel *keyLabel = [cell viewWithTag:1];
        UILabel *valueLabel = [cell viewWithTag:2];
        if (row==0) {
            keyLabel.text = @"申请人";
            valueLabel.text = @"叶雨";
        } else if (row==1) {
            keyLabel.text = @"联系电话";
            valueLabel.text = @"叶雨";
        } else if (row==2) {
            keyLabel.text = @"部门";
            valueLabel.text = @"";
        } else if (row==3) {
            keyLabel.text = @"位置";
            valueLabel.text = @"";
        } else if (row==4) {
            keyLabel.text = @"服务类型";
            valueLabel.text = @"";
        } else if (row==5) {
            keyLabel.text = @"工单类型";
            valueLabel.text = @"";
        } else if (row==6) {
            keyLabel.text = @"优先级";
            valueLabel.text = @"";
        }
    } else if (section == 1) {
        
    } else if (section == 2) {
        picCell = cell;
        [self showAddImageView];
    } else if (section == 3) {
        PRPlaceHolderTextView *textView = [cell viewWithTag:1];
        textView.placeholder = @"请简要描述";
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableView setSeparatorInset:UIEdgeInsetsMake(0,10,0,0)];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)])  {
        [self.tableView setLayoutMargins:UIEdgeInsetsMake(0,10,0,0)];
    }
}

@end
