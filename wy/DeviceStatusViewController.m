//
//  DeviceStatusViewController.m
//  wy
//
//  Created by wangyilu on 16/9/19.
//  Copyright © 2016年 ___PURANG___. All rights reserved.
//

#import "DeviceStatusViewController.h"
#import "TaskXunjian2ViewController.h"

@interface DeviceStatusViewController ()<UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, UIActionSheetDelegate> {
    TaskXunjian2ViewController *scanRootViewController;
}

@property (nonatomic, strong) InspectionChildModelEntity *inspectionChildModel;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *bottomView;

@end

@implementation DeviceStatusViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    scanRootViewController = [self.navigationController.viewControllers objectAtIndex:1];
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    //设置title
    self.inspectionChildModel = self.childModelsArray[self.num];
    NSMutableString *title = [[NSMutableString alloc] initWithString:self.inspectionModel.Name];
    if (self.childModelsArray.count>1) {
        [title appendString:[NSString stringWithFormat:@"(%ld/%ld)",self.num+1, self.childModelsArray.count]];
    }
    [self.navigationItem setTitle:title];
    
    //设置底部按钮
    if (self.num == self.childModelsArray.count-1) {
        UIButton *doneBtn;
        if (self.num > 0) {
            UIButton *preBtn = [[UIButton alloc] initWithFrame:CGRectMake(15, (55-30)/2, (SCREEN_WIDTH-15*3)/2, 30)];
            preBtn.backgroundColor = [UIColor colorFromHexCode:BUTTON_GREEN_COLOR];
            preBtn.layer.cornerRadius = 5;
            preBtn.clipsToBounds = YES;
            [preBtn setTitle:@"上一步" forState:UIControlStateNormal];
            [preBtn addTarget:self action:@selector(preStep:) forControlEvents:UIControlEventTouchUpInside];
            [self.bottomView addSubview:preBtn];
            
            doneBtn = [[UIButton alloc] initWithFrame:CGRectMake((SCREEN_WIDTH-15*3)/2+15*2, (55-30)/2, (SCREEN_WIDTH-15*3)/2, 30)];
        } else {
            doneBtn = [[UIButton alloc] initWithFrame:CGRectMake(15, (55-30)/2, SCREEN_WIDTH-15*2, 30)];
        }
        doneBtn.backgroundColor = [UIColor colorFromHexCode:BUTTON_GREEN_COLOR];
        doneBtn.layer.cornerRadius = 5;
        doneBtn.clipsToBounds = YES;
        [doneBtn setTitle:@"完成" forState:UIControlStateNormal];
        [doneBtn addTarget:self action:@selector(doneClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.bottomView addSubview:doneBtn];
    } else if(self.num == 0) {
        UIButton *nextBtn = [[UIButton alloc] initWithFrame:CGRectMake(15, (55-30)/2, SCREEN_WIDTH-15*2, 30)];
        nextBtn.backgroundColor = [UIColor colorFromHexCode:BUTTON_GREEN_COLOR];
        nextBtn.layer.cornerRadius = 5;
        nextBtn.clipsToBounds = YES;
        [nextBtn setTitle:@"下一步" forState:UIControlStateNormal];
        [nextBtn addTarget:self action:@selector(nextStep:) forControlEvents:UIControlEventTouchUpInside];
        [self.bottomView addSubview:nextBtn];
    } else {
        UIButton *preBtn = [[UIButton alloc] initWithFrame:CGRectMake(15, (55-30)/2, (SCREEN_WIDTH-15*3)/2, 30)];
        preBtn.backgroundColor = [UIColor colorFromHexCode:BUTTON_GREEN_COLOR];
        preBtn.layer.cornerRadius = 5;
        preBtn.clipsToBounds = YES;
        [preBtn setTitle:@"上一步" forState:UIControlStateNormal];
        [preBtn addTarget:self action:@selector(preStep:) forControlEvents:UIControlEventTouchUpInside];
        [self.bottomView addSubview:preBtn];
        
        UIButton *nextBtn = [[UIButton alloc] initWithFrame:CGRectMake((SCREEN_WIDTH-15*3)/2+15*2, (55-30)/2, (SCREEN_WIDTH-15*3)/2, 30)];
        nextBtn.backgroundColor = [UIColor colorFromHexCode:BUTTON_GREEN_COLOR];
        nextBtn.layer.cornerRadius = 5;
        nextBtn.clipsToBounds = YES;
        [nextBtn setTitle:@"下一步" forState:UIControlStateNormal];
        [nextBtn addTarget:self action:@selector(nextStep:) forControlEvents:UIControlEventTouchUpInside];
        [self.bottomView addSubview:nextBtn];
    }
    
    if ([scanRootViewController.deviceCheckInfoDic.allKeys containsObject:self.inspectionChildModel.ParentCode]) {
        NSDictionary *infoDic = scanRootViewController.deviceCheckInfoDic[self.inspectionChildModel.ParentCode];
        if (infoDic && infoDic[self.inspectionChildModel.ItemName]) {
            self.inspectionChildModel = infoDic[self.inspectionChildModel.ItemName];
        }
    }
}

