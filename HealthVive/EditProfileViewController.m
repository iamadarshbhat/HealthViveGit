//
//  EditProfileViewController.m
//  HealthVive
//
//  Created by Sriram Sadhasivan (BLR GSS) on 23/01/17.
//  Copyright © 2017 NousInfosystems. All rights reserved.
//

#import "EditProfileViewController.h"
#import "ContactDetailsCell.h"
#import "APIHandler.h"
#import "CoreDataManager.h"
#import "Profile+CoreDataProperties.h"
#import "Consumer.h"
#import "ConsumerProfileViewController.h"
#import "Globals.h"

@interface EditProfileViewController ()
{
  
     CGFloat screenHeight;
     NSMutableArray *popUptitleArray;
     NSMutableArray *genderArray;
     BOOL isDropDown;
    NSUserDefaults *defaults;
    BOOL isFornemaSurnameEntered;
    NSString *foreNameStr;
    NSString *surNameStr;
    
    
    //edit Profile parameters
     NSString  *title;
     NSString  *fore_name;
     NSString  * sur_name;
     NSString  * dob;
     NSString  * gender;
     NSString  * address1;
     NSString  * address2;
     NSString  * city;
     NSString  *post_code;
     NSString  * country;
     NSString  * home_phone;
     NSString  * mobile_phone;
     NSString  * email;
     NSString *alternate_email;
     NSString *town;
    NSString  * dobString;
    NSDate *dobDate;
    
    Consumer *consumer;
    Globals *global;
    CoreDataManager *cdm;
    UITapGestureRecognizer *tapGesture;
    NSString *dateStringCompare;
    
}
@property (weak, nonatomic) IBOutlet UITextField *addressTxtFld;
@property (nonatomic,strong)NSManagedObjectContext *managedObjectContext;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableViewHeightConstraint;

@end

