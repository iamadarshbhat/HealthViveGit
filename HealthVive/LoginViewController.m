//
//  LoginViewController.m
//  HealthVive
//
//  Created by Adarsha on 10/01/17.
//  Copyright © 2017 NousInfosystems. All rights reserved.
//

#import "LoginViewController.h"
#import "RegistrationQuestionController.h"
#import "APIHandler.h"
#import "ForgotPasswordViewController.h"


@interface LoginViewController ()
{
    CGFloat screenHeight;

}
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *logoHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *regLeading;
@property (weak, nonatomic) IBOutlet UILabel *hlabel;
@property (weak, nonatomic) IBOutlet UIButton *regBtn;
@property (weak, nonatomic) IBOutlet UIButton *backBtn;
@property (weak, nonatomic) IBOutlet UILabel *hlabel1;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *emailHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *hLabel1HeightConstraint;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *accBtnConstraint;
@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    
    
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
    [self.loginBtn.layer setCornerRadius:5.0];
    
    
    if (screenHeight == 667) {
        self.regLeading.constant = 60;
    }
    else if (screenHeight == 736)
    {
        
        self.regLeading.constant = 80;
    }
    _backBtn.hidden =YES;
    _hlabel1.hidden=YES;
    _infoBtn.hidden = YES;
    _nextimage.hidden = YES;
    
  
    
    
   
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
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    
    UITextPosition *beginning = [textField beginningOfDocument];
    [textField setSelectedTextRange:[textField textRangeFromPosition:beginning
                                                          toPosition:beginning]];

    [UIView animateWithDuration:2.0
                     animations:^{
                         if (screenHeight == 568) {
                             
                             
                             //self.logoHeightConstraint.constant = -80;
                             
                             self.labelConatraint.constant = -80;
                             
                         }
                         else if (screenHeight == 667) {
                            // self.logoHeightConstraint.constant = -5;
                             self.labelConatraint.constant = -5;
                             
                             
                         }
                         else if (screenHeight == 736)
                         {
                           //  self.logoHeightConstraint.constant = -20;
                             self.labelConatraint.constant = -20;
                             
                         }
    
                         
                     }];
    
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    
    
    
    [UIView animateWithDuration:2.0
                     animations:^{
                         
                         
                         if (screenHeight == 568) {
                             
                             
                             self.logoHeightConstraint.constant =70;
                             self.labelConatraint.constant = 78;
                             
                         }
                         else if (screenHeight == 667) {
                             self.logoHeightConstraint.constant = 70;
                             self.labelConatraint.constant = 78;
                             
                             
                         }
                         else if (screenHeight == 736)
                         {
                             self.logoHeightConstraint.constant = 70;
                             self.labelConatraint.constant = 78;
                             
                         }

                        
                     
                     }];
    

   
    
    
    return [textField resignFirstResponder];
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    [UIView animateWithDuration:2.0
                     animations:^{

                         if (screenHeight == 568) {
                             
                             self.logoHeightConstraint.constant =70;
                             self.labelConatraint.constant = 78;
                             
                         }
                         else if (screenHeight == 667) {
                             self.logoHeightConstraint.constant = 70;
                             self.labelConatraint.constant = 78;
                             
                             
                         }
                         else if (screenHeight == 736)
                         {
                             self.logoHeightConstraint.constant = 70;
                             self.labelConatraint.constant = 78;
                             
                         }
                         
        
                     
                     
                     }];
    [self.passwordTxtField resignFirstResponder];
    [self.emailTxtField resignFirstResponder];
}


