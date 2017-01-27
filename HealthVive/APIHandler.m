//
//  APIHandler.m
//  HoardNot
//
//  Created by Sadhasivan Sriram on 03/11/16.
//  Copyright © 2016 Sadhasivan Sriram. All rights reserved.
//

#import "APIHandler.h"
#import "constants.h"

@implementation APIHandler
- (void)makeRequest:(NSString *)param serverUrl:(NSString*)urlString completion:(void (^)(NSDictionary *, NSError *))completion;
 {
  
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration delegate:self delegateQueue:nil];
    
     NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@",urlString]];
  
     NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:60.0];
     
     if (param!=nil) {
          NSString *authValue = [NSString stringWithFormat:@"bearer %@",param];
         [request setValue:authValue forHTTPHeaderField:@"Authorization"];
     }
     
     
     
     [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
     [request setHTTPMethod:@"GET"];
    NSURLSessionDataTask *postDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *) response;
        NSLog(@"http Response : %@",httpResponse);
        int statusCode = (int)[httpResponse statusCode];
        
        if ( statusCode == 200) {
            
            if (!error) {
                // convert the NSData response to a dictionary
                id dictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
                if (error) {
                    // there was a parse error...maybe log it here, too
                    completion(nil, error);
                } else {
                    // success!
                    completion(dictionary, nil);
                }
            } else {
                // error from the session...maybe log it here, too
                completion(nil, error);
            }
        }
        else
        {
//            id dictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
//            completion(nil,dictionary);
           
            NSLog(@"Please check the server connection");
        }

          }];
    [postDataTask resume];
    

}
- (void)makeRequestByPost:(NSString*)param serverUrl:(NSString*)urlString completion:(void (^)(NSDictionary *, NSError *))completion;
{
  
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration delegate:self delegateQueue:nil];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat: @"%@",urlString]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:60.0];
    
       
   
    //Creating Post Data For the Services
   
    
    NSData *postData = [param dataUsingEncoding:NSUTF8StringEncoding];
    NSString *postLength = [NSString stringWithFormat:@"%lu",(unsigned long)[postData length]];
    
  //  [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
   
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setHTTPBody:postData];
    [request setHTTPMethod:@"POST"];
    
    NSURLSessionDataTask *postDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *) response;
        NSLog(@"Status code  %@",httpResponse);

       // int length = (int)response.expectedContentLength;
        int statusCode = (int)[httpResponse statusCode];
       //  id dictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
        NSLog(@"Status code  %d",statusCode);
        if ( statusCode == 200) {
            
            if (!error) {
                // convert the NSData response to a dictionary
                
              //  NSLog(@"%@",data);
                id dictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
                if (error) {
                    // there was a parse error...maybe log it here, too
                    NSLog(@"Parse erro -%@",[error localizedDescription]);
                    completion(nil, error);
                } else {
                    // success!
                    completion(dictionary, nil);
                }
            } else {
                // error from the session...maybe log it here, too
                completion(nil, error);
            }
        }
        else
        {
            //To show the error msgs when user removed or deactivated or suspended
            id dictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
            completion(nil,dictionary);
        }
        
    }];
    [postDataTask resume];
    
    
}

- (void)makeRequestByPost:(NSString*)param serverUrl:(NSString*)urlString withAccessToken:(NSString*)token completion:(void (^)(NSDictionary *, NSError *))completion;
{
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration delegate:self delegateQueue:nil];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat: @"%@",urlString]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:60.0];
   
    NSString *authValue = [NSString stringWithFormat:@"bearer %@",token];
    [request setValue:authValue forHTTPHeaderField:@"Authorization"];

    
    
    //Creating Post Data For the Services
    
    
    NSData *postData = [param dataUsingEncoding:NSUTF8StringEncoding];
    NSString *postLength = [NSString stringWithFormat:@"%lu",(unsigned long)[postData length]];
    
    //  [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setHTTPBody:postData];
    [request setHTTPMethod:@"POST"];
    
    NSURLSessionDataTask *postDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *) response;
        NSLog(@"Status code  %@",httpResponse);
        
        // int length = (int)response.expectedContentLength;
        int statusCode = (int)[httpResponse statusCode];
        //  id dictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
        NSLog(@"Status code  %d",statusCode);
        if ( statusCode == 200) {
            
            if (!error) {
                // convert the NSData response to a dictionary
                
                //  NSLog(@"%@",data);
                id dictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
                if (error) {
                    // there was a parse error...maybe log it here, too
                    NSLog(@"Parse erro -%@",[error localizedDescription]);
                    completion(nil, error);
                } else {
                    // success!
                    completion(dictionary, nil);
                }
            } else {
                // error from the session...maybe log it here, too
                completion(nil, error);
            }
        }
        else
        {
            //To show the error msgs when user removed or deactivated or suspended
            id dictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
            completion(nil,dictionary);
        }
        
    }];
    [postDataTask resume];
    
    
}


@end