@implementation EditProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    

     _foreNametextField.delegate = self;
     _surnameTxtField.delegate = self;
     _addressTxtFld.delegate = self;
     _address2TxtFld.delegate = self;
     _postCodeTxtfld.delegate = self;
     _townCityTxtFld.delegate = self;
     _mobileTxtFld.delegate = self;
     _homephoneTxtFld.delegate = self;
     _alternateEmailTxtFld.delegate = self;
    
  
    _foreNameErrorTextView.hidden = YES;
    _foreNameErrorTextView.delegate = self;
    _foreNameErrorTextView.editable = NO;
    tapGesture =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapGestureSelected:)];
    [_foreNameErrorTextView addGestureRecognizer:tapGesture];
    tapGesture.numberOfTouchesRequired = 1;
    
    
    cdm =[CoreDataManager sharedManager];
    
    global =[Globals sharedManager];
    

    popUptitleArray =[[NSMutableArray alloc]initWithObjects:@"Mr",@"Mrs",@"Miss",@"Ms", nil];
    genderArray =[[NSMutableArray alloc]initWithObjects:@"Male",@"Female",@"Others",nil];
    
    defaults =[NSUserDefaults standardUserDefaults];
    [defaults synchronize];
    
    consumer =[[Consumer alloc]init];
   
      [self setNaviagationBarWithTitle:EditProfileNavBarTitle];
      [self setCalendarForMaximumDate];
    
    UIBarButtonItem *rightBarButton =[[UIBarButtonItem alloc] initWithTitle:@"Save" style:UIBarButtonItemStylePlain target:self action:@selector(saveBtnClicked)];
    rightBarButton.tintColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = rightBarButton;
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    screenHeight = screenRect.size.height;
    
    
    [self fetchConsumerDetailsFromDataBase];
    
    
    [self applyColorToPlaceHolderTextField:_foreNametextField];
    [self applyColorToPlaceHolderTextField:_surnameTxtField];
    [self applyColorToPlaceHolderTextField:_addressTxtFld];
    [self applyColorToPlaceHolderTextField:_address2TxtFld];
    [self applyColorToPlaceHolderTextField:_townCityTxtFld];
    [self applyColorToPlaceHolderTextField:_postCodeTxtfld];
    [self applyColorToPlaceHolderTextField:_mobileTxtFld];
    [self applyColorToPlaceHolderTextField:_homephoneTxtFld];
    [self applyColorToPlaceHolderTextField:_alternateEmailTxtFld];

    
    if (screenHeight == 568) {
        _titleBtn.imageEdgeInsets=UIEdgeInsetsMake(3, 60, 0, 0);
        _genderBtn.imageEdgeInsets = UIEdgeInsetsMake(3, 70, 0, 0);
        _countryBtn.imageEdgeInsets = UIEdgeInsetsMake(3, 250, 0, 0);
    }
    else if (screenHeight == 736)
    {
        _titleBtn.imageEdgeInsets=UIEdgeInsetsMake(3, 60, 0, 0);
        _genderBtn.imageEdgeInsets = UIEdgeInsetsMake(3, 70, 0, 0);
        _countryBtn.imageEdgeInsets = UIEdgeInsetsMake(2,330, 0, 0);
    }
   
    [super setScrollView:_editScrollView andTextField:activeTextField];
    _popUpTableView.hidden = YES;
    _datePickerView.hidden = YES;
    
 
    
    consumerId = global.consumerId;
    
    
}
-(void)tapGestureSelected:(UITapGestureRecognizer*)tap
{
    _foreNameErrorTextView.hidden = YES;
    [self applyColorToPlaceHolderTextField:_foreNametextField withplaceHolderText:@"Forename*"];
}
-(void)applyColorToPlaceHolderTextField:(UITextField *)textField{
    UIColor *color = [UIColor colorWithRed:51.0/255.0 green:51.0/255.0 blue:51.0/255.0 alpha:0.5];
    textField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:textField.placeholder attributes:@{NSForegroundColorAttributeName: color}];
}
-(void)applyColorToPlaceHolderTextField:(UITextField *)textField withplaceHolderText:(NSString*)placHolderText{
    UIColor *color = [UIColor colorWithRed:51.0/255.0 green:51.0/255.0 blue:51.0/255.0 alpha:0.5];
    textField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:placHolderText attributes:@{NSForegroundColorAttributeName: color}];
}
-(void)backButtonClicked
{
    [self.navigationController popViewControllerAnimated:YES];
}
//Validataions
#pragma mark Text Field Delegate methods
-(void)textFieldDidBeginEditing:(UITextField *)textField{
    if(textField == _foreNametextField){
        [_foreNametextField setPlaceholder:@"Forename*"];
    }
    if (textField == _surnameTxtField){
        [_surnameTxtField setPlaceholder:@"Surname*"];
    }
    if (textField == _addressTxtFld){
        [_addressTxtFld setPlaceholder:@"Please enter the address1 (Title)"];
    }

    if (textField == _address2TxtFld){
        [_address2TxtFld setPlaceholder:@" Please enter the address2 (Number and Street)"];
    }

     if (textField == _townCityTxtFld){
        [_townCityTxtFld setPlaceholder:@" Please enter the town/city"];
    }
    if (textField == _postCodeTxtfld){
        [_postCodeTxtfld setPlaceholder:@"Please enter the post code"];
    }

     if (textField == _mobileTxtFld){
        [_mobileTxtFld setPlaceholder:@" Please enter the mobile phone"];
    }

     if (textField == _homephoneTxtFld){
        [_homephoneTxtFld setPlaceholder:@" Please enter the home phone"];
    }
  
    if (textField == _alternateEmailTxtFld){
        [_alternateEmailTxtFld setPlaceholder:@"Please enter the alternate email"];
    }


    
    activeTextField = textField;
    
    
}
-(void)textFieldDidEndEditing:(UITextField *)textField{
    activeTextField = textField;
}


-(BOOL)textFieldShouldReturn:(UITextField *)textField{
     activeTextField = textField;
    [activeTextField resignFirstResponder];
    return true;
}



