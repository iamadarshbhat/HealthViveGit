//
//  RegistrationQuestionController.m
//  HealthVive
//
//  Created by Adarsha on 10/01/17.
//  Copyright © 2017 NousInfosystems. All rights reserved.
//

#import "RegistrationQuestionController.h"
#import "RecoveryQuestionModel.h"
#import "Consumer.h"

@interface RegistrationQuestionController (){
    UITextField *activeField;
    UIButton *activieButton;
    NSMutableArray *questionsArray;
    NSMutableArray *filteredQuestions;
    RecoveryQuestionModel *selectedRecoveryModel;
    
    RecoveryQuestionModel *selectedRecoVeryOne;
    RecoveryQuestionModel *selectedRecoveryTwo;
    RecoveryQuestionModel *selectedRecoveryThree;
    
    UIView *blurredView;

}

@end

@implementation RegistrationQuestionController
@synthesize btnQuestionOne;
@synthesize btnQuestionTwo;
@synthesize btnQuestionthree;
@synthesize scrollView;
@synthesize contentView;
@synthesize questionsTableView;
@synthesize centerAlignedConstrant;
@synthesize btnRegister;
@synthesize txtAnswerOne;
@synthesize txtAnswerTwo;
@synthesize txtAnswerThree;
@synthesize emailStr;
@synthesize passwordStr;




- (void)viewDidLoad {
    [super viewDidLoad];
   
    [self getAllRecoveryQuestions];
    
    [super setScrollView:scrollView andTextField:activeField];
    [super setTableView:questionsTableView andTableViewCell:nil withIdentifier:questionTableCellIdentifier andData:questionsArray];
   
    
    
    UIImage *image = [UIImage imageNamed:nextArrow];
    btnQuestionOne.imageEdgeInsets = UIEdgeInsetsMake(0., self.btnRegister.frame.size.width - (image.size.width)-30, 0., 0.);
    btnQuestionOne.titleEdgeInsets = UIEdgeInsetsMake(0.,-20., 0., 30.);
   
    btnQuestionTwo.imageEdgeInsets = UIEdgeInsetsMake(0., self.btnRegister.frame.size.width - (image.size.width)-30, 0., 0.);
    btnQuestionTwo.titleEdgeInsets = UIEdgeInsetsMake(0.,-20., 0., 30.);
    
    btnQuestionthree.imageEdgeInsets = UIEdgeInsetsMake(0., self.btnRegister.frame.size.width - (image.size.width)-30, 0., 0.);
    btnQuestionthree.titleEdgeInsets = UIEdgeInsetsMake(0., -20., 0., 30.);
    
    
    
    [btnQuestionOne setTag:question1Tag];
    [btnQuestionTwo setTag:question2Tag];
    [btnQuestionthree setTag:question3Tag];
    
    [btnRegister setEnabled:false];
    
    [btnQuestionOne.titleLabel setNumberOfLines:3];
    [btnQuestionTwo.titleLabel setNumberOfLines:3];
    [btnQuestionthree.titleLabel setNumberOfLines:3];

    
    txtAnswerOne.enabled = NO;
    txtAnswerTwo.enabled = NO;
    txtAnswerThree.enabled = NO;
    
    [self applyColorToButton:btnRegister];
    [self applyCornerToView:btnRegister];
    
    [self applyColorToPlaceHolderText:txtAnswerOne];
    [self applyColorToPlaceHolderText:txtAnswerTwo];
    [self applyColorToPlaceHolderText:txtAnswerThree];
    
    [self applyCornerToView:questionsTableView];
    [self applyCornerColorToView:questionsTableView withColor:[UIColor grayColor]];
   }

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
   
    // Dispose of any resources that can be recreated.
}

#pragma mark Table View Delegate methods
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell;
    if(cell == nil){
        cell = [tableView dequeueReusableCellWithIdentifier:questionTableCellIdentifier];
        cell.textLabel.numberOfLines = 2;
    }
    RecoveryQuestionModel *recoverymodel = [filteredQuestions objectAtIndex:indexPath.row];
    cell.textLabel.text = recoverymodel.question;
    return  cell;
}

