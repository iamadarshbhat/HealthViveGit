//
//  ChangePasswordTableController.h
//  HealthVive
//
//  Created by Adarsha on 23/02/17.
//  Copyright © 2017 NousInfosystems. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChangePasswordTableController : UITableViewController

@property (weak, nonatomic) IBOutlet UITextField *txtCurrentPassword;

@property (weak, nonatomic) IBOutlet UITextField *txtNewPassword;
@property (weak, nonatomic) IBOutlet UITextField *txtConfirmPassword;

@end
