//
//  AssetsViewController.m
//  wy
//
//  Created by wangyilu on 16/9/27.
//  Copyright © 2016年 ___PURANG___. All rights reserved.
//

#import "AssetsViewController.h"
#import "DeviceEntity.h"
#import "DeviceDBService.h"
#import "AssetsDetailViewController.h"
#import "ScanDeviceViewController.h"
#import "AssetsSiftView.h"
#import "PositionEntity.h"

typedef NS_OPTIONS(NSUInteger, FilterViewHideType) {
    FilterViewHideByCancel       = 0,
    FilterViewHideByConfirm      = 1 << 0
};

@interface AssetsViewController ()<UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *searchField;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation AssetsViewController {
    UIWindow *filterWindow;
    AssetsSiftView *siftView;
    
    NSArray *asstesList;
    NSString *keyWord;
    UIView *noDataView;
    
    NSMutableDictionary *filterDic;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIImageView *image1=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"search"]];
    image1.frame=CGRectMake(0, 0, 25, 25);
    self.searchField.leftView=image1;
    self.searchField.leftViewMode=UITextFieldViewModeAlways;
    self.searchField.delegate = self;
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.estimatedRowHeight = 44;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    
    asstesList = [[NSArray alloc] init];
    
    UIImageView *scanImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 25, 25)];
    scanImageView.image = [UIImage imageNamed:@"scan"];
    UITapGestureRecognizer *scangesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(scanDevice:)];
    [scanImageView addGestureRecognizer:scangesture];
    [scanImageView setUserInteractionEnabled:YES];
    UIBarButtonItem *scanItem = [[UIBarButtonItem alloc]
                                   initWithCustomView:scanImageView];
    
    UIImageView *filterImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 25, 25)];
    filterImageView.image = [UIImage imageNamed:@"filter"];
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(filterAssets:)];
    [filterImageView addGestureRecognizer:gesture];
    [filterImageView setUserInteractionEnabled:YES];
    UIBarButtonItem *filterItem = [[UIBarButtonItem alloc]
                                   initWithCustomView:filterImageView];
    
    self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:filterItem, scanItem, nil];
    
    filterDic = [[NSMutableDictionary alloc] init];
}

- (void)viewDidAppear:(BOOL)animated {
    if (noDataView) {
        return;
    } else {
        CGRect tableFrame = self.tableView.frame;
        float tableWidth = tableFrame.size.width;
        float tableHeight = tableFrame.size.height;
        noDataView = [[UIView alloc] initWithFrame:tableFrame];
        UIView *noView = [[UIView alloc] initWithFrame:CGRectMake((tableWidth-100)/2, (tableHeight-100)/2, 100, 100)];
        UIImageView *nodataImage = [[UIImageView alloc] initWithFrame:CGRectMake((100-65)/2, 0, 65, 57)];
        nodataImage.image = [UIImage imageNamed:@"nodata"];
        [noView addSubview:nodataImage];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 70, 100, 21)];
        label.text = @"暂无检索数据";
        label.font = [UIFont systemFontOfSize:15];
        label.textColor = [UIColor darkGrayColor];
        label.textAlignment = NSTextAlignmentCenter;
        [noView addSubview:label];
        
        [noDataView addSubview:noView];
        
        [self.view addSubview:noDataView];
    }
}

- (void)scanDevice:(UITapGestureRecognizer *)recognizer {
    ScanDeviceViewController *viewController = [[ScanDeviceViewController alloc] init];
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.backBarButtonItem = backButton;
    [viewController setTitle:@"二维码/条码"];
    viewController.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:viewController animated:YES];
}

