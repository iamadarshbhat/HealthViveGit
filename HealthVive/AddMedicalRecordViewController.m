//
//  AddMedicalRecordViewController.m
//  HealthVive
//
//  Created by Sriram Sadhasivan (BLR GSS) on 08/02/17.
//  Copyright © 2017 NousInfosystems. All rights reserved.
//

#import "AddMedicalRecordViewController.h"
#import "CoreDataManager.h"
#import "Globals.h"
#import "Constants.h"
#import "SearchEventsController.h"


@interface AddMedicalRecordViewController ()

{
    BOOL isExpand;
    UITextField *activeTextField;
    CoreDataManager *cdm;
    Globals *globals;
    
    NSArray *updatedArray;
    
    NSMutableArray *appendArray;
    NSMutableArray *eventTypeArray;
    int eventType;
    Medical_event *medicalEventRecord;
    CGFloat screenHeight;
}
@end

@implementation AddMedicalRecordViewController
@synthesize isEditing;
@synthesize isNavigatingFromSearch;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setNaviagationBarWithTitle:EventDetailsnavigationTitle];
     //[_datePicker setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
    isExpand = NO;
    _eventTypeView.hidden = NO;
    _view3.hidden = YES;
    _view4.hidden = YES;
    _view5.hidden = YES;
    _view6.hidden = YES;
    _view7.hidden = YES;
    _createdDateView.hidden = YES;
    _view2HeightConstraint.constant = 50;
    
    //setTextFieldDelegate
    _titleTxtFld.delegate = self;
    _bodyLoctxtFld.delegate = self;
    _symptomsTxtFld.delegate = self;
    _symptomsTxtFld.delegate = self;
    _providerNameTxtFld.delegate = self;
    _providerTypeTxtFld.delegate = self;
    _careTypeTxtFld.delegate = self;
    _descTextFld.delegate = self;
    activeTextField.delegate = self;
    [self updateViewConstraints];
    [super  setScrollView:_recordScrollView andTextField:activeTextField];
    
    UIBarButtonItem *rightBarButton =[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneBtnAction)];
    rightBarButton.tintColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = rightBarButton;
    [_datebtn setTitleColor:[UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:0.5] forState:UIControlStateNormal];
    [self applyColorToPlaceHolderTextField:_titleTxtFld];
    [self applyColorToPlaceHolderTextField:_bodyLoctxtFld];
    [self applyColorToPlaceHolderTextField:_symptomsTxtFld];
    [self applyColorToPlaceHolderTextField:_providerNameTxtFld];
    [self applyColorToPlaceHolderTextField:_providerTypeTxtFld];
    [self applyColorToPlaceHolderTextField:_careTypeTxtFld];
    [self applyColorToPlaceHolderTextField:_descTextFld];
    
    
    cdm = [CoreDataManager sharedManager];
    globals =[Globals sharedManager];
    _datePickerView.hidden =YES;
    _popUpTableView.hidden = YES;
    _popUpTableView.delegate = self;
    _popUpTableView.dataSource = self;
    
    eventTypeArray =[[NSMutableArray alloc] init];
    [eventTypeArray addObject:HealthEventType];
    [eventTypeArray addObject:CalendarEventType];
   // [eventTypeArray addObject:SummaryEventType];
    [eventTypeArray addObject:MessageEventType];
    
    
    self.navigationItem.rightBarButtonItem.enabled = NO;
    if (_isFromRecords == YES) {
        [_eventTypeBtn setTitle:[eventTypeArray objectAtIndex:HealthEvent] forState:UIControlStateNormal];
    }
    
