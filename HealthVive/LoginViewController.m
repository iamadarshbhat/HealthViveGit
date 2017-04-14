//
//  LoginViewController.m
//  HealthVive
//
//  Created by Adarsha on 10/01/17.
//  Copyright © 2017 NousInfosystems. All rights reserved.
//

#import "LoginViewController.h"
#import "RegistrationQuestionController.h"
#import "ForgotPasswordViewController.h"
#import "RegistrationController.h"
#import "Account+CoreDataProperties.h"
#import "CoreDataManager.h"
#import "ConsumerProfileViewController.h"
#import "TabBarController.h"
#import "Globals.h"
#import "Consumer.h"



@interface LoginViewController ()
{
    CGFloat screenHeight;
    NSString *email;
    NSString *password;
    int accountStatus;
    int consumerId;
    Globals *globals;
    CoreDataManager *cdm;
    Consumer *consumer;
    NSDate *dobDate;
    
    NSString *userPlanName;
    NSDate *planExpiryDate;
    
}
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *textFieldTopConstraint;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *regLeading;
@property (weak, nonatomic) IBOutlet UILabel *hlabel;
@property (weak, nonatomic) IBOutlet UIButton *regBtn;
@property (nonatomic,strong)NSUserDefaults *defaults;
@property (nonatomic,strong)NSManagedObjectContext *managedObjectContext;
@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
      [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(logoutUser:) name:LogoutNotification object:nil];
    
     cdm = [CoreDataManager sharedManager];
    consumer =[[Consumer alloc]init];
    
    globals =[Globals sharedManager];

    
    self.navigationController.navigationBar.hidden = YES;
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    screenHeight = screenRect.size.height;
    
    self.passwordTxtField.delegate = self;
    self.emailTxtField.delegate = self;
    
    UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 20)];
    self.passwordTxtField.leftView = paddingView;
    self.passwordTxtField.leftViewMode = UITextFieldViewModeAlways;
       
    UIView *paddingView1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 20)];
    
    self.emailTxtField.leftView = paddingView1;
    self.emailTxtField.leftViewMode = UITextFieldViewModeAlways;
    
    
   [self applyColorToPlaceHolderText:self.emailTxtField];
    [self applyColorToPlaceHolderText:self.passwordTxtField];
    [self setLeftImageForTextField:_emailTxtField withImage:[UIImage imageNamed:userImage]];
    [self setLeftImageForTextField:_passwordTxtField withImage:[UIImage imageNamed:passwordImage]];
    [self.loginBtn.layer setCornerRadius:5.0];
    
    
    if (screenHeight == 667) {
        self.regLeading.constant = 60;
        self.textFieldTopConstraint.constant = 95;
    }
    else if (screenHeight == 736)
    {
        
        self.regLeading.constant = 80;
         self.textFieldTopConstraint.constant = 105;
    }
   
    _defaults =[NSUserDefaults standardUserDefaults];
    [_defaults synchronize];


    //self.emailTxtField.text = @"refertree999@gmail.com";
    //self.passwordTxtField.text = @"Welcome@123";
    [self setButtonEnabled:NO forButton:_loginBtn];

    
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


#pragma mark- ResignKeyBoard

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
  return [textField resignFirstResponder];
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
  
    [self.passwordTxtField resignFirstResponder];
    [self.emailTxtField resignFirstResponder];
}
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    NSUInteger newLength = [[self getTrimmedStringForString:textField.text] length] + [[self getTrimmedStringForString:string] length] - range.length;
    
    
    if(textField == _emailTxtField){
        if(newLength == 0 || _passwordTxtField.text.length == 0){
            [self setButtonEnabled:NO forButton:_loginBtn];
        }else{
            [self setButtonEnabled:YES forButton:_loginBtn];
        }
    }else if (textField == _passwordTxtField){
        if(newLength == 0 || _emailTxtField.text.length == 0){
            [self setButtonEnabled:NO forButton:_loginBtn];
        }
        else{
            [self setButtonEnabled:YES forButton:_loginBtn];
        }
        }
    
    if(range.length + range.location > textField.text.length)
    {
        return NO;
    }
    return YES;
    
}