-(void)saveBtnClicked
{
    if ([self checkInternetConnection]) {
        if([self validateTextFields]&&[self validateDropdownDtatus])
        {
            [self callUpdateConsumerServices];
        }
    }
    else
    {
        [self showAlertWithTitle:errorAlert andMessage:editProfileOfflineError andActionTitle:ok actionHandler:^(UIAlertAction *action) {
            [self.navigationController popViewControllerAnimated:YES];
        }];
    }
    
}
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    NSUInteger newLength = [[self getTrimmedStringForString:textField.text] length] + [[self getTrimmedStringForString:string] length] - range.length;
    
    if (textField == _foreNametextField) {
        if (newLength >foreNameMaximumLength) {
            return false;
            }
        
        }
    else if (textField == _surnameTxtField) {
        if (newLength >surNameMaximumLength) {
            return false;
        }
    }else if (textField == _addressTxtFld) {
        if (newLength >addressFldMaxLenght) {
            return false;
        }
    }
    else if (textField == _address2TxtFld) {
        if (newLength >addressFldMaxLenght) {
            return false;
        }
    }
    else if (textField == _townCityTxtFld) {
        if (newLength >townMaxlength) {
            return false;
        }
    }
    else if (textField == _postCodeTxtfld) {
        if (newLength >postCodeMaxLength) {
            return false;
        }
    }
    else if (textField == _mobileTxtFld) {
        if (newLength >phoneNumMaxLength) {
            return false;
        }
    }
    else if (textField == _homephoneTxtFld) {
        if (newLength >phoneNumMaxLength) {
            return false;
        }
    }
    else if (textField == _alternateEmailTxtFld) {
        if (newLength >altEmailMaxlength) {
            return false;
        }
    }

    
    
    if(range.length + range.location > textField.text.length)
    {
        return NO;
    }
    return YES;
    
}

-(BOOL)validateTextFields
{
    BOOL validate = YES;
    
    if (_foreNametextField.text.length == 0 && _surnameTxtField.text.length ==0) {
        _foreNameErrorTextView.hidden = NO;
        [self applyColorToPlaceHolderTextForError:_foreNametextField withErrorMessage:foreNameInlineError];
          [self applyColorToPlaceHolderTextForError:_surnameTxtField withErrorMessage:surNameInlineError];
        validate = false;
    }
    if (_foreNametextField.text.length == 0 || _foreNametextField.text.length <forNameMininmumLength || _foreNametextField.text.length >foreNameMaximumLength) {
        

        _foreNameErrorTextView.hidden = NO;
        [self applyColorToPlaceHolderTextForError:_foreNametextField withErrorMessage:foreNameInlineError];
        validate = false;
    }

    if (_surnameTxtField.text.length == 0 || _surnameTxtField.text.length<surNameMininmumLength) {
        
        [self applyColorToPlaceHolderTextForError:_surnameTxtField withErrorMessage:surNameInlineError];
          validate = false;
    }
    
    if (_addressTxtFld.text.length >0) {
        
        if ( _addressTxtFld.text.length<addressFldMinLenght || _addressTxtFld.text.length >addressFldMaxLenght) {
            
            [self applyColorToPlaceHolderTextForError:_addressTxtFld withErrorMessage:addres1InlineError];
            validate = false;
        }
        
    }
      if (_address2TxtFld.text.length >0) {
        
        if ( _address2TxtFld.text.length<addressFldMinLenght || _address2TxtFld.text.length >addressFldMaxLenght) {
            
            [self applyColorToPlaceHolderTextForError:_address2TxtFld withErrorMessage:addres2InlineError];
            validate = false;
        }
        
    }
    if (_townCityTxtFld.text.length >0) {
        
        if ( _townCityTxtFld.text.length<townMinlength || _townCityTxtFld.text.length >townMaxlength) {
            
            [self applyColorToPlaceHolderTextForError:_townCityTxtFld withErrorMessage:townInlineError];
            validate = false;
        }
        
    }
    
     if (_mobileTxtFld.text.length >0) {
        
        if ( _mobileTxtFld.text.length<phoneNumMinLength || _mobileTxtFld.text.length >phoneNumMaxLength) {
            
            [self applyColorToPlaceHolderTextForError:_mobileTxtFld withErrorMessage:mobilePhoneInlineError];
           validate = false;
        }
        else
        {
            if (![self numberValidation:_mobileTxtFld.text]) {
                [self applyColorToPlaceHolderTextForError:_mobileTxtFld withErrorMessage:mobilePhoneInlineError];
                 validate = false;
            }
            
        }
        
    }
     if (_homephoneTxtFld.text.length >0) {
        
        if ( _homephoneTxtFld.text.length<phoneNumMinLength || _homephoneTxtFld.text.length >phoneNumMaxLength) {
            
            [self applyColorToPlaceHolderTextForError:_homephoneTxtFld withErrorMessage:homePhoneInlineError];
             validate = false;
        }
        else
        {
            if (![self  numberValidation:_homephoneTxtFld.text]) {
                [self applyColorToPlaceHolderTextForError:_homephoneTxtFld withErrorMessage:homePhoneInlineError];
                validate = false;
            }
            
        }
        
    }
    if (_alternateEmailTxtFld.text.length >0) {
        
        if ( _alternateEmailTxtFld.text.length<altEmaiMinLength || _alternateEmailTxtFld.text.length >altEmailMaxlength) {
            
            [self applyColorToPlaceHolderTextForError:_alternateEmailTxtFld withErrorMessage:alternateEmailInlineError];
            validate = false;
            
        }
        else if (![self IsValidEmail:_alternateEmailTxtFld.text]) {
            [self applyColorToPlaceHolderTextForError:_alternateEmailTxtFld withErrorMessage:alternateEmailInlineError];
            validate = false;
            
        }
    }
    if (_postCodeTxtfld.text.length == 0 ) {
        
        [self applyColorToPlaceHolderTextForError:_postCodeTxtfld withErrorMessage:postCodeInlineError];
        return  false;
    }
    else if (_postCodeTxtfld.text.length > 0)
    {
        if (_postCodeTxtfld.text.length<postCodeMinLength || _postCodeTxtfld.text.length >postCodeMaxLength) {
            [self applyColorToPlaceHolderTextForError:_postCodeTxtfld withErrorMessage:postCodeInlineError];
            validate = false;
        }
        else
        {
            if (![self isAlphaNumericOnly:_postCodeTxtfld.text]) {
                [self applyColorToPlaceHolderTextForError:_postCodeTxtfld withErrorMessage:postCodeInlineError];
                validate = false;
            }
        }
        
    }

    return validate;
}
-(BOOL)validateDropdownDtatus
{
    
    if([_titleBtn.titleLabel.text isEqualToString:@"Title*"]){
        self.navigationItem.rightBarButtonItem.enabled = NO;
        return false;
    }
    else if([_genderBtn.titleLabel.text isEqualToString:@"Gender*"]){
        
        self.navigationItem.rightBarButtonItem.enabled = NO;
        return  false;
    }
    else if([_dobBtn.titleLabel.text isEqualToString:@"Date of birth*"]){
        
      self.navigationItem.rightBarButtonItem.enabled = NO;
        
        return  false;
    }
    else{
        self.navigationItem.rightBarButtonItem.enabled = YES;
        return true;
    }
}


