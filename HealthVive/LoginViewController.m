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
#import "Account.h"
#import "CoreDataManager.h"
#import "ConsumerProfileViewController.h"
#import "TabBarController.h"

@interface LoginViewController ()
{
    CGFloat screenHeight;
    NSString *email;
    NSString *password;
    int userStatus;

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
    
    
    CoreDataManager *cdm = [[CoreDataManager alloc] init];
    _managedObjectContext = cdm.managedObjectContext;

    
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

    
    [self setButtonEnabled:NO forButton:_loginBtn];
    
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
    
    TabBarController *tabBar =[[TabBarController alloc]init];
    [self presentViewController:tabBar animated:NO completion:nil];
    
    if ([self validateForm]) {
                
        if ([self checkInternetConnection]) {
            
            [self callLoginServices];
           
        }
 
   }
}

-(void)callLoginServices
{
    
    email =[self getTrimmedStringForString:self.emailTxtField.text];
    password =[self getTrimmedStringForString:self.passwordTxtField.text];
    NSString *paramString =[NSString stringWithFormat:@"username=%@&password=%@&grant_type=%@",email,password,@"password"];
    APIHandler *reqHandler =[[APIHandler alloc] init];
    [self showProgressHudWithText:@""];
    [reqHandler makeRequestByPost:paramString                                       serverUrl:LoginAuthentication completion:^(NSDictionary *result, NSError *error) {
        
        if ( error == nil) {
            NSLog(@"result -%@",result);
            NSString *accesToken =[result valueForKey:@"access_token"];
            [_defaults setValue:accesToken forKey:@"access_token"];
            
            NSLog(@"%@",[_defaults valueForKey:@"access_token"]);
            userStatus = 2;
            
            
            [self saveLoginAccountDetails];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [self hideProgressHud];
                TabBarController *tabBar =[[TabBarController alloc]init];
                [self presentViewController:tabBar animated:NO completion:nil];
                
            });
            
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
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    [self showAlertWithTitle:errorTitle andMessage:errorDescription andActionTitle:ok actionHandler:^(UIAlertAction *action) {
                        
                        self.passwordTxtField.text = nil;
                    }];
                    
                    
                });
                
            });
            
        }
        
    }];
    
}
    

- (IBAction)registerBtnPressed:(id)sender {
    RegistrationController *registration =[self.storyboard instantiateViewControllerWithIdentifier:@"RegistrationControllerID"];
    [self.navigationController pushViewController:registration animated:YES];
    
}

-(void)grayOutButton
{
    
}

//To get the status of the user

-(void)getTheUserStatus:(NSString*)status
{
  
    if ([status isEqualToString:@"Registered"]) {
        
     
        
        userStatus = 1;
        
        
    }
    else if ([status isEqualToString:@"Rejected"])
    {
        userStatus= 3;
      
    }
    else if ([status isEqualToString:@"Suspended"])
    {
        userStatus = 4;
    
    }

    else if ([status isEqualToString:@"Deactivated"])
    {
        userStatus = 5;
     
    }

    else if ([status isEqualToString:@"UnAuthenticated"])
    {
        userStatus = 6;
     
    }
    else if ([status isEqualToString:@"ApprovedWithEmailUnverified"])
    {
       userStatus = 7;
    }

}

- (IBAction)forgotBtnPressed:(id)sender {
    
  ForgotPasswordViewController *forgotPwd =[self.storyboard instantiateViewControllerWithIdentifier:@"ForgotPasswordViewController"];
    [self.navigationController pushViewController:forgotPwd animated:NO];
    
    
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
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Account"];
    NSMutableArray *accountArray =[[NSMutableArray alloc]init];
    accountArray = [[_managedObjectContext executeFetchRequest:fetchRequest error:nil] mutableCopy];
    
    for (int i=0; i<accountArray.count; i++) {
        
        Account *status =[accountArray objectAtIndex:i];
        NSLog(@"email-%@ ,status-%@ ",status.email,status.account_status);
        
        if ([email isEqualToString:status.email]) {
            
            NSLog(@"the mail id is alreay exist");
        }
        else
        {
            NSManagedObjectContext *context = [self managedObjectContext];
            NSManagedObject *account = [NSEntityDescription insertNewObjectForEntityForName:@"Account" inManagedObjectContext:context];
            [account setValue:email forKey:@"email"];
            [account setValue:password forKey:@"password"];
            [account setValue:[NSNumber numberWithInt:userStatus] forKey:@"account_status"];
            
            NSError *error = nil;
            // Save the object to persistent store
            if (![context save:&error]) {
                NSLog(@"Can't Save! %@ %@", error, [error localizedDescription]);
            }
            

        }
        
    }
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
     self.navigationController.navigationBar.hidden = YES;
    
}


@end


