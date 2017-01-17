//
//  RecoveryQuestionModel.m
//  HealthVive
//
//  Created by Adarsha on 13/01/17.
//  Copyright © 2017 NousInfosystems. All rights reserved.
//

#import "RecoveryQuestionModel.h"

@implementation RecoveryQuestionModel
@synthesize questionId;
@synthesize isActive;
@synthesize question;
@synthesize answer;

-(NSDictionary *)getRecoveryQuestionModel:(RecoveryQuestionModel *)recovery{
    
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInteger:recovery.questionId],questionIDKey,recovery.answer,anserKey, nil];
    return dict;
}



@end
