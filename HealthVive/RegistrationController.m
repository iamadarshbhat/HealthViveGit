//
//  RegistrationController.m
//  HealthVive
//
//  Created by Adarsha on 17/01/17.
//  Copyright © 2017 NousInfosystems. All rights reserved.
//

#import "RegistrationController.h"
#import "RegistrationQuestionController.h"
#import "RecoveryQuestionModel.h"
#import "MemberGroupModel.h"
#import "Consumer.h"

@interface RegistrationController (){
    UITextField *activeField;
    NSMutableArray *questionsArray;
    NSMutableArray *groupOptionsArray;
    NSMutableArray *filteredQuestions;
    Consumer *consumer;

}

@end

@implementation RegistrationController
@synthesize scrollView;
@synthesize txtemail;
@synthesize txtPassword;
@synthesize btnNext;
@synthesize btnSelectGrp;
@synthesize lblPasswordInfo;
@synthesize viewInfo;
@synthesize tblGroupOptions;
@synthesize grpTableHeightConstraint;
@synthesize btnShowPassword;
@synthesize btninfoOK;
@synthesize btnPassInfo;
- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    UITapGestureRecognizer *singleFingerTap =
    [[UITapGestureRecognizer alloc] initWithTarget:self
                                            action:@selector(handleSingleTap:)];
    [self.blurredView addGestureRecognizer:singleFingerTap];
    
    
    consumer = [[Consumer alloc] init];
    
    if([self checkInternetConnection]){
        [self getAllRecoveryQuestions];
    }else{
         [self showAlertWithTitle:httpNoInternetAlert andMessage:httpConnectionProblemMsg andActionTitle:ok actionHandler:nil];
    }
    
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new]
                                                  forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    self.navigationController.navigationBar.translucent = YES;
    self.navigationController.view.backgroundColor = [UIColor clearColor];
    self.navigationController.navigationBar.backgroundColor = [UIColor clearColor];
     lblPasswordInfo.text = passwordInfo;
     [super setScrollView:scrollView andTextField:activeField];
     [self applyColorToPlaceHolderText:txtemail];
     [self applyColorToPlaceHolderText:txtPassword];
    [self applyCornerToView:btnNext];
  //  [self setImageAndTextInsetsToButton:btnSelectGrp andImage:[UIImage imageNamed:dropDown] withLeftSpace:-40.0];
    
    [self fixButtonImages];
    [self setLeftImageForTextField:txtemail withImage:[UIImage imageNamed:userImage]];
    [self setLeftImageForTextField:txtPassword withImage:[UIImage imageNamed:passwordImage]];
    viewInfo.hidden = true;
   tblGroupOptions.hidden = true;
    [self setButtonEnabled:NO forButton:btnNext];
    [btnShowPassword setTitle:btnShowPasswordString forState:UIControlStateNormal];
    [btnShowPassword setHidden:YES];
    
    // Do any additional setup after loading the view.
    
   
}



-(void)viewWillAppear:(BOOL)animated{
    //[tblGroupOptions setHidden:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (IBAction)selectGrpAction:(id)sender {
    
    //tblGroupOptions.hidden = false;
    
    if([self checkInternetConnection] && groupOptionsArray.count >0){
        [self addPopupView:tblGroupOptions];
        CGFloat tableHeight =  groupTableHeight * groupOptionsArray.count;
        
        if(groupOptionsArray.count <= 5){
            [tblGroupOptions needsUpdateConstraints];
            [grpTableHeightConstraint setConstant:tableHeight];
            [tblGroupOptions layoutIfNeeded];
        }
        
        [tblGroupOptions reloadData];
    }else{
         [self showAlertWithTitle:httpNoInternetAlert andMessage:httpConnectionProblemMsg andActionTitle:ok actionHandler:nil];
    }
   
}

- (IBAction)nextBtnAction:(id)sender {
    
    
    
    if([self validateForm] ){
       
        if(![self isValidPassword:txtPassword.text]){
            
            [btnShowPassword setHidden:YES];
            [btnPassInfo setHidden:NO];
            
            [self showAlertWithTitle:errorAlert andMessage:invalidRegistrationPassword andActionTitle:ok actionHandler:^(UIAlertAction *action) {
                
                [self clearPasswordtextField];
                
            }];
            [txtPassword becomeFirstResponder];
            
            return;
        }
        [self callApiTocheckEmail];
            
    }
}

