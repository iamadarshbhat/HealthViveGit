//
//  MedicalContactController.h
//  HealthVive
//
//  Created by Adarsha on 25/01/17.
//  Copyright © 2017 NousInfosystems. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MedicalContactDetailsController.h"
#import "MedicalContactCell.h"
#import "MedicalContactEditController.h"
#import "My_contacts+CoreDataClass.h"

@interface ActiveContactsController : BaseViewController<UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UIButton *btnAddContact;
@property (weak, nonatomic) IBOutlet UITableView *medicalContacttableView;
- (IBAction)addContactAction:(id)sender;

@property (weak, nonatomic) IBOutlet UIView *addMedicalContactView;

//Provider ContactsNotification HeadeeView
@property (weak, nonatomic) IBOutlet UIView *headerNotificationView;

@property (weak, nonatomic) IBOutlet UITableView *providerInvitedContactsTableView;


//Constraints
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *providerContactstableHeifhtConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *medicalContactsHeightConstraint;
@property (weak, nonatomic) IBOutlet UIScrollView *contactsScrollView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentViewHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *viewTopConstraint;

@end
