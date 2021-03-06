//
//  TaskXunjian2ViewController.m
//  wy
//
//  Created by wangyilu on 16/9/8.
//  Copyright © 2016年 ___PURANG___. All rights reserved.
//

#import "TaskXunjian2ViewController.h"
#import "TaskXunjianBaseInfoTableViewController.h"
#import "TaskXunjianDeviceTableViewController.h"
#import "TaskXunjianBaseInfo2TableViewController.h"
#import "TaskService.h"
#import "TaskEntity.h"
#import "TaskDeviceEntity.h"
#import "InspectionChildModelEntity.h"
#import "SubmitWindow.h"
#import "QRCodeScanViewController.h"

@interface TaskXunjian2ViewController ()<UIScrollViewDelegate, UIActionSheetDelegate> {
    TaskService *taskService;
    TaskEntity *taskEntity;
    
    NSArray *editFieldsArray;
    
    NSMutableArray *actionsMutableArr;
    
    TaskXunjianBaseInfoTableViewController *taskXunjianBaseInfoController;
    TaskXunjianDeviceTableViewController *taskDevicesBaseInfoController;
}

@end

@implementation TaskXunjian2ViewController{
    NSInteger selectedIndex;
    UIButton *selectedBtn;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.deviceCheckInfoDic = [[NSMutableDictionary alloc] init];
    
    selectedIndex = 0;
    selectedBtn = [self.titleView viewWithTag:1];
    selectedBtn.selected = TRUE;
    
    self.scrollBackView.delegate = self;
    self.scrollBackView.bounces = NO;
    self.scrollBackView.pagingEnabled = YES;
    self.scrollBackView.contentOffset = CGPointZero;
    self.scrollBackView.contentSize = CGSizeMake(SCREEN_WIDTH * 2, 0);
    self.scrollBackView.showsHorizontalScrollIndicator = NO;
    self.scrollBackView.scrollsToTop = NO;
    
    UIStoryboard* mainSB = [UIStoryboard storyboardWithName:@"Task" bundle:[NSBundle mainBundle]];
//    TaskXunjianBaseInfo2TableViewController *taskXunjianBaseInfoController = [mainSB instantiateViewControllerWithIdentifier:@"TaskXunjianBaseInfo2"];
//    taskXunjianBaseInfoController.code = self.code;
    taskXunjianBaseInfoController = [mainSB instantiateViewControllerWithIdentifier:@"TaskXunjianBaseInfo"];
    taskXunjianBaseInfoController.code = self.code;
    taskXunjianBaseInfoController.ShortTitle = self.ShortTitle;

    taskDevicesBaseInfoController = [mainSB instantiateViewControllerWithIdentifier:@"TaskXunjianDevices"];
    taskDevicesBaseInfoController.code = self.code;
    [self addChildViewController:taskXunjianBaseInfoController];
    [self addChildViewController:taskDevicesBaseInfoController];
    
    taskXunjianBaseInfoController.view.frame = self.scrollBackView.bounds;
    [self.scrollBackView addSubview:taskXunjianBaseInfoController.view];
    
    
    taskService = [[TaskService alloc] init];
    [taskService getTaskEntity:self.code fromLocal:self.isLocalSave success:^(TaskEntity *task){
        taskEntity = task;
        
        [self setBaseInfoController];
        
        [self setDeviceTableViewController];
        
        //判断是否有操作，生成操作按钮
        if (![taskEntity.TaskAction isBlankString]) {
            NSArray *actionsArr = [NSString convertStringToArray:taskEntity.TaskAction];
            actionsMutableArr = [[NSMutableArray alloc] initWithArray:actionsArr];
            if (taskEntity.IsLocalSave) {
                NSMutableDictionary *saveDic = [[NSMutableDictionary alloc] init];
                [saveDic setValue:@"FormSave" forKey:@"EventName"];
                [saveDic setValue:@"保存" forKey:@"DisplayName"];
                [saveDic setValue:@100 forKey:@"flag"];
                [saveDic setValue:taskEntity.EditFields forKey:@"SubmitFields"];
                [actionsMutableArr insertObject:saveDic atIndex:0];
            }
            
            if (actionsMutableArr && actionsMutableArr.count>0) {
                self.bottomViewConstraint.constant = 0;
                NSInteger actionNum = actionsMutableArr.count;
                float btnWidth;
                float space = 15;
                btnWidth = (SCREEN_WIDTH-space*((actionNum>=3?3:actionNum)+1))/(actionNum>=3?3:actionNum);
                float btnHeight = 30;
                float y = (55-btnHeight)/2;
                
                if (actionsMutableArr.count>3) {
                    UIButton *moreBtn = [[UIButton alloc] initWithFrame:CGRectMake(space, y, btnWidth, btnHeight)];
                    [moreBtn setTitle:@"更多" forState:UIControlStateNormal];
                    moreBtn.backgroundColor = [UIColor colorFromHexCode:BUTTON_ORANGE_COLOR];
                    moreBtn.layer.cornerRadius = 5;
                    moreBtn.tag = 2;
                    [moreBtn addTarget:self action:@selector(actionBtnClick:) forControlEvents:UIControlEventTouchUpInside];
                    [self.bottomView addSubview:moreBtn];
                } else if (actionsMutableArr.count==3) {
                    UIButton *btn3 = [[UIButton alloc] initWithFrame:CGRectMake(space, y, btnWidth, btnHeight)];
                    [btn3 setTitle:actionsMutableArr[2][@"DisplayName"] forState:UIControlStateNormal];
                    btn3.backgroundColor = [UIColor colorFromHexCode:BUTTON_ORANGE_COLOR];
                    btn3.layer.cornerRadius = 5;
                    btn3.tag = 2;
                    [btn3 addTarget:self action:@selector(actionBtnClick:) forControlEvents:UIControlEventTouchUpInside];
                    [self.bottomView addSubview:btn3];
                }
                if (actionsMutableArr.count>=3) {
                    UIButton *btn1 = [[UIButton alloc] initWithFrame:CGRectMake(space*2+btnWidth, y, btnWidth, btnHeight)];
                    [btn1 setTitle:actionsMutableArr[0][@"DisplayName"] forState:UIControlStateNormal];
                    btn1.backgroundColor = [UIColor colorFromHexCode:BUTTON_BLUE_COLOR];
                    btn1.layer.cornerRadius = 5;
                    btn1.tag = 0;
                    [btn1 addTarget:self action:@selector(actionBtnClick:) forControlEvents:UIControlEventTouchUpInside];
                    [self.bottomView addSubview:btn1];
                    
                    UIButton *btn2 = [[UIButton alloc] initWithFrame:CGRectMake(space*3+btnWidth*2, y, btnWidth, btnHeight)];
                    [btn2 setTitle:actionsMutableArr[1][@"DisplayName"] forState:UIControlStateNormal];
                    btn2.backgroundColor = [UIColor colorFromHexCode:BUTTON_GREEN_COLOR];
                    btn2.layer.cornerRadius = 5;
                    btn2.tag = 1;
                    [btn2 addTarget:self action:@selector(actionBtnClick:) forControlEvents:UIControlEventTouchUpInside];
                    [self.bottomView addSubview:btn2];
                } else {
                    UIButton *btn1 = [[UIButton alloc] initWithFrame:CGRectMake(space, y, btnWidth, btnHeight)];
                    [btn1 setTitle:actionsMutableArr[0][@"DisplayName"] forState:UIControlStateNormal];
                    btn1.backgroundColor = [UIColor colorFromHexCode:BUTTON_BLUE_COLOR];
                    btn1.layer.cornerRadius = 5;
                    btn1.tag = 0;
                    [btn1 addTarget:self action:@selector(actionBtnClick:) forControlEvents:UIControlEventTouchUpInside];
                    [self.bottomView addSubview:btn1];
                    
                    if (actionsMutableArr.count==2) {
                        UIButton *btn2 = [[UIButton alloc] initWithFrame:CGRectMake(space*2+btnWidth, y, btnWidth, btnHeight)];
                        [btn2 setTitle:actionsMutableArr[1][@"DisplayName"] forState:UIControlStateNormal];
                        btn2.backgroundColor = [UIColor colorFromHexCode:BUTTON_GREEN_COLOR];
                        btn2.layer.cornerRadius = 5;
                        btn2.tag = 1;
                        [btn2 addTarget:self action:@selector(actionBtnClick:) forControlEvents:UIControlEventTouchUpInside];
                        [self.bottomView addSubview:btn2];
                    }
                }
            }
        }
    } failure:^(NSString *message) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:message preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:nil];
        [alertController addAction:okAction];
        [self presentViewController:alertController animated:YES completion:nil];
    }];
    
    UIImageView *scanImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 25, 25)];
    scanImageView.image = [UIImage imageNamed:@"scan"];
    UITapGestureRecognizer *scangesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(scanDevice:)];
    [scanImageView addGestureRecognizer:scangesture];
    [scanImageView setUserInteractionEnabled:YES];
    UIBarButtonItem *scanItem = [[UIBarButtonItem alloc]
                                 initWithCustomView:scanImageView];
    self.navigationItem.rightBarButtonItem = scanItem;
}

