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
@property (weak, nonatomic) IBOutlet UIView *blurView;

@property (weak, nonatomic) IBOutlet UIScrollView *editScrollView;

//TextFields
@property (weak, nonatomic) IBOutlet UITextField *foreNametextField;
@property (weak, nonatomic) IBOutlet UITextField *surnameTxtField;
@property (weak, nonatomic) IBOutlet UIButton *dobBtn;
@property (weak, nonatomic) IBOutlet UIButton *genderBtn;


//Strings
@property(nonatomic,strong)NSString *ctitle;
@property(nonatomic,strong)NSString *surName;
@property(nonatomic,strong)NSDate *dob;
@property(nonatomic,strong)NSString *gender;
@property(nonatomic,assign)int consumerId;
@property (weak, nonatomic) IBOutlet UITableView *popUpTableView;
@property (weak, nonatomic) IBOutlet UILabel *popUpTitleLbl;

@end
