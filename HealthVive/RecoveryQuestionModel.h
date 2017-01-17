//
//  RecoveryQuestionModel.h
//  HealthVive
//
//  Created by Adarsha on 13/01/17.
//  Copyright © 2017 NousInfosystems. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RecoveryQuestionModel : NSObject
@property NSString *question;
@property BOOL isActive;
@property NSInteger questionId;
@property NSString *answer;

-(NSDictionary *)getRecoveryQuestionModel:(RecoveryQuestionModel *)recovery;


@end
