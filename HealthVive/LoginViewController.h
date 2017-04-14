//
//  LoginViewController.h
//  HealthVive
//
//  Created by Adarsha on 10/01/17.
//  Copyright © 2017 NousInfosystems. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

typedef NS_OPTIONS(NSUInteger, AccountStatus) {
    Registered = 1,
    Approved = 2,
    Rejected = 3,
    Suspended = 4,
    Deactivated = 5,
    UnAuthenticated = 6,
    ApprovedWithEmailUnverified = 7
};


@interface LoginViewController : BaseViewController

@property (weak, nonatomic) IBOutlet UITextField *emailTxtField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTxtField;


//Buttons
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;
@property (weak, nonatomic) IBOutlet UIButton *forgotBtn;
@property (nonatomic,assign)AccountStatus *statusType;


@end
