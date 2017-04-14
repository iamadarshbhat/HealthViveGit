//
//  SummaryWebViewController.m
//  HealthVive
//
//  Created by Adarsha on 28/03/17.
//  Copyright © 2017 NousInfosystems. All rights reserved.
//

#import "SummaryWebViewController.h"

@interface SummaryWebViewController ()

@end

@implementation SummaryWebViewController
@synthesize summaryURL;
@synthesize summaryWebView;

- (void)viewDidLoad {
    [super viewDidLoad];
   // UIWebView *webView = [[UIWebView alloc] initWithFrame:self.view.bounds];  //Change self.view.bounds to a smaller CGRect if you don't want it to take up the whole screen
    [self showProgressHudWithText:@"Loading..."];
    [summaryWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:summaryURL]]];
   // [self.view addSubview:webView];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)webViewDidFinishLoad:(UIWebView *)webView{
    [self hideProgressHud];
}

-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    [self hideProgressHud];

}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
