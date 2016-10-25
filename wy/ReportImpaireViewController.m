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
#import "ChooseDeviceViewController.h"
#import "ChoosePositionViewController.h"
#import "AppDelegate.h"
#import "ReportImpaireService.h"

#define IMAGESPLIT_WIDTH 10
#define MAX_IMAGES_NUM 4
#define PICS_PER_LINE 4

@interface ReportImpaireViewController ()<UITableViewDataSource,UITableViewDelegate, UIActionSheetDelegate, SkimPhotoViewDelegate, ELCImagePickerControllerDelegate, ChooseDeviceViewDelegate, ChoosePositionViewDelegate, UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation ReportImpaireViewController {
    NSMutableArray *deviceArr;
    NSInteger PIC_WIDTH_HEIGHT;
    UITableViewCell *picCell;
    UIImageView *addImageView;
    NSMutableDictionary *selectedDevicesDic;
    PositionEntity *position;
    NSInteger serviceType;
    NSString *serviceTypeText;
    NSInteger priority;
    NSString *priorityText;
    ReportImpaireService *reportImpaireService;
    PRPlaceHolderTextView *descTextView;
    NSString *descText;
    NSString *username;
    NSString *name;
    NSString *mobile;
    NSString *department;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    name = [userDefaults objectForKey:@"Name"];
    username = [userDefaults objectForKey:@"userName"];
    mobile = [userDefaults objectForKey:@"Mobile"];
    department = [userDefaults objectForKey:@"Department"];
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    deviceArr = [[NSMutableArray alloc] init];
    selectedDevicesDic = [[NSMutableDictionary alloc] init];
    
    self.imageArray = [[NSMutableArray alloc] init];
    self.imageViewArray = [[NSMutableArray alloc] init];
    PIC_WIDTH_HEIGHT = (SCREEN_WIDTH-IMAGESPLIT_WIDTH*PICS_PER_LINE-10)/PICS_PER_LINE;
    