-(void)updateTableConstraints : (CGFloat) constant{
    [questionsTableView setNeedsUpdateConstraints];
    [UIView animateWithDuration:1.5 animations:^{
        centerAlignedConstrant.constant = constant;
        [questionsTableView layoutIfNeeded];
        
    }];}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [self.view sendSubviewToBack:questionsTableView];
    [blurredView removeFromSuperview];
    
    [self startfadOut:questionsTableView];
    [questionsTableView setHidden:YES];
    RecoveryQuestionModel *recoverymodel = [filteredQuestions objectAtIndex:indexPath.row];
    [activieButton setTitle:recoverymodel.question forState:UIControlStateNormal];
    selectedRecoveryModel = recoverymodel;
    
    if(activieButton == btnQuestionOne){
        selectedRecoVeryOne = recoverymodel;
    }else if (activieButton == btnQuestionTwo){
        selectedRecoveryTwo = recoverymodel;
    }else if (activieButton == btnQuestionthree){
        selectedRecoveryThree = recoverymodel;
    }
    
    [self getFilteredQuestion:activieButton:indexPath];
    
    if(activieButton == btnQuestionOne && ![activieButton.titleLabel.text isEqualToString:recoveryQuestion1]){
        [txtAnswerOne becomeFirstResponder];
    }else if (activieButton == btnQuestionTwo && ![activieButton.titleLabel.text isEqualToString:recoveryQuestion2]){
        [txtAnswerTwo becomeFirstResponder];
    }else if (activieButton == btnQuestionthree && ![activieButton.titleLabel.text isEqualToString:recoveryQuestion3]){
        [txtAnswerThree becomeFirstResponder];
    }
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return filteredQuestions.count;
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

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
     NSUInteger newLength = [[self getTrimmedStringForString:textField.text] length] + [[self getTrimmedStringForString:string] length] - range.length;
    NSString *answerOne = [self getTrimmedStringForString:txtAnswerOne.text];
    NSString *answerTwo = [self getTrimmedStringForString:txtAnswerTwo.text];
    NSString *answerThree = [self getTrimmedStringForString:txtAnswerThree.text];
    
    
    if(textField == txtAnswerOne){
       
        if(newLength >= recoveryBtnEnableMinLength  && answerTwo.length >=recoveryBtnEnableMinLength && answerThree.length >=recoveryBtnEnableMinLength ){
            [self setButtonEnabled:YES forButton:btnRegister];
        }else{
            [self setButtonEnabled:NO forButton:btnRegister];
        }
    }else if (textField == txtAnswerTwo){
        if(newLength >= recoveryBtnEnableMinLength && answerOne.length >=recoveryBtnEnableMinLength && answerThree.length >=recoveryBtnEnableMinLength){
            [self setButtonEnabled:YES forButton:btnRegister];
        }else{
            [self setButtonEnabled:NO forButton:btnRegister];
        }
    }else if (textField == txtAnswerThree){
        if(newLength >= recoveryBtnEnableMinLength && answerOne.length >=recoveryBtnEnableMinLength && answerTwo.length >=recoveryBtnEnableMinLength){
            [self setButtonEnabled:YES forButton:btnRegister];
        }else{
            [self setButtonEnabled:NO forButton:btnRegister];
        }
    }
    
    if(range.length + range.location > textField.text.length)
    {
        return NO;
    }
    return newLength <= recoveryAnswerMaxLength;
}


#pragma mark Button Actions
- (IBAction)questionOneBtnAction:(id)sender {
    
   //***********
    txtAnswerOne.enabled = YES;
    activieButton = sender;
    [self getFilteredQuestion:activieButton:nil];
    [questionsTableView setHidden:NO];
    [self startFade:questionsTableView];
    [activeField resignFirstResponder];
    
    blurredView = [[UIView alloc] initWithFrame:self.view.frame];
    [blurredView setBackgroundColor:[UIColor colorWithWhite:0.0 alpha:0.50]];
    [self.view addSubview:blurredView];
    [self.view bringSubviewToFront:questionsTableView];

   
}

