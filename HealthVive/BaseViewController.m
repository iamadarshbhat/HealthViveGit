//
//  ViewController.m
//  HealthVive
//
//  Created by Adarsha on 10/01/17.
//  Copyright © 2017 NousInfosystems. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseViewController ()
   

@end

@implementation BaseViewController
@synthesize parentScrollView;
@synthesize activeField;
@synthesize parentTableView;
@synthesize parentTableViewCell;
@synthesize parenttableIdentier;
@synthesize parentTableDataArray;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self registerKeyboardNotifications];
   // [self setNeedsStatusBarAppearanceUpdate];
    
}


-(void)setScrollView:(UIScrollView *)scrollView andTextField:(UITextField *)textField{
    parentScrollView = scrollView;
    activeField = textField;
}
-(void)setTableView:(UITableView *)tableView andTableViewCell:(UITableViewCell *)tableViewCell withIdentifier:(NSString *) identifier andData : (NSMutableArray *) arrayData{
    parentTableViewCell = tableViewCell;
    parentTableView = tableView;
    parenttableIdentier = identifier;
    parentTableDataArray = arrayData;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark UIText field delegate methods
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


#pragma Keyboard Notification registration
-(void)registerKeyboardNotifications{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardDidShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification object:nil];
}

// Called when the UIKeyboardDidShowNotification is sent.
- (void)keyboardWasShown:(NSNotification*)aNotification
{
    NSDictionary* info = [aNotification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, kbSize.height, 0.0);
    parentScrollView.contentInset = contentInsets;
    parentScrollView.scrollIndicatorInsets = contentInsets;
    
    // If active text field is hidden by keyboard, scroll it so it's visible
    // Your app might not need or want this behavior.
    CGRect aRect = self.view.frame;
    aRect.size.height -= kbSize.height;
    if (!CGRectContainsPoint(aRect, activeField.frame.origin) ) {
        [parentScrollView scrollRectToVisible:activeField.frame animated:YES];
    }
}

// Called when the UIKeyboardWillHideNotification is sent
- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    parentScrollView.contentInset = contentInsets;
    parentScrollView.scrollIndicatorInsets = contentInsets;
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

#pragma mark Table View Delegate methods
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if(parentTableViewCell == nil){
        parentTableViewCell = [tableView dequeueReusableCellWithIdentifier:questionTableCellIdentifier];
    }
    parentTableViewCell.textLabel.text = [parentTableDataArray objectAtIndex:indexPath.row];
    return  parentTableViewCell;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return parentTableDataArray.count;
}


//Sets Color to button
-(void)applyColorToButton:(UIButton *)button{
    if(button.state == UIControlStateNormal){
         button.alpha  = 1.0;
    [button setBackgroundColor:[UIColor colorWithRed:233.0/255.0f green:52.0/255.0f blue:52.0/255.0f alpha:1]];
    }else if (button.state == UIControlStateDisabled){
        button.alpha  = 0.75;
    }
}

//Sets Corner to view
-(void)applyCornerToView:(UIView *)view{
    view.layer.cornerRadius = 5;
}

//Applies place holder text color
-(void)applyColorToPlaceHolderText:(UITextField *)textField{
    UIColor *color = [UIColor colorWithRed:224.0/255.0f green:224.0/255.0f blue:224.0/255.0f alpha:1];
    textField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:textField.placeholder attributes:@{NSForegroundColorAttributeName: color}];
}

//Applies place holder text color for Error message
-(void)applyColorToPlaceHolderTextForError:(UITextField *)textField withErrorMessage:(NSString *)errorMessage{
    UIColor *color = [UIColor colorWithRed:224.0/255.0f green:224.0/255.0f blue:224.0/255.0f alpha:1];
    textField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:textField.placeholder attributes:@{NSForegroundColorAttributeName: color}];
}

-(void)setButtonEnabled:(Boolean)isEnabled forButton:(UIButton *)button
{
    [button setEnabled:isEnabled];    
    [self applyColorToButton:button];
}


-(void)startFade:(UIView *)view{
    
    [view setAlpha:0.f];
    
    [UIView animateWithDuration:.5f delay:0.f options:UIViewAnimationOptionTransitionCurlUp animations:^{
        [view setAlpha:1.f];
    } completion:nil];
}

-(void)startfadOut:(UIView *)view{
    [UIView animateWithDuration:0.5f delay:0.f options:UIViewAnimationOptionTransitionCurlDown animations:^{
        [view setAlpha:0.f];
    } completion:nil];
}
-(void)applyCornerColorToView:(UIView *)view withColor: (UIColor *)color;{
    [view.layer setBorderColor:color.CGColor];
    [view.layer setBorderWidth:2];
}

-(void)showAlertWithTitle:(NSString*)title andMessage:(NSString*)msg andActionTitle:(NSString*)actionTitle actionHandler:(void (^ __nullable)(UIAlertAction *action))handler
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:msg preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* okAction = [UIAlertAction actionWithTitle:actionTitle style:UIAlertActionStyleDefault handler:handler];
    [alertController addAction:okAction];
    
    [self presentViewController:alertController animated:YES completion:nil];
}


-(NSString *)getTrimmedStringForString:(NSString *)string{
    return  [string stringByTrimmingCharactersInSet:
                               [NSCharacterSet whitespaceCharacterSet]];
}


//   To CheckValidEmailFormat
-(BOOL)IsValidEmail:(NSString *)checkString
{
    BOOL stricterFilter = NO;
    NSString *stricterFilterString = @"^[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}$";
    NSString *laxString = @"^.+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2}[A-Za-z]*$";
    NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:checkString];
}


@end
