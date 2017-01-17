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
@property NSMutableArray *recoveryQuestionsList;
-(NSDictionary *)consumerDic:(Consumer *)consumer;
@end
