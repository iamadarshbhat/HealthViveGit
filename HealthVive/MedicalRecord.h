//
//  MedicalRecord.h
//  HealthVive
//
//  Created by Sriram Sadhasivan (BLR GSS) on 06/02/17.
//  Copyright © 2017 NousInfosystems. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MedicalRecord : NSObject

@property(nonatomic,assign)int id;
@property(nonatomic,strong)NSString *title;
@property(nonatomic,strong)NSString *content;
@property(nonatomic,strong)NSString *body_locations;
@property(nonatomic,strong)NSString *symptom;
@property(nonatomic,strong)NSString *provider_name;
@property(nonatomic,assign)NSString* provider_type;
@property(nonatomic,assign)NSString* care_type;
@property(nonatomic,strong)NSString *event_dateString;
@property(nonatomic,strong)NSDate *event_date;
@property(nonatomic,strong)NSDate *created_date;
@property(nonatomic,strong)NSDate *modified_date;
@property(nonatomic,assign)int diary_id;
@property(nonatomic,assign)int is_active;
@property(nonatomic,assign)int consume_id;


@end
