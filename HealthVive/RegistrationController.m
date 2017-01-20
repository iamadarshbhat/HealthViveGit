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
    UIView *blurredView;
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

- (void)viewDidLoad {
    [super viewDidLoad];
    
    consumer = [[Consumer alloc] init];
    
     [self getAllRecoveryQuestions];
    
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
    [self setImageAndTextInsetsToButton:btnSelectGrp andImage:[UIImage imageNamed:dropDown] withLeftSpace:0.];
    [self setLeftImageForTextField:txtemail withImage:[UIImage imageNamed:userImage]];
    [self setLeftImageForTextField:txtPassword withImage:[UIImage imageNamed:passwordImage]];
    viewInfo.hidden = true;
   tblGroupOptions.hidden = true;
    
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
    [self addPopupView:tblGroupOptions];
    CGFloat tableHeight =  groupTableHeight * groupOptionsArray.count;
   
    if(groupOptionsArray.count <= 5){
        [tblGroupOptions needsUpdateConstraints];
        [grpTableHeightConstraint setConstant:tableHeight];
        [tblGroupOptions layoutIfNeeded];
    }
    
    [tblGroupOptions reloadData];
}

- (IBAction)nextBtnAction:(id)sender {
    if([self validateForm] ){
        if(![self isValidPassword:txtPassword.text]){
            
            [self showAlertWithTitle:invalidPasswordAlert andMessage:invalidRegistrationPassword andActionTitle:ok actionHandler:nil];
            
            return;
        }
        [consumer setEmailId:txtemail.text];
        [consumer setPassword:txtPassword.text];
        
        
        RegistrationQuestionController *registerVC =[self.storyboard instantiateViewControllerWithIdentifier:@"RegistrationQuestionController"];
        registerVC.filteredQuestions = filteredQuestions;
        registerVC.questionsArray = questionsArray;
        registerVC.groupOptionsArray = groupOptionsArray;
        registerVC.consumerToRegister = consumer;
        [self.navigationController pushViewController:registerVC animated:NO];
    }
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
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    activeField = nil;
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return true;
}

//Validates the entire screen
-(Boolean)validateForm{
    
    if(txtemail.text.length == 0){
        
        [self showAlertWithTitle:invalidEmailIdAlert andMessage:emptyLoginEmail andActionTitle:ok actionHandler:^(UIAlertAction *action) {
            
            [self clearTextField];
            
        }];
        
        return false;
    }else if (txtPassword.text.length == 0){
        
        [self showAlertWithTitle:invalidPasswordAlert andMessage:emptyLoginPassword andActionTitle:ok actionHandler:^(UIAlertAction *action) {
            
            [self clearTextField];
            
        }];
        
        return false;
    }else if (![self IsValidEmail:txtemail.text]){
        
        [self showAlertWithTitle:invalidEmailIdAlert andMessage:invalidEmail andActionTitle:ok actionHandler:^(UIAlertAction *action) {
            
            [self clearTextField];
            
        }];
        
        return false;
    }
    
    return true;
}

//Password Validation
-(BOOL)isValidPassword:(NSString *)passwordString{
    
    NSString *passRegex =@"^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)(?=.*[$@$!%*?&])[A-Za-z\\d$@$!%*?&]{8,20}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", passRegex];
    return [emailTest evaluateWithObject:passwordString];
}
-(void)clearTextField
{   self.txtemail.text = nil;
    self.txtPassword.text = nil;
}


//Gets all the recovery Questions from API
-(void)getAllRecoveryQuestions{
    APIHandler *reqHandler =[[APIHandler alloc]init];
    questionsArray = [[NSMutableArray alloc] init];
    groupOptionsArray = [[NSMutableArray alloc] init];
    
    [reqHandler makeRequest:nil serverUrl:httpGetAllRecoveryQuestions completion:^(NSDictionary *result, NSError *error) {
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
        }
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
    [btnSelectGrp.titleLabel setText:[[groupOptionsArray objectAtIndex:indexPath.row] groupName]];
    [consumer setMemberGroupID:[[groupOptionsArray objectAtIndex:indexPath.row] groupId]];
    [self removePopupView:tblGroupOptions];
}
@end