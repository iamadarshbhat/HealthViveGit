//
//  RegistrationEssentialController.m
//  HealthVive
//
//  Created by Adarsha on 19/01/17.
//  Copyright © 2017 NousInfosystems. All rights reserved.
//

#import "RegistrationEssentialController.h"




@interface RegistrationEssentialController (){
    NSArray *titlesArray;
    NSDate *selectedDate;
    UITextField *activeTextField;
    NSString *selectedGender;
    NSString *foreNameStr;
    NSString *surNameStr;
    BOOL isFornemaSurnameEntered;
    
}

@end

@implementation RegistrationEssentialController
@synthesize titleTable;
@synthesize btnTitle;
@synthesize btnMale;
@synthesize btnFemale;
@synthesize btnOther;
@synthesize btnSelectDate;
@synthesize datePickerView;
@synthesize datePickerPopupView;
@synthesize txtSurName;
@synthesize txtForeName;
@synthesize btnRegister;
@synthesize consumerToRegister;

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    UITapGestureRecognizer *singleFingerTap =
    [[UITapGestureRecognizer alloc] initWithTarget:self
                                            action:@selector(handleSingleTap:)];
    [self.blurredView addGestureRecognizer:singleFingerTap];
    titleTable.hidden = true;
    datePickerPopupView.hidden = true;
    [btnSelectDate setTitle:buttonSelectDateStr forState:UIControlStateNormal];
    [btnTitle setTitle:buttonTitleStr forState:UIControlStateNormal];
    [self setCalendarForMaximumDate];
    titlesArray = [NSArray arrayWithObjects:@"Mr",@"Mrs",@"Miss",@"Ms", nil];
    [self setImageAndTextInsetsToButton:btnTitle andImage:[UIImage imageNamed:dropDown] withLeftSpace:0.0];
   // [self setImageAndTextInsetsToButton:btnSelectDate andImage:[UIImage imageNamed:datePickerImage] withLeftSpace:-30.0];
    [self fixButtonImages];
    [self makeGenderButtonDeSelected:btnMale];
    [self makeGenderButtonDeSelected:btnFemale];
    [self makeGenderButtonDeSelected:btnOther];
    [self setButtonEnabled:NO forButton:btnRegister];
    [self applyColorToPlaceHolderText:txtForeName];
    [self applyColorToPlaceHolderText:txtSurName];
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)fixButtonImages{
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenHeight = screenRect.size.height;
    CGFloat screenWidth = screenRect.size.width;
    NSLog(@"screen widht %f an hedight %f",screenWidth,screenHeight);
    
    btnSelectDate.imageEdgeInsets=UIEdgeInsetsMake(0, screenWidth-70, 0, 0);
    btnSelectDate.titleEdgeInsets = UIEdgeInsetsMake(0, -20, 0, 0);
    

    
    
}

- (IBAction)dateOkAction:(id)sender {
    NSString *dateStr = [self getDateString:datePickerView.date withFormat:@"dd/MM/yyyy"];
    [btnSelectDate setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [btnSelectDate setTitle:dateStr forState:UIControlStateNormal];
    [self removePopupView:datePickerPopupView];
    [self validateForm];
}

- (IBAction)dateCancelAction:(id)sender {
     [self removePopupView:datePickerPopupView];
     [self validateForm];
}

- (IBAction)titleClickAction:(id)sender {
    [activeTextField resignFirstResponder];
    titleTable.hidden = false;
    [self addPopupView:titleTable];
    [self validateForm];
}
//Pop back to the previous View controller
- (IBAction)backButtonAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)selectDateAction:(id)sender {
    [activeTextField resignFirstResponder];
    selectedDate = datePickerView.date;
    [self addPopupView:datePickerPopupView];
}

- (IBAction)registerBtnAction:(id)sender {
    
    if([self validateForm]){
        
        if([self validateFirstnameAndSurName]){
            if([self checkInternetConnection]){
                [self registerConsumer];
            }else{
                 [self showAlertWithTitle:httpNoInternetAlert andMessage:httpConnectionProblemMsg andActionTitle:ok actionHandler:nil];
            }
            
        }
        
    }
}