- (IBAction)questionTwoBtnAction:(id)sender {
    
     txtAnswerTwo.enabled = YES;
     activieButton = sender;
    [self getFilteredQuestion:activieButton:nil];
     [questionsTableView setHidden:NO];
     [self startFade:questionsTableView];
     [activeField resignFirstResponder];
    blurredView = [[UIView alloc] initWithFrame:self.view.frame];
    [blurredView setBackgroundColor:[UIColor colorWithWhite:0.0 alpha:0.50]];
    [self.view addSubview:blurredView];
    [self.view bringSubviewToFront:questionsTableView];
}

- (IBAction)questionThreeBtnAction:(id)sender {
   
     txtAnswerThree.enabled = YES;
     activieButton = sender;
    [self getFilteredQuestion:activieButton:nil];
     [questionsTableView setHidden:NO];
     [self startFade:questionsTableView];
     [activeField resignFirstResponder];
     blurredView = [[UIView alloc] initWithFrame:self.view.frame];
     [blurredView setBackgroundColor:[UIColor colorWithWhite:0.0 alpha:0.50]];
     [self.view addSubview:blurredView];
     [self.view bringSubviewToFront:questionsTableView];
}


//Filters the questions on selection
-(NSMutableArray*)getFilteredQuestion:(UIButton *) btn : (NSIndexPath *)index{
    
    if(btn.tag == 1){
        filteredQuestions = [[NSMutableArray alloc] initWithArray:questionsArray];
        if([btnQuestionTwo.titleLabel.text isEqualToString:recoveryQuestion2] || [btnQuestionthree.titleLabel.text isEqualToString:recoveryQuestion3]){
            [filteredQuestions removeObject:selectedRecoveryModel];
        }else{
            [filteredQuestions removeObject:selectedRecoveryTwo];
            [filteredQuestions removeObject:selectedRecoveryThree];
        }
       
        
    }else if (btn.tag == 2){
         filteredQuestions = [[NSMutableArray alloc] initWithArray:questionsArray];
        if((![btnQuestionTwo.titleLabel.text isEqualToString:recoveryQuestion2]) && ([btnQuestionOne.titleLabel.text isEqualToString:recoveryQuestion1] || [btnQuestionthree.titleLabel.text isEqualToString:recoveryQuestion3])){
            [filteredQuestions removeObject:selectedRecoveryModel];
        }else{
           [filteredQuestions removeObject:selectedRecoveryThree];
           [filteredQuestions removeObject:selectedRecoVeryOne];
        }
    }else if (btn.tag == 3){
        filteredQuestions = [[NSMutableArray alloc] initWithArray:questionsArray];
       if((![btnQuestionthree.titleLabel.text isEqualToString:recoveryQuestion3]) &&([btnQuestionthree.titleLabel.text isEqualToString:recoveryQuestion3] || [btnQuestionOne.titleLabel.text isEqualToString:recoveryQuestion1])){
            [filteredQuestions removeObject:selectedRecoveryModel];
       }else{
           [filteredQuestions removeObject:selectedRecoVeryOne];
           [filteredQuestions removeObject:selectedRecoveryTwo];
        }
    }
    [questionsTableView reloadData];
    return filteredQuestions;
}

// Onclick of Register Button
- (IBAction)registerAction:(id)sender {
    
    if ([self validateForm]) {
        [self registerConsumer];
    }
}