-(void)callUpdateConsumerServices
{
    
    NSString *token =[defaults valueForKey:access_tokenKey];
    //    NSString *dateOfBirth = dob;
    //consumer.id = cId;
    consumer.consumerId = consumerId;
    consumer.emailId =email;
    consumer.title = _titleBtn.currentTitle;
    consumer.foreName = _foreNametextField.text;
    consumer.surName =_surnameTxtField.text;
    consumer.gender = _genderBtn.currentTitle;
    consumer.dob = dob;
    consumer.address1 = _addressTxtFld.text;
    consumer.address2 = _address2TxtFld.text;
    consumer.city =_townCityTxtFld.text;
    consumer.post_code = _postCodeTxtfld.text;
    consumer.country =_countryBtn.currentTitle;
    consumer.home_phone = _homephoneTxtFld.text;
    consumer.mobile_phone = _mobileTxtFld.text;
    consumer.alternate_email = _alternateEmailTxtFld.text;
    
    
    NSDictionary *dict =[[NSDictionary alloc]initWithObjectsAndKeys:[NSNumber numberWithInteger:consumer.cid],@"ID",[NSNumber numberWithInteger:consumer.cid],@"ConsumerID",consumer.emailId,@"EmailID",consumer.title,@"Title",consumer.foreName,@"ForeName",consumer.surName,@"LastName",consumer.gender,@"Gender",consumer.dob,@"DateOfBirth",consumer.address1,@"Address1",consumer.address2,@"Address2",consumer.city,@"City",consumer.post_code,@"PostCode",consumer.country,@"Country",consumer.home_phone,@"HomePhoneNumber",consumer.mobile_phone,@"MobilePhoneNumber",consumer.alternate_email,@"AltEmailID",nil];
    
    NSError *writeError = nil;
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:&writeError];
    NSLog(@"%@",writeError);
    
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    NSLog(@"%@",jsonString);
    
    if ([self checkInternetConnection]) {
        
        APIHandler *reqHandler =[[APIHandler alloc]init];
        NSString *url = [NSString stringWithFormat:@"%@%@",BaseURL,upDateConsumerprofile];
        
        [self showProgressHudWithText:@"Saving ..."];
        [reqHandler makeRequestByPost:jsonString serverUrl:url withAccessToken:token completion:^(NSDictionary *result, NSError *error) {
            
            if (error == nil) {
                BOOL isSuccessfull =[[result valueForKey:@"IsSuccessful"] boolValue];
                if ( isSuccessfull == YES) {
                    
                    
                    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                        
                        
                        [self updateConsumerEditedDetails];
                      
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [self hideProgressHud];
                        [self.navigationController popViewControllerAnimated:YES];
                        });
                    });
                }
            
            }
            else
            {
                [self handleServerError:error];
            }
        }];
    }
    
    
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.

}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
        if (isDropDown == YES) {
           return popUptitleArray.count;
        }
        else{
            return genderArray.count;
        }
        
  }

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
     static NSString *cellIdentifier =@"Cell";
  
    UITableViewCell *popUpCell =[tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
        
        if (!popUpCell) {
            popUpCell =[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
           }
        [popUpCell setBackgroundColor:[UIColor whiteColor]];
        popUpCell.textLabel.textAlignment = NSTextAlignmentCenter;
        
        NSString *titlestring;
        if (isDropDown == YES) {
            
            titlestring = [popUptitleArray objectAtIndex:indexPath.row];
        }
        else
        {
             titlestring = [genderArray objectAtIndex:indexPath.row];
        }
        popUpCell.textLabel.text = titlestring;
        
        return popUpCell;
        
  }

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
   
  if (isDropDown == YES) {
           NSString *btnTitle =[popUptitleArray objectAtIndex:indexPath.row];
           [_titleBtn setTitle:btnTitle forState:UIControlStateNormal];
           isDropDown = NO;
      [self validateDropdownDtatus];
       }
       else{
           NSString *btnTitle =[genderArray objectAtIndex:indexPath.row];
           [_genderBtn setTitle:btnTitle forState:UIControlStateNormal];
           isDropDown = YES;
           [self validateDropdownDtatus];
       }
    [self removePopupView:_popUpTableView];
    
}


