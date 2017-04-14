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
#define invitePendingImage @"question-mark"
#define invitAcceptedImage @"tick-mark"
#define backButtonImage @"backButton"
#define rejectedImage @"cross"

#define summaryContactSelectedImage @"OkFilled"
#define summaryContactNonSelectedImage @"tick-frame"
#define sendSummaryImage @"PaperPlaneFilled"
#define replyImage @"reply-icon"
#define replySeenImage @"read-reply-icon"
#define replyNotificationImage @"bell-ringing"
#define addEventToSummaryImage @"add-to-summary-list"
#define addedEventToSummaryImage @"added-to-summary-list"
#define searchImage @"Search-icon"
#define radioUncheckedImage @"radio-button-unchecked"
#define radioCheckedImage @"radio-button-checked"
#define filterImage @"filter-icon"
#define summaryListImage @"summary-list-icon"
#define instructionImage @"instruction-image"


//Tab bar images
#define medContactsTabDefaultImage @"med-contacts"
#define medContactsTabSelectedImage @"med-contacts-filled"
#define profileTabDefaultImage @"my-profile-icon"
#define profileTabSelectedImage @"my-profile-icon-filled"
#define moreTabDefaultImage @"more"
#define moreTabSelectedImage @"more-filled"
#define medicalRecordTabDefaultImage @"med-records-tab"
#define medicalRecordTabSelectedImage @"med-records-tab-filled"
#define settingsTabSelectedImage @"Settings-Filled"
#define settingsTabDefaultImage @"Settings"






//RegistrationController
#define selectGroupOptional @"Select group (optional)"
#define maximumYear 16


//Label texts
#define lblGetStartedText  @"Enter your email and password to get started!"

#define medicalContactCellIdentifier @"medicalContactCellId"

//Table Row Heights
#define groupTableHeight 60





//----Registration---
//Place holder Texts
#define buttonTitleStr @"Title"
#define buttonSelectDateStr @"Select Date (Minimum age 16 years)"
#define btnShowPasswordString @"Show"
#define btnHidePasswordString @"Hide"
#define foreNamePlaceHolderText @"Forename"
#define surNamePlaceHolderText @"Surname"



//Button names
#define recoveryQuestion1 @"Select Question 1"
#define recoveryQuestion2 @"Select Question 2"
#define recoveryQuestion3 @"Select Question 3"

// TableviewCell Identifiers
#define questionTableCellIdentifier @"questionTableCellIdentifier"
#define groupOptionTableCellIdentifier @"groupOptionTableIdentier"
#define titleTableIdentifer @"titleTableIdentifer"
#define summaryContacttableIdentifier @"contactTableIdentifier"
#define settingsTableReusableIdentifier @"settingsTableReuseId"
#define changePasswordTableReuseId @"changePasswordTableReuseId"


//--MedicalContact----

//place Holder texts
#define foreNameMedPlaceHolderText @"Please enter forename"
#define surNameMedPlaceHolderText @"Please enter surname"
#define emailMedPlaceHolderText @"Please enter email"


#define recoveryBtnEnableMinLength 1
#define recoveryAnswerMinLength 4
#define recoveryAnswerMaxLength 50

#define forNameMininmumLength 2
#define surNameMininmumLength 2
#define foreNameMaximumLength 25
#define surNameMaximumLength 30
#define emailMaximumLength 50
#define addressFldMinLenght 4
#define addressFldMaxLenght 75
#define townMinlength 2
#define townMaxlength 75
#define postCodeMinLength 2
#define postCodeMaxLength 25
#define phoneNumMinLength 1
#define phoneNumMaxLength 20
#define altEmaiMinLength 6
#define altEmailMaxlength 50


//Button Ids
#define question1Tag 1
#define question2Tag 2
#define question3Tag 3

#define inviteButtonTag 100
#define addEventToSummaryTag 500


