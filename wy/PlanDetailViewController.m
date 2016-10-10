//
//  PlanDetailViewController.m
//  wy
//
//  Created by wangyilu on 16/10/9.
//  Copyright © 2016年 ___PURANG___. All rights reserved.
//

#import "PlanDetailViewController.h"
#import "PlanMaintainContentTableViewController.h"
#import "PlanObjectTableViewController.h"
#import "PlanService.h"

@interface PlanDetailViewController () <UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *titleScrollView;
@property (strong, nonatomic) UIView *titleBottomView;
@property (weak, nonatomic) IBOutlet UIScrollView *contentScrollView;

@end

@implementation PlanDetailViewController {
    NSInteger selectedIndex;
    UIButton *selectedBtn;
    float TITLEWIDTH;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    TITLEWIDTH = SCREEN_WIDTH/3;
    
    /* 标题滚动 */
    self.titleScrollView.delegate = self;
    self.titleScrollView.bounces = NO;
    self.titleScrollView.pagingEnabled = NO;
    self.titleScrollView.contentOffset = CGPointZero;
    self.titleScrollView.contentSize = CGSizeMake(TITLEWIDTH * 3, 0);
    self.titleScrollView.showsHorizontalScrollIndicator = NO;
    self.titleScrollView.scrollsToTop = NO;
    for (int i=0; i<3; i++) {
        NSString *title;
        if (i==0) {
            title = @"维护内容";
        } else if (i==1) {
            title = @"对象";
        } else if (i==2) {
            title = @"维护工单";
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
    self.contentScrollView.contentSize = CGSizeMake(SCREEN_WIDTH * 3, 0);
    self.contentScrollView.showsHorizontalScrollIndicator = NO;
    self.contentScrollView.scrollsToTop = NO;
    
    
    UIStoryboard* featureSB = [UIStoryboard storyboardWithName:@"Feature" bundle:[NSBundle mainBundle]];
    
    PlanMaintainContentTableViewController *planMaintainContentViewController = [featureSB instantiateViewControllerWithIdentifier:@"PLANMAINTAINCONTENT"];
    [self addChildViewController:planMaintainContentViewController];
    planMaintainContentViewController.view.frame = self.contentScrollView.bounds;
    [self.contentScrollView addSubview:planMaintainContentViewController.view];
    
    PlanObjectTableViewController *planObjectViewController = [featureSB instantiateViewControllerWithIdentifier:@"PLANOBJECT"];
    [self addChildViewController:planObjectViewController];
    
    
    PlanService *planService = [[PlanService alloc] init];
    [planService getPlanDetail:self.Code success:^(PlanDetailEntity *planDetail) {
        planMaintainContentViewController.planDetail = planDetail;
        [planMaintainContentViewController.tableView reloadData];
        
        planObjectViewController.planDetail = planDetail;
        [planObjectViewController.tableView reloadData];
    } failure:^(NSString *message) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:message preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:nil];
        [alertController addAction:okAction];
        [self presentViewController:alertController animated:YES completion:nil];
    }];
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
    /*
    if (index==2 && self.titleScrollView.contentOffset.x<=0) {
        CGFloat offsetX = 0.5 * TITLEWIDTH;
        CGFloat offsetY = self.titleScrollView.contentOffset.y;
        CGPoint offset = CGPointMake(offsetX, offsetY);
        [self.titleScrollView setContentOffset:offset animated:YES];
    }
    */
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