-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
     [activeTextField resignFirstResponder];
    [_foreNametextField resignFirstResponder];
    [_surnameTxtField resignFirstResponder];
    [_addressTxtFld resignFirstResponder];
    [_address2TxtFld resignFirstResponder];
    [_townCityTxtFld resignFirstResponder];
    [_postCodeTxtfld resignFirstResponder];
    [_homephoneTxtFld resignFirstResponder];
    [_mobileTxtFld resignFirstResponder];
    [_alternateEmailTxtFld resignFirstResponder];
   
    
    [self removePopupView:_popUpTableView];
     [self removePopupView:_datePickerView];
   
    
}
- (IBAction)titleBtnClicked:(id)sender {
    [activeTextField resignFirstResponder];
    _popUpTableView.delegate = self;
    _popUpTableView.dataSource = self;
    self.popUpTitleLbl.text = @"Title";
    _tableViewHeightConstraint.constant = 240;
    [_popUpTableView needsUpdateConstraints];
    isDropDown = YES;
    [self addPopupView:_popUpTableView];
    [_popUpTableView reloadData];
 
   }
- (IBAction)genderBtnCkicked:(id)sender {
     [activeTextField resignFirstResponder];
    isDropDown = NO;
    _popUpTableView.delegate = self;
    _popUpTableView.dataSource = self;
    self.popUpTitleLbl.text = @"Gender";
    _tableViewHeightConstraint.constant = 195;
    [_popUpTableView needsUpdateConstraints];
      [self addPopupView:_popUpTableView];
    [_popUpTableView reloadData];
   
    
}
- (IBAction)dobBtnClicked:(id)sender {
     [activeTextField resignFirstResponder];
    _datePickerView.hidden = NO;
    [_datePicker setDate:dobDate];
    [self addPopupView:_datePickerView];
    
}
//Sets Calander to 16 years back
-(void)setCalendarForMaximumDate{
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDate *currentDate = [NSDate date];
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    [comps setYear:-maximumYear];
    NSDate *maxDate = [gregorian dateByAddingComponents:comps toDate:currentDate  options:0];
    _datePicker.maximumDate = maxDate;
}

