//
//  TaskChildTableViewController.m
//  wy
//
//  Created by 王益禄 on 16/8/28.
//  Copyright © 2016年 ___PURANG___. All rights reserved.
//

#import "TaskChildTableViewController.h"
#import "ChoosePersonViewController.h"
#import "PersonEntity.h"

@interface TaskChildTableViewController ()<ChoosePersonViewDelegate>

@end

@implementation TaskChildTableViewController {
    NSMutableDictionary *chargePersonDics;
    NSMutableArray *chargePersons;
    
    NSMutableDictionary *excutePersonDics;
    NSMutableArray *excutePersons;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableView setSeparatorInset:UIEdgeInsetsMake(0,10,0,0)];
    }
    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)])  {
        [self.tableView setLayoutMargins:UIEdgeInsetsZero];
    }
    
    chargePersonDics = [[NSMutableDictionary alloc] init];
    chargePersons = [[NSMutableArray alloc] init];
    excutePersonDics = [[NSMutableDictionary alloc] init];
    excutePersons = [[NSMutableArray alloc] init];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)addPersonInCharge {
    [self toChoosePerson:1];
}
- (void)addPersonInExcute {
    [self toChoosePerson:2];
}

- (void)toChoosePerson:(int)type {
    UIStoryboard* taskSB = [UIStoryboard storyboardWithName:@"Task" bundle:[NSBundle mainBundle]];
    ChoosePersonViewController *choosePersonViewController = [taskSB instantiateViewControllerWithIdentifier:@"CHOOSEPERSON"];
    choosePersonViewController.delegate = self;
    choosePersonViewController.type = type;
    if (type==1) {
        choosePersonViewController.selectedPersonsDic = chargePersonDics;
    }
    else {
        choosePersonViewController.selectedPersonsDic = excutePersonDics;
    }
    [self.navigationController pushViewController:choosePersonViewController animated:YES];
}

- (void)getSelectedPersons:(NSArray *)persons withType:(int)type {
    if (type == 1) {
        [self doChargePersons:persons];
    }
    else {
        [self doExcutePersons:persons];
    }
}

- (void)doChargePersons:(NSArray *)persons {
    [chargePersons removeAllObjects];
    [chargePersons addObjectsFromArray:persons];
    
    [chargePersonDics removeAllObjects];
    for (unsigned i = 0; i < persons.count; i++) {
        PersonEntity *person = (PersonEntity*)persons[i];
        [chargePersonDics setObject:person forKey:person.AppUserName];
    }
    
//    NSMutableArray *indexPaths = [[NSMutableArray alloc] init];
//    for (int i=0; i<persons.count; i++) {
//        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:1];
//        [indexPaths addObject: indexPath];
//    }
    
//    [self.tableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationNone];
    [self.tableView reloadData];
}

- (void)doExcutePersons:(NSArray *)persons {
    [excutePersons removeAllObjects];
    [excutePersons addObjectsFromArray:persons];
    
    [excutePersonDics removeAllObjects];
    for (unsigned i = 0; i < persons.count; i++) {
        PersonEntity *person = (PersonEntity*)persons[i];
        [excutePersonDics setObject:person forKey:person.AppUserName];
    }
    
//    NSMutableArray *indexPaths = [[NSMutableArray alloc] init];
//    for (int i=0; i<persons.count; i++) {
//        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:1];
//        [indexPaths addObject: indexPath];
//    }
    
    //    [self.tableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationNone];
    [self.tableView reloadData];
}

#pragma mark - Table view data source

-(NSInteger)tableView:(UITableView *)tableView indentationLevelForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger section = indexPath.section;
    if (section == 1) {
        return [super tableView:tableView indentationLevelForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:section]];
    } else if (section == 2) {
        return [super tableView:tableView indentationLevelForRowAtIndexPath:[NSIndexPath indexPathForRow:excutePersons.count inSection:section]];
    } else {
        return [super tableView:tableView indentationLevelForRowAtIndexPath:indexPath];
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 120, 44)];
        header.backgroundColor = [UIColor whiteColor];
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, (44-21)/2, 200, 21)];
        titleLabel.text = @"PM0000000001";
        [header addSubview:titleLabel];
        return header;
    }
    if (section == 1) {
        UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 120, 44)];
        header.backgroundColor = [UIColor whiteColor];
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, (44-21)/2, 200, 21)];
        titleLabel.text = @"负责人(只一位)";
        [header addSubview:titleLabel];
        UIButton *addButton = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-10-50, (44-25)/2, 50, 25)];
        [addButton setTitle:@"添加" forState:UIControlStateNormal];
        addButton.titleLabel.font = [UIFont systemFontOfSize:15];
        [addButton setBackgroundColor:[UIColor colorFromHexCode:@"8EC158"]];
        addButton.layer.cornerRadius = 2;
        [addButton addTarget:self action:@selector(addPersonInCharge) forControlEvents:UIControlEventTouchUpInside];
        [header addSubview:addButton];
        return header;
    }
    if (section == 2) {
        UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 120, 44)];
        header.backgroundColor = [UIColor whiteColor];
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, (44-21)/2, 200, 21)];
        titleLabel.text = @"执行人(多位)";
        [header addSubview:titleLabel];
        UIButton *addButton = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-10-50, (44-25)/2, 50, 25)];
        [addButton setTitle:@"添加" forState:UIControlStateNormal];
        addButton.titleLabel.font = [UIFont systemFontOfSize:15];
        [addButton setBackgroundColor:[UIColor colorFromHexCode:@"8EC158"]];
        addButton.layer.cornerRadius = 2;
        [addButton addTarget:self action:@selector(addPersonInExcute) forControlEvents:UIControlEventTouchUpInside];
        [header addSubview:addButton];
        return header;
    }
    return nil;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return [super tableView:tableView numberOfRowsInSection:section];
    } else if (section == 1) {
        if (!chargePersons) {
            return 0;
        } else {
            return chargePersons.count;
        }
    } else if (section == 2) {
        if (!excutePersons) {
            return 0;
        } else {
            return excutePersons.count;
        }
    }
    return 0;
}

- (UITableViewCell *) tableView:(UITableView *) tableView cellForRowAtIndexPath:(NSIndexPath *) indexPath
{
    // for cells not in section 1, rely on the IB definition of the cell
    if (indexPath.section != 1 && indexPath.section != 2)
        return [super tableView:tableView cellForRowAtIndexPath:indexPath];
    
    // configure a task status cell for section 1
    UITableViewCell *cell;
    cell = [tableView dequeueReusableCellWithIdentifier:@"myCustomCell"];
    if (!cell)
    {
        // create a cell
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"myCustomCell"];
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0 || section == 1 || section == 2) {
        return 44;
    }
    return CGFLOAT_MIN;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == 0 || section == 1 || section == 2) {
        return 6;
    }
    return CGFLOAT_MIN;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger section = indexPath.section;
    if (section == 1 || section == 2) {
        return 30;
    }
    return [super tableView:tableView heightForRowAtIndexPath:indexPath];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableView setSeparatorInset:UIEdgeInsetsMake(0,10,0,0)];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)])  {
        [self.tableView setLayoutMargins:UIEdgeInsetsMake(0,10,0,0)];
    }
}

/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
