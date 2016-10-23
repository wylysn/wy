//
//  PlanDetailEntity.m
//  wy
//
//  Created by wangyilu on 16/10/10.
//  Copyright © 2016年 ___PURANG___. All rights reserved.
//

#import "PlanDetailEntity.h"
#import "MaterialsEntity.h"
#import "ToolsEntity.h"

@implementation PlanDetailEntity

/**
 * type:0-本地；1-后台
 **/
- (instancetype)initWithDictionary:(NSDictionary *)dictionary withType:(NSInteger)type
{
    self = super.init;
    if (self) {
        _Code = dictionary[@"Code"];
        _Name = dictionary[@"Name"];
        _Priority = dictionary[@"Priority"];
        _ExecuteTime = dictionary[@"ExecuteTime"];
        _StepList = dictionary[@"StepList"];
        
        NSArray *materialDicArr = dictionary[@"MaterialList"];
        NSMutableArray *materialArr = [[NSMutableArray alloc] init];
        for (NSDictionary *materialDic in materialDicArr) {
            MaterialsEntity *material;
            if (type==0) {
                material = [[MaterialsEntity alloc] initWithDictionary:materialDic];
            } else {
                material = [[MaterialsEntity alloc] initWithNetDictionary:materialDic];
            }
            
            [materialArr addObject:material];
        }
        _MaterialList = materialArr;
        
        NSArray *toolDicArr = dictionary[@"ToolList"];
        NSMutableArray *toolArr = [[NSMutableArray alloc] init];
        for (NSDictionary *toolDic in toolDicArr) {
            ToolsEntity *tool;
            if (type==0) {
                tool = [[ToolsEntity alloc] initWithDictionary:toolDic];
            } else {
                tool = [[ToolsEntity alloc] initWithNetDictionary:toolDic];
            }
            [toolArr addObject:tool];
        }
        _ToolList = toolArr;
        
        _PositionList = dictionary[@"PositionList"];
        _SBList = dictionary[@"SBList"];
        _TaskAction = dictionary[@"TaskAction"];
        _TaskInfo = dictionary[@"TaskInfo"];
        _EditFields = dictionary[@"EditFields"];
        
        _IsLocalSave = [dictionary[@"IsLocalSave"] boolValue];
    }
    return self;
}

@end
