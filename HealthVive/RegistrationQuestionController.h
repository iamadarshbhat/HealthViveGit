//
//  RegistrationQuestionController.h
//  HealthVive
//
//  Created by Adarsha on 10/01/17.
//  Copyright © 2017 NousInfosystems. All rights reserved.
//

#import <UIKit/UIKit.h>



@interface RegistrationQuestionController : BaseViewController
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

//Buttons
@property (weak, nonatomic) IBOutlet UIButton *btnQuestionOne;
@property (weak, nonatomic) IBOutlet UIButton *btnQuestionTwo;
@property (weak, nonatomic) IBOutlet UIButton *btnQuestionthree;
@property (weak, nonatomic) IBOutlet UIButton *btnRegister;

//Text Fields
@property (weak, nonatomic) IBOutlet UITextField *txtAnswerOne;
@property (weak, nonatomic) IBOutlet UITextField *txtAnswerTwo;
@property (weak, nonatomic) IBOutlet UITextField *txtAnswerThree;

//TableView
@property (weak, nonatomic) IBOutlet UITableView *questionsTableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *centerAlignedConstrant;

@property NSDictionary *answerResults;
@property NSString *emailStr;
@property NSString *passwordStr;


- (IBAction)questionOneBtnAction:(id)sender;
- (IBAction)questionTwoBtnAction:(id)sender;
- (IBAction)questionThreeBtnAction:(id)sender;

- (IBAction)registerAction:(id)sender;




@end
