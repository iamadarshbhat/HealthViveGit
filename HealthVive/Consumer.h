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
@property NSString  * address1;
@property NSString  * address2;
@property NSString  * city;
@property NSString  *post_code;
@property NSString  * country;
@property NSString  * home_phone;
@property NSString  * mobile_phone;
@property NSString  * alternate_email;
@property NSString *town;
@property(nonatomic,assign) int cid;
@property(nonatomic,assign)int consumer_id;
-(NSDictionary *)consumerDic:(Consumer *)consumer;
@end
