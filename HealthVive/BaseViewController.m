//
//  ViewController.m
//  HealthVive
//
//  Created by Adarsha on 10/01/17.
//  Copyright © 2017 NousInfosystems. All rights reserved.
//

#import "BaseViewController.h"
@interface BaseViewController (){
    CGFloat screenHeight;
}

@end

@implementation BaseViewController
@synthesize parentScrollView;
@synthesize activeField;
@synthesize parentTableView;
@synthesize parentTableViewCell;
@synthesize parenttableIdentier;
@synthesize parentTableDataArray;
@synthesize blurredView;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self registerKeyboardNotifications];
    blurredView = [[UIView alloc] initWithFrame:self.view.frame];
    [blurredView setBackgroundColor:[UIColor colorWithWhite:0.0 alpha:0.50]];

    
    
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
    [parentScrollView scrollRectToVisible:parentScrollView.frame animated:YES];
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
        button.alpha  = 0.50;
    }
}

//Sets Corner to view
-(void)applyCornerToView:(UIView *)view{
    view.layer.cornerRadius = 5;
}

//Applies place holder text color
-(void)applyColorToPlaceHolderText:(UITextField *)textField{
    UIColor *color = [UIColor colorWithRed:142.0/255.0f green:142.0/255.0f blue:142.0/255.0f alpha:1];
    textField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:textField.placeholder attributes:@{NSForegroundColorAttributeName: color}];
}

-(void)applyColorToPlaceHolderText:(UITextField *)textField WithColor:(UIColor*)color{
textField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:textField.placeholder attributes:@{NSForegroundColorAttributeName:color}];
}

//Applies place holder text color for Error message
-(void)applyColorToPlaceHolderTextForError:(UITextField *)textField withErrorMessage:(NSString *)errorMessage{
    textField.text = @"";
    [textField setAttributedPlaceholder:[[NSAttributedString alloc] initWithString:errorMessage attributes:@{NSForegroundColorAttributeName: [UIColor redColor],NSFontAttributeName: [UIFont systemFontOfSize:10.0]}]];
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
    [view.layer setBorderWidth:1];
}

-(void)showAlertWithTitle:(NSString*)title andMessage:(NSString*)msg andActionTitle:(NSString*)actionTitle actionHandler:(AlertBlock)handler
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
- (BOOL)numberValidation:(NSString *)text {
    NSString *regex = @"^([0-9]*|[0-9]*[.][0-9]*)$";
    NSPredicate *test = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    BOOL isValid = [test evaluateWithObject:text];
    return isValid;
}

//Gives the image and text insets
-(void)setImageAndTextInsetsToButton:(UIButton *)btn andImage:(UIImage *) image withLeftSpace:(CGFloat)space{
//    btn.imageEdgeInsets = UIEdgeInsetsMake(0., btn.frame.size.width - (image.size.width)-space, 0., 0.);
//    btn.titleEdgeInsets = UIEdgeInsetsMake(0.,-16.0, 0., space);

    btn.imageEdgeInsets = UIEdgeInsetsMake(0., btn.frame.size.width - (image.size.width)-space, 0., 0.);
    btn.titleEdgeInsets = UIEdgeInsetsMake(0.,-16.0, 0., -space);
    
    

}
-(void) setImageInsetsToButton:(UIButton *)btn andImage:(UIImage *)image{
    btn.imageEdgeInsets = UIEdgeInsetsMake(0., 0., 0., (-btn.frame.size.width +image.size.width));
    
}

//Sets the image to the text field
-(void)setLeftImageForTextField:(UITextField *)textField withImage:(UIImage *)image{
    textField.leftViewMode = UITextFieldViewModeAlways;
    UIView *leftTextView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, image.size.width+10, image.size.height)];
    [leftTextView addSubview:[[UIImageView alloc] initWithImage:image]];
    textField.leftView = leftTextView;
}

-(void)addPopupView:(UIView *)view{
    view.hidden = false;
    
    [self.view addSubview:blurredView];
    [self.view bringSubviewToFront:view];
}
-(void)removePopupView:(UIView *)view{
    view.hidden = true;
    [self.view sendSubviewToBack:view];
    [blurredView removeFromSuperview];
}
-(void)setTintColor:(UIColor*)color toButton:(UIButton *)btn{
    [btn setTintColor:color];
}

-(void)setAlpha:(CGFloat)alpha toBtn:(UIButton*)button{
    [button setAlpha:alpha];
}


//Gives the date string with the given format
-(NSString*)getDateString:(NSDate *)date withFormat:(NSString *)formatString{
   
    NSDateFormatter *dateFormat=[[NSDateFormatter alloc]init];
    dateFormat.dateStyle=NSDateFormatterMediumStyle;
     [dateFormat setTimeZone:[NSTimeZone localTimeZone]];
    [dateFormat setDateFormat:formatString];
    return  [NSString stringWithFormat:@"%@",[dateFormat  stringFromDate:date]];
}