//StoryBoard IDs
#define RegistrationEssentialControllerId @"RegistrationEssentialController"
#define ConsumerProfileViewControllerId @"ConsumerProfileViewControllerID"
#define medicalContactsControllerId @"MedicalContactsControllerID"
#define activeContactControllerID @"ActiveContactsControllerID"
#define archivedContactControllerID @"ArchivedContactsControllerID"
#define settingsViewControllerID @"SettingsViewControllerID"
#define changePasswordControllerID @"ChangePasswordControllerID"

#define medicalContactDetailsControllerID @"medicalContactDetailsControllerID"
#define medicalContactEditControllerID @"medicalContactEditControllerID"
#define medicalRecordViewControllerID @"MedicalRecordsViewControllerID"
#define medicalRecordsDetailViewControllerID @"MedicalRecordsDetailViewControllerID"
#define AddMedicalRecordViewControllerID @"AddMedicalRecordViewControllerID"
#define SearchEventsControllerId @"SearchEventsControllerId"
#define GenerateSummaryControllerID @"GenerateSummaryControllerID"

#define SummaryContactListControllerID @"SummaryContactListControllerID"
#define SummaryEventListControllerID @"SummaryEventListControllerID"
#define RegistrationControllerID @"RegistrationControllerID"
#define EditProfileViewControllerID @"EditProfileViewControllerID"

//NavBarColor
#define NAVBAR_BCG_COLOR [UIColor colorWithRed:233/255.0 green:52/255.0 blue:52/255.0 alpha:1.0]

//NavBarTitles
#define forgotPassNavigationBarTitle @"Forgot Password"
#define medicalContactNavigationBarTitle @"Health Contacts"
#define contactDetailsNavigatinBarTitle @"Contact Details"
#define EditProfileNavBarTitle @"Edit Profile"
#define MyProfileNavBarTitle @"My Profile"
#define SettingsNavigationBarTitle @"Settings"
#define SummaryEventListBarTitle @"Summary List"
#define ChangePasswordNavigationBarTitle @"Change Password"
#define HealthLogNavigationTitle @"Health Log"
#define EventDetailsnavigationTitle @"Event details"
#define GenearateSummaryNavigationTitle @"Generate Summary"



//Hexa Color Codes
#define buttonColorCode #e93434

//Web Api keys
#define remoteHostName @"www.apple.com"
#define httpResult @"Result"
#define httpError @"Error"
#define httpStatusCode @"SatusCode"
#define httpNoInternetAlert @"Connection Lost"
#define httpConnectionProblemMsg @"Your request cannot be completed because you are not connected to the Internet.Verify your data connection and try again."

#define offlineStatus @"Please check your internet connection."


#define noInternetMessage @"Please check your internet connection."


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
#define backPressErrorMessage @"You must press the Done button to save and use the details."
#define deleteMessage @"Are you sure you want to delete the selected contact?"
#define deleteEventMessage @"Are you sure you want to delete the event?"
#define undoMessage @"Are you sure you want to restore the selected contact?"
#define generateSummaryMessage @"Would you like to send the summary?"
#define backLogAlertMessage @"A copy of your healthlog data will now be uploaded on to the HealthVive server.Any previous backup will be overwritten."
#define healthBackLogSuccessMessage @"Health log data backed up successfully"
//#define @""

//#define alert @"ALERT"
#define errorAlert @"Error"
#define InfoAlert @"Info"
#define generateSummaryAlert @"Send Summary"

#define invalidPasswordAlert @"Invalid Passwrod!"
#define invalidEmailIdAlert @"Invalid Email Id!"
#define forgotPassEmailAlert @"Invalid Email ID"
#define addressErrorMsg @"Address should between 4 to 75 characters long."
#define thanks @"Thanks!"
#define invitationSentAlert @"Status"
#define invitaionSentMessage @"Thank you for sending your invitation. The status will change once it has been accepted."
#define invitationCantSentAlert @"Invitation can't be Sent!"
#define invitationCantSentMessage @"Unfortunately the invitation can’t be sent.Please ensure that you have entered the surname and email."
#define selectProvider @"Please select a provider"