- (void)setBaseInfoController {
    if (taskEntity.SBCheckList && ![taskEntity.SBCheckList isBlankString] ) {
        NSArray *sbCheckDicArr = [NSString convertStringToArray:taskEntity.SBCheckList];
        for (NSDictionary *sbCheckDic in sbCheckDicArr) {
            InspectionChildModelEntity *sbCheck = [[InspectionChildModelEntity alloc] initWithDictionary:sbCheckDic];
            NSMutableDictionary *infoDic;
            if ([self.deviceCheckInfoDic.allKeys containsObject:sbCheckDic[@"Code"]]) {
                infoDic = self.deviceCheckInfoDic[sbCheckDic[@"Code"]];
            } else {
                infoDic = [[NSMutableDictionary alloc] init];
                [self.deviceCheckInfoDic setObject:infoDic forKey:sbCheckDic[@"Code"]];
            }
            [infoDic setObject:sbCheck forKey:sbCheck.ItemName];
        }
    }
    
    taskXunjianBaseInfoController.taskEntity = taskEntity;
    [taskXunjianBaseInfoController.tableView reloadData];
}

- (void)setDeviceTableViewController {
    NSMutableArray *deviceArr = [[NSMutableArray alloc] init];
    if (taskEntity.SBList && ![taskEntity.SBList isBlankString]) {
        NSArray *deviceDicArr = [NSString convertStringToArray:taskEntity.SBList];
        for (NSDictionary *deviceDic in deviceDicArr) {
            TaskDeviceEntity *device = [[TaskDeviceEntity alloc] initWithDictionary:deviceDic];
            NSDictionary *childModelDic = self.deviceCheckInfoDic[device.Code];
            BOOL isComplete = FALSE;
            if (childModelDic && childModelDic.allKeys.count>0) {
                isComplete = TRUE;
                NSArray *childModelArr = childModelDic.allValues;
                for (InspectionChildModelEntity *childModel in childModelArr) {
                    if ([childModel.ItemValue isBlankString]) {
                        isComplete = FALSE;
                        break;
                    }
                }
            }
            [device setIsComplete:isComplete];
            //判断是否已录入所有数据
            [deviceArr addObject:device];
        }
    }
    
    taskDevicesBaseInfoController.taskEntity = taskEntity;
    taskDevicesBaseInfoController.taskDeviceArray = deviceArr;
    [taskDevicesBaseInfoController.tableView reloadData];
}

