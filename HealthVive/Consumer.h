//
//  Consumer.h
//  HealthVive
//
//  Created by Adarsha on 16/01/17.
//  Copyright © 2017 NousInfosystems. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Consumer : NSObject
@property NSInteger consumerId;
@property NSString *emailId;
@property NSString *password;
@property NSInteger memberGroupID;
@property NSMutableArray *recoveryQuestionsList;
@property NSString *title;
@property NSString *foreName;
@property NSString *surName;
@property NSString *gender;
@property NSString *dob;
-(NSDictionary *)consumerDic:(Consumer *)consumer;
@end
