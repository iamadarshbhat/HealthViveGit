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


-(NSDictionary *)consumerDic:(Consumer *)consumer{
    return  [NSDictionary dictionaryWithObjectsAndKeys:emailId,emailIDKey,password,passwordKey,recoveryQuestionsList,recoveryListKey, nil];
}
@end
