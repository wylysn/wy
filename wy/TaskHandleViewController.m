//
//  TaskHandleViewController.m
//  wy
//
//  Created by wangyilu on 16/8/31.
//  Copyright © 2016年 ___PURANG___. All rights reserved.
//

#import "TaskHandleViewController.h"
#import "PRPlaceHolderTextView.h"
#import "DeviceListEntity.h"
#import "PersonEntity.h"
#import "AAPLCameraViewController.h"
#import "SkimPhotoViewController.h"
#import "ELCImagePickerController.h"
#import "UIImage+Resolution.h"
#import "ChooseDeviceViewController.h"
#import "ChoosePersonViewController.h"

#define IMAGESPLIT_WIDTH 10
#define MAX_IMAGES_NUM 5
#define PICS_PER_LINE 4

@interface TaskHandleViewController ()<UITableViewDataSource,UITableViewDelegate, UIActionSheetDelegate, SkimPhotoViewDelegate, ELCImagePickerControllerDelegate, ChooseDeviceViewDelegate, ChoosePersonViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation TaskHandleViewController {
    NSMutableArray *deviceArr;
    NSInteger PIC_WIDTH_HEIGHT;
    UITableViewCell *picCell;
    UIImageView *addImageView;
    NSMutableDictionary *selectedDevicesDic;
    NSMutableDictionary *selectedChargesDic;
    NSMutableArray *chargePersonArr;
    NSMutableDictionary *selectedExcutesDic;
    NSMutableArray *excutePersonArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
        
    deviceArr = [[NSMutableArray alloc] init];
    selectedDevicesDic = [[NSMutableDictionary alloc] init];
    selectedChargesDic = [[NSMutableDictionary alloc] init];
    chargePersonArr = [[NSMutableArray alloc] init];
    selectedExcutesDic = [[NSMutableDictionary alloc] init];
    excutePersonArr = [[NSMutableArray alloc] init];
    
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
        DeviceListEntity *device = (DeviceListEntity *)deviceArr[i];
        [selectedDevicesDic setObject:device forKey:device.code];
    }
    [self.tableView reloadData];
}

- (IBAction)addPersonInCharge:(id)sender {
    [self toChoosePerson:1];
}
- (IBAction)addPersonInExcute:(id)sender {
    [self toChoosePerson:2];
}
- (void)toChoosePerson:(int)type {
    UIStoryboard* taskSB = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    ChoosePersonViewController *choosePersonViewController = [taskSB instantiateViewControllerWithIdentifier:@"CHOOSEPERSON"];
    choosePersonViewController.delegate = self;
    choosePersonViewController.type = type;
    if (type==1) {
        choosePersonViewController.selectedPersonsDic = selectedChargesDic;
    } else {
        choosePersonViewController.selectedPersonsDic = selectedChargesDic;
    }
    [self.navigationController pushViewController:choosePersonViewController animated:YES];
}

- (void)showSelectedPersons:(NSArray *)persons withType:(int)type {
    if (type == 1) {
        chargePersonArr = [[NSMutableArray alloc] initWithArray:persons];
        [selectedChargesDic removeAllObjects];
        for (unsigned i = 0; i < chargePersonArr.count; i++) {
            PersonEntity *person = (PersonEntity *)chargePersonArr[i];
            [selectedChargesDic setObject:person forKey:person.AppUserName];
        }
        [self.tableView reloadData];
    } else {
        excutePersonArr = [[NSMutableArray alloc] initWithArray:persons];
        [selectedChargesDic removeAllObjects];
        for (unsigned i = 0; i < excutePersonArr.count; i++) {
            PersonEntity *person = (PersonEntity *)excutePersonArr[i];
            [selectedChargesDic setObject:person forKey:person.AppUserName];
        }
        [self.tableView reloadData];
    }
}

- (void)deleteChargePerson:(UITapGestureRecognizer *)recognizer
{
    if ([recognizer.view isKindOfClass:[UIButton class]]) {
        UIButton *imageView = (UIButton *)recognizer.view;
        UITableViewCell *cell = (UITableViewCell *)[[[imageView superview] superview] superview];
        NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
        [chargePersonArr removeObjectAtIndex:indexPath.row];
        NSMutableArray *newPersons = [[NSMutableArray alloc] initWithArray:chargePersonArr];
        [self showSelectedPersons:newPersons withType:1];
    }
}