//    if(isEditing){
//        [self performSelector:@selector(expandTable:) withObject:self afterDelay:0];
//    }
    
    [self fixButtonImages];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)fixButtonImages{
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    screenHeight = screenRect.size.height;
    
    if (screenHeight == 568) {
        _datebtn.imageEdgeInsets=UIEdgeInsetsMake(3, 240, 0, 0);
       _eventTypeBtn.imageEdgeInsets = UIEdgeInsetsMake(3, 250, 0, 0);
       
    }
//    else if (screenHeight == 736)
//    {
//       _datebtn.imageEdgeInsets=UIEdgeInsetsMake(3, 60, 0, 0);
//        _eventTypeBtn.imageEdgeInsets = UIEdgeInsetsMake(3, 70, 0, 0);
//        
//    }
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self setNaviagationBarWithTitle:EventDetailsnavigationTitle];
    
    if (!_isFromRecords) {
        if (_eventDetails.title !=nil) {
            self.navigationItem.rightBarButtonItem.enabled =YES;
        }
        NSString *dateString;
        if (_eventDetails.event_date == nil) {
            dateString =@"";
        }
        else
        {
            dateString =[self getDateString:_eventDetails.event_date withFormat:@"EEEE d MMMM yyyy hh:mm a"];
        }
        NSString *createdDateStr;
        if (_eventDetails.created_date  == nil) {
            
            createdDateStr = @"";
        }
        else
        {
            createdDateStr = [self getDateString:_eventDetails.created_date withFormat:@"EEE dd MMM, YYYY | hh:mma"];
        }
        [_datebtn setTitleColor:[UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1] forState:UIControlStateNormal];
        [_datebtn setTitle:dateString forState:UIControlStateNormal];
        
        _titleTxtFld.text = _eventDetails.title;
        _bodyLoctxtFld.text = _eventDetails.body_locations;
        _symptomsTxtFld.text = _eventDetails.symptom;
        _providerNameTxtFld.text = _eventDetails.provider_name;
        _providerTypeTxtFld.text = _eventDetails.provider_type;
        _careTypeTxtFld.text = _eventDetails.care_type;
        _descTextFld.text = _eventDetails.content;
        eventType = _eventDetails.event_type;
        _createdDateLabel.text = createdDateStr;
        NSString *eventTypeString =[self getEventType:_eventDetails.event_type];
        [_eventTypeBtn setTitle:eventTypeString forState:UIControlStateNormal];
        
    }
}
-(void)getSelectedEventDetails:(Medical_event*)eventDetails{
    _eventDetails = eventDetails;
    
}
/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

//TextField delegates
-(void)textFieldDidBeginEditing:(UITextField *)textField{
    
    if (textField == _titleTxtFld) {
        
        [_titleTxtFld  setPlaceholder:@"Please enter the title"];
        
    }
    if (textField == _bodyLoctxtFld) {
        
        [_bodyLoctxtFld  setPlaceholder:@"Please enter the body location(s)"];
    }
    if (textField == _symptomsTxtFld) {
        
        [_symptomsTxtFld  setPlaceholder:@"Please enter the symptom(s)"];
    }
    if (textField == _providerNameTxtFld) {
        
        [_providerNameTxtFld  setPlaceholder:@"Please enter the provider name"];
    }
    if (textField == _providerTypeTxtFld) {
        
        [_providerTypeTxtFld  setPlaceholder:@"Please enter the provider type"];
    }
    if (textField == _careTypeTxtFld) {
        
        [_careTypeTxtFld  setPlaceholder:@" Please enter the care type"];
    }
    if (textField == _descTextFld) {
        
        [_descTextFld  setPlaceholder:@" Please enter the description"];
    }
    
    
    activeTextField = textField;
    
    
}
-(void)textFieldDidEndEditing:(UITextField *)textField{
    activeTextField = textField;
}


-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    activeTextField = textField;
    [activeTextField resignFirstResponder];
    return true;
}
-(void)applyColorToPlaceHolderTextField:(UITextField *)textField{
    UIColor *color = [UIColor colorWithRed:51.0/255.0 green:51.0/255.0 blue:51.0/255.0 alpha:0.5];
    textField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:textField.placeholder attributes:@{NSForegroundColorAttributeName: color}];
}

//Validatations
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    NSUInteger newLength = [[self getTrimmedStringForString:textField.text] length] + [[self getTrimmedStringForString:string] length] - range.length;
    
    if (textField == _titleTxtFld) {
        if (newLength >=2) {
            self.navigationItem.rightBarButtonItem.enabled = YES;
            if (newLength >=50) {
                return false;
            }
            
        }
        else{
            self.navigationItem.rightBarButtonItem.enabled = NO;
            
        }
        if (textField == _bodyLoctxtFld) {
            if (newLength >=100) {
                
                return  false;
            }
        }else if (textField == _symptomsTxtFld) {
            if (newLength >=100) {
                
                return  false;
            }
        }else if (textField == _providerNameTxtFld) {
            if (newLength >=50) {
                
                return  false;
            }
        }else if (textField == _providerTypeTxtFld) {
            if (newLength >=50) {
                
                return  false;
            }
        }
        else if (textField == _careTypeTxtFld) {
            if (newLength >=30) {
                
                return  false;
            }
        }
        
    }
    if(range.length + range.location > textField.text.length)
    {
        return NO;
    }
    return YES;
    
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self removePopupView:_datePickerView];
    [self removePopupView:_popUpTableView];
    
}

