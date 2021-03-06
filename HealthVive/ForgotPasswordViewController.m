//
//  ForgotPasswordViewController.m
//  HealthVive
//
//  Created by Sadhasivan Sriram on 16/01/17.
//  Copyright © 2017 NousInfosystems. All rights reserved.
//

#import "ForgotPasswordViewController.h"
#import "Constants.h"
#import "APIHandler.h"

@interface ForgotPasswordViewController ()
{
    
    CGFloat   screenHeight;
    
}
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *textFieldHeightConstraint;


@end

@implementation ForgotPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setNaviagationBarWithTitle:forgotPassNavigationBarTitle];
    self.emailTextField.delegate = self;
    
    
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    screenHeight = screenRect.size.height;
    
    UIImage*menuIcon = [UIImage imageNamed:@"backButton"];
    CGRect frameimg = CGRectMake(0, 0, menuIcon.size.width, menuIcon.size.height);
    UIButton *menuButton = [[UIButton alloc] initWithFrame:frameimg];
    [menuButton setBackgroundImage:menuIcon forState:UIControlStateNormal];
    [menuButton addTarget:self action:@selector(backButtonClicked)
         forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *leftBarButton =[[UIBarButtonItem alloc] initWithCustomView:menuButton];
    self.navigationItem.leftBarButtonItem = leftBarButton;
    
    
    _emailTextField.layer.cornerRadius = 5.0;
    
    _resetPasswordBtn.layer.cornerRadius = 5.0;
    
    UIView *paddingView1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 25, 20)];
    _emailTextField.leftView = paddingView1;
    _emailTextField.leftViewMode = UITextFieldViewModeAlways;
    
    [self.resetPasswordBtn setBackgroundColor:NAVBAR_BCG_COLOR];
    

  _emailTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Email" attributes:@{NSForegroundColorAttributeName:[UIColor colorWithRed:51.0/255.0 green:51.0/255.0 blue:51.0/255.0 alpha:0.5]}];
    
 
    
    
}

-(void)backButtonClicked
{
    [self.navigationController popViewControllerAnimated:NO];
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

- (IBAction)resetPasswordClicked:(id)sender {
    
   if (_emailTextField.text.length>0) {
           if ([self checkInternetConnection]) {
        if ([self IsValidEmail:self.emailTextField.text]) {
         
                NSError *writeError = nil;
                
                NSDictionary * dict = [[NSDictionary alloc] initWithObjectsAndKeys:self.emailTextField.text,@"emailID",nil];
                NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:&writeError];
                NSLog(@"%@",writeError);
                
                NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
                
                NSLog(@"%@",jsonString);
                
                
                APIHandler *reqHandler =[[APIHandler alloc]init];
           NSString *url =  [NSString stringWithFormat:@"%@%@",BaseURL,ForgotPassword];
                [reqHandler makeRequestByPost:jsonString serverUrl:url completion:^(NSDictionary *result, NSError *error) {
                    
                    if (error == nil) {
                        
                        dispatch_async(dispatch_get_main_queue(), ^{
                            
                            [self showAlertWithTitle:thanks andMessage:resetPasswordLink andActionTitle:ok actionHandler:^(UIAlertAction *action) {
                                
                                
                                dispatch_async(dispatch_get_main_queue(), ^{
                                    
                                    _emailTextField.text = nil;
                                    [self.navigationController popViewControllerAnimated:YES];
                                });
                                
                                
                            }];
                            
                            
                            
                        });
                        
                    }
                    else{
                        
                        
                        dispatch_async(dispatch_get_main_queue(), ^{
                            
                            [self showAlertWithTitle:errorAlert andMessage:forgotPassEmailAlert andActionTitle:ok actionHandler:^(UIAlertAction *action) {
                                _emailTextField.text = nil;
                                
                            }];
                            
                            
                        });
                        
                        
                    }
                    
                    
                }];
                
            }
            else
            {
             
                [self showAlertWithTitle:errorAlert andMessage:forgotPassEmailAlert andActionTitle:ok actionHandler:^(UIAlertAction *action) {
                    _emailTextField.text = nil;
                    
                }];
                
                
            }
            
          
            
        }
        else{
            
            [self showAlertWithTitle:errorAlert andMessage:offlineStatus andActionTitle:ok actionHandler:^(UIAlertAction *action) {
                _emailTextField.text = nil;
                
            }];
            
        }
       
    }
    
  
    
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    
    if (screenHeight == 568) {
        _textFieldHeightConstraint.constant = 160;
        
    }
    return [_emailTextField resignFirstResponder];
    
    
    
}
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    
    if (screenHeight == 568) {
        _textFieldHeightConstraint.constant = 140;
        
    }
    
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    if (screenHeight == 568) {
        _textFieldHeightConstraint.constant = 160;
        
    }
    [_emailTextField resignFirstResponder];
    
}
@end
