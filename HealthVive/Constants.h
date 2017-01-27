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
#define passwordImage @"password"
#define infoIconImage @"info"
#define nextArrow @"next-arrow"
#define dropDown @"dropdown"
#define datePickerImage @"datePicker"

//RegistrationController
#define selectGroupOptional @"Select group (optional)"
#define maximumYear 16


//Label texts
#define lblGetStartedText  @"Enter your email and password to get started!"

// TableviewCell Identifiers
#define questionTableCellIdentifier @"questionTableCellIdentifier"
#define groupOptionTableCellIdentifier @"groupOptionTableIdentier"
#define titleTableIdentifer @"titleTableIdentifer"

//Table Row Heights
#define groupTableHeight 60

//Button names
#define recoveryQuestion1 @"Select Question 1"
#define recoveryQuestion2 @"Select Question 2"
#define recoveryQuestion3 @"Select Question 3"

//Place holder Texts
#define buttonTitleStr @"Title"
#define buttonSelectDateStr @"Select Date (Minimum age 16 years)"
#define btnShowPasswordString @"Show"
#define btnHidePasswordString @"Hide"
#define foreNamePlaceHolderText @"Forename"
#define surNamePlaceHolderText @"Surname"

#define recoveryBtnEnableMinLength 1
#define recoveryAnswerMinLength 4
#define recoveryAnswerMaxLength 50

#define forNameMininmumLength 2
#define sirNameMininmumLength 2
#define foreNameMaximumLength 25
#define surNameMaximumLength 30



//Button Ids
#define question1Tag 1
#define question2Tag 2
#define question3Tag 3

//StoryBoard IDs
#define RegistrationEssentialControllerId @"RegistrationEssentialController"
#define ConsumerProfileViewControllerId @"ConsumerProfileViewControllerID"
#define medicalContactControllerID @"MedicalContactControllerID"
#define medicalContactDetailsControllerID @"medicalContactDetailsControllerID"

//NavBarColor
#define NAVBAR_BCG_COLOR [UIColor colorWithRed:233/255.0 green:52/255.0 blue:52/255.0 alpha:1.0]

//NavBarTitles
#define forgotPassNavigationBarTitle @"Forgot Password"
#define medicalContactNavigationBarTitle @"Medical Contacts"
#define contactDetailsNavigatinBarTitle @"Contact Details"

//Hexa Color Codes
#define buttonColorCode #e93434

//Web Api keys
#define remoteHostName @"www.apple.com"
#define httpResult @"Result"
#define httpError @"Error"
#define httpStatusCode @"SatusCode"
#define httpNoInternetAlert @"Connection Lost"
#define httpConnectionProblemMsg @"Your request cannot be completed because you are not connected to the Internet.Verify your data connection and try again."

#define httpRecoveryQuestion @"Question"
#define httpIsActive @"IsActive"
#define httprecoveryQuestionId @"ID"
#define httpGroupIdkey @"ID"
#define httpGroupNameKey @"GroupName"

#define httpResultMemberGroupList @"MemberGroupList"
#define httpResultRecoveryQuestionList @"RecoveryQuestionList"

//Error Messages
#define invalidEmailMsg @"Invalid email ID and/or password."
#define invalidEmail @"Invalid email! Please enter a valid email address."
#define emptyLoginPassword @"Please Enter the valid password"
#define emptyLoginEmail @"Please Enter the valid email address"
#define invalidRegistrationPassword @"Invalid Password! Please ensure that: It has between 8 and 20 characters. Your password must include at least: 1 upper case, 1 lower case, 1 number and one special character."
#define foreNameInlineError @"Forename should be between 2 and 25 characters long."
#define surNameInlineError @"Surname should be between 2 and 30 characters long."
//#define alert @"ALERT"
#define errorAlert @"Error"
#define invalidPasswordAlert @"Invalid Passwrod!"
#define invalidEmailIdAlert @"Invalid Email Id!"
#define forgotPassEmailAlert @"Invalid Email ID"
#define thanks @"Thanks!"

#define ok @"OK"
#define statusStr @"Status"
#define successfullRegisterMsg @"Thank you for submitting your HealthVive account registration and basic profile for approval. Once approved, we will send you an activation email, which may take up to 24 hours to arrive. Please note that you will need to provide more information to use additional features, premium services, or to enable health professionals to advise and assist you."

#define recoveryAnswerErrorMessage @"Answers to security questions are between 4 and 50 characters long"
#define internalError @"Internal error please try after some time"

#define passwordInfo @"Please ensure that your password should be between 8 and 20 characters.\nIt must include at least : \n1 upper case \n1 lower case \n1 number \none special character."
#define resetPasswordLink @"A reset password link has been sent to your email."

//Web URLS
//#define httpGetAllRecoveryQuestions @"http://NIBC1720/HealthViveService//api/account/GetAllRecoveryQuestions"

#define LoginAuthentication @"http://192.168.18.23/HealthViveService//Authenticate"
#define ForgotPassword @"http://192.168.18.23/HealthViveService/api/account/ForgotPassword"
#define getConsumerProfile @"http://192.168.18.23/HealthViveService/api/account/GetConsumerProfile"
#define httpGetAllRecoveryQuestions @"http://192.168.18.23/HealthViveService/api/account/GetRegistrationMasterData"
#define httpRegisterConsumer @"http://192.168.18.23/HealthViveService/api/account/RegisterConsumer"
#define ForgotPassword @"http://192.168.18.23/HealthViveService/api/account/ForgotPassword"

//Consumer Model keys
#define consumerIDKey @"ConsumerID"
#define emailIDKey @"EmailID"
#define passwordKey @"Password"
#define memberGroupIdKey @"MemberGroupID"
#define recoveryListKey @"RecoveryQuestionList"
#define titleKey @"Title"
#define foreNameKey @"ForeName"
#define surNameKey @"LastName"
#define genderKey @"Gender"
#define dobKey @"DateOfBirth"


//Recovery Question Model
#define questionIDKey @"QuestionID"
#define anserKey @"Answer"
#define questionKey @"Question"


#endif /* Constants_h */