- (IBAction)loginButtonPressed:(id)sender {
      
   if ([self validateForm]) {
                
        if ([self checkInternetConnection]) {
            
            [self callLoginServices];
           
        }
        else
        {
             [self showProgressHudWithText:offlineLogin];
            [self performSelector:@selector(loginOfflineMode) withObject:nil afterDelay:1.5];
          
           
         
        }
    }
    }

-(void)loginOfflineMode
{
    [self fetchAccountDetails];
    if ([globals.email isEqualToString:_emailTxtField.text]&&[globals.password isEqualToString:_passwordTxtField.text]) {
        
        [_defaults setBool:NO forKey:loginStatus];
        [self hideProgressHud];
        [self checkAccountStatus:globals.accountStatus];
        
    }
    else
    {
        [self showAlertWithTitle:errorAlert andMessage:invalidEmailMsg andActionTitle:ok actionHandler:^(UIAlertAction *action) {
            _passwordTxtField.text = nil;
            [self hideProgressHud];
            
        }];
    }
}

-(void)callLoginServices
{
    email =[self getTrimmedStringForString:self.emailTxtField.text];
    password =[self getTrimmedStringForString:self.passwordTxtField.text];
    NSString *paramString =[NSString stringWithFormat:@"username=%@&password=%@&grant_type=%@",email,password,@"password"];
    APIHandler *reqHandler =[[APIHandler alloc] init];
    [self showProgressHudWithText:onlineLogin];
     NSString *url = [NSString stringWithFormat:@"%@%@",BaseURL,LoginAuthentication];
    
    [reqHandler makeRequestByPost:paramString serverUrl:url completion:^(NSDictionary *result, NSError *error) {
        
        if ( error == nil) {
            NSLog(@"result -%@",result);
            NSString *accesToken =[result valueForKey:access_tokenKey];
            [_defaults setValue:accesToken forKey:access_tokenKey];
            [_defaults setBool:YES forKey:loginStatus];
            NSLog(@"%@",[_defaults valueForKey:access_tokenKey]);
       
            [self getBasicUserDetails:accesToken];
            
            }
        else
        {
            dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                NSString *errorDescription =[error valueForKey:@"error_description"];
                NSString *errorStatus =[error valueForKey:@"error"];
                
                NSString *errorTitle;
                if ([errorStatus isEqualToString:@"UnAuthenticated"]) {
                    
                    errorTitle = errorAlert;
                }
                else{
                    errorTitle = statusStr;
                }
                [self getTheUserStatus:errorStatus];
                [self saveLoginAccountDetails];
                dispatch_async(dispatch_get_main_queue(), ^{
                      [self hideProgressHud];
                    [self showAlertWithTitle:errorTitle andMessage:errorDescription andActionTitle:ok actionHandler:^(UIAlertAction *action) {
                        [self hideProgressHud];
                        self.passwordTxtField.text = nil;
                    }];
                    
                    
                });
                
            });
            
        }
        
    }];
    
}
    

- (IBAction)registerBtnPressed:(id)sender {
   
    RegistrationController *registration =[self.storyboard instantiateViewControllerWithIdentifier:RegistrationControllerID];
    [self.navigationController pushViewController:registration animated:YES];
    
}