//Edit Profile Inline Error msgs and Offline msgs
#define addres1InlineError @"Address 1 should be between 4 and 75 characters long."
#define addres2InlineError @"Address 2 should be between 4 and 75 characters long."
#define townInlineError @"Town/City should be between 2 and 75 characters long."
#define postCodeInlineError @"Post Code should be between 2 and 25 characters long."
#define homePhoneInlineError @"Home Phone should be between 2 and 25 characters long."
#define mobilePhoneInlineError @"Mobile Phone should be between 2 and 25 characters long."
#define alternateEmailInlineError @"Invalid email. Please enter a valid email address"
#define mandatoryFldError @"Please fill in all the mandatory details."
#define editProfileOfflineError @"Please ensure that you are connected to the internet before editing your profile."

//Add Medical records inlineError messages
#define titleInlineerror @"Titles must be entered. Make sure title has between 2 and 50 characters."
#define bodyLocationInlineError @"Body location must be between 2 and 100 characters."
#define symptomsInlineError @"Symptom must be between 2 and 100 characters."
#define providerNameInlineError @"Provider name must be between 2 and 50 characters."
#define providerTypeInlineError @"Provider type must be between 2 and 100 characters."
#define careTypeInlineError @"Care type must be between 2 and 100 characters."


#define ok @"OK"
#define statusStr @"Status"
#define successfullRegisterMsg @"Thank you for submitting your HealthVive account registration and basic profile for approval. Once approved, we will send you an activation email, which may take up to 24 hours to arrive. Please note that you will need to provide more information to use additional features, premium services, or to enable health professionals to advise and assist you."

#define recoveryAnswerErrorMessage @"Answers to security questions are between 4 and 50 characters long"
#define internalError @"Internal error please try after some time"

#define passwordInfo @"Please ensure that your password should be between 8 and 20 characters.\nIt must include at least : \n1 upper case \n1 lower case \n1 number \none special character."
#define resetPasswordLink @"A reset password link has been sent to your email."
#define suspendedError @"This account has been suspended. Please contact support for help at support@healthvive.com"
#define deactivatedError @"This account has been deactivated. Please contact support for help at support@healthvive.com"

#define successfullSummarySentMsg @"Summary sent successfully."
#define successfullMesasgeSent @"Message sent successfully."

//Web URLS
//#define httpGetAllRecoveryQuestions @"http://NIBC1720/HealthViveService//api/account/GetAllRecoveryQuestions"
//#define BaseURL @"http://111.93.154.178:9595/UAT-HealthViveService/"
#define BaseURL @"http://192.168.18.23/HealthViveServiceQA/"
#define LoginAuthentication @"Authenticate"
#define getConsumerProfile @"api/account/GetConsumerProfile"
#define getBasicProfileDetails @"api/account/GetConsumerBasicDetails"
#define upDateConsumerprofile @"api/account/UpdateConsumerProfile"
#define httpGetAllRecoveryQuestions @"api/account/GetRegistrationMasterData"
#define httpRegisterConsumer @"api/account/RegisterConsumer"
#define httpValidateConsumerEmailID @"api/account/ValidateConsumerEmailID"
#define ForgotPassword @"api/account/ForgotPassword"
#define httpInviteUser @"api/consumercontact/InviteUser"
#define httpGetInviteProviders @"api/consumercontact/GetInvitedProviders"
#define httpGetProviderContactDetails @"api/consumercontact/GetProviderContactDetails?providerEmailID="
#define httpArchiveProductContact @"api/consumercontact/ArchiveProviderContact"
#define httpGetActiveProvidersContacts @"api/consumercontact/GetActiveProviderContacts/"
#define httpSaveMedicalSummaryDetails @"api/medicalsummary/SaveMedicalSummaryDetails"
#define httpSendAllProviderResponseToConsumer @"api/medicalsummary/SendAllProviderResponseToConsumer"
#define httpGetConsumerPlanDetails @"api/account/GetConsumerPlanDetails"
#define httpChangeConsumerPassword @"api/account/ChangeConsumerPassword"
#define approveAndRejectinvitation @"api/consumercontact/UpdateInviteStatus"
#define httpBackupHealthLog @"api/medicalsummary/BackupHealthLog"

