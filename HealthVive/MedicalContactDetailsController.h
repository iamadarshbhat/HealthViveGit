//
//  MedicalContactDetailsController.h
//  HealthVive
//
//  Created by Adarsha on 27/01/17.
//  Copyright © 2017 NousInfosystems. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "My_contacts+CoreDataProperties.h"

@interface MedicalContactDetailsController : BaseViewController
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UITextField *txtForeName;
@property (weak, nonatomic) IBOutlet UITextField *txtSurName;
@property (weak, nonatomic) IBOutlet UITextField *txtEmail;
@property (weak, nonatomic) IBOutlet UITextField *txtSpecialism;
@property (weak, nonatomic) IBOutlet UITextField *txtAddress;
@property (weak, nonatomic) IBOutlet UITextField *txtTelephone;
@property My_contacts *medicalContact;
@property NSMutableArray *medicalContacts;
@property BOOL isEditing;

@end
