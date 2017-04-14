//
//  SummaryContactListController.m
//  HealthVive
//
//  Created by Adarsha on 14/02/17.
//  Copyright © 2017 NousInfosystems. All rights reserved.
//

#import "SummaryContactListController.h"
#import "SummaryContactCell.h"
#import "Globals.h"
#import "CoreDataManager.h"
#import "Medical_event+CoreDataProperties.h"
#import "Constants.h"


@interface SummaryContactListController (){
    NSMutableArray *inviteProviderList;
    Globals *globals;
    CoreDataManager *dataManager;
    NSMutableArray *allEventsInCart;
    NSMutableDictionary *selectedDict;
    
    NSString *providerEmailId;
    
    
}

@end

@implementation SummaryContactListController
@synthesize lblNoProviders;
@synthesize btnSendSummary;
@synthesize popUpView;
@synthesize contactsTableView;
@synthesize tblHeaderView;
@synthesize isMessageEvent;
@synthesize summaryTitle;
@synthesize summaryDescription;
@synthesize summaryListDelegate;

- (void)viewDidLoad {
    [super viewDidLoad];
    globals = [Globals sharedManager];
    dataManager = [CoreDataManager sharedManager];
    
    if (isMessageEvent == YES) {
        [btnSendSummary  setTitle:@"Send Message" forState:UIControlStateNormal];
        allEventsInCart =[[NSMutableArray alloc]init];
        [allEventsInCart  addObject:_eventData];
       
    }
    else{
        
         allEventsInCart = [[NSMutableArray alloc] initWithArray: [self getAllEventsAddedInCart]];
    }
   
    [self applyShadowToView:tblHeaderView];
    inviteProviderList = [[NSMutableArray alloc] init];
    [self callApiToGetActiveProviderContacts];
    [self applyCornerToView:popUpView];
    [self applyCornerToView:contactsTableView];
    [contactsTableView registerNib:[UINib nibWithNibName:@"SummaryContactCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:summaryContacttableIdentifier];
    contactsTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
   
   
    
   }

-(void)getSelectedEventItem:(Medical_event*)event
{
    _eventData = event;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark Table View delegate methods
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    SummaryContactCell *cell = [tableView dequeueReusableCellWithIdentifier:summaryContacttableIdentifier];
   NSDictionary *dict = [inviteProviderList objectAtIndex:indexPath.row];
   NSString *forName =  [dict valueForKey:@"ProviderForeName"];
   NSString *surName = [dict valueForKey:@"ProviderLastName"];
   NSString *orgName =  [dict valueForKey:@"ProviderOrgName"];
   NSString *speciality = [dict valueForKey:@"ProviderSpeciality"];
   NSInteger isSelected = [[dict valueForKey:@"selectedCell"] integerValue];
    
    if([orgName isKindOfClass:[NSNull class]]){
        orgName = @"";
    }
    if([speciality isKindOfClass:[NSNull class]]){
        speciality = @"";
    }
   
    [cell.nameLbl setText:[NSString stringWithFormat:@"%@ %@", forName,surName]];
    [cell.speacialityLbl setText:[NSString stringWithFormat:@"%@ %@", speciality,orgName]];
    
    if(isSelected){
        [cell.tickImage setImage:[UIImage imageNamed:summaryContactSelectedImage]];
    }else{
         [cell.tickImage setImage:[UIImage imageNamed:summaryContactNonSelectedImage]];
    }
   
    
    return cell;
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return inviteProviderList.count;
    //return 10;
}

//For multiple selection :

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    SummaryContactCell *selectedCell =  [tableView cellForRowAtIndexPath:indexPath];
    [selectedCell.tickImage setImage:[UIImage imageNamed:summaryContactSelectedImage]];
    
    NSMutableDictionary *dict =   [inviteProviderList objectAtIndex:indexPath.row];
    [dict setValue:[NSNumber numberWithInt:1] forKey:@"selectedCell"];
    [inviteProviderList replaceObjectAtIndex:indexPath.row withObject:dict];
    selectedDict = dict;
}
-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
    SummaryContactCell *deSelectedCell =  [tableView cellForRowAtIndexPath:indexPath];
    [deSelectedCell.tickImage setImage:[UIImage imageNamed:summaryContactNonSelectedImage]];
    
    NSMutableDictionary *deSelectedDict = [inviteProviderList objectAtIndex:indexPath.row];
    [deSelectedDict setValue:[NSNumber numberWithInt:0] forKey:@"selectedCell"];
    [inviteProviderList replaceObjectAtIndex:indexPath.row withObject:deSelectedDict];
    
}

