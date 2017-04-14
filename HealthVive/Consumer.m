//
//  Consumer.m
//  HealthVive
//
//  Created by Adarsha on 16/01/17.
//  Copyright © 2017 NousInfosystems. All rights reserved.
//

#import "Consumer.h"

@implementation Consumer
@synthesize consumerId;
@synthesize emailId;
@synthesize password;
@synthesize recoveryQuestionsList;
@synthesize memberGroupID;
@synthesize foreName;
@synthesize surName;
@synthesize gender;
@synthesize dob;
@synthesize title;
@synthesize  address1;
@synthesize address2;
@synthesize city;
@synthesize post_code;
@synthesize country;
@synthesize home_phone;
@synthesize mobile_phone;
@synthesize alternate_email;
@synthesize town;
@synthesize cid;



-(NSDictionary *)consumerDic:(Consumer *)consumer{
    NSMutableDictionary *dict ;
    
    if(memberGroupID == 0){
        dict = [NSMutableDictionary dictionaryWithObjectsAndKeys:emailId,emailIDKey,password,passwordKey,recoveryQuestionsList,recoveryListKey,title,titleKey,foreName,foreNameKey,surName,surNameKey,gender,genderKey,dob,dobKey, nil];
    }else{
        dict = [NSMutableDictionary dictionaryWithObjectsAndKeys:emailId,emailIDKey,password,passwordKey,[NSNumber numberWithInteger:memberGroupID],memberGroupIdKey,recoveryQuestionsList,recoveryListKey,title,titleKey,foreName,foreNameKey,surName,surNameKey,gender,genderKey,dob,dobKey, nil];
    }
    
    
    return  dict;
}
@end
