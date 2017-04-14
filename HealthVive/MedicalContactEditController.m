//
//  MedicalContactEditController.m
//  HealthVive
//
//  Created by Adarsha on 30/01/17.
//  Copyright © 2017 NousInfosystems. All rights reserved.
//

#import "MedicalContactEditController.h"
#import "MedicalContactEditCell.h"
#import "CoreDataManager.h"

@interface MedicalContactEditController (){
    NSMutableArray *titles;
    NSMutableArray *details;
    NSString *address;
    CoreDataManager *dataManager;
    NSString *phone;
    
    NSString *serverAddress;
    NSString *serverPhone;
    NSString *serverCity;
    NSString *serverFirstName;
    NSString *serverLastName;
    NSString *serverSpecialism;
    NSString *serverPostCode;
    NSString *serverOrgName;
    NSString *serverCountry;
    
    
   
  
    
}
    @end

@implementation MedicalContactEditController
@synthesize editLocalContactTableView;
@synthesize medicalcontacts;
@synthesize medicalContact;
@synthesize btnMessage;
@synthesize lblName;
@synthesize lblOrganization;
@synthesize lblSpecialism;
@synthesize orgToSpecConstraint;
@synthesize messageToSpecConstraint;
@synthesize viewtableHeader;
@synthesize allSavedContacts;


- (void)viewDidLoad {
    [super viewDidLoad];
    dataManager = [CoreDataManager sharedManager];
   
   
    address = [NSString stringWithFormat:@"%@,%@",medicalContact.address,medicalContact.city];
    phone = medicalContact.phone;
  
    if(address == nil){
        address = @"";
    }
    
    if(phone == nil){
        phone = @"";
    }
    if (medicalContact.invite_status == 1 && medicalContact.invited_by_consumer == 0 ) {
        _approveBtn.hidden = NO;
        _rejectBtn.hidden = NO;
        
        [_approveBtn.layer setBorderColor:[[UIColor colorWithRed:224.0/255.0 green:224.0/255.0 blue:224.0/255.0 alpha:1.0] CGColor]];
        [_approveBtn.layer setBorderWidth:1.0];
        [_approveBtn.layer setCornerRadius:5.0];
        
        [_rejectBtn.layer setBorderColor:[[UIColor colorWithRed:224.0/255.0 green:224.0/255.0 blue:224.0/255.0 alpha:1.0] CGColor]];
        [_rejectBtn.layer setBorderWidth:1.0];
        [_rejectBtn.layer setCornerRadius:5.0];
        
        [self changePriorities:medicalContact.invite_status];
        
    }
    else{
        _approveBtn.hidden = YES;
        _rejectBtn.hidden = YES;
         [viewtableHeader setFrame:CGRectMake(0, 0, viewtableHeader.frame.size.width, 150)];
        [self.view layoutIfNeeded];
    }
   
    
    if([self checkInternetConnection]){
        if(medicalContact.invite_status == 2 ){
            [self callAPIToGetProviderContactDetails];
        }
    }
    
    [self changePriorities:medicalContact.invite_status];
    [self setNaviagationBarWithTitle:contactDetailsNavigatinBarTitle];
    [self applyCornerToView:btnMessage];
    [self applyCornerColorToView:btnMessage withColor:[UIColor colorWithRed:224.0/255.0 green:224/255.0 blue:224/255.0 alpha:1.0]];

    UIBarButtonItem * editButton = [[UIBarButtonItem alloc]
                                    initWithBarButtonSystemItem:UIBarButtonSystemItemEdit
                                    target:self
                                    action:@selector(editButtonAction)];
    
    if(medicalContact.is_active == 1 && (medicalContact.invite_status == 0 || medicalContact.invite_status == 3)){
        self.navigationItem.rightBarButtonItem = editButton;
    }else{
        self.navigationItem.rightBarButtonItem = nil;
    }
    [self updateUIWithLocalData];
   }