- (IBAction)cancelBtnAction:(id)sender {
    [self dismissViewControllerAnimated:YES completion:^{
        [self.summaryListDelegate cancelledSendingMessage];
 
    }];
}

- (IBAction)sendSummaryAction:(id)sender {
    
    if(selectedDict != nil){
        if([self checkInternetConnection]){
            [self callApiToSendSummary];
        }else{
            [self showAlertWithTitle:httpNoInternetAlert andMessage:noInternetMessage andActionTitle:ok actionHandler:nil];
        }
    }else{
        [self showAlertWithTitle:InfoAlert andMessage:selectProvider andActionTitle:ok actionHandler:nil];
    }
    
}

//Lists all approved providers
-(void)callApiToGetActiveProviderContacts{
    
    APIHandler *reqHandler =[[APIHandler alloc]init];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *token = [defaults valueForKey:access_tokenKey];
    
   NSString *url =  [NSString stringWithFormat:@"%@%@",BaseURL,httpGetActiveProvidersContacts];
    [reqHandler makeRequest:token serverUrl:url completion:^(NSDictionary *result, NSError *error) {
        if (error == nil) {
            NSArray *resultArray = [result objectForKey:httpResult];
            NSLog(@"Results callApiToGetInviteProviders-- %@",resultArray);
           
            
            for (NSMutableDictionary *contactDict in resultArray) {
                NSMutableDictionary *dict =  [[NSMutableDictionary alloc] initWithDictionary:contactDict];
                [dict setValue:[NSNumber numberWithInt:0] forKey:@"selectedCell"];
                [inviteProviderList addObject:dict];
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                if(inviteProviderList.count == 0){
                    contactsTableView.backgroundView = lblNoProviders;
                    [btnSendSummary setHidden:YES];
                }else{
                    lblNoProviders.text = @"";
                     contactsTableView.backgroundView = lblNoProviders;
                    [btnSendSummary setHidden:NO];
                }
           
                [contactsTableView reloadData];
            });
            
            
        }else{
            NSLog(@"Error  :%@",error);
            [self handleServerError:error];
        }
       
    }];
    
    //******* Locally**********
//    NSMutableArray *resultArray = [[NSMutableArray alloc] init];
//    
//   
//    
//    for (int i =0; i<30; i++) {
//         NSMutableDictionary *dict  = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"provider1@test.com",@"ProviderEmailID",@"Shane",@"ProviderForeName",[NSNumber numberWithInt:2],@"ProviderID",@"Watson",@"ProviderLastName",@"Fortis Org",@"ProviderOrgName",@"Arts therapist",@"ProviderSpeciality",nil ];
//        [resultArray addObject:dict];
//    }
//    
//    for (NSMutableDictionary *contactDict in resultArray) {
//        [contactDict setValue:[NSNumber numberWithInt:0] forKey:@"selectedCell"];
//        [inviteProviderList addObject:contactDict];
//    }
}



