//
//  ChangePasswordTableController.m
//  HealthVive
//
//  Created by Adarsha on 23/02/17.
//  Copyright © 2017 NousInfosystems. All rights reserved.
//

#import "ChangePasswordTableController.h"


@interface ChangePasswordTableController ()
   


@end

@implementation ChangePasswordTableController
@synthesize txtNewPassword;
@synthesize txtConfirmPassword;
@synthesize txtCurrentPassword;

- (void)viewDidLoad {
    [super viewDidLoad];
    
  
    [self.navigationItem setRightBarButtonItem:[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneAction:)]];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self applyColorToPlaceHolderText:txtCurrentPassword];
    [self applyColorToPlaceHolderText:txtConfirmPassword];
    [self applyColorToPlaceHolderText:txtNewPassword];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)doneAction:(UIBarButtonItem *)doneButton{
    
    if([self isValidPassword:txtNewPassword.text]){
        if([txtNewPassword.text isEqualToString:txtConfirmPassword.text]){
            [self callApiTochangePasword];
        }else{
            [self showAlertWithTitle:errorAlert andMessage:@"The new passwords do not match. Please try again. Your new password must have: between 8 and 20 characters; 1 upper case letter; 1 lower case letter; 1 number; 1 special character" andActionTitle:ok actionHandler:^(UIAlertAction *action) {
                txtNewPassword.text = @"";
                txtConfirmPassword.text = @"";
            }];
        }
    }else{
        [self showAlertWithTitle:errorAlert andMessage:invalidRegistrationPassword andActionTitle:ok actionHandler:^(UIAlertAction *action) {
            txtNewPassword.text = @"";
            txtConfirmPassword.text = @"";
        }];
    }
    
}

-(void)callApiTochangePasword{
    
    NSError *writeError = nil;
    
    NSDictionary * dict = [NSDictionary dictionaryWithObjectsAndKeys:txtCurrentPassword.text,@"OldPassword",txtNewPassword.text,@"NewPassword", nil];
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:&writeError];
    
    
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    NSLog(@"JSON String :%@",jsonString);
    
    APIHandler *reqHandler =[[APIHandler alloc] init];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *token = [defaults valueForKey:access_tokenKey];
    
    [self showProgressHudWithText:@"Changing password..."];
    NSString *url =  [NSString stringWithFormat:@"%@%@",BaseURL,httpChangeConsumerPassword];
   
    [reqHandler makeRequestByPost:jsonString serverUrl:url withAccessToken:token  completion:^(NSDictionary *result, NSError *error) {
        
        if ( error == nil) {
            NSLog(@"result -%@",result);
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [self hideProgressHud];
                [self showAlertWithTitle:statusStr andMessage:@"Password changed successfully" andActionTitle:ok actionHandler:^(UIAlertAction *action){
                [[NSNotificationCenter defaultCenter] postNotificationName:LogoutNotification object:nil];
                [self.tabBarController.navigationController popViewControllerAnimated:YES];
                
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
                        txtNewPassword.text = @"";
                        txtConfirmPassword.text = @"";
                        txtCurrentPassword.text = @"";
                    }];
                });
            });
           
        }
        
        NSDictionary *errorDict =  [error valueForKey: @"Error"];
        NSString *errorDescription =[errorDict valueForKey:@"error_description"];
        
        
        BOOL isUserActive = [[error valueForKey:@"IsUserActive"] boolValue];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self hideProgressHud];
        });
        
        
        if(!isUserActive){
            dispatch_async(dispatch_get_main_queue(), ^{
                [self showAlertWithTitle:errorAlert andMessage:errorDescription andActionTitle:ok actionHandler:^(UIAlertAction *action) {
                    [[NSNotificationCenter defaultCenter] postNotificationName:LogoutNotification object:nil];
                    [self.tabBarController.navigationController popViewControllerAnimated:YES];
                }];
                
            });
        }

    }];

    
}

//Shows Alert View
-(void)showAlertWithTitle:(NSString*)title andMessage:(NSString*)msg andActionTitle:(NSString*)actionTitle actionHandler:(void (^ __nullable)(UIAlertAction *action))handler
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:msg preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* okAction = [UIAlertAction actionWithTitle:actionTitle style:UIAlertActionStyleDefault handler:handler];
    [alertController addAction:okAction];
    
    [self presentViewController:alertController animated:YES completion:nil];
}
//Shows the HUD
-(void)showProgressHudWithText:(NSString *)text{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeAnnularDeterminate;
    // hud.label.textColor = [UIColor blackColor];
    //[hud.bezelView setBackgroundColor:[UIColor blackColor]];
    hud.label.text = text;
}

//Hides the HUD
-(void)hideProgressHud{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}

//Password Validation
-(BOOL)isValidPassword:(NSString *)passwordString{
    
    NSString *passRegex =@"^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)(?=.*[$@$!%*?&])[A-Za-z\\d$@$!%*?&]{8,20}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", passRegex];
    return [emailTest evaluateWithObject:passwordString];
}
//Applies place holder text color
-(void)applyColorToPlaceHolderText:(UITextField *)textField{
    UIColor *color = [UIColor colorWithRed:142.0/255.0f green:142.0/255.0f blue:142.0/255.0f alpha:1];
    textField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:textField.placeholder attributes:@{NSForegroundColorAttributeName: color}];
}


@end