- (IBAction)registerBtnPressed:(id)sender {

    [self.loginBtn setTitle:@"Next" forState:UIControlStateNormal];
    self.emailTxtField.text = nil;
    self.passwordTxtField.text = nil;
    _regBtn.hidden =YES;
    _hlabel.hidden = YES;
    _hlabel1.hidden=NO;
    _backBtn.hidden = NO;
    _infoBtn.hidden = NO;
    _forgotBtn.hidden = YES;
    _nextimage.hidden = NO;

    
    [UIView animateWithDuration:2.0
                     animations:^{
                         if (screenHeight == 667) {
                             _accBtnConstraint.constant = 35;
                             
                         }
                         else if (screenHeight == 736)
                         {
                             _accBtnConstraint.constant = 5;
                             
                         }
                         
                         
                         _hLabel1HeightConstraint.constant= 40;
                         _emailHeightConstraint.constant =50;
                         _usrImgConstraint.constant = 135;
                         
                     }];
    NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc] initWithString:@"I have already an Account!"];
    [attributeString addAttribute:NSUnderlineStyleAttributeName
                            value:[NSNumber numberWithInt:1]
                            range:(NSRange){0,[attributeString length]}];
    [_backBtn setAttributedTitle:attributeString forState:UIControlStateNormal];
    
    
    
}
- (IBAction)backBtnPressed:(id)sender {
     [self.loginBtn setTitle:@"Login" forState:UIControlStateNormal];
    self.emailTxtField.text = nil;
    self.passwordTxtField.text = nil;
    _regBtn.hidden =NO;
    _hlabel.hidden = NO;
    _hlabel1.hidden=YES;
    _backBtn.hidden=YES;
    _forgotBtn.hidden = NO;
    _infoBtn.hidden = YES;
    _nextimage.hidden = YES;
    _hLabel1HeightConstraint.constant= 20;
    _emailHeightConstraint.constant =30;
     _usrImgConstraint.constant =95;
}
- (IBAction)loginButtonPressed:(id)sender {
    
        if ([self.loginBtn.currentTitle isEqualToString:@"Login"]) {
           
          
            
            if ([self validateForm]) {
                
                NSLog(@"Valid Email -%@",self.emailTxtField.text);
                NSString *paramString =[NSString stringWithFormat:@"username=%@&password=%@&grant_type=%@",self.emailTxtField.text,self.passwordTxtField.text,@"password"];
                APIHandler *reqHandler =[[APIHandler alloc] init];
                
            [reqHandler makeRequestByPost:paramString                                       serverUrl:LoginAuthentication completion:^(NSDictionary *result, NSError *error) {
                    
                    if ( error == nil) {
                        NSLog(@"result -%@",result);
                        dispatch_async(dispatch_get_main_queue(), ^{
                            
                            [self showAlertWithTitle:statusStr andMessage:@"User logged in successfully" andActionTitle:ok actionHandler:^(UIAlertAction *action) {
                                
                                [self clearTextField];
                            }];
                        });
                        
                    }
                    else
                    {
                        
                        dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                            NSString *errorDescription =[error valueForKey:@"error_description"];
                            NSLog(@"%@",errorDescription);
                            
                            dispatch_async(dispatch_get_main_queue(), ^{
                                
                                [self showAlertWithTitle:statusStr andMessage:errorDescription andActionTitle:ok actionHandler:^(UIAlertAction *action) {
                                
                                    [self clearTextField];
                                }];
                                
                                
                            });
                            
                        });
                        
                    }
                    
                }];
                
            }
                
    }
    else if([self.loginBtn.currentTitle isEqualToString:@"Next"])
    {
        if([self validateForm] ){
        if(![self isValidPassword:_passwordTxtField.text]){
            
            [self showAlertWithTitle:alert andMessage:invalidRegistrationPassword andActionTitle:ok actionHandler:nil];
            
                return;
        }

        RegistrationQuestionController *registerVC =[self.storyboard instantiateViewControllerWithIdentifier:@"RegistrationQuestionController"];
        registerVC.emailStr = self.emailTxtField.text;
        registerVC.passwordStr = self.passwordTxtField.text;
        [self.navigationController pushViewController:registerVC animated:NO];
        }
        
    }
    
}
- (IBAction)forgotBtnPressed:(id)sender {
    
    ForgotPasswordViewController *forgotPwd =[self.storyboard instantiateViewControllerWithIdentifier:@"ForgotPasswordViewController"];
    [self.navigationController pushViewController:forgotPwd animated:NO];
    
    
}
- (IBAction)infoBtnPressed:(id)sender {
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.hidden = YES;
}

#pragma mark- To CheckValidEmailFormat
-(BOOL)IsValidEmail:(NSString *)checkString
{
    BOOL stricterFilter = NO;
    NSString *stricterFilterString = @"^[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}$";
    NSString *laxString = @"^.+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2}[A-Za-z]*$";
    NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:checkString];
}

-(BOOL)isValidPassword:(NSString *)passwordString{
                         
    NSString *passRegex =@"^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)(?=.*[$@$!%*?&])[A-Za-z\\d$@$!%*?&]{8,20}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", passRegex];
    return [emailTest evaluateWithObject:passwordString];
}


-(Boolean)validateForm{
    
    if(_emailTxtField.text.length == 0){
        
        [self showAlertWithTitle:alert andMessage:emptyLoginEmail andActionTitle:ok actionHandler:^(UIAlertAction *action) {
           
            [self clearTextField];

        }];
        
        return false;
    }else if (_passwordTxtField.text.length == 0){
        
        [self showAlertWithTitle:alert andMessage:emptyLoginPassword andActionTitle:ok actionHandler:^(UIAlertAction *action) {
            
            [self clearTextField];
        
        }];

            return false;
    }else if (![self IsValidEmail:_emailTxtField.text]){
        
    [self showAlertWithTitle:alert andMessage:invalidEmail andActionTitle:ok actionHandler:^(UIAlertAction *action) {
        
        [self clearTextField];
        
        }];

        return false;
    }
    
    return true;
}

-(void)clearTextField
{
    self.emailTxtField.text = nil;
    self.passwordTxtField.text = nil;
  
  
}
@end
