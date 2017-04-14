 //
//  MedicalContactController.m
//  HealthVive
//
//  Created by Adarsha on 25/01/17.
//  Copyright © 2017 NousInfosystems. All rights reserved.
//

#import "ActiveContactsController.h"
#import "CoreDataManager.h"
#import "Globals.h"
#import "ProviderInvitedContactsCell.h"




@interface ActiveContactsController (){
    NSMutableArray *medicalcontacts;
    NSInteger editingIndex;
    CoreDataManager *dataManager;
    Globals *globals;
    NSMutableArray *allMedicalContacts;
    NSMutableArray *providerInvitedContacts;
    
    BOOL isMovingDown;
    NSInteger fetchLimit;
    
    NSMutableArray *lazyloadDataArray;
    
    long currentRow;
}

@end

@implementation ActiveContactsController
@synthesize btnAddContact;
@synthesize medicalContacttableView;
@synthesize addMedicalContactView;


- (void)viewDidLoad {
    [super viewDidLoad];
   dataManager = [CoreDataManager sharedManager];
   globals = [Globals sharedManager];
    
    
    //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(insertMedicalRecord:) name:InsertMedicalContactNotification object:nil];
    _providerInvitedContactsTableView.delegate = self;
    _providerInvitedContactsTableView.dataSource = self;
    _contactsScrollView.delegate = self;
    
   [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateMedicalContact:) name:UpdateMedicalContactNotification object:nil];
    
    [self applyCornerToView:btnAddContact];
   
    UINib *nib = [UINib nibWithNibName:@"MedicalContactCell" bundle:nil];
    [medicalContacttableView registerNib:nib forCellReuseIdentifier:@"medicalContactCellId"];
    medicalContacttableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
}

-(void)viewWillAppear:(BOOL)animated{
    
   
    lazyloadDataArray =[[NSMutableArray alloc]init];
     allMedicalContacts = [[NSMutableArray alloc] initWithArray:[self getAllMedicalContasFromLocalDB]];
     fetchLimit = 0;
    if([self checkInternetConnection]){
        [self callApiToGetInviteProviders];
       
    }
    else{
        [self fetchDtataFromDataBase];
    }
   
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}


//On click of add Button
- (IBAction)addContactAction:(id)sender {
    
    MedicalContactDetailsController *contactDetail = [[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:medicalContactDetailsControllerID];
    [contactDetail setIsEditing:NO];
    [contactDetail setMedicalContacts:[self getAllMedicalContasFromLocalDB ]];
    [self.navigationController pushViewController:contactDetail animated:YES];

    
}

#pragma mark Table View
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == medicalContacttableView) {
        MedicalContactCell *cell = [tableView dequeueReusableCellWithIdentifier:medicalContactCellIdentifier];
        [cell.btnInvite setTag:inviteButtonTag + indexPath.row];
       
        My_contacts *medicalContact = [lazyloadDataArray objectAtIndex:indexPath.row];
             
        
              [cell.nameLabel setText: [NSString stringWithFormat:@"%@ %@",medicalContact.fore_name,medicalContact.sur_name]];
              [cell.emailOrSpecialityLabel setText:medicalContact.specialism];
              
              [cell.btnInvite addTarget:self action:@selector(inviteBtnAction:) forControlEvents:UIControlEventTouchUpInside];
              if(medicalContact.invite_status == 1 ){
                  [cell.btnInvite setHidden:true];
                  [cell.inviteImage setImage:[UIImage imageNamed:invitePendingImage]];
              }else if(medicalContact.invite_status == 2){
                  [cell.btnInvite setHidden:true];
                  [cell.inviteImage setImage:[UIImage imageNamed:invitAcceptedImage]];
                  [cell.emailOrSpecialityLabel setText:medicalContact.specialism];
              }else if(medicalContact.invite_status == 3){
                  [cell.btnInvite setHidden:false];
                  [cell.inviteImage setImage:[UIImage imageNamed:rejectedImage]];
                  [cell.emailOrSpecialityLabel setText:medicalContact.specialism];
              }else{
                  [cell.btnInvite setHidden:false];
                  [cell.inviteImage setImage:nil];
              }

      return cell;
    }
    else
    {
        static NSString *cellIdentifier =@"Cell";
        ProviderInvitedContactsCell *cell =[tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
        if (!cell) {
            cell =[[ProviderInvitedContactsCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        }
        dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
              My_contacts *contacts =[providerInvitedContacts objectAtIndex:indexPath.row];
            dispatch_async(dispatch_get_main_queue(), ^{
                
              cell.titleLabel.text = [NSString stringWithFormat:@"%@ %@",contacts.fore_name,contacts.sur_name];
                cell.descLabel.text= contacts.specialism;
            });
            
        });
        
        
        return cell;
        
    }
    
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView == _providerInvitedContactsTableView) {
        
        return providerInvitedContacts.count;
    }
    else {
        
        return lazyloadDataArray.count;
    }
    
}

