//
//  EditProfileViewController.h
//  HealthVive
//
//  Created by Sriram Sadhasivan (BLR GSS) on 23/01/17.
//  Copyright © 2017 NousInfosystems. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EditProfileViewController : BaseViewController<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIButton *titleBtn;
@property (weak, nonatomic) IBOutlet UITableView *contactDetailsTableView;


@property (strong, nonatomic) IBOutlet UIScrollView *editScrollView;

//TextFields
@property (weak, nonatomic) IBOutlet UITextField *foreNametextField;
@property (weak, nonatomic) IBOutlet UITextField *surnameTxtField;
@property (weak, nonatomic) IBOutlet UITextField *address2TxtFld;
@property (weak, nonatomic) IBOutlet UITextField *townCityTxtFld;
@property (weak, nonatomic) IBOutlet UITextField *postCodeTxtfld;
@property (weak, nonatomic) IBOutlet UITextField *mobileTxtFld;
@property (weak, nonatomic) IBOutlet UITextField *homephoneTxtFld;
@property (weak, nonatomic) IBOutlet UITextField *alternateEmailTxtFld;
@property (weak, nonatomic) IBOutlet UIButton *countryBtn;

@property (weak, nonatomic) IBOutlet UIView *datePickerView;
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;




@property (weak, nonatomic) IBOutlet UIButton *dobBtn;
@property (weak, nonatomic) IBOutlet UIButton *genderBtn;


//Strings
@property(nonatomic,strong)NSString *ctitle;
@property(nonatomic,strong)NSString *surName;
@property(nonatomic,strong)NSString *dob;
@property(nonatomic,strong)NSString *gender;
@property(nonatomic,assign)int consumerId;
@property (weak, nonatomic) IBOutlet UITableView *popUpTableView;
@property (weak, nonatomic) IBOutlet UILabel *popUpTitleLbl;

@end