- (void)nextStep:(id)sender {
    UIStoryboard* taskSB = [UIStoryboard storyboardWithName:@"Task" bundle:[NSBundle mainBundle]];
    DeviceStatusViewController *viewController = [taskSB instantiateViewControllerWithIdentifier:@"DeviceStatus"];
    viewController.inspectionModel = self.inspectionModel;
    viewController.childModelsArray = self.childModelsArray;
    viewController.num = self.num+1;
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.backBarButtonItem = backButton;
    [self.navigationController pushViewController:viewController animated:YES];
    
    [self savaData];
}

- (void)preStep:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)doneClick:(id)sender {
    [self savaData];
    
    /*其它操作，后续要加上*/
    [self.navigationController popToViewController:scanRootViewController animated:YES];
}

- (void)savaData {
    /*保存数据*/
//    NSMutableDictionary *info = [[NSMutableDictionary alloc] init];
    NSString *ItemValue;
    NSString *DataValid;
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    if (self.inspectionChildModel.ItemType == 0) {
        UITextField *textField = [cell viewWithTag:1];
        ItemValue = textField.text;
    } else {
        UILabel *label = [cell viewWithTag:1];
        ItemValue = label.text;
    }
    NSIndexPath *selectedIndexPath = [self.tableView indexPathForSelectedRow];
    if (selectedIndexPath.row==0) {
        DataValid = @"正常";
    } else {
        DataValid = @"异常";
    }
    self.inspectionChildModel.ItemValue = ItemValue;
    self.inspectionChildModel.DataValid = DataValid;
    NSMutableDictionary *infoDic;
    if ([scanRootViewController.deviceCheckInfoDic.allKeys containsObject:self.inspectionChildModel.ParentCode]) {
        infoDic = scanRootViewController.deviceCheckInfoDic[self.inspectionChildModel.ParentCode];
    } else {
        infoDic = [[NSMutableDictionary alloc] init];
        [scanRootViewController.deviceCheckInfoDic setObject:infoDic forKey:self.inspectionChildModel.ParentCode];
    }
    [infoDic setObject:self.inspectionChildModel forKey:self.inspectionChildModel.ItemName];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section==0) {
        return 1;
    } else {
        return 2;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 44)];
    header.backgroundColor = [UIColor whiteColor];
    if (section == 0) {
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, (44-21)/2, 200, 21)];
        titleLabel.text = self.inspectionChildModel.ItemName;
        [header addSubview:titleLabel];
        return header;
    } else if (section == 1) {
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, (44-21)/2, 200, 21)];
        titleLabel.text = @"数据是否正常";
        [header addSubview:titleLabel];
        return header;
    }
    return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *CELLID;
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    if (section==0) {
        if (self.inspectionChildModel.ItemType == 0) {
            CELLID = @"TEXTFIELDCELL";
        } else {
            CELLID = @"ACTIONSHEETCELL";
        }
    } else if(section==1) {
        CELLID = @"RADIOCELL";
    }
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CELLID forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CELLID];
    }
    
    if (section==0) {
        if (self.inspectionChildModel.ItemType == 0) {
            UITextField *textView = [cell viewWithTag:1];
            textView.keyboardType = UIKeyboardTypeDecimalPad;
            textView.autocorrectionType = UITextAutocorrectionTypeNo;
            textView.delegate = self;
            textView.text = self.inspectionChildModel.ItemValue;
        } else {
            UILabel *label = [cell viewWithTag:1];
            label.text = self.inspectionChildModel.ItemValue;
            UIButton *openBtn = [cell viewWithTag:2];
            [openBtn addTarget:self action:@selector(popActionSheet) forControlEvents:UIControlEventTouchUpInside];
        }
    } else if(section==1) {
        UILabel *label = [cell viewWithTag:2];
        if (row == 0) {
            label.text = @"正常";
        } else {
            label.text = @"不正常";
        }
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 44;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section==0) {
        return 20;
    }
    return CGFLOAT_MIN;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    if (section==0 && row==0 && self.inspectionChildModel.ItemType==1) {
        [self popActionSheet];
        [self.tableView deselectRowAtIndexPath:indexPath animated:NO];
    } else if (section==1) {
        UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
        UIButton *radioBtn = [cell viewWithTag:1];
        radioBtn.selected = !radioBtn.selected;
        
        NSIndexPath *otherIndexPath = [NSIndexPath indexPathForItem:row==0?1:0 inSection:section];
        UITableViewCell *otherCell = [self.tableView cellForRowAtIndexPath:otherIndexPath];
        UIButton *otherRadioBtn = [otherCell viewWithTag:1];
        if (otherRadioBtn.selected) {
            otherRadioBtn.selected = !otherRadioBtn.selected;
            [self.tableView deselectRowAtIndexPath:otherIndexPath animated:NO];
        }
    }
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

- (void)popActionSheet {
    NSString *itemValues = self.inspectionChildModel.ItemValues;
    NSArray *itemArray = [itemValues componentsSeparatedByString:@"|"];
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle: @"请选择" delegate: self cancelButtonTitle: nil destructiveButtonTitle: nil otherButtonTitles: nil];
    for( NSString *title in itemArray)  {
        [actionSheet addButtonWithTitle:title];
    }
    [actionSheet addButtonWithTitle:@"取消"];
    actionSheet.cancelButtonIndex = [itemArray count];
    [actionSheet showInView:self.view];
}

#pragma mark - actionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
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
