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

@interface TaskXunjian2ViewController ()<UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIView *titleView;
@property (weak, nonatomic) IBOutlet UIView *buttonSrollView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollBackView;

@end

@implementation TaskXunjian2ViewController{
    NSInteger selectedIndex;
    UIButton *selectedBtn;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
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
    TaskXunjianBaseInfo2TableViewController *taskXunjianBaseInfoController = [mainSB instantiateViewControllerWithIdentifier:@"TaskXunjianBaseInfo2"];
    taskXunjianBaseInfoController.code = self.code;
    TaskXunjianDeviceTableViewController *taskDevicesBaseInfoController = [mainSB instantiateViewControllerWithIdentifier:@"TaskXunjianDevices"];
    taskDevicesBaseInfoController.code = self.code;
    [self addChildViewController:taskXunjianBaseInfoController];
    [self addChildViewController:taskDevicesBaseInfoController];
    
    taskXunjianBaseInfoController.view.frame = self.scrollBackView.bounds;
    [self.scrollBackView addSubview:taskXunjianBaseInfoController.view];
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