- (void)scanDevice:(UITapGestureRecognizer *)recognizer {
    QRCodeScanViewController *viewController = [[QRCodeScanViewController alloc] init];
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.backBarButtonItem = backButton;
    [viewController setTitle:@"二维码/条码"];
    viewController.hidesBottomBarWhenPushed = YES;
    viewController.hasNotDeviceCode = YES;
    viewController.taskDeviceArray = taskDevicesBaseInfoController.taskDeviceArray;
    [self.navigationController pushViewController:viewController animated:YES];
}

- (void)actionBtnClick:(id)sender {
    UIButton *btn = (UIButton *)sender;
    NSInteger tag = btn.tag;
    if (tag == 2 && actionsMutableArr.count>3) {
        UIActionSheet* actionSheet = [[UIActionSheet alloc] initWithTitle:@"请选择" delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil];
        for (int i=2; i<actionsMutableArr.count; i++) {
            [actionSheet addButtonWithTitle:actionsMutableArr[i][@"DisplayName"]];
        }
        [actionSheet addButtonWithTitle:@"取消"];
        actionSheet.cancelButtonIndex = actionSheet.numberOfButtons - 1;
        actionSheet.tag = 2;
        [actionSheet showInView:self.view];
    } else {
        [self doAction:tag];
    }
}

