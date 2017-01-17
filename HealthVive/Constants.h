//
//  Constants.h
//  HealthVive
//
//  Created by Adarsha on 10/01/17.
//  Copyright © 2017 NousInfosystems. All rights reserved.
//

#ifndef Constants_h
#define Constants_h


//Image names
#define userImage @"username"
#define passwordImage @"next-arrow"
#define infoIconImage @"info"
#define nextArrow @"next-arrow"



//Label texts
#define lblGetStartedText  @"Enter your email and password to get started!"

// TableviewCell Identifiers
#define questionTableCellIdentifier @"questionTableCellIdentifier"

//Button names
#define recoveryQuestion1 @"Select Question 1"
#define recoveryQuestion2 @"Select Question 2"
#define recoveryQuestion3 @"Select Question 3"

#define recoveryBtnEnableMinLength 1
#define recoveryAnswerMinLength 4
#define recoveryAnswerMaxLength 25

//Button Ids
#define question1Tag 1
#define question2Tag 2
#define question3Tag 3

//NavBarColor
#define NAVBAR_BCG_COLOR [UIColor colorWithRed:233/255.0 green:52/255.0 blue:52/255.0 alpha:1.0]


//Hexa Color Codes
#define buttonColorCode #e93434

//Web Api keys
#define httpResult @"Result"
#define httpError @"Error"
#define httpStatusCode @"SatusCode"

#define httpRecoveryQuestion @"Question"
#define httpIsActive @"IsActive"
#define httprecoveryQuestionId @"ID"

//Error Messages
#define invalidEmail @"Invalid email. Please enter a valid email address"
#define emptyLoginPassword @"Please Enter the valid password"
#define emptyLoginEmail @"Please Enter the valid email address"
#define invalidRegistrationPassword @"Invalid password.Please ensure that: -it has between 8 and 20 characters. Your password must include at least: 1 upper case, 1 lower case, 1 number and one special character"
#define alert @"ALERT"
#define ok @"OK"
#define statusStr @"Status"
#define successfullRegisterMsg @"User Registered successfully!"
#define recoveryAnswerErrorMessage @"Answers to security questions are between 4 and 25 characters long"
#define internalError @"Internal error please try after some time"


//Web URLS
//#define httpGetAllRecoveryQuestions @"http://NIBC1720/HealthViveService//api/account/GetAllRecoveryQuestions"

#define LoginAuthentication @"http://192.168.18.23/HealthViveService//Authenticate"
#define httpGetAllRecoveryQuestions @"http://192.168.18.23/HealthViveService/api/account/GetAllRecoveryQuestions"
#define httpRegisterConsumer @"http://192.168.18.23/HealthViveService/api/account/RegisterConsumer"


//Consumer Model keys
#define consumerIDKey @"ConsumerID"
#define emailIDKey @"EmailID"
#define passwordKey @"Password"
#define recoveryListKey @"RecoveryQuestionList"

//Recovery Question Model
#define questionIDKey @"QuestionID"
#define anserKey @"Answer"
#define questionKey @"Question"


#endif /* Constants_h */
