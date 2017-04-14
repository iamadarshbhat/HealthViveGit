//
//  MedicalRecordsViewController.h
//  HealthVive
//
//  Created by Sriram Sadhasivan (BLR GSS) on 03/02/17.
//  Copyright © 2017 NousInfosystems. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SummaryContactListController.h"

@interface MedicalRecordsViewController : BaseViewController<SummaryContactListDelegate>
@property (weak, nonatomic) IBOutlet UIButton *createEventBtn;
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UITableView *medicalRecordTableView;
//- (IBAction)showSummaryContactListAction:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *tblHeaderView;

@end