- (IBAction)expandTable:(id)sender {
    _view3.hidden = YES;
    [_titleTxtFld resignFirstResponder];
    [_bodyLoctxtFld resignFirstResponder];
    [_symptomsTxtFld resignFirstResponder];
    [_providerNameTxtFld resignFirstResponder];
    [_providerTypeTxtFld resignFirstResponder];
    [_careTypeTxtFld resignFirstResponder];
    [_descTextFld resignFirstResponder];
    
    
    if (isExpand == NO) {
        [UIView animateWithDuration:0.25 delay:1.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
            [self.expandableBtn setImage:[UIImage imageNamed:@"Minus"] forState:UIControlStateNormal];
            _view2HeightConstraint.constant = 475;
            [self updateViewConstraints];
            _view3.hidden = NO;
            _view4.hidden = NO;
            _view5.hidden = NO;
            _view6.hidden = NO;
            _view7.hidden = NO;
           
            if (_isFromRecords == NO) {
                _createdDateView.hidden  = NO;
            }
            else
            {
                 _createdDateView.hidden  = YES;
            }
            
            
        } completion:^(BOOL finished) {
            isExpand = YES;
        }];
        
        
    }
    else
    {
        [UIView animateWithDuration:0.25 delay:1.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
            [self.expandableBtn setImage:[UIImage imageNamed:@"Plus"] forState:UIControlStateNormal];
            _view2HeightConstraint.constant = 50;
            [self updateViewConstraints];
            _view3.hidden = YES; _view4.hidden = YES;
            _view5.hidden = YES;
            _view6.hidden = YES;
            _view7.hidden = YES;
           
            if (_isFromRecords == NO) {
                _createdDateView.hidden  = NO;
            }
            else
            {
                _createdDateView.hidden  = YES;
            }
            
            
        } completion:^(BOOL finished) {
            isExpand = NO;
        }];
        
    }
}

-(void)doneBtnAction
{
    if ([self  validations]) {
        [self dismissKeyBoard];
        if (_isFromRecords == NO) {
             [self UpdateMedicalEventsData];
        }
        else{
             [self saveEventDetailsToDatabase];
        }

        [self addAndUpdateHealthEvents];
    }
    
    
}

//check condition for event type and call edit and update
-(void)addAndUpdateHealthEvents
{
    if (eventType == MessageEvent) {
        UIAlertController *alert =[UIAlertController alertControllerWithTitle:MsgEventTitle message:MsgEventMsg preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *nowAction =[UIAlertAction actionWithTitle:Now style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
                        NSLog(@"title-%@",_eventDetails.title);
            
            NSLog(@"title-%@",medicalEventRecord.title);
            
            dispatch_async(dispatch_get_main_queue(), ^{
                SummaryContactListController *summary =[self.storyboard instantiateViewControllerWithIdentifier:SummaryContactListControllerID];
                NSLog(@"title-%@",_eventDetails.title);
                
                NSLog(@"title-%@",medicalEventRecord.title);
                if (_isFromRecords == NO) {
                   [summary getSelectedEventItem:_eventDetails];
                }
                else{
                     [summary getSelectedEventItem:medicalEventRecord];
                }
                
                summary.isMessageEvent = YES;
                summary.summaryListDelegate = self;
                [self presentViewController:summary animated:NO completion:nil];
                
                
            });
            
        }];
        
        
        UIAlertAction *laterAction =[UIAlertAction actionWithTitle:Later style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            if(medicalEventRecord == nil){
                _eventDetails.is_draft = 1;               
            }else{
                medicalEventRecord.is_draft = 1;
            }
           
            [cdm commitChanges];
            [self dismissTheCurrentView];
        }];
        
        [alert addAction:nowAction];
        [alert addAction:laterAction];
        
        [self presentViewController:alert animated:YES completion:nil];
        
    }
    else{
        [self dismissTheCurrentView];
    }
    
    
}
-(BOOL)validations
{
    BOOL validate = YES;
    
    if (_bodyLoctxtFld.text.length<2 && _bodyLoctxtFld.text.length>0 ) {
        [self applyColorToPlaceHolderTextForError:_bodyLoctxtFld withErrorMessage:bodyLocationInlineError];
        validate = false;
    }
    if (_symptomsTxtFld.text.length<2 &&_symptomsTxtFld.text.length>0 ) {
        [self applyColorToPlaceHolderTextForError:_symptomsTxtFld withErrorMessage:symptomsInlineError];
        validate = false;
    }
    
    if (_providerNameTxtFld.text.length<2 && _providerNameTxtFld.text.length>0) {
        [self applyColorToPlaceHolderTextForError:_providerNameTxtFld withErrorMessage:providerNameInlineError];
        validate = false;;
    }
    
    if (_providerTypeTxtFld.text.length<2 && _providerTypeTxtFld.text.length>0) {
        [self applyColorToPlaceHolderTextForError:_providerTypeTxtFld withErrorMessage:providerTypeInlineError];
        validate = false;
    }
    
    if (_careTypeTxtFld.text.length<2 && _careTypeTxtFld.text.length>0 ) {
        [self applyColorToPlaceHolderTextForError:_careTypeTxtFld withErrorMessage:careTypeInlineError];
        validate = false;
    }
    
    return validate;
    
}


