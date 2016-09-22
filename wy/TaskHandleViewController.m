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
#import "TaskService.h"
#import "PRActionSheetPickerView.h"

#define IMAGESPLIT_WIDTH 10
#define MAX_IMAGES_NUM 5
#define PICS_PER_LINE 4

static NSString *startTimeBtnPlaceholder = @"请输入到场时间";
static NSString *endTimeBtnPlaceholder = @"请输入结束时间";

@interface TaskHandleViewController ()<UITableViewDataSource,UITableViewDelegate, UIActionSheetDelegate, SkimPhotoViewDelegate, ELCImagePickerControllerDelegate, ChooseDeviceViewDelegate, ChoosePersonViewDelegate, PRActionSheetPickerViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomViewConstraint;

@property (strong, nonatomic) UIButton *startTimeBtn;
@property (strong, nonatomic) UIButton *endTimeBtn;
@property (strong, nonatomic) UILabel *timeDiffLabel;

@end

@implementation TaskHandleViewController {
    UIWindow *window;
    NSInteger btnTag;
    
    NSMutableArray *deviceArr;
    NSInteger PIC_WIDTH_HEIGHT;
    UITableViewCell *picCell;
    UIImageView *addImageView;
    NSMutableDictionary *selectedDevicesDic;
    NSMutableDictionary *selectedChargesDic;
    NSMutableArray *chargePersonArr;
    NSMutableDictionary *selectedExcutesDic;
    NSMutableArray *excutePersonArr;
    
    TaskService *taskService;
    TaskEntity *taskEntity;
    NSArray *editFieldsArray;
    
    BOOL isDescriptionEditable;
    BOOL isWorkContentEditable;
    BOOL isLeaderEditable;
    BOOL isExecutorsEditable;
    BOOL isEStartTimeEditable;
    BOOL isEEndTimeEditable;
    BOOL isEWorkHoursEditable;
    BOOL isSBListEditable;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    taskService = [[TaskService alloc] init];
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.estimatedRowHeight = 44;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    
    deviceArr = [[NSMutableArray alloc] init];
    selectedDevicesDic = [[NSMutableDictionary alloc] init];
    selectedChargesDic = [[NSMutableDictionary alloc] init];
    chargePersonArr = [[NSMutableArray alloc] init];
    selectedExcutesDic = [[NSMutableDictionary alloc] init];
    excutePersonArr = [[NSMutableArray alloc] init];
    
    [taskService getTaskEntity:self.code success:^(TaskEntity *task){
        taskEntity = task;
        
        /*暂定这种格式*/
        if (taskEntity.SBList && ![@"" isEqualToString:taskEntity.SBList]) {
            NSArray *deviceNameArr = [NSString convertStringToArray:taskEntity.TaskAction];
            for (NSString *deviceName in deviceNameArr) {
                DeviceListEntity *device = [[DeviceListEntity alloc] initWithDictionary:@{@"Name":deviceName}];
                [deviceArr addObject:device];
            }
        }
        
        //判断是否有操作，生成操作按钮
        if (taskEntity.TaskAction) {
            NSArray *actionsArr = [NSString convertStringToArray:taskEntity.TaskAction];
            NSMutableArray *actionsMutableArr = [[NSMutableArray alloc] initWithArray:actionsArr];
            if (taskEntity.IsLocalSave) {
                NSDictionary *saveDic = [[NSDictionary alloc] initWithObjectsAndKeys:@{@"EventName":@"FormSave",@"DisplayName":@"保存", @"flag":@100}, nil];
                [actionsMutableArr insertObject:saveDic atIndex:0];
            }
            if (actionsMutableArr && actionsMutableArr.count>0) {
                self.bottomViewConstraint.constant = 0;
                NSInteger actionNum = actionsMutableArr.count;
                float btnWidth;
                float space = 15;
                btnWidth = (SCREEN_WIDTH-space*(actionNum>=3?3:actionNum+1))/actionNum;
                float btnHeight = 30;
                float y = (55-btnHeight)/2;
                
                if (actionsMutableArr.count>3) {
                    UIButton *moreBtn = [[UIButton alloc] initWithFrame:CGRectMake(space, y, btnWidth, btnHeight)];
                    [moreBtn setTitle:@"更多" forState:UIControlStateNormal];
                    moreBtn.backgroundColor = [UIColor colorFromHexCode:BUTTON_ORANGE_COLOR];
                    moreBtn.layer.cornerRadius = 5;
                    [self.bottomView addSubview:moreBtn];
                } else if (actionsMutableArr.count==3) {
                    UIButton *btn3 = [[UIButton alloc] initWithFrame:CGRectMake(space, y, btnWidth, btnHeight)];
                    [btn3 setTitle:actionsArr[2][@"DisplayName"] forState:UIControlStateNormal];
                    btn3.backgroundColor = [UIColor colorFromHexCode:BUTTON_ORANGE_COLOR];
                    btn3.layer.cornerRadius = 5;
                    [self.bottomView addSubview:btn3];
                }
                if (actionsMutableArr.count>=3) {
                    UIButton *btn1 = [[UIButton alloc] initWithFrame:CGRectMake(space*2+btnWidth, y, btnWidth, btnHeight)];
                    [btn1 setTitle:actionsArr[0][@"DisplayName"] forState:UIControlStateNormal];
                    btn1.backgroundColor = [UIColor colorFromHexCode:BUTTON_BLUE_COLOR];
                    btn1.layer.cornerRadius = 5;
                    [self.bottomView addSubview:btn1];
                    
                    UIButton *btn2 = [[UIButton alloc] initWithFrame:CGRectMake(space*3+btnWidth*2, y, btnWidth, btnHeight)];
                    [btn2 setTitle:actionsArr[1][@"DisplayName"] forState:UIControlStateNormal];
                    btn2.backgroundColor = [UIColor colorFromHexCode:BUTTON_GREEN_COLOR];
                    btn2.layer.cornerRadius = 5;
                    [self.bottomView addSubview:btn2];
                } else {
                    UIButton *btn1 = [[UIButton alloc] initWithFrame:CGRectMake(space, y, btnWidth, btnHeight)];
                    [btn1 setTitle:actionsArr[0][@"DisplayName"] forState:UIControlStateNormal];
                    btn1.backgroundColor = [UIColor colorFromHexCode:BUTTON_BLUE_COLOR];
                    btn1.layer.cornerRadius = 5;
                    [self.bottomView addSubview:btn1];
                    
                    if (actionsMutableArr.count==2) {
                        UIButton *btn2 = [[UIButton alloc] initWithFrame:CGRectMake(space*2+btnWidth, y, btnWidth, btnHeight)];
                        [btn2 setTitle:actionsArr[1][@"DisplayName"] forState:UIControlStateNormal];
                        btn2.backgroundColor = [UIColor colorFromHexCode:BUTTON_GREEN_COLOR];
                        btn2.layer.cornerRadius = 5;
                        [self.bottomView addSubview:btn2];
                    }
                }
            }
        }
        
        editFieldsArray = [[[task.EditFields stringByReplacingOccurrencesOfString:@"[" withString:@""] stringByReplacingOccurrencesOfString:@"]" withString:@""] componentsSeparatedByString:@";"];
        isDescriptionEditable = !([editFieldsArray indexOfObject:@"Description"]==NSNotFound);
        isWorkContentEditable = !([editFieldsArray indexOfObject:@"WorkContent"]==NSNotFound);
        isLeaderEditable = !([editFieldsArray indexOfObject:@"Leader"]==NSNotFound);
        isExecutorsEditable = !([editFieldsArray indexOfObject:@"Executors"]==NSNotFound);
        isEStartTimeEditable = !([editFieldsArray indexOfObject:@"EStartTime"]==NSNotFound);
        isEEndTimeEditable = !([editFieldsArray indexOfObject:@"EEndTime"]==NSNotFound);
        isEWorkHoursEditable = !([editFieldsArray indexOfObject:@"EWorkHours"]==NSNotFound);
        isSBListEditable = !([editFieldsArray indexOfObject:@"SBList"]==NSNotFound);
        [self.tableView reloadData];
    } failure:^(NSString *message) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:message preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:nil];
        [alertController addAction:okAction];
        [self presentViewController:alertController animated:YES completion:nil];
    }];
    
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
        [selectedDevicesDic setObject:device forKey:device.Code];
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
    return 8;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 7;
    } else if (section == 1) {
        return deviceArr.count;
    }