-(void)callApiToSendSummary{
    
   
    NSError *writeError;
    
    NSMutableArray *eventList = [[NSMutableArray alloc] init];
    
    
    for (Medical_event *event in allEventsInCart) {
        NSMutableDictionary *eventDict  = [[NSMutableDictionary alloc] init];
        
        NSString *eventDateStr = [self getDateString:event.event_date withFormat:@"yyyy/MM/dd"] ;
        if(event.event_date == nil){
            eventDateStr = @"";
        }
        [eventDict setValue:eventDateStr forKey:@"EventDate"];
        [eventDict setValue:event.body_locations forKey:@"BodyLocation"];
        [eventDict setValue:event.symptom forKey:@"Symptom"];
        [eventDict setValue:event.provider_name forKey:@"ProviderName"];
        [eventDict setValue:event.provider_type forKey:@"ProviderType"];
        [eventDict setValue:event.care_type forKey:@"CareType"];
        [eventDict setValue:event.title forKey:@"EventTitle"];
        [eventDict setValue:event.content forKey:@"EventDescription"];
        [eventList addObject:eventDict];
        NSLog(@"%@",eventDict);
    }
    
  
    int eventType;
    NSString *providerEmailid =[selectedDict valueForKey:@"ProviderEmailID"];
    NSDictionary *dict;
    if (isMessageEvent == YES) {
        eventType = Message;
       dict = [NSDictionary dictionaryWithObjectsAndKeys:providerEmailid ,@"ProviderEmailID",eventList,@"EventList",[NSNumber numberWithInt:eventType],@"SummaryType", nil];
    }
    else{
        eventType = Summary;
        dict = [NSDictionary dictionaryWithObjectsAndKeys:providerEmailid ,@"ProviderEmailID",eventList,@"EventList",[NSNumber numberWithInt:eventType],@"SummaryType",summaryTitle,@"SummaryTitle",summaryDescription,@"SummaryDescription", nil];
    
    }
    
  
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:&writeError];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *token = [defaults valueForKey:access_tokenKey];
    
    
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    NSLog(@"JSON String :%@",jsonString);
    
    APIHandler *reqHandler =[[APIHandler alloc] init];
    [self showProgressHudWithText:@"Processing..."];
    
    NSString *url =  [NSString stringWithFormat:@"%@%@",BaseURL,httpSaveMedicalSummaryDetails];

    [reqHandler makeRequestByPost:jsonString serverUrl:url withAccessToken:token completion:^(NSDictionary *result, NSError *error) {
        
        if ( error == nil) {
            NSLog(@"result -%@",result);
            NSString *providerName = [NSString stringWithFormat:@"%@ %@",[selectedDict valueForKey:@"ProviderForeName"],[selectedDict valueForKey:@"ProviderLastName"]];
           
            NSString *successMessage;
            if (isMessageEvent == YES) {
                successMessage = [NSString stringWithFormat:@"%@",successfullMesasgeSent];
                _eventData.is_draft = 0;
                _eventData.messaging_provider_name = providerName;
                [dataManager commitChanges];
                [self.summaryListDelegate msgSentSuccessfully];
             
            }
            else{
                successMessage = [NSString stringWithFormat:@"%@",successfullSummarySentMsg];
                NSString *summaryIdString = [result valueForKey:@"Result"];

                [self saveSummaryEventAfterSummarySent:summaryIdString :providerName];
                [self updateDBAfterSummarySent];
            }
            
          dispatch_async(dispatch_get_main_queue(), ^{
                [self hideProgressHud];
               // [self deleteContact:medicalContactIndexPath];
                 [self showAlertWithTitle:statusStr andMessage:successMessage
                           andActionTitle:ok actionHandler:^(UIAlertAction *action) {
                               
                               [self disimissThecurrentPopUpView];
                              
                              
                           }];
                
            });
        }
        else
        {
            dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                NSDictionary *errorObj =[error valueForKey:@"Error"];
                
                NSString *errorDescription = [errorObj valueForKey:@"error_description"];
                NSLog(@"errorDescription ....%@",errorDescription);
                if (errorDescription == nil || [errorDescription isEqualToString:@""]) {
                    errorDescription = internalError;
                }
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self hideProgressHud];
                    [self showAlertWithTitle:statusStr andMessage:errorDescription andActionTitle:ok actionHandler:^(UIAlertAction *action) {
                        [self disimissThecurrentPopUpView];
                    }];
                });
            });
            [self handleServerError:error];
        }
    }];
    

}

