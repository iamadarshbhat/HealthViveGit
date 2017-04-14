//
//  SettingsViewController.m
//  HealthVive
//
//  Created by Adarsha on 22/02/17.
//  Copyright © 2017 NousInfosystems. All rights reserved.
//

#import "SettingsViewController.h"
#import "SettingsCell.h"
#import "ChangePasswordTableController.h"
#import "CoreDataManager.h"
#import "Account+CoreDataProperties.h"
#import "Globals.h"
#import "Medical_event+CoreDataProperties.h"
#import "My_contacts+CoreDataClass.h"



@interface SettingsViewController ()
{
    NSMutableDictionary *settingsHeaderDict;
    NSOrderedSet *settingsheaderSet;
    NSMutableString *planName;
    NSMutableString *expiryDateStr;
    NSDate *expiryDate;
    CoreDataManager *dataManager;
    Globals *globals;
    NSMutableArray *allEvents;
}

@end

@implementation SettingsViewController
@synthesize settingsTableView;

- (void)viewDidLoad {
    [super viewDidLoad];
    planName = [[NSMutableString alloc] initWithString:@""];
    expiryDateStr = [[NSMutableString alloc] initWithString:@""];
    NSString *versionString = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    settingsTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    settingsHeaderDict = [[NSMutableDictionary alloc] initWithObjectsAndKeys:@[@"Current Plan",@"Plan End Date"],@"Subscription Details",@[@"Change Password",@"Backup Health Log"],@"Account",@[@"Terms Of Use",@"Contact Us"],@"About Us",@[@"Sign Out"],@"",@[[NSString stringWithFormat:@"HealthVive v%@",versionString]],@"Version", nil];
    settingsheaderSet = [[NSOrderedSet alloc] initWithObjects:@"Subscription Details",@"Account",@"About Us",@"",@"Version", nil];
    dataManager = [CoreDataManager sharedManager];
    globals = [Globals sharedManager];
    
     allEvents = [[NSMutableArray alloc] initWithArray: [self getAllMedicalEventsFromLocalDB]];
    }

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
   
}
-(void)viewWillAppear:(BOOL)animated{
     [self setNaviagationBarWithTitle:SettingsNavigationBarTitle];
//    if([self checkInternetConnection]){
//        [self callApiToGetConsumerPlanDetails];
//    }else{
    
    //}
    
    //if([planName isEqualToString:@""] && [expiryDateStr isEqualToString:@""]){
       [self getLocalAccountData];
    //}
}