- (IBAction)maleBtnAction:(id)sender {
    selectedGender = @"Male";
    [self makeGenderButtonSelected:btnMale];
    [self makeGenderButtonDeSelected:btnFemale];
    [self makeGenderButtonDeSelected:btnOther];
   [self validateForm];
    
}

- (IBAction)femaleBtnAction:(id)sender {
    selectedGender = @"Female";
    [self makeGenderButtonSelected:btnFemale];
    [self makeGenderButtonDeSelected:btnMale];
    [self makeGenderButtonDeSelected:btnOther];
    [self validateForm];
    
}

- (IBAction)otherBtnAction:(id)sender {
    selectedGender = @"Other";
    [self makeGenderButtonSelected:btnOther];
    [self makeGenderButtonDeSelected:btnFemale];
    [self makeGenderButtonDeSelected:btnMale];
    [self validateForm];
}

- (IBAction)dateValueChanged:(id)sender {
    selectedDate = datePickerView.date;
}

#pragma mark Table View Delegate methods
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:titleTableIdentifer];
   
    cell.textLabel.text =  [titlesArray objectAtIndex:indexPath.row];
    
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [titlesArray count];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
   
    [btnTitle setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [btnTitle setTitle:[titlesArray objectAtIndex:indexPath.row] forState:UIControlStateNormal];
    [self removePopupView:titleTable];
    [self validateForm];
}


//Changes the color of selected Gender button to red
-(void)makeGenderButtonSelected:(UIButton*)button{
    
    [self setTintColor:[UIColor colorWithRed:233.0/255.0f green:52.0/255.0f blue:52/255.0f alpha:1.0] toButton:button];
     [self setAlpha:1.0 toBtn:button];
    [self applyCornerColorToView:button withColor:[UIColor colorWithRed:233.0/255.0f green:52.0/255.0f blue:52/255.0f alpha:1]];
   
}
//Changes the color of deselected Gender button to gray
-(void)makeGenderButtonDeSelected:(UIButton*)button{
    
    [self setTintColor:[UIColor blackColor] toButton:button];
    [self setAlpha:0.3 toBtn:button];
    [self applyCornerColorToView:button withColor:[UIColor clearColor]];
}

//Sets Calander to 16 years back
-(void)setCalendarForMaximumDate{
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDate *currentDate = [NSDate date];
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    [comps setYear:-maximumYear];
    NSDate *maxDate = [gregorian dateByAddingComponents:comps toDate:currentDate  options:0];
    datePickerView.maximumDate = maxDate;
}