-(void)saveEventDetailsToDatabase
{
   medicalEventRecord = [[Medical_event alloc] initWithEntity:[NSEntityDescription entityForName:medical_event inManagedObjectContext:cdm.managedObjectContext] insertIntoManagedObjectContext:cdm.managedObjectContext];
    medicalEventRecord.consumer_id = globals.consumerId;
    medicalEventRecord.title = _titleTxtFld.text;
    medicalEventRecord.content = _descTextFld.text;
    medicalEventRecord.body_locations = _bodyLoctxtFld.text;
    medicalEventRecord.symptom = _symptomsTxtFld.text;
    medicalEventRecord.provider_name = _providerNameTxtFld.text;
    NSString *providerType = _providerTypeTxtFld.text ;
    NSString *careType = _careTypeTxtFld.text ;
    medicalEventRecord.provider_type = providerType;
    medicalEventRecord.care_type = careType;
    medicalEventRecord.created_date =[NSDate date];
    
    NSDate *eventDate = [self getDateFromString:_datebtn.titleLabel.text WithFormat:@"EEE d MMM yyyy hh:mm a"];
    medicalEventRecord.event_date = eventDate;
    medicalEventRecord.modified_date = nil;
    medicalEventRecord.diary_id = 0;
    medicalEventRecord.is_active = 0;
    medicalEventRecord.is_read = 0;
    medicalEventRecord.response_id = 0;
    medicalEventRecord.is_draft = 0;
    // medicalEventRecord.event_type = MedicalRecordEnum;
    medicalEventRecord.event_type = eventType;
    
    [cdm commitChanges];
    
    
    
}