-(void)viewWillAppear:(BOOL)animated{
    [self updateUIWithLocalData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    MedicalContactEditCell *cell =   [tableView dequeueReusableCellWithIdentifier:@"editContactTableID"];
    cell.lbltitle.text =  [titles objectAtIndex:indexPath.row];
    NSString *detailTxt = [details objectAtIndex:indexPath.row];
    if([detailTxt isEqualToString:@""]){
       detailTxt = @"---";
    }
    cell.lblDetail.numberOfLines = 3;
    cell.lblDetail.text = detailTxt;
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return titles.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if(indexPath.row == 1){
        return 100;
    }else{
        return 62;
    }
}


//On Click of edit button
-(void)editButtonAction{
    MedicalContactDetailsController *medicalContactDetails = [[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:medicalContactDetailsControllerID];
    [medicalContactDetails setMedicalContact:medicalContact];
    [medicalContactDetails setIsEditing:YES];
    [medicalContactDetails setMedicalContacts:allSavedContacts];
    [self.navigationController pushViewController:medicalContactDetails animated:YES];
}

-(void)changePriorities:(int)inviteStatus {
    
    if(inviteStatus == 1 || inviteStatus == 2){
        
        
        if (medicalContact.invite_status == 1 && medicalContact.invited_by_consumer == 0 ){
           [viewtableHeader setFrame:CGRectMake(0, 0, viewtableHeader.frame.size.width, 200)];
        }else{
            [viewtableHeader setFrame:CGRectMake(0, 0, viewtableHeader.frame.size.width, 150)];
        }
        
        
        //When Organization label is there
        messageToSpecConstraint.priority = 500;
        orgToSpecConstraint.priority = 999;  //High priority for organization label
        lblOrganization.alpha = 1;
        // [viewtableHeader setFrame:CGRectMake(0, 0, viewtableHeader.frame.size.width, 200)];
    }else{
        //When Organization label is not there
        messageToSpecConstraint.priority = 999; // High Priority for message Button
        orgToSpecConstraint.priority = 500;
        lblOrganization.alpha = 0;
        [viewtableHeader setFrame:CGRectMake(0, 0, viewtableHeader.frame.size.width, 150)];
    }
    [self.view layoutIfNeeded];

}

-(void)callAPIToGetProviderContactDetails{
    APIHandler *reqHandler =[[APIHandler alloc]init];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *token = [defaults valueForKey:access_tokenKey];
    
    NSString *emailAppendedURL = [NSString stringWithFormat:@"%@%@%@",BaseURL,httpGetProviderContactDetails,medicalContact.email];
    [self showProgressHudWithText:@"Fetching..."];
    [reqHandler makeRequest:token serverUrl:emailAppendedURL completion:^(NSDictionary *result, NSError *error) {
        if (error == nil) {
            NSArray *resultArray = [result objectForKey:httpResult];
            NSLog(@"Results -- %@",resultArray);
            
            if(resultArray.count >0){
                NSDictionary *obj = [resultArray objectAtIndex:0];
                serverFirstName = [obj valueForKey:@"FirstName"];
                serverLastName =  [obj valueForKey:@"SurName"];
                serverPhone = [obj valueForKey:@"MobileNumber"];
                serverSpecialism = [obj valueForKey:@"Specialism"];
                serverCity =  [obj valueForKey:@"City"];
                serverPostCode = [obj valueForKey:@"PostCode"];
                serverOrgName =  [obj valueForKey:@"OrganisationName"];
                serverCountry = [obj valueForKey:@"Country"];
                
                NSString *address1 = [obj valueForKey:@"Address1"];
                NSString *address2 = [obj valueForKey:@"Address2"];
                NSString *address3 = [obj valueForKey:@"Address3"];
                
                NSMutableString *addressString = [[NSMutableString alloc] init];
                
                if(!(address1 == nil || address1 == (id)[NSNull null])){
                    [addressString appendString:[NSString stringWithFormat:@"%@, ",address1]];                }
                if(!(address2 == nil || address2 == (id)[NSNull null])){
                    [addressString appendString:[NSString stringWithFormat:@"%@, ",address2]];
                }
                
                if(!(address3 == nil || address3 == (id)[NSNull null])){
                     [addressString appendString:[NSString stringWithFormat:@"%@, ",address3]];                }
                if(serverCity == nil || [serverCity isKindOfClass:[NSNull class]]){
                    serverCity = @"";
                }
                if(serverCountry == nil || [serverCountry isKindOfClass:[NSNull class]]){
                   serverCountry = @"";
                }
                if(serverPostCode == nil || [serverPostCode isKindOfClass:[NSNull class]]){
                   serverPostCode = @"";
                }

                
               
               
                
              //  serverAddress = [NSString stringWithFormat:@"%@, %@, %@, %@, %@, %@",[self getTrimmedStringForString:address1],[self getTrimmedStringForString:address2],[self getTrimmedStringForString:address3],serverCity,serverPostCode,serverCountry];
                serverAddress = addressString;
                if(serverAddress == nil || [serverAddress isKindOfClass:[NSNull class]]){
                    serverAddress = @"";
                }
                if(serverPhone == nil || [serverPhone isKindOfClass:[NSNull class]]){
                    serverPhone = @"";
                }
                if(serverPostCode == nil || [serverPostCode isKindOfClass:[NSNull class]]){
                    serverPostCode = @"";
                }
                if(serverOrgName == nil || [serverOrgName isKindOfClass:[NSNull class]]){
                    serverOrgName = @"";
                }
               
                [self updateLocalDBWithServerData];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self updateUIWithServerData];
                });
                            }
        }else{
            NSLog(@"Error :%@",error);
        }
        NSDictionary *errorObj =[error valueForKey:@"Error"];
        NSString *errorDescription = [errorObj valueForKey:@"error_description"];
        NSLog(@"errorDescription ....%@",errorDescription);
        dispatch_async(dispatch_get_main_queue(), ^{
            // [self showAlertWithTitle:statusStr andMessage:errorDescription andActionTitle:ok actionHandler:nil];
            [self hideProgressHud];
        });
       // NSLog(@"Error Description :%@",error.localizedDescription);
    }];

}

