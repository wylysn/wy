//
//  PlanService.m
//  wy
//
//  Created by wangyilu on 16/10/10.
//  Copyright © 2016年 ___PURANG___. All rights reserved.
//

#import "PlanService.h"

@implementation PlanService

- (void)getPlanDetail:(NSString *)code success:(void (^)(PlanDetailEntity *planDetail))success failure:(void (^)(NSString *message))failure {
    PlanDetailEntity *plan = [[PlanDetailEntity alloc] init];
    plan.Name = @"冷水机组维护";
    plan.Priority = @"1";
    plan.ExecuteTime = @"2016-09-21 11:05:11";
    plan.StepList = @[@{@"Code":@"1", @"Content":@"维护1"},@{@"Code":@"2", @"Content":@"维护2维护2维护2维护2维护2维护2维护2维护2，维护2"}];
    plan.MaterialList = @[@{@"WzName":@"螺丝帽", @"Wzpinp":@"德国宝来", @"Wztype":@"X1-11", @"WzUnitName":@"个", @"Wznumber":@"21"},@{@"WzName":@"螺丝帽2", @"Wzpinp":@"德国宝来", @"Wztype":@"X1-11", @"WzUnitName":@"个", @"Wznumber":@"1"}];
    plan.ToolList = @[@{@"GjName":@"螺丝刀", @"Gjtype":@"K-13", @"Gjnumber":@"2把"}, @{@"GjName":@"螺丝刀2", @"Gjtype":@"K-14", @"Gjnumber":@"1把"}];
    plan.PositionList = @[@{@"Code":@"015", @"Name":@"上海国际旅游区能源站维保管理系统/能源站/设备系统/主设备间"},@{@"Code":@"016", @"Name":@"上海国际旅游区能源站维保管理系统/能源站/设备系统/主设备间"}];
    plan.SBList = @[@{@"Code":@"000010", @"Name":@"冷却塔软水设备", @"CatalogName":@"非电力系统/化水/化水设备", @"Position":@"上海国际旅游区能源站维保管理系统/能源站/设备系统/主设备间"}, @{@"Code":@"000020", @"Name":@"冷却塔软水设备", @"CatalogName":@"非电力系统/化水/化水设备", @"Position":@"上海国际旅游区能源站维保管理系统/能源站/设备系统/主设备间"}];
    plan.TaskInfo = @{@"Code":@"123456", @"ShortTitle":@"3", @"Subject":@"", @"Location":@""};
    success(plan);
}

@end
