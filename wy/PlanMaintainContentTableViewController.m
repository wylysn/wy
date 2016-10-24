//
//  PlanMaintainContentTableViewController.m
//  wy
//
//  Created by wangyilu on 16/10/9.
//  Copyright © 2016年 ___PURANG___. All rights reserved.
//

#import "PlanMaintainContentTableViewController.h"
#import "ChooseMaterialViewController.h"
#import "MaterialsEntity.h"
#import "ChooseToolViewController.h"
#import "ToolsEntity.h"

@interface PlanMaintainContentTableViewController ()<ChooseMaterialViewDelegate, ChooseToolViewDelegate, UITextFieldDelegate>

@end

@implementation PlanMaintainContentTableViewController {
    NSMutableDictionary *selectedMaterialsDic;
    NSMutableDictionary *selectedToolsDic;
    NSArray *editFieldsArray;
    BOOL isWZListEditable;
    BOOL isGJListEditable;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.estimatedRowHeight = 44;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    
    selectedMaterialsDic = [[NSMutableDictionary alloc] init];
    selectedToolsDic = [[NSMutableDictionary alloc] init];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)changeVariable {
    editFieldsArray = [[[self.planDetail.EditFields stringByReplacingOccurrencesOfString:@"[" withString:@""] stringByReplacingOccurrencesOfString:@"]" withString:@""] componentsSeparatedByString:@";"];
    isWZListEditable = !([editFieldsArray indexOfObject:@"WZList"]==NSNotFound);
    isGJListEditable = !([editFieldsArray indexOfObject:@"GJList"]==NSNotFound);
    
    //初始化赋值
    for (MaterialsEntity *material in self.planDetail.MaterialList) {
        [selectedMaterialsDic setObject:material forKey:material.Name];
    }
    for (ToolsEntity *tool in self.planDetail.ToolList) {
        [selectedToolsDic setObject:tool forKey:tool.Name];
    }
}

- (void)addWz:(UITapGestureRecognizer *)recognizer
{
    UIStoryboard* taskSB = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    ChooseMaterialViewController *chooseMaterialViewController = [taskSB instantiateViewControllerWithIdentifier:@"CHOOSEMATERIAL"];
    chooseMaterialViewController.delegate = self;
    chooseMaterialViewController.selectedMaterialsDic = selectedMaterialsDic;
    [self.navigationController pushViewController:chooseMaterialViewController animated:YES];
}

- (void)addGj:(UITapGestureRecognizer *)recognizer
{
    UIStoryboard* taskSB = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    ChooseToolViewController *chooseToolViewController = [taskSB instantiateViewControllerWithIdentifier:@"CHOOSETOOL"];
    chooseToolViewController.delegate = self;
    chooseToolViewController.selectedToolsDic = selectedToolsDic;
    [self.navigationController pushViewController:chooseToolViewController animated:YES];
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    UITableViewCell *cell = (UITableViewCell *)[[textField superview] superview];
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    NSInteger section = indexPath.section;
    
    if (section>=2 && section<2+(self.planDetail.MaterialList.count<1?1:self.planDetail.MaterialList.count)) {
        MaterialsEntity *material = self.planDetail.MaterialList[section-2];
        material.Number = [textField.text floatValue];
    }
    
    if (section>=2+(self.planDetail.MaterialList.count<1?1:self.planDetail.MaterialList.count) && section<2+(self.planDetail.MaterialList.count<1?1:self.planDetail.MaterialList.count)+(self.planDetail.ToolList.count<1?1:self.planDetail.ToolList.count)) {
        ToolsEntity *tool = self.planDetail.ToolList[section-(2+(self.planDetail.MaterialList.count<1?1:self.planDetail.MaterialList.count))];
        tool.Number = [textField.text floatValue];
    }
    
    return YES;
}

//- (BOOL)textFieldShouldReturn:(UITextField *)textField {
//    NSLog(@"输入的数据：%@", textField.text);
//    return YES;
//}

#pragma mark - ChooseMaterialViewDelegate

- (void)showSelectedMaterials:(NSArray *) materials {
    self.planDetail.MaterialList = [[NSMutableArray alloc] initWithArray:materials];
    [selectedMaterialsDic removeAllObjects];
    for (unsigned i = 0; i < self.planDetail.MaterialList.count; i++) {
        MaterialsEntity *material = (MaterialsEntity *)self.planDetail.MaterialList[i];
        [selectedMaterialsDic setObject:material forKey:material.Name];
    }
    [self.tableView reloadData];
}

#pragma mark - ChooseToolViewDelegate

