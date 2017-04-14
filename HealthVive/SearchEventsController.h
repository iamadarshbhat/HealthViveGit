//
//  SearchEventsController.h
//  HealthVive
//
//  Created by Adarsha on 01/03/17.
//  Copyright © 2017 NousInfosystems. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchEventsController : BaseViewController<UISearchBarDelegate>
- (IBAction)cancelPopupAction:(id)sender;

@property NSMutableOrderedSet *eventsArrayForSummary;
@property (weak, nonatomic) IBOutlet UITableView *searchTableView;
@property (weak, nonatomic) IBOutlet UIView *filterView;
@property (weak, nonatomic) IBOutlet UIButton *btnSingleDay;
@property (weak, nonatomic) IBOutlet UIButton *btnRange;
@property (weak, nonatomic) IBOutlet UIButton *frmBtn;
@property (weak, nonatomic) IBOutlet UIButton *toBtn;
@property (weak, nonatomic) IBOutlet UIView *lineViewToBtn;
@property (weak, nonatomic) IBOutlet UIView *datePickerView;
@property (weak, nonatomic) IBOutlet UIDatePicker *datePickker;

@property (weak, nonatomic) IBOutlet UILabel *lblNoSearchResults;

@property (weak, nonatomic) IBOutlet UIView *eventPopupView;



@property (weak, nonatomic) IBOutlet UIButton *btnSelectEventType;

- (IBAction)clearBtnAction:(id)sender;
- (IBAction)frmBtnAction:(id)sender;
- (IBAction)toBtnAction:(id)sender;
- (IBAction)singleDayBtnAction:(id)sender;
- (IBAction)dateRangeBtnAction:(id)sender;
- (IBAction)datePickerValueChanged:(id)sender;
- (IBAction)applyFilterAction:(id)sender;
- (IBAction)calendarEventAction:(id)sender;
- (IBAction)messageEventAction:(id)sender;
- (IBAction)selectEventTypeAction:(id)sender;
- (IBAction)datePickerCancelAction:(id)sender;
- (IBAction)datePickerOkAction:(id)sender;
- (IBAction)healthEventAction:(id)sender;


@end