- (void)doAction:(NSInteger)tag {
    NSDictionary *actionDic = actionsMutableArr[tag];
    NSString *eventname = actionDic[@"EventName"];
    NSArray *submitField = [[[actionDic[@"SubmitFields"] stringByReplacingOccurrencesOfString:@"[" withString:@""] stringByReplacingOccurrencesOfString:@"]" withString:@""] componentsSeparatedByString:@";"];
    NSMutableDictionary *submitDic = [[NSMutableDictionary alloc] init];
    [submitDic setObject:eventname forKey:@"eventname"];
    NSMutableDictionary *dataDic = [[NSMutableDictionary alloc] init];
    for (NSString *fieldStr in submitField) {
        if ([@"SBCheckList" isEqualToString:fieldStr]) {
            NSMutableArray *sbCheckListArr = [[NSMutableArray alloc] init];
            NSArray *values = self.deviceCheckInfoDic.allValues;
            for (NSDictionary *infoDic in values) {
                NSArray *values2 = infoDic.allValues;
                for (InspectionChildModelEntity *insChildEntity in values2) {
                    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
                    [dic setObject:insChildEntity.taskDeviceCode forKey:@"Code"];
                    [dic setObject:[NSString stringWithFormat:@"%ld", insChildEntity.ItemType] forKey:@"ItemType"];
                    [dic setObject:!insChildEntity.InputMax||[insChildEntity.InputMax isBlankString]?@"":insChildEntity.InputMax forKey:@"InputMax"];
                    [dic setObject:!insChildEntity.InputMin||[insChildEntity.InputMin isBlankString]?@"":insChildEntity.InputMin forKey:@"InputMin"];
                    [dic setObject:!insChildEntity.UnitName||[insChildEntity.UnitName isBlankString]?@"":insChildEntity.UnitName forKey:@"UnitName"];
                    [dic setObject:insChildEntity.ItemValues forKey:@"ItemValues"];
                    [dic setObject:insChildEntity.ItemName forKey:@"ItemName"];
                    [dic setObject:insChildEntity.taskDeviceCode forKey:@"taskDeviceCode"];
                    if (insChildEntity.ItemValue && insChildEntity.ItemValue!=nil) {
                        [dic setObject:insChildEntity.ItemValue forKey:@"ItemValue"];
                    }
                    if (insChildEntity.DataValid && insChildEntity.DataValid!=nil) {
                        [dic setObject:insChildEntity.DataValid forKey:@"DataValid"];
                    }
                    [sbCheckListArr addObject:dic];
                }
            }
            [dataDic setObject:sbCheckListArr forKey:fieldStr];
            taskEntity.SBCheckList = [NSString convertArrayToString:sbCheckListArr];
        }
    }
    NSArray *dataArr = [[NSArray alloc] initWithObjects:dataDic, nil];
    [submitDic setObject:dataArr forKey:@"data"];
    
    if (taskEntity.IsLocalSave && tag==0) { //保存按钮点击
        bool success = [taskService updateLocalTaskEntity:taskEntity];
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:success?@"数据保存成功！":@"数据保存失败！" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self.navigationController popViewControllerAnimated:YES];
        }];
        [alertController addAction:okAction];
        [self presentViewController:alertController animated:YES completion:nil];
    } else {
        BOOL hasCompleteAll = YES;
        for (TaskDeviceEntity *taskDevice in taskDevicesBaseInfoController.taskDeviceArray) {
            if (!taskDevice.isComplete) {
                hasCompleteAll = NO;
                break;
            }
        }
        if (!hasCompleteAll) {
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"还存在未录入数据项是否确认提交，确认请按是，否则取消" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                
            }];
            UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"是" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [self sendData:submitDic];
            }];
            [alertController addAction:cancelAction];
            [alertController addAction:okAction];
            [self presentViewController:alertController animated:YES completion:nil];
        } else {
            [self sendData:submitDic];
        }
        
    }
}