-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (tableView == _providerInvitedContactsTableView) {
        
        return false;
    }
    else {
        
        return true;
    }

   
}
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
       
        UIAlertController *alertController = [UIAlertController
                                              alertControllerWithTitle:InfoAlert
                                              message:deleteMessage
                                              preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancelAction = [UIAlertAction
                                       actionWithTitle:NSLocalizedString(@"Yes", @"Cancel action")
                                       style:UIAlertActionStyleDefault
                                       handler:^(UIAlertAction *action)
                                       {
                                         [self deleteMedicalContact:indexPath];
                                       }];
        
        UIAlertAction *okAction = [UIAlertAction
                                   actionWithTitle:NSLocalizedString(@"No", @"OK action")
                                   style:UIAlertActionStyleDefault
                                   handler:^(UIAlertAction *action)
                                   {
                                       NSLog(@"OK action");
                                       
                                   }];
        
        [alertController addAction:cancelAction];
        [alertController addAction:okAction];
        [self presentViewController:alertController animated:YES completion:nil];

        
        
      
    }
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
     MedicalContactEditController *editContact =  [[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:medicalContactEditControllerID];
    
    if (tableView == medicalContacttableView) {
        editingIndex = indexPath.row;
        My_contacts *medicalContact = [lazyloadDataArray objectAtIndex:indexPath.row];
       [editContact setMedicalContact:medicalContact];
       [editContact setAllSavedContacts:allMedicalContacts];
    }
    else{
        My_contacts *providerContact = [providerInvitedContacts objectAtIndex:indexPath.row];
        [editContact setMedicalContact:providerContact];
    }
    [self.navigationController pushViewController:editContact animated:YES];
   }


//to find the scrolling Direction
-(void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset
{
    NSLog(@"content Offset .........   %f",velocity.y);
    CGFloat initail = 0;
    CGFloat scrollPos = velocity.y;
    if (initail >scrollPos) {
       isMovingDown = YES;
        }
    else{
        isMovingDown = NO;
        }
    
}
- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView
{
    if (isMovingDown == NO) {
        currentRow = ((NSIndexPath *)[[medicalContacttableView indexPathsForVisibleRows] lastObject]).row;
            NSLog(@"%li",currentRow);
            NSLog(@"%li",(unsigned long)lazyloadDataArray.count);
        NSInteger prevLimit = 20;
        fetchLimit = prevLimit +fetchLimit;
        [self fetchDtataFromDataBase];
    }
    else{
      //  NSLog(@"is moving down .........   %i",isMovingDown);
    }
}


// Invites the contact
-(void)inviteBtnAction:(UIButton *)sender{
    My_contacts *medicalContact = [lazyloadDataArray objectAtIndex:(sender.tag-inviteButtonTag)];
   
    if(![self validateForInvite:medicalContact]){
         [self showAlertWithTitle:errorAlert andMessage:invitationCantSentMessage andActionTitle:ok actionHandler:nil];
    }else{
        if([self checkInternetConnection]){
            [self callApiToInviteUser:medicalContact];
        }else{
            [self showAlertWithTitle:errorAlert andMessage:noInternetMessage andActionTitle:ok actionHandler:nil];
        }
    }
}


-(void)updateMedicalContact:(NSNotification *)notification{
  //  [dataManager commitChanges];
    //[medicalContacttableView reloadData];
}
-(void)deleteMedicalContact :(NSIndexPath *)indexPath{
    My_contacts *contact = [lazyloadDataArray objectAtIndex:indexPath.row];
    if(contact.invite_status == 1 || contact.invite_status == 2){
        if([self checkInternetConnection]){
             [self callApiToDeleteContact:indexPath];
        }else{
            [self showAlertWithTitle:errorAlert andMessage:noInternetMessage andActionTitle:ok actionHandler:nil];
        }
    }else{
        [self deleteContact:indexPath];
    }
}

//Add and edit record
-(void)insertMedicalContact:(NSNotification *) notification{
    
    //NSDictionary *dict = [notification userInfo];
    //My_contacts *modifiedContact = [dict objectForKey:@"medicalContactModelInsertKey"];
   // [medicalcontacts addObject:modifiedContact];
    [medicalContacttableView setHidden:false];
    [addMedicalContactView setHidden:true];
    [medicalContacttableView reloadData];
}

//Returns all medical contacts saved in the db
-(NSMutableArray*)getActiveMedicalContasFromLocalDB{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"is_active == %@ && consumer_id == %@  ",[NSNumber numberWithInteger:1],[NSNumber numberWithInt:globals.consumerId]];
    
    NSArray *medicalContactss = [self fetchDataFromEntity:medicalContactEntity predicate:predicate sortBy:@"fore_name" WithLimit:fetchLimit];
    return [medicalContactss mutableCopy];
}
-(NSMutableArray*)getContactsForTheEvents
{
    NSArray *activeContacts =[self getActiveMedicalContasFromLocalDB];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(invited_by_consumer == 0 && invite_status == 2)  OR  (invited_by_consumer == 1 && invite_status == 3) OR  (invited_by_consumer == 1 && invite_status == 2) OR (invited_by_consumer == 1 && invite_status == 0) OR (invited_by_consumer == 1 && invite_status == 1) OR (invited_by_consumer == 0 && invite_status == 0)"];
    NSArray *medicalContactss = [activeContacts filteredArrayUsingPredicate:predicate];
    return [medicalContactss mutableCopy];
    
}
-(NSMutableArray*)sortedByForeName
{
    NSArray *dataArray =[self getContactsForTheEvents];
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"fore_name" ascending:NO];
    
    NSArray *medicalContactss = [dataArray sortedArrayUsingDescriptors:@[sortDescriptor]];
    return [medicalContactss mutableCopy];
    
}
-(NSMutableArray*)getApprovedMedicalContasFromLocalDB{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"invited_by_consumer == 0 && is_active == %@ && consumer_id == %@ && invite_status == 2 ",[NSNumber numberWithInteger:1],[NSNumber numberWithInt:globals.consumerId]];
    NSArray *medicalContactss = [dataManager fetchDataFromEntity:medicalContactEntity predicate:predicate sortBy:@"fore_name"];
    return [medicalContactss mutableCopy];
}