-(void)filterAssets:(UITapGestureRecognizer *)recognizer
{
    float px;
    if (SCREEN_WIDTH<=320) {
        px = 50;
    } else if (SCREEN_WIDTH<=375) {
        px = 80;
    } else {
        px = 100;
    }
    float pwidth = SCREEN_WIDTH-px;
    if (filterWindow) {
        filterWindow.hidden = NO;
        [UIView animateWithDuration:0.2 animations:^{
            CGRect newFrame = siftView.frame;
            newFrame.origin.x = px;
            siftView.frame = newFrame;
        } completion:^(BOOL finished) {
            
        }];
    } else {
        filterWindow = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
        filterWindow.rootViewController = self;
        filterWindow.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
        [filterWindow makeKeyAndVisible];
        
        UIView *backView = [[UIView alloc] initWithFrame:filterWindow.frame];
        backView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
        [filterWindow addSubview:backView];
        
        UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideFilterView:)];
        [backView addGestureRecognizer:gesture];
        [backView setUserInteractionEnabled:YES];
        
        NSArray *views = [[NSBundle mainBundle] loadNibNamed:@"AssetsSiftView" owner:nil options:nil];
        siftView = views[0];
        
        siftView.frame = CGRectMake(SCREEN_WIDTH, 0, pwidth, SCREEN_HEIGHT);
        [filterWindow addSubview:siftView];
        
        [siftView.cancelButton addTarget:self action:@selector(filterCancelBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [siftView.confirmButton addTarget:self action:@selector(filterConfirmBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        [UIView animateWithDuration:0.2 animations:^{
            CGRect newFrame = siftView.frame;
            newFrame.origin.x = px;
            siftView.frame = newFrame;
        } completion:^(BOOL finished) {
            
        }];
    }
}

- (IBAction)filterCancelBtnClick:(id)sender
{
    [self filterViewHideWithTye:FilterViewHideByCancel];
}

- (IBAction)filterConfirmBtnClick:(id)sender
{
    [self filterViewHideWithTye:FilterViewHideByConfirm];
    
    NSArray<NSIndexPath *> *indexPathsOfSelectedRows = [siftView.siftTableView indexPathsForSelectedRows];
    NSMutableDictionary *locationDic = [[NSMutableDictionary alloc] init];
    for (NSIndexPath *indexPath in indexPathsOfSelectedRows) {
        if (indexPath.section==0) {
            PositionEntity *position = siftView.positionList[indexPath.row];
            [locationDic setObject:position forKey:position.Code];
        } else if (indexPath.section==1) {
            //后续加上分类筛选
        }
    }
    [filterDic setObject:locationDic forKey:@"Location"];
    
    [self refreshDataByCondition];
}

- (void)hideFilterView:(UITapGestureRecognizer *)recognizer {
    [self filterViewHideWithTye:FilterViewHideByCancel];
}

- (void)filterViewHideWithTye:(FilterViewHideType) type {
    [UIView animateWithDuration:0.2 animations:^{
        CGRect newFrame = siftView.frame;
        newFrame.origin.x = SCREEN_WIDTH;
        siftView.frame = newFrame;
    } completion:^(BOOL finished) {
        if (type == FilterViewHideByCancel) {
            //重置筛选条件
            if (filterDic[@"Location"]) {
                siftView.selectedlocationDic = [[NSMutableDictionary alloc] initWithDictionary:filterDic[@"Location"]];
            }
            [siftView.siftTableView reloadData];
        }
        
        filterWindow.hidden = YES;
    }];
}

- (void)refreshDataByCondition {
    //刷新列表
    asstesList = [[DeviceDBService getSharedInstance] findAssetsByKeyword:filterDic[@"keyword"]?filterDic[@"keyword"]:@""];
    noDataView.hidden = asstesList.count>0;
    [self.tableView reloadData];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return asstesList.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger row = indexPath.row;
    NSString *CELLID;
    if (row==0) {
        CELLID = @"ASSETSTITLEIDENTIFIER";
    } else {
        CELLID = @"ASSETSCONTENTIDENTIFIER";
    }
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CELLID forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CELLID];
    }
    
    DeviceEntity *device = asstesList[row];
    if (row==0) {
        UILabel *titleLabel = [cell viewWithTag:1];
        titleLabel.text = device.Name;
    } else {
        UILabel *locationLabel = [cell viewWithTag:1];
        UILabel *classLabel = [cell viewWithTag:2];
        locationLabel.text = @"上海国际能源站维保系统/能源站/设备系统/主设备间";//device.Pos;
        classLabel.text = @"非电力系统/化水";
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 44;
    }
    return CGFLOAT_MIN;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 6;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 44)];
    if (section == 0) {
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, (44-21)/2, 200, 21)];
        titleLabel.text = @"检索结果";
        [header addSubview:titleLabel];
        return header;
    }
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger section = indexPath.section;
    DeviceEntity *device = asstesList[section];
    
    UIStoryboard* featureSB = [UIStoryboard storyboardWithName:@"Feature" bundle:[NSBundle mainBundle]];
    AssetsDetailViewController *viewController = [featureSB instantiateViewControllerWithIdentifier:@"ASSETSDETAIL"];
    
    viewController.Code = device.Code;
    [viewController setTitle:device.Name];
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"知识库" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.backBarButtonItem = backButton;
    [self.navigationController pushViewController:viewController animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    keyWord = textField.text;
    [self.searchField resignFirstResponder];
    [filterDic setObject:keyWord forKey:@"keyword"];
    [self refreshDataByCondition];
    return YES;
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
