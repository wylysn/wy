//
//  KnowledgeDetailTableViewController.h
//  wy
//
//  Created by 王益禄 on 16/8/31.
//  Copyright © 2016年 ___PURANG___. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KnowledgeEntity.h"

@interface KnowledgeDetailTableViewController : UITableViewController

@property (nonatomic,strong) NSString *keyword;
@property (nonatomic,strong) KnowledgeEntity *knowlwdge;

@end