-(void)callApiTocheckEmail{
    
  
    NSError *writeError = nil;
    
    NSDictionary * dict = [NSDictionary dictionaryWithObject:txtemail.text forKey:@"EmailID"];
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:&writeError];
    
    
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    NSLog(@"JSON String :%@",jsonString);
    
    APIHandler *reqHandler =[[APIHandler alloc] init];
    
    [self showProgressHudWithText:@"Validating Email..."];
    NSString *url =  [NSString stringWithFormat:@"%@%@",BaseURL,httpValidateConsumerEmailID];
    [reqHandler makeRequestByPost:jsonString  serverUrl:url completion:^(NSDictionary *result, NSError *error) {
        
        if ( error == nil) {
            NSLog(@"result -%@",result);
           
           

            dispatch_async(dispatch_get_main_queue(), ^{
                
                [self hideProgressHud];
                 [self pushToNextScreen];
                
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
        }
    }];
  
}

-(void)pushToNextScreen{
    [consumer setEmailId:txtemail.text];
    [consumer setPassword:txtPassword.text];
    
    
    RegistrationQuestionController *registerVC =[self.storyboard instantiateViewControllerWithIdentifier:@"RegistrationQuestionController"];
    registerVC.filteredQuestions = filteredQuestions;
    registerVC.questionsArray = questionsArray;
    registerVC.groupOptionsArray = groupOptionsArray;
    registerVC.consumerToRegister = consumer;
    [self.navigationController pushViewController:registerVC animated:NO];
}

-(void)infoOkAction:(id)sender{
    [self removePopupView:viewInfo];
}

- (IBAction)infoBtnAction:(id)sender {
    [self addPopupView:viewInfo];
}

- (IBAction)iHaveAccountAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark Text Field Delegate methods
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    activeField = textField;
    if(textField == txtPassword && [txtPassword.text  isEqual: @""]){
        [btnPassInfo setHidden:NO];
        [btnShowPassword setHidden:YES];
    }
    
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    activeField = nil;
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    return true;
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
   
    
    [txtPassword setSecureTextEntry:YES];
    NSUInteger newLength = [[self getTrimmedStringForString:textField.text] length] + [[self getTrimmedStringForString:string] length] - range.length;
    
    
    if(textField == txtemail){
        if(newLength == 0 || txtPassword.text.length == 0){
            [self setButtonEnabled:NO forButton:btnNext];
        }else{
            [self setButtonEnabled:YES forButton:btnNext];
        }
    }else if (textField == txtPassword){
        if(newLength == 0){
            [btnShowPassword setHidden:YES];
            [btnPassInfo setHidden:NO];
        }else{
            [btnPassInfo setHidden:YES];
            [btnShowPassword setHidden:NO];
            [btnShowPassword setTitle:btnShowPasswordString forState:UIControlStateNormal];
        }
        
        if(newLength == 0 || txtemail.text.length == 0){
            [self setButtonEnabled:NO forButton:btnNext];
        }
        else{
            [self setButtonEnabled:YES forButton:btnNext];
        }
        
    }
    
    if(range.length + range.location > textField.text.length)
    {
        return NO;
    }
    return YES;

}

//Validates the entire screen
-(Boolean)validateForm{
    
    if(![self isValidPassword:txtPassword.text] && ![self IsValidEmail:txtemail.text]){
      
       
        [self showAlertWithTitle:errorAlert andMessage:invalidEmail andActionTitle:ok actionHandler:^(UIAlertAction *action) {
            
             [self clearAllTextfields];
            
        }];
         [txtemail becomeFirstResponder];
    }
    
    if(txtemail.text.length == 0){
        
        
        [self showAlertWithTitle:invalidEmailIdAlert andMessage:emptyLoginEmail andActionTitle:ok actionHandler:^(UIAlertAction *action) {
            
            [self clearEmailTextField];
            
        }];
        
        return false;
    }else if (txtPassword.text.length == 0){
        
        [self showAlertWithTitle:invalidPasswordAlert andMessage:emptyLoginPassword andActionTitle:ok actionHandler:^(UIAlertAction *action) {
            [self clearPasswordtextField];
        }];
        
        return false;
    }else if (![self IsValidEmail:txtemail.text]){
        
       [txtemail becomeFirstResponder];
        [self showAlertWithTitle:errorAlert andMessage:invalidEmail andActionTitle:ok actionHandler:^(UIAlertAction *action) {
            
            [self clearEmailTextField];
            
        }];
        
        return false;
    }
    
    return true;
}