#pragma mark Text Field Delegate methods
-(void)textFieldDidBeginEditing:(UITextField *)textField{
    
    activeTextField = textField;
    [self applyColorToPlaceHolderText:activeTextField WithColor:[UIColor lightGrayColor]];
    
    if(textField == txtForeName){
        [txtForeName setPlaceholder:foreNamePlaceHolderText];
    }else if (textField == txtSurName){
        [txtSurName setPlaceholder:surNamePlaceHolderText];
    }
    
}
-(void)textFieldDidEndEditing:(UITextField *)textField{
    activeTextField = textField;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return true;
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{

    NSUInteger newLength = [[self getTrimmedStringForString:textField.text] length] + [[self getTrimmedStringForString:string] length] - range.length;
    
    if(textField == txtForeName){
        if (newLength == 0 || txtSurName.text.length == 0) {
            isFornemaSurnameEntered = false;
        }else{
            isFornemaSurnameEntered = true;

        }
    }else if(textField == txtSurName){
        if (newLength == 0 || txtForeName.text.length == 0) {
            isFornemaSurnameEntered = false;

        }else{
            isFornemaSurnameEntered = true;

        }
    }
    [self validateForm];
    
    
    if(range.length + range.location > textField.text.length)
    {
        return NO;
    }
    
    if(textField == txtForeName){
        return newLength <= foreNameMaximumLength;
    }else if (textField == txtSurName){
        return newLength <= surNameMaximumLength;
    }else{
        return false;
    }
}

-(BOOL)validateFirstnameAndSurName{
    BOOL flag = true;
    if(foreNameStr.length < 2){
        [self applyColorToPlaceHolderTextForError:txtForeName withErrorMessage:foreNameInlineError];
        flag = false;
    }
    if (surNameStr.length < 2){
        [self applyColorToPlaceHolderTextForError:txtSurName withErrorMessage:surNameInlineError];
        flag = false;
    }
    
    return  flag;
}


//Validates all fields
-(BOOL)validateForm{
    foreNameStr = [self getTrimmedStringForString:txtForeName.text];
    surNameStr = [self getTrimmedStringForString:txtSurName.text];
    
    if([btnTitle.titleLabel.text isEqualToString:buttonTitleStr]){
        [self setButtonEnabled:NO forButton:btnRegister];
        return false;
    }else if ([btnSelectDate.titleLabel.text isEqualToString:buttonSelectDateStr]){
        [self setButtonEnabled:NO forButton:btnRegister];
        return false;
    }else if (selectedGender == nil){
         [self setButtonEnabled:NO forButton:btnRegister];
        return false;
    }else if (foreNameStr ==nil || !isFornemaSurnameEntered){
         [self setButtonEnabled:NO forButton:btnRegister];
        return false;
    }else if (txtSurName == nil || !isFornemaSurnameEntered){
         [self setButtonEnabled:NO forButton:btnRegister];
        return false;
    }else if(!isFornemaSurnameEntered){
         [self setButtonEnabled:NO forButton:btnRegister];
        return false;
    }else{
       [self setButtonEnabled:YES forButton:btnRegister];
    }
    return true;
}

//Calls web API to post all data
-(void)registerConsumer{
    
    
    [consumerToRegister setTitle:btnTitle.titleLabel.text];
    [consumerToRegister setForeName:txtForeName.text];
    [consumerToRegister setSurName:txtSurName.text];
    [consumerToRegister setGender:selectedGender];
    [consumerToRegister setDob:[self getDateString:selectedDate withFormat:@"yyyy/MM/dd"]];

    NSError *writeError = nil;
    
    NSDictionary * dict = [consumerToRegister consumerDic:consumerToRegister];
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:&writeError];
    
    
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    NSLog(@"JSON String :%@",jsonString);

    APIHandler *reqHandler =[[APIHandler alloc] init];
    
    [self showProgressHudWithText:@"Registering..."];
      NSString *url =  [NSString stringWithFormat:@"%@%@",BaseURL,httpRegisterConsumer];
    [reqHandler makeRequestByPost:jsonString  serverUrl:url completion:^(NSDictionary *result, NSError *error) {

        if ( error == nil) {
            NSLog(@"result -%@",result);
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [self hideProgressHud];
                [self showAlertWithTitle:statusStr andMessage:successfullRegisterMsg andActionTitle:ok actionHandler:^(UIAlertAction *action){
                    [self popToRootView];
                }];
                
            });
        }
        else
        {
            dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                NSDictionary *errorObj =[error valueForKey:@"Error"];
                
              
                
                NSString *errorDescription = [errorObj valueForKey:@"error_description"];
                NSLog(@"errorDescription ....%@",errorDescription);
                if (errorDescription == nil || [errorDescription isEqualToString:@""]) {
                    errorDescription = internalError;
                }
                
                dispatch_async(dispatch_get_main_queue(), ^{
                     [self hideProgressHud];
                    [self showAlertWithTitle:statusStr andMessage:errorDescription andActionTitle:ok actionHandler:nil];
                });
            });
        }
    }];
}

//Pop back the view controller to root
-(void)popToRootView{
    [self.navigationController popToRootViewControllerAnimated:YES];
}


//The event handling method for Scrreen touch
- (void)handleSingleTap:(UITapGestureRecognizer *)recognizer {
    // CGPoint location = [recognizer locationInView:[recognizer.view superview]];
    if(datePickerPopupView !=nil){
        [self removePopupView:datePickerPopupView];

    }
    if(titleTable != nil){
       [self removePopupView:titleTable]; 
    }
    
    //Do stuff here...
}

@end
