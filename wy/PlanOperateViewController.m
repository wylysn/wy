//
//  PlanOperateViewController.m
//  wy
//
//  Created by wangyilu on 16/10/17.
//  Copyright © 2016年 ___PURANG___. All rights reserved.
//

#import "PlanOperateViewController.h"
#import "PlanMaintainContentTableViewController.h"
#import "PlanObjectTableViewController.h"
#import "PlanOrderTableViewController.h"
#import "PlanService.h"
#import "PlanOperateNaviViewController.h"
#import "TaskService.h"
#import "TaskDBService.h"

@interface PlanOperateViewController () <UIScrollViewDelegate, UIActionSheetDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *titleScrollView;
@property (strong, nonatomic) UIView *titleBottomView;
@property (weak, nonatomic) IBOutlet UIScrollView *contentScrollView;
@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomViewConstraint;

@end

@implementation PlanOperateViewController {
    NSInteger selectedIndex;
    UIButton *selectedBtn;
    float TITLEWIDTH;
    
    TaskService *taskService;
    PlanService *planService;
    
    NSMutableArray *actionsMutableArr;
    
    PlanDetailEntity *plan;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    TITLEWIDTH = SCREEN_WIDTH/2;
    
    taskService = [[TaskService alloc] init];
    planService = [[PlanService alloc] init];
    
    /* 标题滚动 */
    self.titleScrollView.delegate = self;
    self.titleScrollView.bounces = NO;
    self.titleScrollView.pagingEnabled = NO;
    self.titleScrollView.contentOffset = CGPointZero;
    self.titleScrollView.contentSize = CGSizeMake(TITLEWIDTH * 2, 0);
    self.titleScrollView.showsHorizontalScrollIndicator = NO;
    self.titleScrollView.scrollsToTop = NO;
    for (int i=0; i<2; i++) {
        NSString *title;
        if (i==0) {
            title = @"维护内容";
        } else if (i==1) {
            title = @"对象";
        }
        UIButton *titleBtn = [[UIButton alloc] initWithFrame:CGRectMake(i*TITLEWIDTH, 0, TITLEWIDTH, 50)];
        titleBtn.tag = i+1;
        titleBtn.titleLabel.font = [UIFont systemFontOfSize:17];
        [titleBtn setTitle:title forState:UIControlStateNormal];
        [titleBtn setTitle:title forState:UIControlStateSelected];
        [titleBtn setTitleColor:[UIColor colorFromHexCode:@"555555"] forState:UIControlStateNormal];
        [titleBtn setTitleColor:[UIColor colorFromHexCode:@"FC852D"] forState:UIControlStateSelected];
        [titleBtn addTarget:self action:@selector(titlebtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.titleScrollView addSubview:titleBtn];
    }
    self.titleBottomView = [[UIView alloc] initWithFrame:CGRectMake(0, 50-2, TITLEWIDTH, 2)];
    self.titleBottomView.backgroundColor = [UIColor colorFromHexCode:@"FC852D"];
    [self.titleScrollView addSubview:self.titleBottomView];
    selectedIndex = 0;
    selectedBtn = [self.titleScrollView viewWithTag:1];
    selectedBtn.selected = TRUE;
    
    /* 内容滚动 */
    self.contentScrollView.delegate = self;
    self.contentScrollView.bounces = NO;
    self.contentScrollView.pagingEnabled = YES;
    self.contentScrollView.contentOffset = CGPointZero;
    self.contentScrollView.contentSize = CGSizeMake(SCREEN_WIDTH * 2, 0);
    self.contentScrollView.showsHorizontalScrollIndicator = NO;
    self.contentScrollView.scrollsToTop = NO;
    
    
    UIStoryboard* featureSB = [UIStoryboard storyboardWithName:@"Feature" bundle:[NSBundle mainBundle]];
    
    PlanMaintainContentTableViewController *planMaintainContentViewController = [featureSB instantiateViewControllerWithIdentifier:@"PLANMAINTAINCONTENT"];
    [self addChildViewController:planMaintainContentViewController];
    planMaintainContentViewController.view.frame = CGRectMake(0, 0, self.contentScrollView.frame.size.width, self.contentScrollView.frame.size.height);//self.contentScrollView.bounds;
    [self.contentScrollView addSubview:planMaintainContentViewController.view];
    
    PlanObjectTableViewController *planObjectViewController = [featureSB instantiateViewControllerWithIdentifier:@"PLANOBJECT"];
    [self addChildViewController:planObjectViewController];
    
    PlanOrderTableViewController *planOrderViewController = [featureSB instantiateViewControllerWithIdentifier:@"PLANORDER"];
    [self addChildViewController:planOrderViewController];
    
    PlanOperateNaviViewController *naviViewController = (PlanOperateNaviViewController *)(self.navigationController);
    [planService getPlanTask:naviViewController.Code success:^(PlanDetailEntity *planDetail) {
        plan = planDetail;
        
        planMaintainContentViewController.planDetail = planDetail;
        [planMaintainContentViewController changeVariable];
        [planMaintainContentViewController.tableView reloadData];
        
        planObjectViewController.planDetail = planDetail;
        [planObjectViewController.tableView reloadData];
        
        planOrderViewController.planDetail = planDetail;
        [planOrderViewController.tableView reloadData];
        
        //判断是否有操作，生成操作按钮
        
        if (planDetail.TaskAction) {
            actionsMutableArr = [[NSMutableArray alloc] initWithArray:planDetail.TaskAction];
            
            if (planDetail.IsLocalSave) {
                NSMutableDictionary *saveDic = [[NSMutableDictionary alloc] init];
                [saveDic setValue:@"FormSave" forKey:@"EventName"];
                [saveDic setValue:@"保存" forKey:@"DisplayName"];
                [saveDic setValue:@100 forKey:@"flag"];
                [saveDic setValue:planDetail.EditFields forKey:@"SubmitFields"];
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
    /*
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
     */
    NSArray *dataArr = [[NSArray alloc] initWithObjects:dataDic, nil];
    [submitDic setObject:dataArr forKey:@"data"];
    
    if (plan.IsLocalSave && tag==0) { //保存按钮点击
        bool success = [planService updateLocalPlanDetailEntity:plan];
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:success?@"数据保存成功！":@"数据保存失败！" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self.navigationController popViewControllerAnimated:YES];
        }];
        [alertController addAction:okAction];
        [self presentViewController:alertController animated:YES completion:nil];
    } else {
        [taskService submitAction:submitDic withCode:self.Code success:^{
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"操作处理成功！" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [self.navigationController dismissViewControllerAnimated:YES completion:nil];
            }];
            [alertController addAction:okAction];
            [self presentViewController:alertController animated:YES completion:nil];
        } failure:^(NSString *message) {
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:message preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:nil];
            [alertController addAction:okAction];
            [self presentViewController:alertController animated:YES completion:nil];
        }];
    }
}

