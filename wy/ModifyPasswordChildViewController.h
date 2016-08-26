//
//  ModifyPasswordChildViewController.h
//  wy
//
//  Created by wangyilu on 16/8/26.
//  Copyright © 2016年 ___PURANG___. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ModifyPasswordChildViewController : UITableViewController

@property (weak, nonatomic) IBOutlet UITextField *originalPassword;
@property (weak, nonatomic) IBOutlet UITextField *yourNewPassword;
@property (weak, nonatomic) IBOutlet UITextField *confirmPassword;

@end