//    else if (section == 2) {  //图片暂时不加
//        return 1;
//    }
    else if (section == 2) {
        return 1;
    } else if (section == 3) {
        return 1;
    } else if (section == 4) {
        return chargePersonArr.count;
    } else if (section == 5) {
        return excutePersonArr.count;
    } else if (section == 6) {
        return 2;
    }
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 44)];
    if (section == 0) {
        header.backgroundColor = [UIColor whiteColor];
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, (44-21)/2, 200, 21)];
        titleLabel.text = taskEntity.Code;
        [header addSubview:titleLabel];
        return header;
    } else if (section == 1) {
        header.backgroundColor = [UIColor whiteColor];
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, (44-21)/2, 200, 21)];
        titleLabel.text = @"故障设备";
        [header addSubview:titleLabel];
        if (isSBListEditable) {
            UIImageView *plusImageView = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-35, (44-25)/2, 25, 25)];
            plusImageView.image = [UIImage imageNamed:@"plus50"];
            UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(addDevice:)];
            [plusImageView addGestureRecognizer:gesture];
            [plusImageView setUserInteractionEnabled:YES];
            [header addSubview:plusImageView];
        }
        return header;
    }
    /*
    else if (section == 2) {
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, (44-21)/2, 200, 21)];
        titleLabel.text = @"图片(问题截图)";
        [header addSubview:titleLabel];
        return header;
    }
     */
    else if (section == 2) {
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, (44-21)/2, 200, 21)];
        titleLabel.text = @"问题描述";
        [header addSubview:titleLabel];
        return header;
    } else if (section == 3) {
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, (44-21)/2, 200, 21)];
        titleLabel.text = @"工作内容";
        [header addSubview:titleLabel];
        return header;
    } else if (section == 4) {
        header.backgroundColor = [UIColor whiteColor];
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, (44-21)/2, 200, 21)];
        titleLabel.text = @"负责人";
        [header addSubview:titleLabel];
        
        if (isLeaderEditable) {
            UIButton *addChargeBtn = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-65, (44-25)/2, 50, 25)];
            [addChargeBtn setTitle:@"添加" forState:UIControlStateNormal];
            [addChargeBtn addTarget:self action:@selector(addPersonInCharge:) forControlEvents:UIControlEventTouchUpInside];
            addChargeBtn.titleLabel.font = [UIFont systemFontOfSize:15];
            addChargeBtn.tintColor = [UIColor whiteColor];
            addChargeBtn.backgroundColor = [UIColor colorFromHexCode:BUTTON_GREEN_COLOR];
            addChargeBtn.layer.cornerRadius = 3;
            [header addSubview:addChargeBtn];
        }
        
        return header;
    } else if (section == 5) {
        header.backgroundColor = [UIColor whiteColor];
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, (44-21)/2, 200, 21)];
        titleLabel.text = @"执行人";
        [header addSubview:titleLabel];
        
        if (isExecutorsEditable) {
            UIButton *addExcuteBtn = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-65, (44-25)/2, 50, 25)];
            [addExcuteBtn setTitle:@"添加" forState:UIControlStateNormal];
            [addExcuteBtn addTarget:self action:@selector(addPersonInExcute:) forControlEvents:UIControlEventTouchUpInside];
            addExcuteBtn.titleLabel.font = [UIFont systemFontOfSize:15];
            addExcuteBtn.tintColor = [UIColor whiteColor];
            addExcuteBtn.backgroundColor = [UIColor colorFromHexCode:BUTTON_GREEN_COLOR];
            addExcuteBtn.layer.cornerRadius = 3;
            [header addSubview:addExcuteBtn];
        }
        
        return header;
    } else if (section == 6) {
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, (44-21)/2, 200, 21)];
        titleLabel.text = @"预估工作时间";
        [header addSubview:titleLabel];
        
        return header;
    } else if (section == 7) {
        header.backgroundColor = [UIColor whiteColor];
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, (44-21)/2, 200, 21)];
        titleLabel.text = @"耗时";
        [header addSubview:titleLabel];
        
        UILabel *timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-40-40-2, (44-21)/2, 40, 21)];
        timeLabel.text = taskEntity.EWorkHours;
        timeLabel.textColor = [UIColor colorFromHexCode:@"555555"];
        timeLabel.textAlignment = NSTextAlignmentRight;
        self.timeDiffLabel = timeLabel;
        UILabel *unitLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-40-2, (44-21)/2, 40, 21)];
        unitLabel.textColor = [UIColor colorFromHexCode:@"555555"];
        unitLabel.text = @"小时";
        
        [header addSubview:timeLabel];
        [header addSubview:unitLabel];
        
        return header;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 44;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == 0 || section == 2 || section == 3 || section == 4 || section == 6) {
        return 6;
    }
    return CGFLOAT_MIN;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger section = indexPath.section;
    /*
    if (section == 2) {
        return (self.imageArray.count/PICS_PER_LINE+1)*PIC_WIDTH_HEIGHT+(self.imageArray.count/PICS_PER_LINE+1+1)*10;
    } else
     */
    if (section == 2) {
        if (isDescriptionEditable) {
            return 96;
        } else {
            return UITableViewAutomaticDimension;
        }
    } else if (section == 3) {
        if (isWorkContentEditable) {
            return 96;
        } else {
            return UITableViewAutomaticDimension;
        }
    }
    return 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *CELLID;
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    if (section == 0) {
        CELLID = @"BASEINFOCELL";
    } else if (section == 1 || section == 4 || section == 5) {
        CELLID = @"DEVICECELL";
    }
    /*
    else if (section == 2) {
        CELLID = @"PICCELL";
    }
     */
    else if (section == 2) {
        if (isDescriptionEditable) {
            CELLID = @"DESCCELL";
        } else {
            CELLID = @"DESCCELL2";
        }
    } else if (section == 3) {
        if (isDescriptionEditable) {
            CELLID = @"PROBLEMCELL";
        } else {
            CELLID = @"PROBLEMCELL2";
        }
    } else if (section == 6) {
        CELLID = @"ESTIMATECELL";
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
            valueLabel.text = taskEntity.Applyer;
        } else if (row==1) {
            keyLabel.text = @"创建时间";
            valueLabel.text = taskEntity.CreateDate;
        } else if (row==2) {
            keyLabel.text = @"部门";
            valueLabel.text = taskEntity.Department;
        } else if (row==3) {
            keyLabel.text = @"位置";
            valueLabel.text = taskEntity.Location;
        } else if (row==4) {
            keyLabel.text = @"服务类型";
            valueLabel.text = taskEntity.ServiceType;
        } else if (row==5) {
            keyLabel.text = @"工单类型";
            valueLabel.text = shortTitleDic[self.ShortTitle];
        } else if (row==6) {
            keyLabel.text = @"优先级";
            valueLabel.text = taskEntity.Priority;
        }
    } else if (section == 1) {
        DeviceListEntity *device = deviceArr[row];
        UILabel *nameLabel = [cell viewWithTag:1];
        nameLabel.text = device.Name;
        UIImageView *deleteView = [cell viewWithTag:2];
        if (isSBListEditable) {
            deleteView.hidden = NO;
            UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(deleteDevice:)];
            [deleteView addGestureRecognizer:gesture];
            [deleteView setUserInteractionEnabled:YES];
        } else {
            deleteView.hidden = YES;
        }
    }
    /*
    else if (section == 2) {
        picCell = cell;
        [self showAddImageView];
    }
     */
    else if (section == 2) {
        PRPlaceHolderTextView *textView = [cell viewWithTag:1];
        if ([editFieldsArray indexOfObject:@"Description"] == NSNotFound) {
            textView.text = taskEntity.Description;
        } else {
            if ([@"" isEqualToString:taskEntity.Description]) {
                textView.placeholder = @"请简要描述";
            } else {
                textView.text = taskEntity.Description;
            }
        }
    } else if (section == 3) {
        PRPlaceHolderTextView *textView = [cell viewWithTag:1];
        if ([editFieldsArray indexOfObject:@"WorkContent"] == NSNotFound) {
            textView.text = taskEntity.WorkContent;
        } else {
            if ([@"" isEqualToString:taskEntity.WorkContent]) {
                textView.placeholder = @"请简要填写工作内容";
            } else {
                textView.text = taskEntity.WorkContent;
            }
        }
    } else if (section == 4) {
        PersonEntity *person = chargePersonArr[row];
        UILabel *nameLabel = [cell viewWithTag:1];
        nameLabel.text = person.EmployeeName;
        UIImageView *deleteView = [cell viewWithTag:2];
        UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(deleteChargePerson:)];
        [deleteView addGestureRecognizer:gesture];
        [deleteView setUserInteractionEnabled:YES];
    } else if (section == 5) {
        PersonEntity *person = excutePersonArr[row];
        UILabel *nameLabel = [cell viewWithTag:1];
        nameLabel.text = person.EmployeeName;
        UIImageView *deleteView = [cell viewWithTag:2];
        UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(deleteExcutePerson:)];
        [deleteView addGestureRecognizer:gesture];
        [deleteView setUserInteractionEnabled:YES];
    } else if (section == 6) {
        UILabel *keyLabel = [cell viewWithTag:1];
        UIButton *timeBtn = [cell viewWithTag:2];
        if (row == 0) {
            self.startTimeBtn = timeBtn;
            timeBtn.tag = 10;
            keyLabel.text = @"到场时间";
            NSString *title = isEStartTimeEditable&&[@"" isEqualToString:taskEntity.EStartTime]?startTimeBtnPlaceholder:taskEntity.EStartTime;
            [timeBtn setTitle:title forState:UIControlStateNormal];
            if (isEStartTimeEditable) {
                [timeBtn addTarget:self action:@selector(dateBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            }
        } else {
            self.endTimeBtn = timeBtn;
            timeBtn.tag = 11;
            keyLabel.text = @"结束时间";
            NSString *title = isEStartTimeEditable&&[@"" isEqualToString:taskEntity.EEndTime]?endTimeBtnPlaceholder:taskEntity.EEndTime;
            [timeBtn setTitle:title forState:UIControlStateNormal];
            if (isEEndTimeEditable) {
                [timeBtn addTarget:self action:@selector(dateBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            }
        }
    }
    
    return cell;
}

- (IBAction)dateBtnClick:(id)sender {
    window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    window.rootViewController = self;
    window.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.2];
    [window makeKeyAndVisible];
    
    UIButton *btn = (UIButton *)sender;
    btnTag = btn.tag;
    
    PRActionSheetPickerView *pickerView = [[PRActionSheetPickerView alloc] init];
    pickerView.delegate = self;
    if (![btn.titleLabel.text isEqualToString:startTimeBtnPlaceholder] && ![btn.titleLabel.text isEqualToString:endTimeBtnPlaceholder]) {
        pickerView.defaultDate = btn.titleLabel.text;
    }
    [pickerView showDatePickerInView:window withType:UIDatePickerModeDateAndTime withBackId:1];
}

- (void)getDateWithDate:(NSDate *)date andId:(NSInteger)idNum {
    [self disMissBackView];
    NSString *title = [DateUtil formatDateString:date withFormatter:@"yyyy-MM-dd HH:mm:00"];
    if (btnTag == 10) {
        [self.startTimeBtn setTitle:title forState:UIControlStateNormal];
        [self calculateTimeDiffrence:title toTheTime:self.endTimeBtn.titleLabel.text];
    } else if(btnTag == 11) {
        [self.endTimeBtn setTitle:title forState:UIControlStateNormal];
        [self calculateTimeDiffrence:self.startTimeBtn.titleLabel.text toTheTime:title];
    }
}

- (void)disMissBackView {
    window.hidden = YES;
    window.rootViewController = nil;
    window = nil;
}

- (void)calculateTimeDiffrence:(NSString *)fromTime toTheTime:(NSString *)toTime {
    if (![fromTime isEqualToString:startTimeBtnPlaceholder] && ![toTime isEqualToString:endTimeBtnPlaceholder]) {
        NSDate *startD = [DateUtil dateFromString:fromTime withFormatter:@"yyyy-MM-dd HH:mm:00"];
        NSDate *endD = [DateUtil dateFromString:toTime withFormatter:@"yyyy-MM-dd HH:mm:00"];
        NSInteger df = [DateUtil intervalFromLastDate:startD toTheDate:endD];
        NSString *hours = [NSString stringWithFormat:@"%ld", (long)df];
        self.timeDiffLabel.text = hours;
        taskEntity.EWorkHours = hours;
    }
}

@end