- (IBAction)cancelBtnAction:(id)sender {
    [self removePopupView:_datePickerView];
}
- (IBAction)okBtnAction:(id)sender {
   
    NSDateFormatter *dateFormat=[[NSDateFormatter alloc]init];
    dateFormat.dateStyle=NSDateFormatterMediumStyle;
    [dateFormat setTimeZone:[NSTimeZone localTimeZone]];
    [dateFormat setDateFormat:@"EEE d MMM yyyy hh:mm a"];
    
    NSString *dateString =[NSString stringWithFormat:@"%@",[dateFormat  stringFromDate:_datePicker.date]];
    [_datebtn setTitleColor:[UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1] forState:UIControlStateNormal];
    [_datebtn setTitle:dateString forState:UIControlStateNormal];
    [self removePopupView:_datePickerView];
}
- (IBAction)eventDateBtnAction:(id)sender {
    
    [self dismissKeyBoard];
    _datePickerView.hidden = NO;
    [_datePicker setTimeZone:[NSTimeZone localTimeZone]];

   // [_datePicker setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
    [_datePicker setDatePickerMode:UIDatePickerModeDateAndTime];
    [self addPopupView:_datePickerView];
}
-(void)dismissKeyBoard
{
    [_titleTxtFld resignFirstResponder];
    [_bodyLoctxtFld resignFirstResponder];
    [_symptomsTxtFld resignFirstResponder];
    [_providerNameTxtFld resignFirstResponder];
    [_providerTypeTxtFld resignFirstResponder];
    [_careTypeTxtFld resignFirstResponder];
    [_descTextFld resignFirstResponder];
}
-(void)UpdateMedicalEventsData
{
    _eventDetails.consumer_id = globals.consumerId;
    _eventDetails.title = _titleTxtFld.text;
    _eventDetails.content = _descTextFld.text;
    _eventDetails.body_locations = _bodyLoctxtFld.text;
    _eventDetails.symptom = _symptomsTxtFld.text;
    _eventDetails.provider_name = _providerNameTxtFld.text;
    NSString *providertype = _providerTypeTxtFld.text ;
    NSString *caretype = _careTypeTxtFld.text ;
    _eventDetails.created_date =_eventDetails.created_date;
    _eventDetails.event_date = [self getDateFromString:_datebtn.titleLabel.text WithFormat:@"EEE d MMM yyyy hh:mm a"];
    _eventDetails.modified_date = [NSDate date];
    _eventDetails.diary_id = 0;
    _eventDetails.is_active = 0;
    _eventDetails.care_type = caretype;
    _eventDetails.provider_type = providertype;
    _eventDetails.event_type = eventType;
    
    
    [cdm commitChanges];
    
}
-(void)applyColorToPlaceHolderText:(UITextField *)textField {
    textField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:textField.placeholder attributes:@{NSForegroundColorAttributeName:[UIColor colorWithRed:102.0/255.0 green:102.0/255.0 blue:102.0/255.0 alpha:0.5]}];
}
- (IBAction)eventTypeBtnAction:(id)sender {
    [self dismissKeyBoard];
    NSInteger index;
    if (_isFromRecords ==  YES) {
        index = eventType;
    }
    else{
        index = _eventDetails.event_type;
    }
    

    NSIndexPath* selectedCellIndexPath= [NSIndexPath indexPathForRow:index inSection:0];
    [self tableView:_popUpTableView didSelectRowAtIndexPath:selectedCellIndexPath];
    [_popUpTableView selectRowAtIndexPath:selectedCellIndexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
    [self addPopupView:_popUpTableView];
}
#pragma mark- TableView Delegate Methods
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return eventTypeArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier =@"Cell";
    UITableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    [cell.textLabel setTextAlignment:NSTextAlignmentCenter];
    cell.textLabel.text = [eventTypeArray objectAtIndex:indexPath.row];
    return  cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if(indexPath.row == 2){
        eventType = MessageEvent;
    }else{
        eventType = (int)indexPath.row;
    }
    
    [_eventTypeBtn setTitle:[eventTypeArray objectAtIndex:indexPath.row] forState:UIControlStateNormal];
    [self removePopupView:_popUpTableView];
    
}

//PopUp View For to get list of Providers
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
    if([segue.identifier isEqualToString:@"sendSummarySegue"]){
        SummaryContactListController *summaryVC = segue.destinationViewController;
        summaryVC.summaryListDelegate = self;
        
        [self.tabBarController.tabBar setHidden:YES];
        [self setPresentationStyleForSelfController:self presentingController:summaryVC];
    }
    
}

- (void)setPresentationStyleForSelfController:(UIViewController *)selfController presentingController:(UIViewController *)presentingController
{
    if ([NSProcessInfo instancesRespondToSelector:@selector(isOperatingSystemAtLeastVersion:)])
    {
        //iOS 8.0 and above
        presentingController.providesPresentationContextTransitionStyle = YES;
        presentingController.definesPresentationContext = YES;
        
        [presentingController setModalPresentationStyle:UIModalPresentationOverCurrentContext];
    }
    else
    {
        [selfController setModalPresentationStyle:UIModalPresentationCurrentContext];
        [selfController.navigationController setModalPresentationStyle:UIModalPresentationCurrentContext];
    }
}

- (void)onCloseOfPopupView{
    [self dismissTheCurrentView];
   }

-(void)cancelledSendingMessage{
    medicalEventRecord.is_draft = 1;
   // _eventDetails.is_draft = 1;
    [cdm commitChanges];
}

-(void)msgSentSuccessfully{
    //editBarButton = nil;
}

-(void)dismissTheCurrentView{
    
    if(isNavigatingFromSearch){
        NSArray *viewControllers = [[self navigationController] viewControllers];
        SearchEventsController *searchController =   [viewControllers objectAtIndex:1];
        [self.navigationController popToViewController:searchController animated:YES];
    }else{
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}

@end