    reportImpaireService = [[ReportImpaireService alloc] init];

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
    if (self.imageArray.count>=MAX_IMAGES_NUM) {
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
    if (actionSheet.tag == 1) {
        if (buttonIndex == 0)
        {
            
            UIStoryboard* mainSB = [UIStoryboard storyboardWithName:@"Camera" bundle:[NSBundle mainBundle]];
            
            AAPLCameraViewController* cameraViewController = [mainSB instantiateViewControllerWithIdentifier:@"camera"];
            
            [self presentViewController:cameraViewController animated:YES completion:nil];
        }
        else if (buttonIndex == 1)
        {
            ELCImagePickerController * elcPicker = [[ELCImagePickerController alloc] initImagePicker];
            elcPicker.maximumImagesCount = MAX_IMAGES_NUM - self.imageArray.count; //Set the maximum number of images to select to 100
            elcPicker.returnsOriginalImage = YES; //Only return the fullScreenImage, not the fullResolutionImage
            elcPicker.returnsImage = YES; //Return UIimage if YES. If NO, only return asset location information
            elcPicker.onOrder = YES; //For multiple image selection, display and return order of selected images
            elcPicker.isTrim = YES;
            elcPicker.mediaTypes = @[(NSString *)kUTTypeImage]; //Supports image and movie types
            elcPicker.imagePickerDelegate = self;
            
            [self presentViewController:elcPicker animated:YES completion:nil];
        }
    } else if (actionSheet.tag == 2) {
        if (buttonIndex==4) {
            return;
        }
        serviceType = buttonIndex+1;
        [self.tableView reloadData];
    } else if (actionSheet.tag == 3) {
        if (buttonIndex==4) {
            return;
        }
        priority = buttonIndex+1;
        [self.tableView reloadData];
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
    UIStoryboard* mainSB = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    ChooseDeviceViewController *chooseDeviceViewController = [mainSB instantiateViewControllerWithIdentifier:@"CHOOSEDEVICE"];
    chooseDeviceViewController.delegate = self;
    chooseDeviceViewController.selectedDevicesDic = selectedDevicesDic;
    [self.navigationController pushViewController:chooseDeviceViewController animated:YES];
}

- (void)deleteDevice:(UITapGestureRecognizer *)recognizer
{
    if ([recognizer.view isKindOfClass:[UIButton class]]) {
        UIButton *imageView = (UIButton *)recognizer.view;
        UITableViewCell *cell = (UITableViewCell *)[[[imageView superview] superview] superview];
        NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
        [deviceArr removeObjectAtIndex:indexPath.row];
        NSMutableArray *newDevices = [[NSMutableArray alloc] initWithArray:deviceArr];
        [self showSelectedDevices:newDevices];
    }
}

- (void)showSelectedDevices:(NSArray *)deviceArray {
    deviceArr = [[NSMutableArray alloc] initWithArray:deviceArray];
    [selectedDevicesDic removeAllObjects];
    for (unsigned i = 0; i < deviceArr.count; i++) {
        DeviceEntity *device = (DeviceEntity *)deviceArr[i];
        [selectedDevicesDic setObject:device forKey:device.Code];
    }
    [self.tableView reloadData];
}

- (void)showSelectedPositions:(PositionEntity *) selectedPosition {
    position = selectedPosition;
    [self.tableView reloadData];
}

- (void)textViewDidChange:(UITextView *)textView {
    UITableViewCell *cell = (UITableViewCell *)[[textView superview] superview];
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    NSInteger section = indexPath.section;
    
    if (section == 3) {
        descText = textView.text;
    }
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
        if (row==0 || row==1 || row==2 || row==4) {
            CELLID = @"BASEINFOCELL2";
        }
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
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (section == 0) {
        UILabel *keyLabel = [cell viewWithTag:1];
        UILabel *valueLabel = [cell viewWithTag:2];
        if (row==0) {
            keyLabel.text = @"申请人";
            valueLabel.text = name;
        } else if (row==1) {
            keyLabel.text = @"联系电话";
            valueLabel.text = mobile;
        } else if (row==2) {
            keyLabel.text = @"部门";
            valueLabel.text = department;
        } else if (row==3) {
            keyLabel.text = @"服务类型";
            serviceTypeText = [serviceTypeDic objectForKey:[NSString stringWithFormat:@"%ld", serviceType]];
            if (serviceTypeText) {
                valueLabel.text = serviceTypeText;
            } else {
                NSMutableAttributedString *attri = [[NSMutableAttributedString alloc] initWithString:@""];
                NSTextAttachment *attch = [[NSTextAttachment alloc] init];
                attch.image = [UIImage imageNamed:@"arrow-right"];
                attch.bounds = CGRectMake(0, 0, 7, 12);
                NSAttributedString *string = [NSAttributedString attributedStringWithAttachment:attch];
                [attri appendAttributedString:string];
                valueLabel.attributedText = attri;
            }
        } else if (row==4) {
            keyLabel.text = @"任务类型";
            valueLabel.text = @"工单任务";
        } else if (row==5) {
            keyLabel.text = @"优先级";
            priorityText = [priorityDic objectForKey:[NSString stringWithFormat:@"%ld", priority]];
            if (priorityText) {
                valueLabel.text = priorityText;
            } else {
                NSMutableAttributedString *attri = [[NSMutableAttributedString alloc] initWithString:@""];
                NSTextAttachment *attch = [[NSTextAttachment alloc] init];
                attch.image = [UIImage imageNamed:@"arrow-right"];
                attch.bounds = CGRectMake(0, 0, 7, 12);
                NSAttributedString *string = [NSAttributedString attributedStringWithAttachment:attch];
                [attri appendAttributedString:string];
                valueLabel.attributedText = attri;
            }
        } else if (row==6) {
            keyLabel.text = @"位置";
            if (position) {
                valueLabel.text = position.Name;
            } else {
                NSMutableAttributedString *attri = [[NSMutableAttributedString alloc] initWithString:@""];
                NSTextAttachment *attch = [[NSTextAttachment alloc] init];
                attch.image = [UIImage imageNamed:@"arrow-right"];
                attch.bounds = CGRectMake(0, 0, 7, 12);
                NSAttributedString *string = [NSAttributedString attributedStringWithAttachment:attch];
                [attri appendAttributedString:string];
                valueLabel.attributedText = attri;
            }
        }
    } else if (section == 1) {
        DeviceEntity *device = deviceArr[row];
        UILabel *nameLabel = [cell viewWithTag:1];
        nameLabel.text = device.Name;
        UIImageView *deleteView = [cell viewWithTag:2];
        UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(deleteDevice:)];
        [deleteView addGestureRecognizer:gesture];
        [deleteView setUserInteractionEnabled:YES];
    } else if (section == 2) {
        picCell = cell;
        [self showAddImageView];
    } else if (section == 3) {
        descTextView = [cell viewWithTag:1];
        descTextView.placeholder = @"请简要描述";
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    if (section==0 && row==6) {
        UIStoryboard* mainSB = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
        ChoosePositionViewController *choosePositionViewController = [mainSB instantiateViewControllerWithIdentifier:@"CHOOSEPOSITION"];
        choosePositionViewController.delegate = self;
        [self.navigationController pushViewController:choosePositionViewController animated:YES];
    } else if (section==0 && row==3) {
        UIActionSheet* changeImageSheet = [[UIActionSheet alloc]initWithTitle:@"请选择" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"工程服务",@"安保服务",@"保洁服务",@"其他服务", nil];
        changeImageSheet.tag=2;
        [changeImageSheet showInView:self.view];
    } else if (section==0 && row==5) {
        UIActionSheet* changeImageSheet = [[UIActionSheet alloc]initWithTitle:@"请选择" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"低",@"中",@"高",@"紧急", nil];
        changeImageSheet.tag=3;
        [changeImageSheet showInView:self.view];
    }
    
    [self.tableView deselectRowAtIndexPath:indexPath animated:NO];
}

- (IBAction)releaseImpaire:(id)sender {
    NSMutableDictionary *dataDic = [[NSMutableDictionary alloc] init];
    
    [dataDic setObject:username  forKey:@"Applyer"];
    [dataDic setObject:mobile?@"":mobile  forKey:@"ApplyerTel"];
    if (!serviceTypeText || [serviceTypeText isBlankString]) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"请选择服务类型" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:nil];
        [alertController addAction:okAction];
        [self presentViewController:alertController animated:YES completion:nil];
        return;
    }
    [dataDic setObject:serviceTypeText forKey:@"ServiceType"];
    
