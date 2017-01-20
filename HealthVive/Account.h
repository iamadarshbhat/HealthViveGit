//
//  Account.h
//  HealthVive
//
//  Created by Sadhasivan Sriram on 18/01/17.
//  Copyright © 2017 NousInfosystems. All rights reserved.
//

#import <CoreData/CoreData.h>
@class Profile;
@interface Account : NSManagedObject

@property(nonatomic,strong)NSNumber *id;
@property(nonatomic,strong)NSString *email;
@property(nonatomic,strong)NSString *password;
@property(nonatomic,strong)NSNumber *account_status;
@property(nonatomic,strong)NSNumber *subscribed_plan;
@property(nonatomic,strong)NSDate *plan_expiry;
@property(nonatomic,strong)Profile *profile;

@end