//Update UI with server data
-(void)updateUIWithServerData{
        [lblOrganization setText:serverOrgName];
        [lblName setText:[NSString stringWithFormat:@"%@ %@",serverFirstName,serverLastName]];
        [lblSpecialism setText:serverSpecialism];
        titles = [[NSMutableArray alloc] initWithObjects:@"Email",@"Address",@"Telephone",nil];
    
        details = [[NSMutableArray alloc] initWithObjects:medicalContact.email,serverAddress,serverPhone, nil];
        [editLocalContactTableView reloadData];
}

-(void)updateUIWithLocalData{
  //  [lblOrganization setText:medicalContact.address];
    [lblSpecialism setText:medicalContact.specialism];
    [lblName setText:[NSString stringWithFormat:@"%@ %@",medicalContact.fore_name,medicalContact.sur_name]];
    
    
    titles = [[NSMutableArray alloc] initWithObjects:@"Email",@"Address",@"Telephone", nil];
    details = [[NSMutableArray alloc] initWithObjects:medicalContact.email,medicalContact.address,medicalContact.phone, nil];
    editLocalContactTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [editLocalContactTableView reloadData];
}

//updates to local db with server data
-(void)updateLocalDBWithServerData{
    
        [medicalContact setPhone:serverPhone];
        [medicalContact setSpecialism:serverSpecialism];
        [medicalContact setFore_name:serverFirstName];
        [medicalContact setSur_name:serverLastName];
        [medicalContact setAddress:serverAddress];
        [medicalContact setCity:serverCity];
        [medicalContact setPost_code:serverPostCode];
        [medicalContact setOrg_name:serverOrgName];
        [dataManager commitChanges];
}

- (IBAction)approvedBtnAction:(id)sender {
    if ([self checkInternetConnection]) {
        [self callApproveAndRejectApi:ApprovedStatus];
    }
    else{
        [self showAlertWithTitle:errorAlert andMessage:noInternetMessage andActionTitle:ok actionHandler:nil];
    }
    
    
    
}
- (IBAction)rejectedBtnAction:(id)sender {
    
    if ([self checkInternetConnection]) {
        [self callApproveAndRejectApi:RejectedStatus];
    }
    else{
        [self showAlertWithTitle:errorAlert andMessage:noInternetMessage andActionTitle:ok actionHandler:nil];
    }
}
//call Approve and reject API.

-(void)callApproveAndRejectApi:(int)status
{
    
    NSError *writeError = nil;
    
    NSDictionary * dict = [NSDictionary dictionaryWithObjectsAndKeys:medicalContact.email,@"InviterEmailID",[NSNumber numberWithInteger:status],@"Status", nil];
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:&writeError];
    
    
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    NSLog(@"JSON String :%@",jsonString);
    
    
    APIHandler *reqHandler =[[APIHandler alloc]init];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *token = [defaults valueForKey:access_tokenKey];
    NSString *url = [NSString stringWithFormat:@"%@%@",BaseURL,approveAndRejectinvitation];
    [self showProgressHudWithText:@""];
    [reqHandler makeRequestByPost:jsonString serverUrl:url withAccessToken:token completion:^(NSDictionary *result, NSError *error) {
        
        if (error == nil) {
            
            BOOL isSuccess =[[result valueForKey:@"IsSuccessful"] boolValue];
            
            if (isSuccess == YES) {
                [self upDateMedicalContact:status];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self hideProgressHud];
                    [self.navigationController popToRootViewControllerAnimated:YES];
                });
                
            }
            //            [self showAlertWithTitle:statusStr andMessage:@"Rejected" andActionTitle:@"Ok" actionHandler:nil];
        }
        else{
            
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

//Update the Invite Status
-(void)upDateMedicalContact:(InviteStatus)status
{
    switch (status) {
        case ApprovedStatus:
            [medicalContact setInvite_status:status];
            [medicalContact setIs_active:1];
            [dataManager commitChanges];
            break;
        case RejectedStatus:
            [medicalContact setInvite_status:status];
            [medicalContact setIs_active:0];
            [dataManager commitChanges];
            break;
            
            
        default:
            break;
    }
    
}



@end
