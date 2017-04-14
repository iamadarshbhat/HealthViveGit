//
//  SummaryWebViewController.h
//  HealthVive
//
//  Created by Adarsha on 28/03/17.
//  Copyright © 2017 NousInfosystems. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SummaryWebViewController : BaseViewController<UIWebViewDelegate>
@property NSString *summaryURL;
@property (weak, nonatomic) IBOutlet UIWebView *summaryWebView;

@end
