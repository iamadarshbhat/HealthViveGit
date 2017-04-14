//
//  GenerateSummaryController.m
//  HealthVive
//
//  Created by Adarsha on 07/03/17.
//  Copyright © 2017 NousInfosystems. All rights reserved.
//

#import "GenerateSummaryController.h"


@interface GenerateSummaryController (){
    UITextField *activeTextField;
}

@end

@implementation GenerateSummaryController
@synthesize txtTitle;
@synthesize txtDescription;

- (void)viewDidLoad {
    [super viewDidLoad];
   [self setNaviagationBarWithTitle:GenearateSummaryNavigationTitle];
   
    
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelAction)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Send" style:UIBarButtonItemStylePlain target:self action:@selector(saveSummary)];
      [self.navigationItem.rightBarButtonItem setEnabled:NO];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//Send the summary to provider
-(void)saveSummary{
   
    [txtDescription resignFirstResponder];
    UIAlertController *alertController = [UIAlertController
                                          alertControllerWithTitle:InfoAlert
                                          message:generateSummaryMessage
                                          preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction
                                   actionWithTitle:NSLocalizedString(@"Cancel", @"Cancel action")
                                   style:UIAlertActionStyleDefault
                                   handler:^(UIAlertAction *action)
                                   {
                                         NSLog(@"Cancel summary action");
                                   }];
    
    UIAlertAction *okAction = [UIAlertAction
                               actionWithTitle:NSLocalizedString(@"Send", @"OK action")
                               style:UIAlertActionStyleDefault
                               handler:^(UIAlertAction *action)
                               {
                                   [self sendSummary];
                               }];
    
    [alertController addAction:cancelAction];
    [alertController addAction:okAction];
    [self presentViewController:alertController animated:YES completion:nil];
    
}

-(void)cancelAction{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)sendSummary{
    SummaryContactListController *summaryVC = [[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:SummaryContactListControllerID];
    summaryVC.summaryListDelegate = self;
    summaryVC.summaryTitle = txtTitle.text;
    summaryVC.summaryDescription = txtDescription.text;
    [self.tabBarController.tabBar setHidden:YES];
    [self setPresentationStyleForSelfController:self presentingController:summaryVC];
    [self presentViewController:summaryVC animated:YES completion:nil];
}

- (void)setPresentationStyleForSelfController:(UIViewController *)selfController presentingController:(UIViewController *)presentingController
{
    if ([NSProcessInfo instancesRespondToSelector:@selector(isOperatingSystemAtLeastVersion:)])
    {
        //iOS 8.0 and above
        presentingController.providesPresentationContextTransitionStyle = YES;
        presentingController.definesPresentationContext = YES;
        
        [presentingController setModalPresentationStyle:UIModalPresentationOverCurrentContext];
    }
    else
    {
        [selfController setModalPresentationStyle:UIModalPresentationCurrentContext];
        [selfController.navigationController setModalPresentationStyle:UIModalPresentationCurrentContext];
    }
}

#pragma mark Text Field Delegate methods
-(void)textFieldDidBeginEditing:(UITextField *)textField{
    activeTextField = textField;
}
-(void)textFieldDidEndEditing:(UITextField *)textField{
    activeTextField = textField;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return true;
}


-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
     NSUInteger newLength = [[self getTrimmedStringForString:textView.text] length] + [[self getTrimmedStringForString:text] length] - range.length;
    if(textView == txtDescription){
        if (newLength == 0 || txtTitle.text.length == 0) {
            
            [self.navigationItem.rightBarButtonItem setEnabled:NO];
        }else{
            
            [self.navigationItem.rightBarButtonItem setEnabled:YES];
        }
    }
    if(range.length + range.location > textView.text.length)
    {
        return NO;
    }
    
    return true;
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    NSUInteger newLength = [[self getTrimmedStringForString:textField.text] length] + [[self getTrimmedStringForString:string] length] - range.length;
    
    if(textField == txtTitle){
        if (newLength == 0 || txtDescription.text.length == 0) {
            [self.navigationItem.rightBarButtonItem setEnabled:NO];
        }else{
           
             [self.navigationItem.rightBarButtonItem setEnabled:YES];
        }
    }
    
    
    if(range.length + range.location > textField.text.length)
    {
        return NO;
    }
    
    return true;
}

-(void)onCloseOfPopupView{
    [self.navigationController popToRootViewControllerAnimated:YES];
}



@end