- (void)deleteExcutePerson:(UITapGestureRecognizer *)recognizer
{
    if ([recognizer.view isKindOfClass:[UIButton class]]) {
        UIButton *imageView = (UIButton *)recognizer.view;
        UITableViewCell *cell = (UITableViewCell *)[[[imageView superview] superview] superview];
        NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
        [excutePersonArr removeObjectAtIndex:indexPath.row];
        NSMutableArray *newPersons = [[NSMutableArray alloc] initWithArray:excutePersonArr];
        [self showSelectedPersons:newPersons withType:2];
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 7;
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
    } else if (section == 4) {
        return 1;
    } else if (section == 5) {
        return chargePersonArr.count;
    } else if (section == 6) {
        return excutePersonArr.count;
    }
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 44)];
    if (section == 0) {
        header.backgroundColor = [UIColor whiteColor];
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, (44-21)/2, 200, 21)];
        titleLabel.text = @"PM00000001";
        [header addSubview:titleLabel];
        return header;
    }
    if (section == 1) {
        header.backgroundColor = [UIColor whiteColor];
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, (44-21)/2, 200, 21)];
        titleLabel.text = @"故障设备";
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
        titleLabel.text = @"图片(问题截图)";
        [header addSubview:titleLabel];
        return header;
    }
    if (section == 3) {
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, (44-21)/2, 200, 21)];
        titleLabel.text = @"问题描述";
        [header addSubview:titleLabel];
        return header;
    }
    if (section == 4) {
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, (44-21)/2, 200, 21)];
        titleLabel.text = @"工作内容";
        [header addSubview:titleLabel];
        return header;
    }
    if (section == 5) {
        header.backgroundColor = [UIColor whiteColor];
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, (44-21)/2, 200, 21)];
        titleLabel.text = @"负责人";
        [header addSubview:titleLabel];
        
        UIButton *addChargeBtn = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-65, (44-25)/2, 50, 25)];
        [addChargeBtn setTitle:@"添加" forState:UIControlStateNormal];
        [addChargeBtn addTarget:self action:@selector(addPersonInCharge:) forControlEvents:UIControlEventTouchUpInside];
        addChargeBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        addChargeBtn.tintColor = [UIColor whiteColor];
        addChargeBtn.backgroundColor = [UIColor colorFromHexCode:BUTTON_GREEN_COLOR];
        addChargeBtn.layer.cornerRadius = 3;
        [header addSubview:addChargeBtn];
        
        return header;
    }
    if (section == 6) {
        header.backgroundColor = [UIColor whiteColor];
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, (44-21)/2, 200, 21)];
        titleLabel.text = @"执行人";
        [header addSubview:titleLabel];
        
        UIButton *addExcuteBtn = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-65, (44-25)/2, 50, 25)];
        [addExcuteBtn setTitle:@"添加" forState:UIControlStateNormal];
        [addExcuteBtn addTarget:self action:@selector(addPersonInExcute:) forControlEvents:UIControlEventTouchUpInside];
        addExcuteBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        addExcuteBtn.tintColor = [UIColor whiteColor];
        addExcuteBtn.backgroundColor = [UIColor colorFromHexCode:BUTTON_GREEN_COLOR];
        addExcuteBtn.layer.cornerRadius = 3;
        [header addSubview:addExcuteBtn];
        
        return header;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 44;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == 0 || section == 3 || section == 4 || section == 5) {
        return 6;
    }
    return CGFLOAT_MIN;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger section = indexPath.section;
    if (section == 2) {
        return (self.imageArray.count/PICS_PER_LINE+1)*PIC_WIDTH_HEIGHT+(self.imageArray.count/PICS_PER_LINE+1+1)*10;
    }
    if (section == 3 || section == 4) {
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
    } else if (section == 1 || section == 5 || section == 6) {
        CELLID = @"DEVICECELL";
    } else if (section == 2) {
        CELLID = @"PICCELL";
    } else if (section == 3) {
        CELLID = @"DESCCELL";
    } else if (section == 4) {
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
            keyLabel.text = @"创建时间";
            valueLabel.text = @"13888888888";
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
        DeviceListEntity *device = deviceArr[row];
        UILabel *nameLabel = [cell viewWithTag:1];
        nameLabel.text = device.name;
        UIImageView *deleteView = [cell viewWithTag:2];
        UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(deleteDevice:)];
        [deleteView addGestureRecognizer:gesture];
        [deleteView setUserInteractionEnabled:YES];
    } else if (section == 2) {
        picCell = cell;
        [self showAddImageView];
    } else if (section == 3) {
        PRPlaceHolderTextView *textView = [cell viewWithTag:1];
        textView.placeholder = @"请简要描述";
    } else if (section == 4) {
        PRPlaceHolderTextView *textView = [cell viewWithTag:1];
        textView.placeholder = @"请简要填写工作内容";
    } else if (section == 5) {
        PersonEntity *person = chargePersonArr[row];
        UILabel *nameLabel = [cell viewWithTag:1];
        nameLabel.text = person.EmployeeName;
        UIImageView *deleteView = [cell viewWithTag:2];
        UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(deleteChargePerson:)];
        [deleteView addGestureRecognizer:gesture];
        [deleteView setUserInteractionEnabled:YES];
    } else if (section == 6) {
        PersonEntity *person = excutePersonArr[row];
        UILabel *nameLabel = [cell viewWithTag:1];
        nameLabel.text = person.EmployeeName;
        UIImageView *deleteView = [cell viewWithTag:2];
        UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(deleteExcutePerson:)];
        [deleteView addGestureRecognizer:gesture];
        [deleteView setUserInteractionEnabled:YES];
    }
    
    return cell;
}

@end