//#define httpSummaryLink @"http://111.93.154.178:9595/UAT-HealthVive/account/ConsumerSummaryView?summaryID="
//#define httpSummaryLink @"http://192.168.18.23/HealthVive/account/ConsumerSummaryView?summaryID="

#define httpSummaryLink @"http://192.168.18.23/HealthViveQA/account/ConsumerSummaryView?summaryID="
                                
//#define termsAndConditionLink @"http://111.93.154.178:9595/UAT-HealthVive/account/TermsAndCondition"
#define termsAndConditionLink @"http://192.168.18.23/HealthViveQA/account/TermsAndCondition"


//#define termsAndConditionLink @"http://192.168.18.23/HealthVive/Account/TermsAndCondition"


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

//MedicalContactModel
#define medicaContactForeNameKey @"medicalForenameKey"
#define medicaContactSurNameKey @"medicalSurnameKey"
#define medicaContactemailKey @"medicalEmailKey"
#define medicaContactspecialismKey @"medicalSpecialismKey"
#define medicalContactAddressKey @"medicalAddressKey"
#define medicalContacttelephoneKey @"medicalContactTelephoneKey"


//Notification Names
#define InsertMedicalContactNotification @"InsertMedicalContactNotificationName"
#define UpdateMedicalContactNotification @"UpdateMedicalContactNotification"
#define medicalContactModelInsertKey @"medicalContactModelInsertKey";
#define medicalContactModelUpdateKey @"medicalContactModelUpdateKey"
#define LogoutNotification @"LogoutNotification"


//Event Type Keywords

#define MsgEventTitle @"Info"
#define MsgEventMsg @"Do you want to send the details now or later?"
#define Now @"Now"
#define Later @"Later"

#define HealthEventType @"Health"
#define MessageEventType @"Message"
#define SummaryEventType @"Summary"
#define CalendarEventType @"Calendar"
//LoginView
#define offlineLogin @"Logging in offline ..."
#define onlineLogin @"Logging In"

//Event images
#define  calEventImage [UIImage imageNamed:@"CalEvent"]
#define  SummaryEventImage [UIImage imageNamed:@"summary-icon"]
#define  messageEventImage [UIImage imageNamed:@"evemsg"]

#define plusImage @"Plus"
#define minusImage @"Minus"



//------------------------Database Constants-------------

//Entities :

#define accountEntity @"Account"
#define profileEntity @"Profile"
#define medicalContactEntity @"My_contacts"
#define medical_event @"Medical_event"

//My_Contact entity Attributes :
#define foreNameMyContactsAtt @"fore_name"
#define surNameMyContactsAtt @"sur_name"
#define emailMyContactsAtt @"email"
#define specialismMyContactsAtt @"specialism"
#define telephoneMyContactsAtt @"phone"
#define addressMyContactsAtt @"address"

//Account Entity:
#define consumerIdAccountAtt  @"id";
#define emailAccountAtt  @"email";
#define passwordAccountAtt  @"password";
#define accountStatusAccountAtt  @"account_status";
#define subscribed_planAccountAtt  @"subscribed_plan";
#define plan_expiryAccountAtt @"plan_expiry";
#define profileAccountAtt @"profile"

// UserDefaults Keys
#define access_tokenKey @"access_token"
#define loginStatus @"Online"


typedef NS_ENUM(NSInteger, PlayerStateType) {
    MedicalRecordEnum,
    ProviderResponseEnum = 4
};

typedef NS_ENUM(NSInteger, EventType) {
    Summary = 1,
    Message
};
typedef NS_ENUM(NSInteger,InviteStatus) {
    Invited = 1,
    ApprovedStatus,
    RejectedStatus
};
typedef NS_ENUM(NSInteger,LocalEvenType) {
    HealthEvent = 0,
    Calendarevent,
    SummaryEvent,
    MessageEvent,
    ProviderResponseEvent
    
};

#endif /* Constants_h */