- (void)showSelectedTools:(NSArray *) tools {
    self.planDetail.ToolList = [[NSMutableArray alloc] initWithArray:tools];
    [selectedToolsDic removeAllObjects];
    for (unsigned i = 0; i < self.planDetail.ToolList.count; i++) {
        ToolsEntity *tool = (ToolsEntity *)self.planDetail.ToolList[i];
        [selectedToolsDic setObject:tool forKey:tool.Name];
    }
    [self.tableView reloadData];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2+(self.planDetail.MaterialList.count<1?1:self.planDetail.MaterialList.count)+(self.planDetail.ToolList.count<1?1:self.planDetail.ToolList.count)+(self.planDetail.PositionList.count<1?1:self.planDetail.PositionList.count);
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 3;
    } else if (section == 1) {
        if (self.planDetail.StepList.count<1) {
            return 0;
        }
        return 2;
    } else if (section>=2 && section<2+(self.planDetail.MaterialList.count<1?1:self.planDetail.MaterialList.count)) {
        if (section==2 && self.planDetail.MaterialList.count<1) {
            return 0;
        }
        return 2;
    } else if (section>=2+(self.planDetail.MaterialList.count<1?1:self.planDetail.MaterialList.count) && section<2+(self.planDetail.MaterialList.count<1?1:self.planDetail.MaterialList.count)+(self.planDetail.ToolList.count<1?1:self.planDetail.ToolList.count)) {
        if (section==2+(self.planDetail.MaterialList.count<1?1:self.planDetail.MaterialList.count) && self.planDetail.ToolList.count<1) {
            return 0;
        }
        return 2;
    } else if (section >= 2+(self.planDetail.MaterialList.count<1?1:self.planDetail.MaterialList.count)+(self.planDetail.ToolList.count<1?1:self.planDetail.ToolList.count)) {
        if (section==2+(self.planDetail.MaterialList.count<1?1:self.planDetail.MaterialList.count)+(self.planDetail.ToolList.count<1?1:self.planDetail.ToolList.count) && self.planDetail.PositionList.count<1) {
            return 0;
        }
        return 2;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0 || section == 1 || section == 2 || section == 2+(self.planDetail.MaterialList.count<1?1:self.planDetail.MaterialList.count) || section == 2+(self.planDetail.MaterialList.count<1?1:self.planDetail.MaterialList.count)+(self.planDetail.ToolList.count<1?1:self.planDetail.ToolList.count)) {
        return 44;
    }
    return CGFLOAT_MIN;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 5;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 44)];
    if (section == 0) {
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, (44-21)/2, 200, 21)];
        titleLabel.text = @"基本信息";
        [header addSubview:titleLabel];
        return header;
    } else if (section == 1) {
        header.backgroundColor = [UIColor whiteColor];
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, (44-21)/2, 200, 21)];
        titleLabel.text = @"重点工作";
        [header addSubview:titleLabel];
        return header;
    } else if (section == 2) {
        header.backgroundColor = [UIColor whiteColor];
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, (44-21)/2, 200, 21)];
        titleLabel.text = @"物资需求";
        [header addSubview:titleLabel];
        
        if (isWZListEditable) {
            UIImageView *plusImageView = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-35, (44-25)/2, 25, 25)];
            plusImageView.image = [UIImage imageNamed:@"plus50"];
            UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(addWz:)];
            [plusImageView addGestureRecognizer:gesture];
            [plusImageView setUserInteractionEnabled:YES];
            [header addSubview:plusImageView];
        }
        return header;
    } else if (section == 2+(self.planDetail.MaterialList.count<1?1:self.planDetail.MaterialList.count)) {
        header.backgroundColor = [UIColor whiteColor];
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, (44-21)/2, 200, 21)];
        titleLabel.text = @"维护工具";
        [header addSubview:titleLabel];
        
        if (isGJListEditable) {
            UIImageView *plusImageView = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-35, (44-25)/2, 25, 25)];
            plusImageView.image = [UIImage imageNamed:@"plus50"];
            UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(addGj:)];
            [plusImageView addGestureRecognizer:gesture];
            [plusImageView setUserInteractionEnabled:YES];
            [header addSubview:plusImageView];
        }
        
        return header;
    } else if (section == 2+(self.planDetail.MaterialList.count<1?1:self.planDetail.MaterialList.count)+(self.planDetail.ToolList.count<1?1:self.planDetail.ToolList.count)) {
        header.backgroundColor = [UIColor whiteColor];
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, (44-21)/2, 200, 21)];
        titleLabel.text = @"空间位置";
        [header addSubview:titleLabel];
        return header;
    }
    return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    NSString *CELLID = @"PLANDETAILCELL";
    if ((
         (section>=2 && section<2+(self.planDetail.MaterialList.count<1?1:self.planDetail.MaterialList.count) && isWZListEditable)
         ||
         (section>=2+(self.planDetail.MaterialList.count<1?1:self.planDetail.MaterialList.count) && section<2+(self.planDetail.MaterialList.count<1?1:self.planDetail.MaterialList.count)+(self.planDetail.ToolList.count<1?1:self.planDetail.ToolList.count) && isGJListEditable)
         ) && row==1) {
        CELLID = @"PLANDETAILEDITCELL";
    }
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CELLID forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CELLID];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    UILabel *keyLabel = [cell viewWithTag:1];
    UILabel *valueLabel = [cell viewWithTag:2];
    if (section == 0) {
        if (row == 0) {
            keyLabel.text = @"维保名称";
            valueLabel.text = self.planDetail.Name;
        } else if (row == 1) {
            keyLabel.text = @"优先级";
            valueLabel.text = self.planDetail.Priority;
        } else if (row == 2) {
            keyLabel.text = @"时间";
            valueLabel.text = self.planDetail.ExecuteTime;
        }
    } else if (section == 1) {
        for (NSDictionary *workDic in self.planDetail.StepList) {
            keyLabel.text = @"维护内容";
            valueLabel.text = workDic[@"Content"];
        }
    } else if (section>=2 && section<2+(self.planDetail.MaterialList.count<1?1:self.planDetail.MaterialList.count)) {
        if (self.planDetail.MaterialList.count>0) {
            MaterialsEntity *material = self.planDetail.MaterialList[section-2];
            if (row == 0) {
                keyLabel.text = @"物资名称";
                valueLabel.text = material.Name;
            }
            /*
            else if (row == 1) {
                keyLabel.text = @"品牌";
                valueLabel.text = materialDic[@"Wzpinp"];
            } else if (row == 2) {
                keyLabel.text = @"型号";
                valueLabel.text = materialDic[@"Wztype"];
            } else if (row == 3) {
                keyLabel.text = @"单位";
                valueLabel.text = materialDic[@"WzUnitName"];
            }
            */
            else if (row == 1) {
                keyLabel.text = @"数量";
                NSString *num = [[NSNumber numberWithFloat:material.Number] stringValue];
                num = [@"0" isEqualToString:num]?@"":num;
                if (isWZListEditable) {
                    UITextField *textField = [cell viewWithTag:2];
                    textField.delegate = self;
                    textField.keyboardType = UIKeyboardTypeDecimalPad;
                    textField.text = num;
                } else {
                    valueLabel.text = num;
                }
            }
        }
    } else if (section>=2+(self.planDetail.MaterialList.count<1?1:self.planDetail.MaterialList.count) && section<2+(self.planDetail.MaterialList.count<1?1:self.planDetail.MaterialList.count)+(self.planDetail.ToolList.count<1?1:self.planDetail.ToolList.count)) {
        ToolsEntity *tool = self.planDetail.ToolList[section-(2+(self.planDetail.MaterialList.count<1?1:self.planDetail.MaterialList.count))];
        if (row == 0) {
            keyLabel.text = @"工具名称";
            valueLabel.text = tool.Name;
        }
        /*
        else if (row == 1) {
            keyLabel.text = @"型号/规格";
            valueLabel.text = toolDic[@"Gjtype"];
        }
         */
        else if (row == 1) {
            keyLabel.text = @"数量";
            NSString *num = [[NSNumber numberWithFloat:tool.Number] stringValue];
            num = [@"0" isEqualToString:num]?@"":num;
            if (isGJListEditable) {
                UITextField *textField = [cell viewWithTag:2];
                textField.delegate = self;
                textField.keyboardType = UIKeyboardTypeDecimalPad;
                textField.text = num;
            } else {
                valueLabel.text = num;
            }
        }
    } else if (section >= 2+(self.planDetail.MaterialList.count<1?1:self.planDetail.MaterialList.count)+(self.planDetail.ToolList.count<1?1:self.planDetail.ToolList.count)) {
        NSDictionary *positionDic = self.planDetail.PositionList[section-(2+(self.planDetail.MaterialList.count<1?1:self.planDetail.MaterialList.count)+(self.planDetail.ToolList.count<1?1:self.planDetail.ToolList.count))];
        if (row == 0) {
            keyLabel.text = @"编码";
            valueLabel.text = positionDic[@"Code"];
        } else if (row == 1) {
            keyLabel.text = @"位置空间";
            valueLabel.text = positionDic[@"Name"];
        }
    }
    
    return cell;
}

@end
