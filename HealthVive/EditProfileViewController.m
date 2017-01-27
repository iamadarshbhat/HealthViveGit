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

@interface EditProfileViewController ()
{
  
     CGFloat screenHeight;
     NSMutableArray *popUptitleArray;
     NSMutableArray *genderArray;
     BOOL isDropDown;
    NSUserDefaults *defaults;
}
@property (weak, nonatomic) IBOutlet UITextField *addressTxtFld;

@end

@implementation EditProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    

   _foreNametextField.delegate = self;
   _surnameTxtField.delegate = self;
    
    

    popUptitleArray =[[NSMutableArray alloc]initWithObjects:@"Mr.",@"Mrs.",@"Miss",@"Ms.",@"Sir",@"Etc", nil];
    genderArray =[[NSMutableArray alloc]initWithObjects:@"Male",@"Female", nil];
    
    defaults =[NSUserDefaults standardUserDefaults];
    [defaults synchronize];
   
      [self setNaviagationBarWithTitle:@"Edit Profile"];
    
    
   
    UIImage*menuIcon = [UIImage imageNamed:@"backButton"];
    CGRect frameimg = CGRectMake(0, 0, menuIcon.size.width, menuIcon.size.height);
    UIButton *menuButton = [[UIButton alloc] initWithFrame:frameimg];
    [menuButton setBackgroundImage:menuIcon forState:UIControlStateNormal];
    [menuButton addTarget:self action:@selector(backButtonClicked)
         forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *leftBarButton =[[UIBarButtonItem alloc] initWithCustomView:menuButton];
    self.navigationItem.leftBarButtonItem = leftBarButton;
    
    
    
    UIBarButtonItem *rightBarButton =[[UIBarButtonItem alloc] initWithTitle:@"Save" style:UIBarButtonItemStylePlain target:self action:@selector(saveBtnClicked)];
    rightBarButton.tintColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = rightBarButton;
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    screenHeight = screenRect.size.height;
    if (screenHeight == 667) {
        
        _genderBtn.imageEdgeInsets = UIEdgeInsetsMake(3, 95, 0, 0);
    }
    else if (screenHeight == 736)
    {
        
        _genderBtn.imageEdgeInsets = UIEdgeInsetsMake(3, 110, 0, 0);
    }

    [super setScrollView:_editScrollView andTextField:_addressTxtFld];
    _popUpTableView.hidden = YES;
    _datePickerView.hidden = YES;
    

}

-(void)backButtonClicked
{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)saveBtnClicked
{
 
    
    NSString *upDateConsumerprofile =@"http://192.168.18.23/HealthViveService/api/account/UpdateConsumerProfile";
    NSString *token =[defaults valueForKey:@"access_token"];
    NSString *dateOfBirth = _dob;
    NSString *forName = _foreNametextField.text;
    NSString*surName =_surnameTxtField.text;
    NSString *gender = _genderBtn.currentTitle;
    NSString *postCode = @"560016";
    NSString *title = _titleBtn.currentTitle;
    
    NSError *writeError = nil;
    
    NSDictionary * dict = [[NSDictionary alloc] initWithObjectsAndKeys:title,@"Title",forName,@"ForeName",surName,@"LastName",gender,@"Gender",postCode,@"PostCode",dateOfBirth,@"DateOfBirth",nil];
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:&writeError];
    NSLog(@"%@",writeError);
    
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    NSLog(@"%@",jsonString);
    
    if ([self checkInternetConnection]) {

        APIHandler *reqHandler =[[APIHandler alloc]init];
        [reqHandler makeRequestByPost:jsonString serverUrl:upDateConsumerprofile withAccessToken:token completion:^(NSDictionary *result, NSError *error) {
            
            if (error == nil) {
                
                
                NSLog(@"%@",result);
            }
            else
            {
                NSLog(@"%@",error);
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
           NSString *title =[popUptitleArray objectAtIndex:indexPath.row];
           [_titleBtn setTitle:title forState:UIControlStateNormal];
           isDropDown = NO;
       }
       else{
           NSString *title =[genderArray objectAtIndex:indexPath.row];
           [_genderBtn setTitle:title forState:UIControlStateNormal];
           isDropDown = YES;
       }
    [self removePopupView:_popUpTableView];
    
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    return  [textField resignFirstResponder];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self removePopupView:_popUpTableView];
     [self removePopupView:_datePickerView];
    
}
- (IBAction)titleBtnClicked:(id)sender {
    _popUpTableView.delegate = self;
    _popUpTableView.dataSource = self;
    self.popUpTitleLbl.text = @"Title";
    isDropDown = YES;
    [self addPopupView:_popUpTableView];
    [_popUpTableView reloadData];
 
   }
- (IBAction)genderBtnCkicked:(id)sender {
    isDropDown = NO;
    _popUpTableView.delegate = self;
    _popUpTableView.dataSource = self;
    self.popUpTitleLbl.text = @"Gender";
      [self addPopupView:_popUpTableView];
    [_popUpTableView reloadData];
   
    
}
- (IBAction)dobBtnClicked:(id)sender {
    _datePickerView.hidden = NO;
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
    
    _dob = [self getDateString:_datePicker.date withFormat:@"dd/MM/yyyy"];
    [_dobBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [_dobBtn setTitle:_dob forState:UIControlStateNormal];
    [self removePopupView:_datePickerView];
}
- (IBAction)dateCancelAction:(id)sender {
    
     [self removePopupView:_datePickerView];
}

@end