-(void)getBasicUserDetails:(NSString*)token
{
     APIHandler *reqHandler =[[APIHandler alloc] init];
    NSString *url = [NSString stringWithFormat:@"%@%@",BaseURL,getBasicProfileDetails];

     [reqHandler makeRequest:token serverUrl:url completion:^(NSDictionary *result, NSError *error) {
         
         if (error == nil) {
             
             NSLog(@"%@",result);
                NSDictionary *dict =[result valueForKey:@"Result"];
             globals.password =_passwordTxtField.text;
             globals.email =[dict valueForKey:@"EmailID"];
             globals.accountStatus = [[dict valueForKey:@"AccountStatus"]intValue];
             globals.consumerId =[[dict valueForKey:@"ConsumerID"]intValue];
             consumerId = globals.consumerId;
             userPlanName =[dict valueForKey:@"PlanName"];
             NSString *expiry =[dict valueForKey:@"ExpiryDate"];
          planExpiryDate =    [self getDateFromString:expiry WithFormat:@"yyyy-MM-dd'T'HH:mm:ss.SS"];
           // planExpiryDate  = [self returnDatefromString:expiry withFormat:@"yyyy/MM/dd'T'HH:mm:ss"];
           
             NSLog(@"Expiry Date -%@",planExpiryDate);
             
             [_defaults setValue:[NSNumber numberWithInt:consumerId] forKey:@"ConsumerID"];
           
             [self saveLoginAccountDetails];
             [self callGetConsumerservices ];
             
         
         }
         else{
             
         }
         
         
         
     }];
    
    
}

-(void)getTheUserStatus:(NSString*)status
{
    
    if ([status isEqualToString:@"Registered"]) {
        
        globals.accountStatus = 1;
        
        
    }
    else if ([status isEqualToString:@"Rejected"])
    {
         globals.accountStatus= 3;
        
    }
    else if ([status isEqualToString:@"Suspended"])
    {
         globals.accountStatus = 4;
        
    }
    
    else if ([status isEqualToString:@"Deactivated"])
    {
         globals.accountStatus = 5;
        
    }
    
    else if ([status isEqualToString:@"UnAuthenticated"])
    {
         globals.accountStatus = 6;
        
    }
    else if ([status isEqualToString:@"ApprovedWithEmailUnverified"])
    {
         globals.accountStatus = 7;
    }
    
}



- (IBAction)forgotBtnPressed:(id)sender {
    
  ForgotPasswordViewController *forgotPwd =[self.storyboard instantiateViewControllerWithIdentifier:@"ForgotPasswordViewController"];
    [self.navigationController pushViewController:forgotPwd animated:YES];
    
    
}
-(Boolean)validateForm{
    
    if(_emailTxtField.text.length == 0){
        
        [self showAlertWithTitle:invalidEmailIdAlert andMessage:emptyLoginEmail andActionTitle:ok actionHandler:^(UIAlertAction *action) {
           
            [self clearTextField];
          
        
        }];
        
        return false;
    }else if (_passwordTxtField.text.length == 0){
        
        [self showAlertWithTitle:invalidPasswordAlert andMessage:emptyLoginPassword andActionTitle:ok actionHandler:^(UIAlertAction *action) {
            
            [self clearTextField];
        
        }];

            return false;
    }else if (![self IsValidEmail:_emailTxtField.text]){
        
    [self showAlertWithTitle:errorAlert andMessage:invalidEmailMsg andActionTitle:ok actionHandler:^(UIAlertAction *action) {
        
        [self clearTextField];
        
        }];

        return false;
    }
    
    return true;
}

-(void)clearTextField
{    self.emailTxtField.text = nil;
    self.passwordTxtField.text = nil;
    [self setButtonEnabled:NO forButton:_loginBtn];
}


-(void)saveLoginAccountDetails
{
   
   NSPredicate *predicate = [NSPredicate predicateWithFormat:@"email = %@",self.emailTxtField.text];
    NSArray *accountArray =[cdm fetchDataFromEntity:accountEntity predicate:predicate];

    if(accountArray.count>0) {
        Account *status =[accountArray lastObject];
        NSLog(@"email-%@ ,status-%hd ",status.email,status.account_status);
        
        if ([email isEqualToString:status.email]) {
            globals.consumerId = status.consumer_id;
            globals.email  = status.email;
            globals.password = status.password;
            userPlanName = status.subscribed_plan;
            planExpiryDate = status.plan_expiry;
          
            [self updateUserStatusToDataBase];
        }
        else
        {
            [self saveAccontDetails];

        }
      
    }
    else{
        
        [self saveAccontDetails];

        
    }
    
}