//Returns all medical contacts saved in the db
-(NSMutableArray*)getAllMedicalContasFromLocalDB{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"consumer_id == %@",[NSNumber numberWithInteger:globals.consumerId]];
    NSArray *medicalContactss = [dataManager fetchDataFromEntity:medicalContactEntity predicate:predicate sortBy:@"fore_name"];
    return [medicalContactss mutableCopy];
}


//Validations for inviting the user
-(BOOL)validateForInvite :(My_contacts*)medicalcontact{

    if([medicalcontact.email isEqualToString:@""] || [medicalcontact.fore_name isEqualToString:@""] || [medicalcontact.sur_name isEqualToString:@""] ){
        return false;
    }
    return true;
}


//Calls API to send Invite
-(void)callApiToInviteUser :(My_contacts *)medicalContact{
    
    NSError *writeError = nil;
    NSDictionary * dict = [NSDictionary dictionaryWithObjectsAndKeys:medicalContact.email,@"InviteeEmailID",[NSNumber numberWithBool:YES],@"IsInitiatedByConsumer",medicalContact.fore_name,@"InviteeForeName",medicalContact.sur_name,@"InviteerSurName", nil];
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:&writeError];
    
    
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    NSLog(@"JSON String :%@",jsonString);
    
    APIHandler *reqHandler =[[APIHandler alloc] init];

    [self showProgressHudWithText:@"Inviting.."];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *token = [defaults valueForKey:access_tokenKey];
    NSString *url = [NSString stringWithFormat:@"%@%@",BaseURL,httpInviteUser];
    [reqHandler makeRequestByPost:jsonString  serverUrl:url withAccessToken:token  completion:^(NSDictionary *result, NSError *error) {
        
        if ( error == nil) {
            NSLog(@"result -%@",result);
            
            [self updateDBAfterInvite:medicalContact];
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [self hideProgressHud];
                [self showAlertWithTitle:invitationSentAlert andMessage:invitaionSentMessage andActionTitle:ok actionHandler:^(UIAlertAction *action){
                     [medicalContacttableView reloadData];
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
                    [self showAlertWithTitle:statusStr andMessage:errorDescription andActionTitle:ok actionHandler:nil];
                });
            });
            
            [self handleServerError:error];
        }
    }];

}

