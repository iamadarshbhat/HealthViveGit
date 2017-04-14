//
//  MedicalContactEditController.h
//  HealthVive
//
//  Created by Adarsha on 30/01/17.
//  Copyright © 2017 NousInfosystems. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MedicalContactDetailsController.h"
#import "My_contacts+CoreDataClass.h"
@interface MedicalContactEditController : BaseViewController
@property NSDictionary *medicalcontacts;
@property  My_contacts *medicalContact;
@property NSMutableArray *allSavedContacts;
@property (weak, nonatomic) IBOutlet UITableView *editLocalContactTableView;
@property (weak, nonatomic) IBOutlet UIView *viewtableHeader;
@property (weak, nonatomic) IBOutlet UILabel *lblName;
@property (weak, nonatomic) IBOutlet UILabel *lblSpecialism;
@property (weak, nonatomic) IBOutlet UILabel *lblOrganization;
@property (weak, nonatomic) IBOutlet UIButton *btnMessage;


@property (weak, nonatomic) IBOutlet NSLayoutConstraint *orgToSpecConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *messageToSpecConstraint;

//Approve and Reject
@property (weak, nonatomic) IBOutlet UIButton *approveBtn;
@property (weak, nonatomic) IBOutlet UIButton *rejectBtn;

@end