#pragma mark- Database methods
//Save Data To Databse
-(void)saveAccontDetails
{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setValue:globals.email forKey:@"email"];
    [dict setValue:globals.password forKey:@"password"];
    [dict setValue: [NSNumber numberWithInt:globals.accountStatus] forKey:@"account_status"];
    [dict setValue: [NSNumber numberWithInt:globals.consumerId] forKey:@"consumer_id"];
    [dict setValue:userPlanName forKey:@"subscribed_plan"];
    [dict setValue:planExpiryDate forKey:@"plan_expiry"];

    [cdm saveDetailsToEntity:accountEntity andValues:dict];
}

//Fetch data from database
-(void)fetchAccountDetails
{
    
       NSPredicate *predicate = [NSPredicate predicateWithFormat:@"email = %@",self.emailTxtField.text];
  
    NSArray *accountArray =[cdm fetchDataFromEntity:accountEntity predicate:predicate];
    if(accountArray.count>0) {
        Account *status =[accountArray lastObject];
        NSLog(@"email-%@ ,status-%hd ",status.email,status.account_status);
        globals.accountStatus= status.account_status;
        globals.consumerId = status.consumer_id;
        globals.email  = status.email;
        globals.password = status.password;
     
       }
    
}

//updating Datbase
-(void)updateUserStatusToDataBase
{
   
   NSPredicate *predicate = [NSPredicate predicateWithFormat:@"email = %@",self.emailTxtField.text];
  
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setValue:globals.email forKey:@"email"];
    [dict setValue:globals.password forKey:@"password"];
    [dict setValue: [NSNumber numberWithInt:globals.accountStatus] forKey:@"account_status"];
    [dict setValue: [NSNumber numberWithInt:globals.consumerId] forKey:@"consumer_id"];
    [dict setValue:userPlanName forKey:@"subscribed_plan"];
    [dict setValue:planExpiryDate forKey:@"plan_expiry"];
    [cdm updateDeatailsToEntity:accountEntity andPredicate:predicate andValues:dict];
}

//To check if the 
-(void)checkAccountStatus:(int)statusType
{
    TabBarController *tabBar =[[TabBarController alloc]init];
    switch (statusType) {
        case Registered:
        
            break;
        case Approved:
            
                [self.navigationController pushViewController:tabBar animated:YES];
            
            
            break;
        case Rejected:
            
            break;
        case Suspended:
            
                [self showAlertWithTitle:statusStr andMessage:suspendedError andActionTitle:ok actionHandler:nil];
                
                break;
        case Deactivated:
         
               [self showAlertWithTitle:statusStr andMessage:deactivatedError andActionTitle:ok actionHandler:nil];
            
            
            break;
        case UnAuthenticated:
          
            
            break;
        case ApprovedWithEmailUnverified:
            
            break;
           default:
            break;
    }
}



//Get profile Information from Server

