//
//  ArchivedContactsController.m
//  HealthVive
//
//  Created by Adarsha on 09/02/17.
//  Copyright © 2017 NousInfosystems. All rights reserved.
//

#import "ArchivedContactsController.h"
#import "CoreDataManager.h"
#import "Globals.h"
#import "MedicalContactCell.h"
#import "My_contacts+CoreDataProperties.h"
#import "MedicalContactEditController.h"

@interface ArchivedContactsController (){
    CoreDataManager *dataManager;
    Globals *globals;
    NSMutableArray *inActiveMedicalcontacts;
   // NSMutableArray *allMedicalContacts;
    NSInteger editingIndex;
}

@end

@implementation ArchivedContactsController
@synthesize archivedContactsTableView;
@synthesize emptyArchiveView;

- (void)viewDidLoad {
    [super viewDidLoad];
    dataManager = [CoreDataManager sharedManager];
    globals = [Globals sharedManager];

    UINib *nib = [UINib nibWithNibName:@"MedicalContactCell" bundle:nil];
    [archivedContactsTableView registerNib:nib forCellReuseIdentifier:@"medicalContactCellId"];
    archivedContactsTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)viewWillAppear:(BOOL)animated{
    
    inActiveMedicalcontacts = [self getInactiveMedicalContasFromLocalDB];
    //allMedicalContacts = [[NSMutableArray alloc] initWithArray:[self getAllMedicalContactsFromLocalDB]];
   [self getAllMedicalContactsFromLocalDB];
    
    if(inActiveMedicalcontacts.count > 0){
        [archivedContactsTableView setHidden:false];
        [emptyArchiveView setHidden:true];
        [archivedContactsTableView reloadData];
    }else{
        [archivedContactsTableView setHidden:true];
        [emptyArchiveView setHidden:false];
    }
}


//Returns all archived contacts saved in the db
-(NSMutableArray*)getAllMedicalContactsFromLocalDB{
   NSPredicate *predicate = [NSPredicate predicateWithFormat:@"consumer_id == %@",[NSNumber numberWithInteger:globals.consumerId]];
    NSArray *medicalContactss = [dataManager fetchDataFromEntity:medicalContactEntity predicate:predicate sortBy:@"fore_name"];
    return [medicalContactss mutableCopy];
}


//Returns all archived contacts saved in the db
-(NSMutableArray*)getInactiveMedicalContasFromLocalDB{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"is_active == %@ && consumer_id == %@",[NSNumber numberWithInteger:0],[NSNumber numberWithInteger:globals.consumerId]];
    NSArray *medicalContactss = [dataManager fetchDataFromEntity:medicalContactEntity predicate:predicate sortBy:@"fore_name"];
    return [medicalContactss mutableCopy];
}


#pragma mark Table View
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MedicalContactCell *cell = [tableView dequeueReusableCellWithIdentifier:medicalContactCellIdentifier];
   // [cell.btnInvite setTag:inviteButtonTag + indexPath.row];
    [cell.btnInvite setHidden:YES];
    [cell.btnMessage setHidden:YES];
    
    My_contacts *medicalContact = [inActiveMedicalcontacts objectAtIndex:indexPath.row];
    
    [cell.nameLabel setText: [NSString stringWithFormat:@"%@ %@",medicalContact.fore_name,medicalContact.sur_name]];
    [cell.emailOrSpecialityLabel setText:medicalContact.specialism];
    
    //[cell.btnInvite addTarget:self action:@selector(inviteBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    if(medicalContact.invite_status == 1){
       // [cell.btnInvite setHidden:true];
       // [cell.inviteImage setImage:[UIImage imageNamed:invitePendingImage]];
    }else if(medicalContact.invite_status == 2){
        //[cell.btnInvite setHidden:true];
       // [cell.inviteImage setImage:[UIImage imageNamed:invitAcceptedImage]];
        [cell.emailOrSpecialityLabel setText:medicalContact.specialism];
    }else if(medicalContact.invite_status == 3){
        //[cell.btnInvite setHidden:false];
      //  [cell.inviteImage setImage:[UIImage imageNamed:rejectedImage]];
        [cell.emailOrSpecialityLabel setText:medicalContact.specialism];
    }else{
       // [cell.btnInvite setHidden:false];
        [cell.inviteImage setImage:nil];
    }
    return cell;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return inActiveMedicalcontacts.count;
}

-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return true;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    editingIndex = indexPath.row;
    My_contacts *medicalContact = [inActiveMedicalcontacts objectAtIndex:indexPath.row];
    MedicalContactEditController *editContact =  [[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:medicalContactEditControllerID];
    [editContact setMedicalContact:medicalContact];
   // [editContact setAllSavedContacts:medicalcontacts];
    [self.navigationController pushViewController:editContact animated:YES];
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        UIAlertController *alertController = [UIAlertController
                                              alertControllerWithTitle:InfoAlert
                                              message:undoMessage
                                              preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancelAction = [UIAlertAction
                                       actionWithTitle:NSLocalizedString(@"Yes", @"Cancel action")
                                       style:UIAlertActionStyleDefault
                                       handler:^(UIAlertAction *action)
                                       {
                                           [self unDoMedicalContact:indexPath];
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


-(NSString*)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    return @"Undo";
}
// Invites the contact
-(void)inviteBtnAction:(UIButton *)sender{
    My_contacts *medicalContact = [inActiveMedicalcontacts objectAtIndex:(sender.tag-inviteButtonTag)];
    
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
    
    NSDictionary * dict = [NSDictionary dictionaryWithObjectsAndKeys:medicalContact.email,@"InvitedEmailID",[NSNumber numberWithBool:YES],@"IsInitiatedByConsumer", nil];
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
                    [archivedContactsTableView reloadData];
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
    //[medicalContact setValue:[NSNumber numberWithInt:1] forKey:@"invite_status"];
    //[dataManager update:medicalContact :[NSDictionary dictionaryWithObject:[NSNumber numberWithInt:1] forKey:@"invite_status"]];
    
    // [dataManager updateDeatailsToEntity:medicalContactEntity andPredicate:[NSPredicate predicateWithFormat:@"email == %@",medicalContact.email] andValues:[NSDictionary dictionaryWithObject:[NSNumber numberWithInt:1] forKey:@"invite_status"]];
}


-(void)unDoMedicalContact :(NSIndexPath *)indexPath{
    
    My_contacts *contact = [inActiveMedicalcontacts objectAtIndex:indexPath.row];
    // [dataManager deleteData:contact];
    [contact setIs_active:1];
    [contact setInvite_status:0];
    [contact setInvited_by_consumer:1];
    [dataManager commitChanges];
    
    [self getAllMedicalContactsFromLocalDB];
    [inActiveMedicalcontacts removeObjectAtIndex:indexPath.row];
    [archivedContactsTableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    
    if(inActiveMedicalcontacts.count == 0){
        [archivedContactsTableView setHidden:true];
        [emptyArchiveView setHidden:false];
    }
}

@end
