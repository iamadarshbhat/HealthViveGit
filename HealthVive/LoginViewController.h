//
//  LoginViewController.h
//  HealthVive
//
//  Created by Adarsha on 10/01/17.
//  Copyright © 2017 NousInfosystems. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginViewController : BaseViewController


@property (weak, nonatomic) IBOutlet UITextField *emailTxtField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTxtField;


@property (weak, nonatomic) IBOutlet UIView *loginHeightConstraint;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *usrImgConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *labelConatraint;


//imageView
@property (weak, nonatomic) IBOutlet UIImageView *nextimage;

//Buttons
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;
@property (weak, nonatomic) IBOutlet UIButton *infoBtn;
@property (weak, nonatomic) IBOutlet UIButton *forgotBtn;


@end
