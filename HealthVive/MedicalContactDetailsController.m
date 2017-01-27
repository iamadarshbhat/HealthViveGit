//
//  MedicalContactDetailsController.m
//  HealthVive
//
//  Created by Adarsha on 27/01/17.
//  Copyright © 2017 NousInfosystems. All rights reserved.
//

#import "MedicalContactDetailsController.h"

@interface MedicalContactDetailsController (){
    UITextField *activeField;
}

@end

@implementation MedicalContactDetailsController
@synthesize scrollView;

- (void)viewDidLoad {
    [super viewDidLoad];
    
   [self setNaviagationBarWithTitle:contactDetailsNavigatinBarTitle];
    
    //[self.navigationItem.rightBarButtonItem setAction:@selector(doneButtonAction:)];
    [super setScrollView:scrollView andTextField:activeField];

    UIBarButtonItem * doneButton = [[UIBarButtonItem alloc]
                                    initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                    target:self
                                    action:@selector(doneButtonAction)];
    self.navigationItem.rightBarButtonItem = doneButton;

}

//Pops the view to previous view
-(void)doneButtonAction{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark Text Field Delegate methods
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    activeField = textField;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    activeField = nil;
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return true;
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    return true;
}

@end
