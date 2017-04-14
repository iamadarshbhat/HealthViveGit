//
//  MedicalRecordsDetailViewController.h
//  HealthVive
//
//  Created by Sriram Sadhasivan (BLR GSS) on 06/02/17.
//  Copyright © 2017 NousInfosystems. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MedicalRecord.h"
#import "Medical_event+CoreDataClass.h"
#import "SummaryContactListController.h"

@interface MedicalRecordsDetailViewController : BaseViewController<SummaryContactListDelegate>
@property (weak, nonatomic) IBOutlet UITableView *medicalRecordDetailTableView;
@property (nonatomic,strong)Medical_event *eventDetails;
@property (weak, nonatomic) IBOutlet UILabel *lblEventTitle;

@property (weak, nonatomic) IBOutlet UILabel *lblEventDate;
@property BOOL isNavigatinFromSearch;

//To get selected Event
-(void)getSelectedEventDetails:(Medical_event*)eventDetails;
@end
