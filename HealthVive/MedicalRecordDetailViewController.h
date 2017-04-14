//
//  MedicalRecordDetailViewController.h
//  HealthVive
//
//  Created by Adarsha on 31/03/17.
//  Copyright © 2017 NousInfosystems. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Medical_event+CoreDataProperties.h"
#import "SummaryContactListController.h"

@interface MedicalRecordDetailViewController : BaseViewController<SummaryContactListDelegate>
@property (weak, nonatomic) IBOutlet UITableView *medicalRecordDetailTable;
@property Medical_event *selectedMedicalEvent;
@property BOOL isNavigatinFromSearch;
@end