-(void)callGetConsumerservices
{
    
    NSString *token =[NSString stringWithFormat:@"%@",[_defaults valueForKey:access_tokenKey]];
    
    APIHandler *reqHandler =[[APIHandler alloc] init];
    
    NSString *url = [NSString stringWithFormat:@"%@%@",BaseURL,getConsumerProfile];
    [reqHandler makeRequest:token serverUrl:url completion:^(NSDictionary *result, NSError *error) {
        
        if (error == nil) {
            NSLog(@"%@",result);
            NSDictionary *dict =[result valueForKey:@"Result"];
            
            consumer.cid =[[dict valueForKey:@"ID"] intValue];
            consumer.consumerId =[[dict valueForKey:@"ConsumerID"] integerValue];
            consumer.emailId = [dict valueForKey:@"EmailID"];
            consumer.title =[dict valueForKey:@"Title"];
            consumer.foreName =[dict valueForKey:@"ForeName"];
            consumer.surName =[dict valueForKey:@"LastName"];
            consumer.gender =[dict valueForKey:@"Gender"];
            consumer.dob =[dict valueForKey:@"DateOfBirth"];
            
             dobDate = [self returnDatefromString:consumer.dob withFormat:@"yyyy/MM/dd'T'HH:mm:ss"];
            
            consumer.address1 = [dict valueForKey:@"Address1"];
            consumer.address2 =[dict valueForKey:@"Address2"];
            consumer.city = [dict valueForKey:@"City"];
            consumer.post_code =[dict valueForKey:@"PostCode"];
            consumer.country =[dict valueForKey:@"Country"];
            consumer.home_phone =[dict valueForKey:@"HomePhoneNumber"];
            consumer.mobile_phone =[dict valueForKey:@"MobilePhoneNumber"];
            consumer.alternate_email =[dict valueForKey:@"AltEmailID"];
            
            
        
            if ([consumer.alternate_email isKindOfClass:[NSNull class]]) {
                consumer.alternate_email = nil;
            }
            if ([consumer.home_phone isKindOfClass:[NSNull class]]) {
                consumer.home_phone = nil;
            }
            if ([consumer.mobile_phone isKindOfClass:[NSNull class]]) {
                consumer.mobile_phone = nil;
            }
            if ([consumer.country isKindOfClass:[NSNull class]]) {
                consumer.country = nil;
            }
            if ([consumer.address1 isKindOfClass:[NSNull class]]) {
                consumer.address1 = nil;
            }
            
            if ([consumer.address2 isKindOfClass:[NSNull class]]) {
                consumer.address2 = nil;
            }
            
            if ([consumer.post_code isKindOfClass:[NSNull class]]) {
                consumer.post_code = nil;
            }
            if ([consumer.city isKindOfClass:[NSNull class]]) {
                consumer.city = nil;
            }
            
            // dateString = [self getDateString:dob withFormat:@"yyyy-MM-dd"];
            
            [self saveConsumerDetails];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [self hideProgressHud];
                
                TabBarController *tabBar =[[TabBarController alloc]init];
                [self.navigationController pushViewController:tabBar animated:YES];
                
            });

       
           
              }
        else
        {
            NSDictionary *errorObj =[error valueForKey:@"Error"];
            NSString *errorDescription = [errorObj valueForKey:@"error_description"];
            NSLog(@"errorDescription ....%@",errorDescription);
            dispatch_async(dispatch_get_main_queue(), ^{
                [self showAlertWithTitle:statusStr andMessage:errorDescription andActionTitle:ok actionHandler:nil];
            });
            
        }
        
    }];
    
    
}
-(void)saveConsumerDetails
{
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
        [dict setValue:consumer.title forKey:@"title"];
        [dict setValue:consumer.emailId forKey:@"email"];
        [dict setValue:consumer.foreName forKey:@"fore_name"];
        [dict setValue:consumer.surName forKey:@"sur_name"];
        [dict setValue:dobDate forKey:@"dob"];
        [dict setValue:consumer.gender forKey:@"gender"];
        [dict setValue:consumer.address1 forKey:@"address1"];
        [dict setValue:consumer.address2 forKey:@"address2"];
        [dict setValue:consumer.city forKey:@"city"];
        [dict setValue:consumer.post_code forKey:@"post_code"];
        [dict setValue:consumer.country forKey:@"country"];
        [dict setValue:consumer.home_phone forKey:@"home_phone"];
        [dict setValue:consumer.mobile_phone forKey:@"mobile_phone"];
        [dict setValue:consumer.alternate_email forKey:@"alternate_email"];
        [dict setValue:[NSNumber numberWithUnsignedInteger:consumerId] forKey:@"consumer_id"];
        [dict setValue:[NSNumber numberWithInt:consumer.cid] forKey:@"id"];
        
        
        [cdm saveDetailsToEntity:profileEntity andValues:dict];
        
    }

-(NSDate*)returnDatefromString:(NSString*)dateStr withFormat:(NSString*)format
{
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:format];
    return [dateFormat dateFromString:dateStr];
}

-(void)logoutUser:(NSNotification *)logoutNotification{
    self.emailTxtField.text = @"";
    self.passwordTxtField.text = @"";
    [self setButtonEnabled:NO forButton:_loginBtn];
}
@end


