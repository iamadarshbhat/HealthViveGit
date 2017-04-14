//
//  Globals.h
//  HealthVive
//
//  Created by Sriram Sadhasivan (BLR GSS) on 31/01/17.
//  Copyright © 2017 NousInfosystems. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Globals : NSObject

@property(nonatomic,strong)NSString *email;
@property(nonatomic,strong)NSString *password;
@property(nonatomic,assign)int accountStatus;
@property(nonatomic,assign)int consumerId;
@property(nonatomic,assign)BOOL isEmailVerified;


+ (id)sharedManager;
@end