//Gets all the recovery Questions from API
-(void)getAllRecoveryQuestions{
    APIHandler *reqHandler =[[APIHandler alloc]init];
    questionsArray = [[NSMutableArray alloc] init];
    
    [reqHandler makeRequest:nil serverUrl:httpGetAllRecoveryQuestions completion:^(NSDictionary *result, NSError *error) {
        if (error == nil) {
            
            NSArray *resultArray = [result objectForKey:httpResult];
            for (NSDictionary *dict in resultArray) {
                RecoveryQuestionModel *recoveryModel = [[RecoveryQuestionModel alloc] init];
                [recoveryModel setQuestion:[dict objectForKey:httpRecoveryQuestion]];
                [recoveryModel setQuestionId:[[dict objectForKey:httprecoveryQuestionId] integerValue]];
                [questionsArray addObject:recoveryModel];
                
            }
            filteredQuestions = [[NSMutableArray alloc] initWithArray:questionsArray];
            NSLog(@"result-%@",filteredQuestions);
        }
        
    }];

}

//Validates the answer screen
-(BOOL)validateForm{
    NSString *answerOne = [self getTrimmedStringForString:txtAnswerOne.text];
    NSString *answerTwo = [self getTrimmedStringForString:txtAnswerTwo.text];
    NSString *answerThree = [self getTrimmedStringForString:txtAnswerThree.text];
    if(answerOne.length < recoveryAnswerMinLength){
        [self showAlertWithTitle:alert andMessage:recoveryAnswerErrorMessage andActionTitle:ok actionHandler:nil];
        [txtAnswerOne becomeFirstResponder];
        return false;
    }else if (answerTwo.length < recoveryAnswerMinLength){
        [self showAlertWithTitle:alert andMessage:recoveryAnswerErrorMessage andActionTitle:ok actionHandler:nil];
        [txtAnswerTwo becomeFirstResponder];
        return false;
    }else if (answerThree.length < recoveryAnswerMinLength){
        [self showAlertWithTitle:alert andMessage:recoveryAnswerErrorMessage andActionTitle:ok actionHandler:nil];
        [txtAnswerThree becomeFirstResponder];
        return false;
    }else{
        return true;
    }
    return true;
}

//Calls web API to post all data
-(void)registerConsumer{
    Consumer *consumer = [[Consumer alloc] init];
    consumer.emailId = emailStr;
    consumer.password = passwordStr;
    [selectedRecoVeryOne setAnswer:txtAnswerOne.text];
    [selectedRecoveryTwo setAnswer:txtAnswerTwo.text];
    [selectedRecoveryThree setAnswer:txtAnswerThree.text];
    
    
    
    
    NSMutableArray *questionAnserList =  [[NSMutableArray alloc] initWithObjects:[selectedRecoVeryOne getRecoveryQuestionModel:selectedRecoVeryOne],[selectedRecoveryTwo getRecoveryQuestionModel:selectedRecoveryTwo],[selectedRecoveryThree getRecoveryQuestionModel:selectedRecoveryThree], nil];
    consumer.recoveryQuestionsList = questionAnserList;
    
    
    //Prepare JSON
    
    
    NSError *writeError = nil;
    
    NSDictionary * dict = [consumer consumerDic:consumer];
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:&writeError];
    NSLog(@"%@",writeError);
    
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    NSLog(@"%@",jsonString);
    
    
    
    //NSString *paramString =[NSString stringWithFormat:@"username=%@&password=%@&grant_type=%@",self.emailTxtField.text,self.passwordTxtField.text,@"password"];
    APIHandler *reqHandler =[[APIHandler alloc] init];
    
    [reqHandler makeRequestByPost:jsonString  serverUrl:httpRegisterConsumer completion:^(NSDictionary *result, NSError *error) {
        
        if ( error == nil) {
            NSLog(@"result -%@",result);
         
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [self showAlertWithTitle:statusStr andMessage:successfullRegisterMsg andActionTitle:ok actionHandler:nil];
                
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
                    [self showAlertWithTitle:statusStr andMessage:errorDescription andActionTitle:ok actionHandler:nil];
                    
                });
                
            });
            
            
        }
        
    }];  
}

@end