//Returns all medical contacts saved in the db
-(NSMutableArray*)getAllMedicalEventsFromLocalDB{
    NSArray *medicalEvents = [dataManager fetchDataFromEntity:medical_event predicate:nil];
    return [medicalEvents mutableCopy];
}

//Returns all medical contacts saved in the db
-(NSMutableArray*)getAllEventsAddedInCart{
    NSArray *medicalEvents = [dataManager fetchDataFromEntity:medical_event predicate:[NSPredicate predicateWithFormat:@"is_added_to_summary == 1"]];
    return [medicalEvents mutableCopy];
}

-(void)disimissThecurrentPopUpView{
    [self dismissViewControllerAnimated:YES completion:^{
        [self.summaryListDelegate onCloseOfPopupView];
    }];
}
-(void)onSucceesfullMessage
{
    [self dismissViewControllerAnimated:YES completion:^{
        [self.summaryListDelegate msgSentSuccessfully];
    }];
}

-(void)saveEventDetailsToDatabase
{
  Medical_event * medicalEventRecord = [[Medical_event alloc] initWithEntity:[NSEntityDescription entityForName:medical_event inManagedObjectContext:dataManager.managedObjectContext] insertIntoManagedObjectContext:dataManager.managedObjectContext];
    medicalEventRecord.consumer_id = globals.consumerId;
    medicalEventRecord.title = _eventData.title;
    medicalEventRecord.content = _eventData.content;
    medicalEventRecord.body_locations = _eventData.body_locations;
    medicalEventRecord.symptom = _eventData.symptom;
    medicalEventRecord.provider_name = _eventData.provider_name;
    NSString *providerType = _eventData.provider_type ;
    NSString *careType = _eventData.care_type ;
    medicalEventRecord.provider_type = providerType;
    medicalEventRecord.care_type = careType;
    medicalEventRecord.created_date =[NSDate date];
    medicalEventRecord.event_date = _eventData.event_date;
    medicalEventRecord.modified_date = nil;
    medicalEventRecord.diary_id = 0;
    medicalEventRecord.is_active = 0;
    medicalEventRecord.is_read = 0;
    medicalEventRecord.response_id = 0;
    // medicalEventRecord.event_type = MedicalRecordEnum;
    medicalEventRecord.event_type = _eventData.event_type;
    
 [dataManager commitChanges];
    
}

-(void)saveSummaryEventAfterSummarySent:(NSString *)summaryIdString : (NSString *)providerName{
   
    Medical_event * summaryEvent = [[Medical_event alloc] initWithEntity:[NSEntityDescription entityForName:medical_event inManagedObjectContext:dataManager.managedObjectContext] insertIntoManagedObjectContext:dataManager.managedObjectContext];

    summaryEvent.consumer_id = globals.consumerId;
    summaryEvent.title = summaryTitle;
    summaryEvent.content = summaryDescription;
    summaryEvent.event_type =  2;
    summaryEvent.created_date =[NSDate date];
    summaryEvent.event_date = [NSDate date];
    summaryEvent.diary_id = 0;
    summaryEvent.is_active = 0;
    summaryEvent.is_read = 0;
    summaryEvent.response_id = 0;
    summaryEvent.summary_id = summaryIdString;
    summaryEvent.messaging_provider_name = providerName;
    [dataManager commitChanges];
    
}

-(void)updateDBAfterSummarySent{
  NSArray *eventsInCart =   [self getAllEventsAddedInCart];
    
    for (Medical_event *event in eventsInCart) {
        [event setIs_added_to_summary:0];
    }
    
    [dataManager  commitChanges];
}

@end