//Update data in database after invite sent
-(void)updateDBAfterInvite:(My_contacts *)medicalContact{
    [medicalContact setInvite_status:1];
    
    [dataManager commitChanges];
}

//Lists all approved providers
-(void)callApiToGetInviteProviders{

    APIHandler *reqHandler =[[APIHandler alloc]init];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *token = [defaults valueForKey:access_tokenKey];

     NSString *url = [NSString stringWithFormat:@"%@%@",BaseURL,httpGetInviteProviders];
    [reqHandler makeRequest:token serverUrl:url completion:^(NSDictionary *result, NSError *error) {
        if (error == nil) {
            NSArray *resultArray = [result objectForKey:httpResult];
            NSLog(@"Results callApiToGetInviteProviders-- %@",resultArray);
           
            [self saveProviderInvitedContactToLocalDB:resultArray];
            [self fetchDtataFromDataBase];
            
            }
        else{
           NSLog(@"Error  :%@",error);
            [self handleServerError:error];
        }
    }];
}

//Updates the Local DB with Server contact details
-(void)updateDBForApprovedContacts:(NSArray*) approvedContacts{
    
    for (NSDictionary *approvedContact in approvedContacts) {

        NSArray *emailObjs = [allMedicalContacts filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"email == %@",[approvedContact objectForKey:@"ProviderEmailID"]]];
        //If already invited contact is there
         if(emailObjs.count >0){
             My_contacts *updatingContact = [emailObjs objectAtIndex:0];
            
             NSInteger statusFromServer = [[approvedContact objectForKey:@"InviteStatus"] integerValue];
             int isArchivedFromServer =  [[approvedContact objectForKey:@"IsArchived"] intValue];

             //Completely deletes the contact from DB
             if(statusFromServer == 1 && isArchivedFromServer == 1){
                [dataManager.managedObjectContext deleteObject:updatingContact];
             }else if ((statusFromServer == 1 || statusFromServer == 2) && isArchivedFromServer == 0){
                 [updatingContact setIs_active:1];
                 [updatingContact setInvite_status:[[approvedContact objectForKey:@"InviteStatus"] integerValue]];
                 [updatingContact setIs_archived:isArchivedFromServer];
                 [updatingContact setInvited_by_consumer:[[approvedContact objectForKey:@"IsInitiatedByConsumer"] integerValue]];
                 [updatingContact setEmail:[approvedContact objectForKey:@"ProviderEmailID"]];
                 if(statusFromServer == 2){
                     [updatingContact setFore_name:[approvedContact objectForKey:@"ProviderForeName"]];
                     [updatingContact setSur_name:[approvedContact objectForKey:@"ProviderLastName"]];
                     [updatingContact setSpecialism:[approvedContact objectForKey:@"ProviderSpeciality"]];
                 }
                 
             }else if (statusFromServer == 2 && isArchivedFromServer == 1){
                 
                 if(updatingContact.is_active == 1 && updatingContact.invite_status != 0){
                     [updatingContact setIs_active:0];
                     [updatingContact setInvite_status:0];
                   //  [updatingContact setInvite_status:[[approvedContact objectForKey:@"InviteStatus"] integerValue]];
                     [updatingContact setIs_archived:isArchivedFromServer];
                     [updatingContact setInvited_by_consumer:[[approvedContact objectForKey:@"IsInitiatedByConsumer"] integerValue]];
                     [updatingContact setEmail:[approvedContact objectForKey:@"ProviderEmailID"]];
                     
                     // if(statusFromServer == 2){
                     [updatingContact setFore_name:[approvedContact objectForKey:@"ProviderForeName"]];
                     [updatingContact setSur_name:[approvedContact objectForKey:@"ProviderLastName"]];
                     [updatingContact setSpecialism:[approvedContact objectForKey:@"ProviderSpeciality"]];
                     // }
                 }
                 
             }else if (statusFromServer == 3 && isArchivedFromServer == 0){
                 
                 if(updatingContact.is_active == 1 && updatingContact.invite_status == 1){
                     [updatingContact setIs_active:1];
                     [updatingContact setInvite_status:[[approvedContact objectForKey:@"InviteStatus"] integerValue]];
                     [updatingContact setIs_archived:isArchivedFromServer];
                     [updatingContact setInvited_by_consumer:[[approvedContact objectForKey:@"IsInitiatedByConsumer"] integerValue]];

                     [updatingContact setEmail:[approvedContact objectForKey:@"ProviderEmailID"]];
                    
                    
                     
                 }
             }
        [dataManager commitChanges];
           
       }
       }
    }

