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
    titleTable.hidden = true;
    datePickerPopupView.hidden = true;
    [btnSelectDate setTitle:buttonSelectDateStr forState:UIControlStateNormal];
    [btnTitle setTitle:buttonTitleStr forState:UIControlStateNormal];
    [self setCalendarForMaximumDate];
    titlesArray = [NSArray arrayWithObjects:@"Mr",@"Mrs",@"Miss",@"Sir", nil];
    [self setImageAndTextInsetsToButton:btnTitle andImage:[UIImage imageNamed:dropDown] withLeftSpace:0.0];
    [self setImageAndTextInsetsToButton:btnSelectDate andImage:[UIImage imageNamed:datePickerImage] withLeftSpace:0.0];
    [self makeGenderButtonDeSelected:btnMale];
    [self makeGenderButtonDeSelected:btnFemale];
    [self makeGenderButtonDeSelected:btnOther];
    [self setButtonEnabled:NO forButton:btnRegister];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (IBAction)dateOkAction:(id)sender {
    NSString *dateStr = [self getDateString:datePickerView.date withFormat:@"dd/MM/yyyy"];
    [btnSelectDate setTitle:dateStr forState:UIControlStateNormal];
    [self removePopupView:datePickerPopupView];
    [self validateForm];
}

- (IBAction)dateCancelAction:(id)sender {
     [self removePopupView:datePickerPopupView];
     [self validateForm];
}

- (IBAction)titleClickAction:(id)sender {
    titleTable.hidden = false;
    [self addPopupView:titleTable];
    [self validateForm];
}
//Pop back to the previous View controller
- (IBAction)backButtonAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)selectDateAction:(id)sender {
    [self addPopupView:datePickerPopupView];
}

- (IBAction)registerBtnAction:(id)sender {
    
    if([self validateForm]){
        [self registerConsumer];
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
}
-(void)textFieldDidEndEditing:(UITextField *)textField{
    activeTextField = textField;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return true;
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    [self validateForm];
    NSUInteger newLength = [[self getTrimmedStringForString:textField.text] length] + [[self getTrimmedStringForString:string] length] - range.length;
    
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

//Validates all fields
-(BOOL)validateForm{
    foreNameStr = [self getTrimmedStringForString:txtForeName.text];
    surNameStr = [self getTrimmedStringForString:txtSurName.text];
    
    if([btnTitle.titleLabel.text isEqualToString:buttonTitleStr]){
        return false;
    }else if ([btnSelectDate.titleLabel.text isEqualToString:buttonSelectDateStr]){
        return false;
    }else if (selectedGender == nil){
        return false;
    }else if (foreNameStr ==nil || [foreNameStr isEqualToString:@""]){
        return false;
    }else if (txtSurName == nil || [surNameStr isEqualToString:@""]){
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
    
    

    APIHandler *reqHandler =[[APIHandler alloc] init];
    
    [reqHandler makeRequestByPost:jsonString  serverUrl:httpRegisterConsumer completion:^(NSDictionary *result, NSError *error) {

        if ( error == nil) {
            NSLog(@"result -%@",result);
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
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

@end
