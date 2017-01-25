//
//  EditProfileViewController.m
//  HealthVive
//
//  Created by Sriram Sadhasivan (BLR GSS) on 23/01/17.
//  Copyright © 2017 NousInfosystems. All rights reserved.
//

#import "EditProfileViewController.h"
#import "ContactDetailsCell.h"

@interface EditProfileViewController ()
{
    NSMutableArray *titleArray;
     CGFloat screenHeight;
     NSMutableArray *popUptitleArray;
    NSMutableArray *genderArray;
    BOOL isDropDown;
}

@end

@implementation EditProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _contactDetailsTableView.delegate = self;
    _contactDetailsTableView.dataSource = self;
   _foreNametextField.delegate = self;
    _surnameTxtField.delegate = self;
    
  

    
    titleArray =[[NSMutableArray alloc]initWithObjects:@"Address1 (Title)", @"Address2(Number and Street.)",@"Town/City",@"PostCode*",@"Country",@"Home phone",@"Mobile Phone",@"Alternate Email",nil];

    popUptitleArray =[[NSMutableArray alloc]initWithObjects:@"Mr.",@"Mrs.",@"Miss",@"Ms.",@"Sir",@"Etc", nil];
    genderArray =[[NSMutableArray alloc]initWithObjects:@"Male",@"Female", nil];
   
    self.navigationController.navigationBar.hidden =NO;
    self.navigationItem.title = @"Edit";
    self.navigationItem.hidesBackButton = YES;
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName : [UIColor whiteColor]};
    self.navigationController.navigationBar.barTintColor = NAVBAR_BCG_COLOR;
    self.navigationController.navigationBar.translucent = NO;
    
    
   
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

    self.blurView.hidden = YES;
  

}

-(void)backButtonClicked
{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)saveBtnClicked
{
  
  
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
    if (tableView == _popUpTableView) {
        
        if (isDropDown == YES) {
           return popUptitleArray.count;
        }
        else{
            return genderArray.count;
        }
        
    }
    else if(tableView == _contactDetailsTableView){
        
        return titleArray.count;
    }
    
    return 0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
     static NSString *cellIdentifier =@"Cell";
  
    if (tableView  == _popUpTableView) {
       
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
    else {
        
        ContactDetailsCell *contactDetailcell =[tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
        
        if (!contactDetailcell) {
            contactDetailcell =[[ContactDetailsCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
            contactDetailcell.contactEditTextField.delegate = self;
        }
        
        contactDetailcell.contactEditTextField.delegate = self;
        contactDetailcell.contactEditTextField.tag = indexPath.row;
          [super setScrollView:_editScrollView andTextField:contactDetailcell.contactEditTextField];
        if (indexPath.row == 4) {
            
            contactDetailcell.countryBtn.hidden =NO;
            contactDetailcell.contactEditTextField.hidden = YES;
            if (screenHeight == 667) {
                
                contactDetailcell.countryBtn.imageEdgeInsets = UIEdgeInsetsMake(5, 310, 0, 0);
            }
            else if (screenHeight == 736)
            {
                contactDetailcell.countryBtn.imageEdgeInsets = UIEdgeInsetsMake(5, 350, 0, 0);
            }
            
            
            [contactDetailcell.countryBtn setTitle:[titleArray objectAtIndex:indexPath.row] forState:UIControlStateNormal];
            
        }
        else
        {   contactDetailcell.countryBtn.hidden =YES;
            contactDetailcell.contactEditTextField.hidden = NO;
            contactDetailcell.contactEditTextField.placeholder =[titleArray objectAtIndex:indexPath.row];
        }
        
        return contactDetailcell;
    }
    
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
   
   if (tableView == _popUpTableView) {
        self.editScrollView.scrollEnabled = YES;
        self.blurView.hidden =YES;
       
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
       
      }
    
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    return  [textField resignFirstResponder];
}
- (IBAction)titleBtnClicked:(id)sender {
    _popUpTableView.delegate = self;
    _popUpTableView.dataSource = self;
    self.blurView.hidden = NO;
   // [self addPopupView:_popUpTableView];
     self.popUpTitleLbl.text = @"Title";
    isDropDown = YES;
    [self.blurView setBackgroundColor:[UIColor colorWithWhite:0.0 alpha:0.4]];
    self.editScrollView.scrollEnabled = NO;
    self.contactDetailsTableView.userInteractionEnabled = NO;
    [_popUpTableView reloadData];
 
   }
- (IBAction)genderBtnCkicked:(id)sender {
    isDropDown = NO;
    _popUpTableView.delegate = self;
    _popUpTableView.dataSource = self;
    self.blurView.hidden = NO;
   //  [self addPopupView:_popUpTableView];
    self.popUpTitleLbl.text = @"Gender";
    [self.blurView setBackgroundColor:[UIColor colorWithWhite:0.0 alpha:0.4]];
   self.editScrollView.scrollEnabled = NO;
    self.contactDetailsTableView.userInteractionEnabled = NO;

    [_popUpTableView reloadData];
   
    
}


@end