- (IBAction)dateOkAction:(id)sender {
    
    dob = [self getDateString:_datePicker.date withFormat:@"yyyy/MM/dd"];
    dobString =[self getDateString:_datePicker.date withFormat:@"dd/MM/yyyy"];
    [_dobBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [_dobBtn setTitle:dobString forState:UIControlStateNormal];
    [self removePopupView:_datePickerView];
    [self validateDropdownDtatus];
  
}
- (IBAction)dateCancelAction:(id)sender {
    
     [self removePopupView:_datePickerView];
}


//Fetch Consumer Data ffrrom Databse
- (IBAction)countryBtnAction:(id)sender {
    
    [_countryBtn setTitle:@"UK" forState:UIControlStateNormal];
}

-(void)fetchConsumerDetailsFromDataBase
{
    
    consumerId =  global.consumerId;
    
     NSPredicate *predicate = [NSPredicate predicateWithFormat:@"consumer_id = %ld",(long)consumerId];
       NSArray *profileArray =[cdm fetchDataFromEntity:profileEntity predicate:predicate];
    
 if (profileArray.count>0) {
          Profile *profile = [profileArray lastObject];
        _foreNametextField.text = profile.fore_name;
        _surnameTxtField.text = profile.sur_name;
        _address2TxtFld.text = profile.address2;
        _addressTxtFld.text = profile.address1;
        _townCityTxtFld.text = profile.city;
        _postCodeTxtfld.text = profile.post_code;
        _mobileTxtFld.text= profile.mobile_phone;
        _homephoneTxtFld.text = profile.home_phone;
        _alternateEmailTxtFld.text = profile.alternate_email;
      
    
        //cId = profile.consumer_id;
       dobDate = profile.dob;
        NSString *dateString= [self getDateString:dobDate withFormat:@"dd/MM/yyyy"];
      dob= [self getDateString:profile.dob withFormat:@"yyyy/MM/dd"];
     dateStringCompare = [self getDateString:profile.dob withFormat:@"yyyy/MM/dd"];
         email = profile.email;
      if (profile.country == nil) {
          [_countryBtn  setTitle:@"Country" forState:UIControlStateNormal];
      }
      else{
           [_countryBtn  setTitle:profile.country forState:UIControlStateNormal];
      }
      
      
        [_dobBtn  setTitle:dateString forState:UIControlStateNormal];
        [_genderBtn  setTitle:profile.gender forState:UIControlStateNormal];
        [_titleBtn setTitle:profile.title forState:UIControlStateNormal];
      
      [self validateDropdownDtatus];
      
    }
    else
    {
        [self validateDropdownDtatus];
        
    }
    
}


//Saving Consumer Details into Database
-(void)updateConsumerEditedDetails
{
  
  NSPredicate *predicate = [NSPredicate predicateWithFormat:@"consumer_id = %ld",consumerId];
  
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setValue:consumer.title forKey:@"title"];
    [dict setValue:consumer.foreName forKey:@"fore_name"];
    [dict setValue:consumer.surName forKey:@"sur_name"];
    
    if ([dateStringCompare isEqual:consumer.dob]) {
         [dict setValue:dobDate forKey:@"dob"];
    }
    else
    {
        [dict setValue:_datePicker.date forKey:@"dob"];
        
    }
    
   
    [dict setValue:consumer.gender forKey:@"gender"];
    [dict setValue:consumer.address1 forKey:@"address1"];
    [dict setValue:consumer.address2 forKey:@"address2"];
    [dict setValue:consumer.city forKey:@"city"];
    [dict setValue:consumer.post_code forKey:@"post_code"];
    [dict setValue:consumer.country forKey:@"country"];
    [dict setValue:consumer.home_phone forKey:@"home_phone"];
    [dict setValue:consumer.mobile_phone forKey:@"mobile_phone"];
    [dict setValue:consumer.alternate_email forKey:@"alternate_email"];
    [dict setValue:[NSNumber numberWithUnsignedInteger:consumerId] forKey:@"consumer_id"];
   
    [cdm updateDeatailsToEntity:profileEntity andPredicate:predicate andValues:dict];

    }
-(BOOL)isAlphaNumericOnly:(NSString *)input
{
    NSString *alphaNum = @"[a-zA-Z0-9]+";
    NSPredicate *regexTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", alphaNum];
    
    return [regexTest evaluateWithObject:input];
}

@end