-(NSDate *)getDateFromString:(NSString *)dateStr WithFormat:(NSString *)format{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeZone:[NSTimeZone localTimeZone]];
    [dateFormatter setDateFormat:format];
    NSDate *date = [dateFormatter dateFromString:dateStr];
    return date;
}
//Shows the HUD
-(void)showProgressHudWithText:(NSString *)text{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeAnnularDeterminate;
   // hud.label.textColor = [UIColor blackColor];
    //[hud.bezelView setBackgroundColor:[UIColor blackColor]];
    hud.label.text = text;
}

//Hides the HUD
-(void)hideProgressHud{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}


//Checks the internet Connection
-(BOOL)checkInternetConnection{
    Reachability *reachability = [Reachability reachabilityWithHostName:remoteHostName];
    Reachability *internetReachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus netStatus = [reachability currentReachabilityStatus];
    NetworkStatus internetStatus = [internetReachability currentReachabilityStatus];
    BOOL connectionRequired = [reachability connectionRequired];
    NSString* statusString = @"";
    Boolean isReachable;
    switch (netStatus)
    {
        case NotReachable:        {
            statusString = NSLocalizedString(@"Access Not Available", @"Text field text for access is not available");
            
            /*
             Minor interface detail- connectionRequired may return YES even when the host is unreachable. We cover that up here...
             */
            connectionRequired = NO;
            isReachable = NO;
            break;
        }
            
        case ReachableViaWWAN:        {
            statusString = NSLocalizedString(@"Reachable WWAN", @"");
            isReachable = YES;
            break;
        }
        case ReachableViaWiFi:        {
            statusString= NSLocalizedString(@"Reachable WiFi", @"");
            isReachable = YES;
            break;
        }
    }
    
    switch (internetStatus)
    {
        case NotReachable:        {
            statusString = NSLocalizedString(@"Access Not Available", @"Text field text for access is not available");
            
            /*
             Minor interface detail- connectionRequired may return YES even when the host is unreachable. We cover that up here...
             */
            connectionRequired = NO;
            isReachable = NO;
            break;
        }
            
        case ReachableViaWWAN:        {
            statusString = NSLocalizedString(@"Reachable WWAN", @"");
            isReachable = YES;
            break;
        }
        case ReachableViaWiFi:        {
            statusString= NSLocalizedString(@"Reachable WiFi", @"");
            isReachable = YES;
            break;
        }
    }

    
    if (connectionRequired)
    {
        NSString *connectionRequiredFormatString = NSLocalizedString(@"%@, Connection Required", @"Concatenation of status string with connection requirement");
        statusString= [NSString stringWithFormat:connectionRequiredFormatString, statusString];
    }
    
//    if(connectionRequired || !isReachable){
//       [self showAlertWithTitle:httpNoInternetAlert andMessage:httpConnectionProblemMsg andActionTitle:ok actionHandler:nil];
//    }
    NSLog(@"isReachable %@,%hhu",statusString,isReachable);
    return isReachable;
    
}

-(void)setNaviagationBarWithTitle:(NSString *)title{
    self.navigationController.navigationBar.backItem.title = @"";
    self.navigationController.navigationBar.hidden =NO;
    self.navigationItem.title = title;
    // self.navigationItem.hidesBackButton = YES;
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName : [UIColor whiteColor]};
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    [self.navigationController.navigationItem.leftBarButtonItem setTitle:@""];
    self.navigationController.navigationBar.barTintColor = NAVBAR_BCG_COLOR;
    self.navigationController.navigationBar.translucent = NO;
    
    self.navigationController.navigationController.navigationBar.shadowImage = [[UIImage alloc] init];
    [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
}

-(void)applyShadowToView:(UIView *)view{
    view.layer.shadowColor = [[UIColor blackColor] CGColor];
    view.layer.shadowOffset = CGSizeMake(1.0f, 1.0f);
    view.layer.shadowRadius = 1.5f;
    view.layer.shadowOpacity = 0.2f;
}
// to get Selected EventType
-(NSString*)getEventType:(LocalEvenType)eveType
{
    NSString *eventTypeString;
    switch (eveType) {
        case HealthEvent:
            eventTypeString = @"Health";
            break;
        case Calendarevent:
            eventTypeString = @"Calendar";
            break;
        case SummaryEvent:
            eventTypeString = @"Summary";
            break;
        case MessageEvent:
            eventTypeString = @"Message";
            break;
            
        case ProviderResponseEvent:
            eventTypeString = @"Provider Response";
            break;
        default:
            break;
    }
    
    return eventTypeString;
}

-(void)handleServerError:(NSError *)error{
    
    NSDictionary *errorDict =  [error valueForKey: @"Error"];
    NSString *errorDescription =[errorDict valueForKey:@"error_description"];
    
    
    BOOL isUserActive = [[error valueForKey:@"IsUserActive"] boolValue];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self hideProgressHud];
    });
    
    
    if(!isUserActive){
        dispatch_async(dispatch_get_main_queue(), ^{
            [self showAlertWithTitle:errorAlert andMessage:errorDescription andActionTitle:ok actionHandler:^(UIAlertAction *action) {
                [[NSNotificationCenter defaultCenter] postNotificationName:LogoutNotification object:nil];
                [self.tabBarController.navigationController popViewControllerAnimated:YES];
            }];
            
        });
    }
}




@end
