//
//  Profile.h
//  HealthVive
//
//  Created by Sadhasivan Sriram on 19/01/17.
//  Copyright © 2017 NousInfosystems. All rights reserved.
//

#import <CoreData/CoreData.h>

@class Account;
@interface Profile : NSManagedObject
@property(nonatomic,strong)NSNumber *id;
@property(nonatomic,strong)NSNumber *consumer_id;
@property(nonatomic,strong)NSString *title;
@property(nonatomic,strong)NSString *fore_name;
@property(nonatomic,strong)NSString *sur_name;
@property(nonatomic,strong)NSDate *dob;
@property(nonatomic,strong)NSString *gender;
@property(nonatomic,strong)NSString *address1;
@property(nonatomic,strong)NSString *address2;
@property(nonatomic,strong)NSString *city;
@property(nonatomic,strong)NSString *post_code;
@property(nonatomic,strong)NSString *country;
@property(nonatomic,strong)NSString *home_phone;
@property(nonatomic,strong)NSString *mobile_phone;
@property(nonatomic,strong)NSString *alternate_email;
@property(nonatomic,strong)Account *account;




@end
