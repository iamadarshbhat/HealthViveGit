//
//  APIHandler.h
//  HoardNot
//
//  Created by Sadhasivan Sriram on 03/11/16.
//  Copyright © 2016 Sadhasivan Sriram. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface APIHandler : NSObject<NSURLSessionTaskDelegate>
-(void)makeRequest:(NSString *)param serverUrl:(NSString*)urlString completion:(void (^)(NSDictionary *, NSError *))completion;
- (void)makeRequestByPost:(NSString*)param serverUrl:(NSString*)urlString completion:(void (^)(NSDictionary *, NSError *))completion;

- (void)makeRequestByPost:(NSString*)param serverUrl:(NSString*)urlString withAccessToken:(NSString*)token completion:(void (^)(NSDictionary *, NSError *))completion;


@end