//Insert provider invited Contacts From Server to Local DB
-(void)saveProviderInvitedContactToLocalDB:(NSArray *)providerContacts{
    
    for (int i=0; i<providerContacts.count; i++) {
        NSString *providerEmailId =[[providerContacts objectAtIndex:i] objectForKey:@"ProviderEmailID"];
      BOOL isExists =   [self isproviderEmailIDExists:providerEmailId];
        NSLog(@"i sExists -%i",isExists);
        if (isExists == YES) {
         [self updateDBForApprovedContacts:providerContacts];
          }
        else
        {
           int invistedStatus =  [[[providerContacts objectAtIndex:i] objectForKey:@"InviteStatus"] intValue];
            int isArchived =  [[[providerContacts objectAtIndex:i] objectForKey:@"IsArchived"] intValue];
            
            if(invistedStatus == 1 && isArchived){
                
            }else{
                My_contacts *medicalContactModel = [[My_contacts alloc] initWithEntity:[NSEntityDescription entityForName:medicalContactEntity inManagedObjectContext:dataManager.managedObjectContext] insertIntoManagedObjectContext:dataManager.managedObjectContext];
                [medicalContactModel setFore_name:[[providerContacts objectAtIndex:i] objectForKey:@"ProviderForeName"]];
                [medicalContactModel setSur_name:[[providerContacts objectAtIndex:i] objectForKey:@"ProviderLastName"]];
                [medicalContactModel setEmail:[[providerContacts objectAtIndex:i]objectForKey:@"ProviderEmailID"]];
                [medicalContactModel setSpecialism:[[providerContacts objectAtIndex:i] objectForKey:@"ProviderSpeciality"]];
                [medicalContactModel setInvited_by_consumer:[[[providerContacts objectAtIndex:i] objectForKey:@"IsInitiatedByConsumer"] integerValue]];
                [medicalContactModel setInvite_status:[[[providerContacts objectAtIndex:i] objectForKey:@"InviteStatus"] integerValue]];
                
                int isArchived =  [[[providerContacts objectAtIndex:i] objectForKey:@"IsArchived"] intValue];
                [medicalContactModel setIs_archived:isArchived];
                if(isArchived == 1){
                    [medicalContactModel setIs_active:0];
                }else{
                    [medicalContactModel setIs_active:1];
                }
                
                
                [medicalContactModel setPhone:@""];
                [medicalContactModel setAddress:@""];
                [medicalContactModel setConsumer_id:globals.consumerId];
                [dataManager commitChanges];
            }
        }
        
         medicalcontacts = [[NSMutableArray alloc] initWithArray:[self getActiveMedicalContasFromLocalDB]];
        
    }
}
-(BOOL)isproviderEmailIDExists:(NSString*)providerEmail
{
    allMedicalContacts =[self getAllMedicalContasFromLocalDB];
    NSMutableArray *emailArray =[[NSMutableArray alloc]init];
    
    for (int i=0; i<allMedicalContacts.count;i++) {
       My_contacts *contacts =[allMedicalContacts objectAtIndex:i];
        NSString *email =contacts.email;
        [emailArray addObject:email];
    }
    if ([emailArray containsObject:providerEmail]) {
        return  YES;
    }
    else
    {
        return NO;
    }
   
}

-(NSMutableArray*)getproviderInvitedContactList
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"invited_by_consumer == 0 && invite_status == 1 && consumer_id == %@ && is_active == 1",[NSNumber numberWithInt:globals.consumerId]];
    NSArray *medicalContactss = [dataManager fetchDataFromEntity:medicalContactEntity predicate:predicate sortBy:@"fore_name"];
    
    return [medicalContactss mutableCopy];
}
-(void)callApiToDeleteContact :(NSIndexPath *)medicalContactIndexPath{
    
    My_contacts *medicalContact = [lazyloadDataArray objectAtIndex:medicalContactIndexPath.row];
    NSError *writeError = nil;
    
    NSDictionary * dict = [NSDictionary dictionaryWithObject:medicalContact.email forKey:@"EmailID"];
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:&writeError];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *token = [defaults valueForKey:access_tokenKey];

    
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    NSLog(@"JSON String :%@",jsonString);
    
    APIHandler *reqHandler =[[APIHandler alloc] init];
    [self showProgressHudWithText:@"Deleting.."];
    NSString *url = [NSString stringWithFormat:@"%@%@",BaseURL,httpArchiveProductContact];
    
    [reqHandler makeRequestByPost:jsonString serverUrl:url withAccessToken:token completion:^(NSDictionary *result, NSError *error) {
        
        if ( error == nil) {
            NSLog(@"result -%@",result);
            
            [self updateTableAfterDeletion:medicalContactIndexPath];
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [self hideProgressHud];
                [self deleteContact:medicalContactIndexPath];
             
                
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
                    [self showAlertWithTitle:statusStr andMessage:errorDescription andActionTitle:ok actionHandler:nil];
                });
            });
            [self handleServerError:error];
        }
    }];

}
-(void)updateTableAfterDeletion:(NSIndexPath *)indexPath{
    My_contacts *contact = [lazyloadDataArray objectAtIndex:indexPath.row];
    [contact setIs_active:0];
    [contact setInvite_status:0];
    [dataManager commitChanges];
   // [lazyloadDataArray removeObjectAtIndex:indexPath.row];
}

