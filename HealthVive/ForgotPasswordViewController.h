//
//  ForgotPasswordViewController.h
//  HealthVive
//
//  Created by Sadhasivan Sriram on 16/01/17.
//  Copyright © 2017 NousInfosystems. All rights reserved.
//

#import "BaseViewController.h"

@interface ForgotPasswordViewController : BaseViewController
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UIButton *resetPasswordBtn;
- (IBAction)resetPasswordClicked:(id)sender;
@end
