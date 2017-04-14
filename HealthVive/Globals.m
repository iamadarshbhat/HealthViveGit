//
//  Globals.m
//  HealthVive
//
//  Created by Sriram Sadhasivan (BLR GSS) on 31/01/17.
//  Copyright © 2017 NousInfosystems. All rights reserved.
//

#import "Globals.h"

@implementation Globals

+ (id)sharedManager {
    static Globals *globaslManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        globaslManager = [[self alloc] init];
    });
    return globaslManager;
}

-(id)init
{
    self =[super init];
    if (self ) {
        self.email = @"";
        self.password = @"";
        self.consumerId =0;
        self.accountStatus =0;
        
    }
    
    return  self;
}

@end