#pragma mark Table View delegate methods

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
   SettingsCell *settingsCell =  [tableView dequeueReusableCellWithIdentifier:settingsTableReusableIdentifier];
    
   NSArray *titlesArr =  [settingsHeaderDict valueForKey:[settingsheaderSet objectAtIndex:indexPath.section]];
    settingsCell.cellTitlLabel.text = [titlesArr objectAtIndex:indexPath.row];
    
    if(indexPath.section == 0){
        
        if(indexPath.row == 0){
            settingsCell.cellDetailLabel.text = planName;
        }else{
             settingsCell.cellDetailLabel.text = expiryDateStr;
        }
    }else{
         settingsCell.cellDetailLabel.text = @"";
    }
    return settingsCell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSArray *arr =  [settingsHeaderDict valueForKey:[settingsheaderSet objectAtIndex:indexPath.section]];
    
    NSString *selectedTitle  = [arr objectAtIndex:indexPath.row];
    
    if([selectedTitle isEqualToString:@"Change Password"]){
        ChangePasswordTableController *changePass = [[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:changePasswordControllerID];
        [changePass setTitle:ChangePasswordNavigationBarTitle];
        [self.navigationController pushViewController:changePass animated:YES];
    }
    
    if([selectedTitle isEqualToString:@"Sign Out"]){
        [[NSNotificationCenter defaultCenter] postNotificationName:LogoutNotification object:nil];
        [self.tabBarController.navigationController popViewControllerAnimated:YES];
    }
    
    if([selectedTitle isEqualToString:@"Contact Us"]){
        
//        for (int i = 0; i <5000; i++) {
//            Medical_event * medicalEventRecord = [[Medical_event alloc] initWithEntity:[NSEntityDescription entityForName:medical_event inManagedObjectContext:dataManager.managedObjectContext] insertIntoManagedObjectContext:dataManager.managedObjectContext];
//            medicalEventRecord.consumer_id = globals.consumerId;
//            medicalEventRecord.title = [NSString stringWithFormat:@"Medical Title %d",i];
//            medicalEventRecord.content = [NSString stringWithFormat:@"Content %d",i];;
//            medicalEventRecord.body_locations = [NSString stringWithFormat:@"Leg , Heart %d",i];;
//            medicalEventRecord.symptom = [NSString stringWithFormat:@"Symptom %d",i];;
//            medicalEventRecord.provider_name = [NSString stringWithFormat:@"Doctor Pushparaj %d",i];;
//            NSString *providerType = [NSString stringWithFormat:@"Dentist%d",i]; ;
//            NSString *careType = [NSString stringWithFormat:@"Care%d",i]; ;
//            medicalEventRecord.provider_type = providerType;
//            medicalEventRecord.care_type = careType;
//            medicalEventRecord.created_date =[NSDate date];
//            medicalEventRecord.event_date = [[NSDate date] dateByAddingTimeInterval:7*24*60*60];
//            medicalEventRecord.modified_date = nil;
//            medicalEventRecord.diary_id = 0;
//            medicalEventRecord.is_active = 0;
//            medicalEventRecord.is_read = 0;
//            medicalEventRecord.response_id = 0;
//            // medicalEventRecord.event_type = MedicalRecordEnum;
//            medicalEventRecord.event_type = i%5;
//            
//            [dataManager commitChanges];
//            
//            
//            
//            
//                  }
//        for (int i=0; i<5000; i++) {
//            
//            My_contacts *medicalContactModel = [[My_contacts alloc] initWithEntity:[NSEntityDescription entityForName:medicalContactEntity inManagedObjectContext:dataManager.managedObjectContext] insertIntoManagedObjectContext:dataManager.managedObjectContext];
//            [medicalContactModel setFore_name:@"Gary"];
//            [medicalContactModel setSur_name:@"Christon"];
//            [medicalContactModel setEmail:@"gary@gmail.com"];
//            [medicalContactModel setSpecialism:@"Eye Specialist"];
//            [medicalContactModel setInvited_by_consumer:0];
//            [medicalContactModel setInvite_status:2];
//            [medicalContactModel setIs_active:1];
//            [medicalContactModel setPhone:@"454564878122"];
//            [medicalContactModel setAddress:@"Banglore"];
//            [medicalContactModel setConsumer_id:globals.consumerId];
//            [dataManager commitChanges];
//        }
//        
//        
//        NSLog(@"------------------------Done-----------------------");

    }
    
    
    if([selectedTitle isEqualToString:@"Backup Health Log"]){
        [self sendBackup];
    }
    
    if([selectedTitle isEqualToString:@"Terms Of Use"]){
        NSURL *url = [NSURL URLWithString:termsAndConditionLink];
        [[UIApplication sharedApplication] openURL:url];
    }
    if([selectedTitle isEqualToString:@"Privacy Policy"]){
       // NSURL *url = [NSURL URLWithString:@"http://www.narendramodi.in/"];
        //[[UIApplication sharedApplication] openURL:url];
    }
    
    if([selectedTitle isEqualToString:@"Contact Us"]){
        NSURL *url = [NSURL URLWithString:@"mailto://support@healthvive.com"];
        [[UIApplication sharedApplication] openURL:url];
    }
}

-(void)sendBackup{
    
        UIAlertController *alertController = [UIAlertController
                                              alertControllerWithTitle:InfoAlert
                                              message:backLogAlertMessage
                                              preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancelAction = [UIAlertAction
                                       actionWithTitle:NSLocalizedString(@"Cancel", @"Cancel action")
                                       style:UIAlertActionStyleDefault
                                       handler:^(UIAlertAction *action)
                                       {
                                           NSLog(@"Cancel summary action");
                                       }];
        
        UIAlertAction *okAction = [UIAlertAction
                                   actionWithTitle:NSLocalizedString(@"Ok", @"OK action")
                                   style:UIAlertActionStyleDefault
                                   handler:^(UIAlertAction *action)
                                   {
                                       [self callAPiToBackupHealthLog];
                                   }];
        
        [alertController addAction:cancelAction];
        [alertController addAction:okAction];
        [self presentViewController:alertController animated:YES completion:nil];
        
    

}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
   NSArray *arr =  [settingsHeaderDict valueForKey:[settingsheaderSet objectAtIndex:section]];
    return arr.count;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return settingsheaderSet.count;
}
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return [settingsheaderSet objectAtIndex:section];
}




-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if(indexPath.section == 0){
        return  74;
    }else{
        return 47;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    CGFloat headerHeight = 12.0f;
    if(section == 0){
        headerHeight = 40.0f;
    }else if(section == 2){
        headerHeight = 0.0f;
    }else{
        headerHeight = 15.0f;
    }
    return headerHeight;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    CGFloat footerHeight = 15.0f;
    if(section == 2){
        footerHeight = 0.0f;
    }else{
        footerHeight = 15.0f;
    }
    return  footerHeight;
}



- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section
{
    UITableViewHeaderFooterView *header = (UITableViewHeaderFooterView *)view;
    header.textLabel.textColor = [UIColor blackColor];
    UIFont *font = [UIFont fontWithName:@"SFUIText-Medium" size:16];
    header.textLabel.font = font;
    header.textLabel.text = [settingsheaderSet objectAtIndex:section];
    header.textLabel.textAlignment = NSTextAlignmentLeft;
}


//Api Call to get Settings
-(void)callApiToGetConsumerPlanDetails{
    APIHandler *reqHandler =[[APIHandler alloc]init];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *token = [defaults valueForKey:access_tokenKey];
    
    NSString *url = [NSString stringWithFormat:@"%@%@",BaseURL,httpGetConsumerPlanDetails];
    [self showProgressHudWithText:@"Fetching..."];
    [reqHandler makeRequest:token serverUrl:url completion:^(NSDictionary *result, NSError *error) {
        if (error == nil) {
            NSArray *resultArray = [result objectForKey:httpResult];
            NSLog(@"Results callApiToGetConsumerPlanDetails-- %@",resultArray);
            
           NSMutableDictionary *dict =  [resultArray lastObject];
           
          planName =   [dict valueForKey:@"PlanName"];
          NSString *expiryDateStrng = [dict valueForKey:@"ExpiryDate"];
          expiryDate =   [self getDateFromString:expiryDateStrng WithFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSS"];
           expiryDateStr =  [[self getDateString:expiryDate withFormat:@"d MMM yyyy"] mutableCopy];
            [self updateServerDataToAccountTable];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self hideProgressHud];
                [settingsTableView reloadData];
               
            });
            
            
        }else{
            [self handleServerError:error];
        }
        
    }];
    
}


//Updates the table with server data
-(void)updateServerDataToAccountTable{
  
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"consumer_id == %@",[NSNumber numberWithInt:globals.consumerId]];
    
    NSArray *consumerAccounts = [dataManager fetchDataFromEntity:accountEntity predicate:predicate];
  
    Account *consumerAccount = [consumerAccounts lastObject];
    
    consumerAccount.subscribed_plan = planName;
    consumerAccount.plan_expiry = expiryDate;
    
    [dataManager commitChanges];
    
   }

-(void)getLocalAccountData{
      NSPredicate *predicate = [NSPredicate predicateWithFormat:@"consumer_id == %@",[NSNumber numberWithInt:globals.consumerId]];
      NSArray *consumerAccounts = [dataManager fetchDataFromEntity:accountEntity predicate:predicate];
    
    Account *consumerAccount = [consumerAccounts lastObject];
    
     planName = [consumerAccount.subscribed_plan mutableCopy];
     expiryDate= consumerAccount.plan_expiry;
    expiryDateStr = [[self getDateString:expiryDate withFormat:@"d MMM yyyy"] mutableCopy];

}

-(void)callAPiToBackupHealthLog{
    {
        
        
        NSError *writeError;
        
        NSMutableArray *eventList = [[NSMutableArray alloc] init];
        
        
        for (Medical_event *event in allEvents) {
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
            [eventDict setValue:[NSNumber numberWithInt:event.event_type] forKey:@"EventType"];
            [eventList addObject:eventDict];
            NSLog(@"%@",eventDict);
        }
        
        NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:eventList,@"EventList", nil];
        

        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:&writeError];
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSString *token = [defaults valueForKey:access_tokenKey];
        
        
        NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        
        NSLog(@"JSON String :%@",jsonString);
        
        APIHandler *reqHandler =[[APIHandler alloc] init];
        [self showProgressHudWithText:@"Please Wait..."];
        
        NSString *url =  [NSString stringWithFormat:@"%@%@",BaseURL,httpBackupHealthLog];
        
        [reqHandler makeRequestByPost:jsonString serverUrl:url withAccessToken:token completion:^(NSDictionary *result, NSError *error) {
            
            if ( error == nil) {
                NSLog(@"result -%@",result);
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self hideProgressHud];
                    // [self deleteContact:medicalContactIndexPath];
                    [self showAlertWithTitle:statusStr andMessage:healthBackLogSuccessMessage
                              andActionTitle:ok actionHandler:^(UIAlertAction *action) {
                                  
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
                           
                        }];
                    });
                });
            }
            [self handleServerError:error];
        }];
        
        
    }
}

//Returns all medical contacts saved in the db
-(NSMutableArray*)getAllMedicalEventsFromLocalDB{
    NSArray *medicalEvents = [dataManager fetchDataFromEntity:medical_event predicate:nil];
    return [medicalEvents mutableCopy];
}
@end