-(void)deleteContact:(NSIndexPath *) indexPath{
    My_contacts *contact = [lazyloadDataArray objectAtIndex:indexPath.row];
    [contact setIs_active:0];
    [contact setInvite_status:0];
    [dataManager commitChanges];
    [lazyloadDataArray removeObjectAtIndex:indexPath.row];
    [medicalContacttableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    
    if(lazyloadDataArray.count == 0){
        [medicalContacttableView setHidden:true];
        [addMedicalContactView setHidden:false];
    }
}
-(void)fetchDtataFromDataBase
{
      [dataManager.managedObjectContext performBlock:^{
          
           dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
          medicalcontacts = [[NSMutableArray alloc] initWithArray:[self getContactsForTheEvents]];
         providerInvitedContacts =[self getproviderInvitedContactList];
               
               NSLog(@"Medical Contacts count %lu",(unsigned long)medicalcontacts.count);
               NSLog(@"provider InvitedContacts count %lu",(unsigned long)providerInvitedContacts.count);
               
               if (medicalcontacts.count>0) {
                   for (int i=0; i<medicalcontacts.count; i++) {
                       My_contacts *contact =[medicalcontacts objectAtIndex:i];
                       [lazyloadDataArray addObject:contact];
                   }
                   NSLog(@"array count -%lu",(unsigned long)lazyloadDataArray.count);
               }
          
           dispatch_async(dispatch_get_main_queue(), ^{
               
                 if (providerInvitedContacts.count >0 || lazyloadDataArray.count >0)
                 {
                     [addMedicalContactView setHidden:true];
                 }
                 else{
                     [addMedicalContactView setHidden:false];
                 }
               
               if (providerInvitedContacts.count >0) {
                   
                
                   _providerInvitedContactsTableView.hidden = NO;
                   self.providerContactstableHeifhtConstraint.constant = providerInvitedContacts.count*74+60;
                   _viewTopConstraint.constant = 20;
               
                   [self.providerInvitedContactsTableView reloadData];
                   
               }
               else
               {
                   
                   self.providerContactstableHeifhtConstraint.constant =0;
                   _providerInvitedContactsTableView.hidden = YES;
                   _viewTopConstraint.constant = -20;
               
               }
               
               if(lazyloadDataArray.count > 0){
                  
                   
                   [medicalContacttableView setHidden:false];
               
                   self.medicalContactsHeightConstraint.constant =lazyloadDataArray.count*77;
                       self.contentViewHeightConstraint.constant = self.providerContactstableHeifhtConstraint.constant +  self.medicalContactsHeightConstraint.constant;
                       
                   
                        [medicalContacttableView reloadData];
               }
               else{
                   [medicalContacttableView setHidden:true];
                  
            }
         });
    
        });
      }];
    }

-(NSArray*)fetchDataFromEntity:(NSString*)entityName predicate:(NSPredicate*)predicate sortBy:(NSString *)param WithLimit:(NSInteger)limit
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:entityName];
    NSArray *dataArray =[[NSArray alloc]init];
    [fetchRequest setPredicate:predicate];
    [fetchRequest setFetchLimit:20];
    [fetchRequest setFetchOffset:limit];
    [fetchRequest setSortDescriptors:@[[[NSSortDescriptor alloc] initWithKey:param ascending:YES]]];
    dataArray = [[dataManager.managedObjectContext executeFetchRequest:fetchRequest error:nil] mutableCopy];
    return dataArray;
}
@end
