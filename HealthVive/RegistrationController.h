//
//  RegistrationController.h
//  HealthVive
//
//  Created by Adarsha on 17/01/17.
//  Copyright © 2017 NousInfosystems. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RegistrationController : BaseViewController

@property (weak, nonatomic) IBOutlet UITextField *txtemail;

@property (weak, nonatomic) IBOutlet UITextField *txtPassword;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIButton *btnNext;
@property (weak, nonatomic) IBOutlet UIButton *btnSelectGrp;
- (IBAction)selectGrpAction:(id)sender;
- (IBAction)nextBtnAction:(id)sender;
- (IBAction)infoOkAction:(id)sender;
- (IBAction)infoBtnAction:(id)sender;
- (IBAction)iHaveAccountAction:(id)sender;


@property (weak, nonatomic) IBOutlet NSLayoutConstraint *grpTableHeightConstraint;
@property (weak, nonatomic) IBOutlet UIView *viewInfo;
@property (weak, nonatomic) IBOutlet UIButton *btninfoOK;
@property (weak, nonatomic) IBOutlet UILabel *lblPasswordInfo;
@property (weak, nonatomic) IBOutlet UITableView *tblGroupOptions;
@property (weak, nonatomic) IBOutlet UIButton *btnPassInfo;

@property (weak, nonatomic) IBOutlet UIButton *btnShowPassword;
- (IBAction)showPasswordAction:(id)sender;

@end
