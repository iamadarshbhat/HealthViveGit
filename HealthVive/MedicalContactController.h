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

@interface MedicalContactController : BaseViewController
@property (weak, nonatomic) IBOutlet UIButton *btnAddContact;
@property (weak, nonatomic) IBOutlet UITableView *medicalContacttableView;
- (IBAction)addContactAction:(id)sender;
- (IBAction)addBarButtonAction:(id)sender;

@end