#pragma mark - actionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (actionSheet.tag == 2) {
        [self doAction:buttonIndex+2];
    }
}

- (void)titlebtnClick:(id)sender {
    UIButton *btn = (UIButton *)sender;
    NSInteger tag = btn.tag;
    [self changePageWithIndex:tag];
}

- (void)changePageWithIndex:(NSInteger)index {
    UIButton *btn = [self.titleScrollView viewWithTag:index];
    if (!btn.selected) {
        [self changeTitlebtnWithIndex:index];
        
        CGFloat offsetX = (index-1) * self.contentScrollView.frame.size.width;
        CGFloat offsetY = self.contentScrollView.contentOffset.y;
        CGPoint offset = CGPointMake(offsetX, offsetY);
        [self.contentScrollView setContentOffset:offset animated:YES];
    }
}

- (void)changeTitlebtnWithIndex:(NSInteger)index {
    UIButton *btn = [self.titleScrollView viewWithTag:index];
    
    selectedBtn.selected = FALSE;
    NSInteger preTag = selectedBtn.tag;
    
    btn.selected = YES;
    selectedIndex = index-1;
    selectedBtn = btn;
    [UIView animateWithDuration:0.5 animations:^{
        CGPoint _center = self.titleBottomView.center;
        _center.x +=  (index-preTag)*self.titleBottomView.frame.size.width;
        self.titleBottomView.center = _center;
    }];
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
    if ([scrollView isEqual:self.contentScrollView]) {
        // 获得索引
        NSUInteger index = scrollView.contentOffset.x / self.contentScrollView.frame.size.width;
        
        //修改标题栏索引
        [self changeTitlebtnWithIndex:index+1];
        
        //添加控制器
        UITableViewController *newsVc = self.childViewControllers[index];
        if (!newsVc.view.superview) {
            newsVc.view.frame = scrollView.bounds;
            [self.contentScrollView addSubview:newsVc.view];
        }
    }
}

/** 滚动结束（手势导致） */
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self scrollViewDidEndScrollingAnimation:scrollView];
}

/** 正在滚动 */
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
}

- (IBAction)backclick:(id)sender {
    [self.navigationController dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