    if (!priorityText || [priorityText isBlankString]) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"请选择优先级" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:nil];
        [alertController addAction:okAction];
        [self presentViewController:alertController animated:YES completion:nil];
        return;
    }
    [dataDic setObject:priorityText forKey:@"Priority"];
    
    if (!position || [position.Code isBlankString]) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"请选择位置" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:nil];
        [alertController addAction:okAction];
        [self presentViewController:alertController animated:YES completion:nil];
        return;
    }
    [dataDic setObject:position?position.Code:@"" forKey:@"Location"];
    [dataDic setObject:descText?descText:@"" forKey:@"Description"];
    NSMutableString *deviceCodesStr = [[NSMutableString alloc] init];
    for (int i=0; i<deviceArr.count; i++) {
        DeviceEntity *device = (DeviceEntity *)deviceArr[i];
        [deviceCodesStr appendString:device.Code];
        if (i!=deviceArr.count-1) {
            [deviceCodesStr appendString:@","];
        }
    }
    [dataDic setObject:deviceCodesStr forKey:@"SBName"];
    [reportImpaireService submitImpaire:dataDic withImage:self.imageArray success:^{
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"报障数据提交成功！" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self.navigationController popViewControllerAnimated:YES];
        }];
        [alertController addAction:okAction];
        [self presentViewController:alertController animated:YES completion:nil];
    } failure:^(NSString *message) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"报障数据提交失败！" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self.navigationController popViewControllerAnimated:YES];
        }];
        [alertController addAction:okAction];
        [self presentViewController:alertController animated:YES completion:nil];
    }];
}

@end
