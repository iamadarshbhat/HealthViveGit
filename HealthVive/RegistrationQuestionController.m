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

#import "RegistrationEssentialController.h"

@interface RegistrationQuestionController (){
    UITextField *activeField;
    UIButton *activieButton;
    
    RecoveryQuestionModel *selectedRecoveryModel;
    RecoveryQuestionModel *selectedRecoVeryOne;
    RecoveryQuestionModel *selectedRecoveryTwo;
    RecoveryQuestionModel *selectedRecoveryThree;
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
@synthesize questionsArray;
@synthesize filteredQuestions;
@synthesize groupOptionsArray;
@synthesize consumerToRegister;




- (void)viewDidLoad {
    [super viewDidLoad];
   
    UITapGestureRecognizer *singleFingerTap =
    [[UITapGestureRecognizer alloc] initWithTarget:self
                                            action:@selector(handleSingleTap:)];
    [self.blurredView addGestureRecognizer:singleFingerTap];
    
    [super setScrollView:scrollView andTextField:activeField];
    [super setTableView:questionsTableView andTableViewCell:nil withIdentifier:questionTableCellIdentifier andData:questionsArray];
   
    
    
    UIImage *image = [UIImage imageNamed:nextArrow];
    [self setImageAndTextInsetsToButton:btnQuestionOne andImage:image withLeftSpace:-30];
    [self setImageAndTextInsetsToButton:btnQuestionTwo andImage:image withLeftSpace:-30];
    [self setImageAndTextInsetsToButton:btnQuestionthree andImage:image withLeftSpace:-30];

    
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
    [self removePopupView:questionsTableView];
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
    
    if([self checkInternetConnection]){
        txtAnswerOne.enabled = YES;
        activieButton = sender;
        [self getFilteredQuestion:activieButton:nil];
        [questionsTableView setHidden:NO];
        [activeField resignFirstResponder];
        [self addPopupView:questionsTableView];
    }
}

- (IBAction)questionTwoBtnAction:(id)sender {
    
     if([self checkInternetConnection]){
     txtAnswerTwo.enabled = YES;
     activieButton = sender;
    [self getFilteredQuestion:activieButton:nil];
     [questionsTableView setHidden:NO];
     [activeField resignFirstResponder];
    [self addPopupView:questionsTableView];
     }
}

- (IBAction)questionThreeBtnAction:(id)sender {
   
     if([self checkInternetConnection]){
     txtAnswerThree.enabled = YES;
     activieButton = sender;
    [self getFilteredQuestion:activieButton:nil];
     [questionsTableView setHidden:NO];
     [activeField resignFirstResponder];
    [self addPopupView:questionsTableView];
     }
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
       RegistrationEssentialController *registerVC =[self.storyboard instantiateViewControllerWithIdentifier:RegistrationEssentialControllerId];
       registerVC.consumerToRegister = consumerToRegister;
       
       [self.navigationController pushViewController:registerVC animated:NO];
    }
    
    
    
}

- (IBAction)backButtonAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

//Validates the answer screen
-(BOOL)validateForm{
    NSString *answerOne = [self getTrimmedStringForString:txtAnswerOne.text];
    NSString *answerTwo = [self getTrimmedStringForString:txtAnswerTwo.text];
    NSString *answerThree = [self getTrimmedStringForString:txtAnswerThree.text];
    if(answerOne.length < recoveryAnswerMinLength){
        [self showAlertWithTitle:errorAlert andMessage:recoveryAnswerErrorMessage andActionTitle:ok actionHandler:nil];
        [txtAnswerOne becomeFirstResponder];
        return false;
    }else if (answerTwo.length < recoveryAnswerMinLength){
        [self showAlertWithTitle:errorAlert andMessage:recoveryAnswerErrorMessage andActionTitle:ok actionHandler:nil];
        [txtAnswerTwo becomeFirstResponder];
        return false;
    }else if (answerThree.length < recoveryAnswerMinLength){
        [self showAlertWithTitle:errorAlert andMessage:recoveryAnswerErrorMessage andActionTitle:ok actionHandler:nil];
        [txtAnswerThree becomeFirstResponder];
        return false;
    }else{
        return true;
    }
    return true;
}

//Calls web API to post all data
-(void)registerConsumer{
   
    [selectedRecoVeryOne setAnswer:txtAnswerOne.text];
    [selectedRecoveryTwo setAnswer:txtAnswerTwo.text];
    [selectedRecoveryThree setAnswer:txtAnswerThree.text];
    NSMutableArray *questionAnserList =  [[NSMutableArray alloc] initWithObjects:[selectedRecoVeryOne getRecoveryQuestionModel:selectedRecoVeryOne],[selectedRecoveryTwo getRecoveryQuestionModel:selectedRecoveryTwo],[selectedRecoveryThree getRecoveryQuestionModel:selectedRecoveryThree], nil];
    consumerToRegister.recoveryQuestionsList = questionAnserList;
   }

//The event handling method for Scrreen touch
- (void)handleSingleTap:(UITapGestureRecognizer *)recognizer {
    [self removePopupView:questionsTableView];
}

@end
