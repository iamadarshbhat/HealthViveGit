//
//  RegistrationEssentialController.h
//  HealthVive
//
//  Created by Adarsha on 19/01/17.
//  Copyright © 2017 NousInfosystems. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Consumer.h"

@interface RegistrationEssentialController : BaseViewController

@property (weak, nonatomic) IBOutlet UITextField *txtForeName;
@property (weak, nonatomic) IBOutlet UIButton *btnTitle;
@property (weak, nonatomic) IBOutlet UITextField *txtSurName;
@property (weak, nonatomic) IBOutlet UIButton *btnSelectDate;
@property (weak, nonatomic) IBOutlet UIButton *btnMale;
@property (weak, nonatomic) IBOutlet UIButton *btnFemale;
@property (weak, nonatomic) IBOutlet UIButton *btnOther;
@property (weak, nonatomic) IBOutlet UIButton *btnRegister;
@property (weak, nonatomic) IBOutlet UITableView *titleTable;
@property (weak, nonatomic) IBOutlet UIDatePicker *datePickerView;
@property (weak, nonatomic) IBOutlet UIView *datePickerPopupView;

@property Consumer *consumerToRegister;


- (IBAction)dateOkAction:(id)sender;
- (IBAction)dateCancelAction:(id)sender;
- (IBAction)titleClickAction:(id)sender;
- (IBAction)backButtonAction:(id)sender;
- (IBAction)selectDateAction:(id)sender;
- (IBAction)registerBtnAction:(id)sender;
- (IBAction)maleBtnAction:(id)sender;
- (IBAction)femaleBtnAction:(id)sender;
- (IBAction)otherBtnAction:(id)sender;
- (IBAction)dateValueChanged:(id)sender;

@end
