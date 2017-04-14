//
//  AddMedicalRecordViewController.h
//  HealthVive
//
//  Created by Sriram Sadhasivan (BLR GSS) on 08/02/17.
//  Copyright © 2017 NousInfosystems. All rights reserved.
//

#import "BaseViewController.h"
#import "Medical_event+CoreDataProperties.h"
#import "SummaryContactListController.h"
//#import "MedicalR"
@interface AddMedicalRecordViewController : BaseViewController<SummaryContactListDelegate>

//Views
@property (weak, nonatomic) IBOutlet UIView *view1;
@property (weak, nonatomic) IBOutlet UIView *view2;
@property (weak, nonatomic) IBOutlet UIView *view3;
@property (weak, nonatomic) IBOutlet UIView *view4;
@property (weak, nonatomic) IBOutlet UIView *view5;
@property (weak, nonatomic) IBOutlet UIView *view6;
@property (weak, nonatomic) IBOutlet UIView *view7;
@property (weak, nonatomic) IBOutlet UIView *eventTypeView;
@property (weak, nonatomic) IBOutlet UIView *createdDateView;
//ScrollView
@property (weak, nonatomic) IBOutlet UIScrollView *recordScrollView;

//Constraints
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *view2HeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *scrollViewHeightConstraint;



//label
@property (weak, nonatomic) IBOutlet UILabel *createdDateLabel;


//TextFields

@property (weak, nonatomic) IBOutlet UITextField *titleTxtFld;
@property (weak, nonatomic) IBOutlet UITextField *bodyLoctxtFld;
@property (weak, nonatomic) IBOutlet UITextField *symptomsTxtFld;
@property (weak, nonatomic) IBOutlet UITextField *providerNameTxtFld;
@property (weak, nonatomic) IBOutlet UITextField *providerTypeTxtFld;
@property (weak, nonatomic) IBOutlet UITextField *careTypeTxtFld;
@property (weak, nonatomic) IBOutlet UITextField *descTextFld;


//Btn
@property (weak, nonatomic) IBOutlet UIButton *datebtn;
@property (weak, nonatomic) IBOutlet UIButton *expandableBtn;
@property (weak, nonatomic) IBOutlet UIButton *eventTypeBtn;

//popup Dateview Objects
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (weak, nonatomic) IBOutlet UIView *datePickerView;

@property(nonatomic,assign)BOOL isFromRecords;

//Popup TableView
@property (weak, nonatomic) IBOutlet UITableView *popUpTableView;


//get selected event details for edit
@property(nonatomic,strong)Medical_event *eventDetails;
@property BOOL isNavigatingFromSearch;
-(void)getSelectedEventDetails:(Medical_event*)eventDetails;

@property BOOL isEditing;



@end