- (void)sendData:(NSMutableDictionary *)submitDic {
    __block SubmitWindow *submitWindow = [[SubmitWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    submitWindow.rootViewController = self;
    [submitWindow makeKeyAndVisible];
    [taskService submitAction:submitDic withCode:taskEntity.Code success:^{
        [self dismissSubmitWindow:submitWindow];
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"操作处理成功！" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self.navigationController popViewControllerAnimated:YES];
        }];
        [alertController addAction:okAction];
        [self presentViewController:alertController animated:YES completion:nil];
    } failure:^(NSString *message) {
        [self dismissSubmitWindow:submitWindow];
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:message preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:nil];
        [alertController addAction:okAction];
        [self presentViewController:alertController animated:YES completion:nil];
    }];
}

- (void)dismissSubmitWindow:(SubmitWindow *)submitWindow {
    submitWindow.hidden = YES;
    submitWindow.rootViewController = nil;
    submitWindow = nil;
}

#pragma mark - actionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (actionSheet.tag == 2) {
        [self doAction:buttonIndex+2];
    }
}

- (IBAction)titleBtnClick:(id)sender {
    [self changeNewsWithindex:((UIButton *)sender).tag];
}

- (void)changeNewsWithindex:(NSInteger)index {
    selectedBtn.selected = FALSE;
    NSInteger preTag = selectedBtn.tag;
    selectedBtn = [self.titleView viewWithTag:index];
    NSInteger tag = selectedBtn.tag;
    selectedIndex = tag-1;
    selectedBtn.selected = !selectedBtn.selected;
    [UIView animateWithDuration:0.5 animations:^{
        CGPoint _center = self.buttonSrollView.center;
        _center.x +=  (tag-preTag)*self.buttonSrollView.frame.size.width;
        self.buttonSrollView.center = _center;
    }];
    
    CGFloat offsetX = (index-1) * self.scrollBackView.frame.size.width;
    CGFloat offsetY = self.scrollBackView.contentOffset.y;
    CGPoint offset = CGPointMake(offsetX, offsetY);
    [self.scrollBackView setContentOffset:offset animated:YES];
}

/*一个页面只有一个view为scrolltotop的时候，点击status bar才可以滚动到顶部*/
- (void)setScrollToTopWithIndex:(NSInteger)index {
    NSArray *controllers = [self childViewControllers];
    for (int i=0; i<controllers.count; i++) {
        UITableViewController *tableController = controllers[i];
        tableController.tableView.scrollsToTop = i==index;
    }
}

#pragma mark - ******************** scrollView代理方法

/** 滚动结束后调用（代码导致） */
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    // 获得索引
    NSUInteger index = scrollView.contentOffset.x / self.scrollBackView.frame.size.width;
    
    selectedBtn.selected = FALSE;
    NSInteger preTag = selectedBtn.tag;
    selectedBtn = [self.titleView viewWithTag:index+1];
    NSInteger tag = selectedBtn.tag;
    selectedIndex = tag-1;
    selectedBtn.selected = !selectedBtn.selected;
    [UIView animateWithDuration:0.5 animations:^{
        CGPoint _center = self.buttonSrollView.center;
        _center.x +=  (tag-preTag)*self.buttonSrollView.frame.size.width;
        self.buttonSrollView.center = _center;
    }];
    
    //添加控制器
    UITableViewController *newsVc = self.childViewControllers[index];
    if (!newsVc.view.superview) {
        newsVc.view.frame = scrollView.bounds;
        [self.scrollBackView addSubview:newsVc.view];
    }
    //    [self reloadSubControllerWithIndex:index];
    
    [self setScrollToTopWithIndex:index];
}

//- (void)reloadSubControllerWithIndex:(NSInteger)index {
//    UITableViewController *newsVc = self.childViewControllers[index];
//    NSTimeInterval now = [NSDate timeIntervalSinceReferenceDate];
//    if (newsVc.lastUpdateTimeInterval>0 && now-newsVc.lastUpdateTimeInterval>NEWS_REFRESHTIMEINTERVAL) {
//        [newsVc reloadData];
//    }
//}

/** 滚动结束（手势导致） */
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self scrollViewDidEndScrollingAnimation:scrollView];
}

/** 正在滚动 */
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
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