//Password Validation
-(BOOL)isValidPassword:(NSString *)passwordString{
    
    NSString *passRegex =@"^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)(?=.*[$@$#!%*?&])[A-Za-z\\d$@$!#%*?&]{8,20}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", passRegex];
    return [emailTest evaluateWithObject:passwordString];
}
-(void)clearEmailTextField
{   self.txtemail.text = nil;
    [self setButtonEnabled:NO forButton:btnNext];
    //[txtemail becomeFirstResponder];
    
}
-(void)clearPasswordtextField{
    self.txtPassword.text = nil;
    [self setButtonEnabled:NO forButton:btnNext];
    //[txtPassword becomeFirstResponder];
}

-(void)clearAllTextfields{
    [self setButtonEnabled:NO forButton:btnNext];
    self.txtemail.text = nil;
    self.txtPassword.text = nil;
    
}

//Gets all the recovery Questions from API
-(void)getAllRecoveryQuestions{
    APIHandler *reqHandler =[[APIHandler alloc]init];
    questionsArray = [[NSMutableArray alloc] init];
    groupOptionsArray = [[NSMutableArray alloc] init];
    
    NSString *url = [NSString stringWithFormat:@"%@%@",BaseURL,httpGetAllRecoveryQuestions];
    [reqHandler makeRequest:nil serverUrl:url completion:^(NSDictionary *result, NSError *error) {
        if (error == nil) {
            
            NSDictionary *resultdict = [result objectForKey:httpResult];
            NSLog(@"Results -- %@",resultdict);
            
            
            NSArray *groupOptionsArr = [resultdict objectForKey:httpResultMemberGroupList];
            NSArray *questionsArr = [resultdict objectForKey:httpResultRecoveryQuestionList];
            
            
            for (NSDictionary *dict in questionsArr) {
                RecoveryQuestionModel *recoveryModel = [[RecoveryQuestionModel alloc] init];
                [recoveryModel setQuestion:[dict objectForKey:httpRecoveryQuestion]];
                [recoveryModel setQuestionId:[[dict objectForKey:httprecoveryQuestionId] integerValue]];
                [questionsArray addObject:recoveryModel];
            }
            
            for (NSDictionary *dict in groupOptionsArr) {
                MemberGroupModel *groupModel = [[MemberGroupModel alloc] init];
                [groupModel setGroupId:[[dict objectForKey:httpGroupIdkey] integerValue]];
                [groupModel setGroupName:[dict objectForKey:httpGroupNameKey]];
                [groupOptionsArray addObject:groupModel];
                
            }
            filteredQuestions = [[NSMutableArray alloc] initWithArray:questionsArray];
        }else{
            
        }
        
        NSLog(@"Error Description :%@",error.localizedDescription);
    }];
}

#pragma mark Table View Delegate methods
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:groupOptionTableCellIdentifier];
    MemberGroupModel *grpModel = [groupOptionsArray objectAtIndex:indexPath.row];
    cell.textLabel.text = grpModel.groupName;
   return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [groupOptionsArray count];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
      [btnSelectGrp setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btnSelectGrp.titleLabel setText:[[groupOptionsArray objectAtIndex:indexPath.row] groupName]];
    [consumer setMemberGroupID:[[groupOptionsArray objectAtIndex:indexPath.row] groupId]];
    [self removePopupView:tblGroupOptions];
}
- (IBAction)showPasswordAction:(id)sender {
      txtPassword.text = txtPassword.text;
    if (txtPassword.isFirstResponder) {
        [txtPassword resignFirstResponder];
        //[txtPassword becomeFirstResponder];
    }
    if([btnShowPassword.titleLabel.text isEqualToString:btnHidePasswordString]){
        [txtPassword setSecureTextEntry:YES];
        [btnShowPassword setTitle:btnShowPasswordString forState:UIControlStateNormal];
    }else{
        [txtPassword setSecureTextEntry:NO];
        [btnShowPassword setTitle:btnHidePasswordString forState:UIControlStateNormal];
    }
}

//The event handling method for Scrreen touch
- (void)handleSingleTap:(UITapGestureRecognizer *)recognizer {
    [self removePopupView:tblGroupOptions];
}

-(void)fixButtonImages{
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenHeight = screenRect.size.height;
    CGFloat screenWidth = screenRect.size.width;
    NSLog(@"screen widht %f an hedight %f",screenWidth,screenHeight);
    
    btnSelectGrp.imageEdgeInsets=UIEdgeInsetsMake(0, screenWidth-75, 0, 0);
    btnSelectGrp.titleEdgeInsets = UIEdgeInsetsMake(0, -18, 0, 0);
   
}
@end
