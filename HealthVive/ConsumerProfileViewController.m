//
//  ConsumerProfileViewController.m
//  HealthVive
//
//  Created by Sriram Sadhasivan (BLR GSS) on 20/01/17.
//  Copyright © 2017 NousInfosystems. All rights reserved.
//

#import "ConsumerProfileViewController.h"
#import "EditProfileViewController.h"
#import "ConsumerContactCell.h"
#import "CoreDataManager.h"
#import "Consumer.h"
#import "Globals.h"
#import "Account+CoreDataProperties.h"
#import "Profile+CoreDataClass.h"


@interface ConsumerProfileViewController ()
{
    NSMutableArray *titleArray;
    
    NSUserDefaults *defaults;
    
    int consumerId;
    Consumer *consumer;
    NSString *fullAddress;
    Globals *global;
    CoreDataManager *cdm;
    
   
   
}

@end

@implementation ConsumerProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    
    cdm = [CoreDataManager sharedManager];
    global =[Globals sharedManager];
    
    consumer = [[Consumer alloc]init];
    
   [self setNaviagationBarWithTitle:@"My Profile"];
    
   
    UIBarButtonItem *rightBarButton =[[UIBarButtonItem alloc] initWithTitle:@"Edit" style:UIBarButtonItemStylePlain target:self action:@selector(editBtnClicked)];
    rightBarButton.tintColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = rightBarButton;
    
    titleArray =[[NSMutableArray alloc] initWithObjects:@"Address",@"Home Phone",@"Mobile Phone",@"Alternate Email", nil];
    
    
    _consumeContactTable.delegate = self;
    _consumeContactTable.dataSource = self;
    
    self.profile_imageView.layer.cornerRadius = self.profile_imageView.frame.size.width / 2;
    self.profile_imageView.clipsToBounds = YES;
    
    self.addDetailsBtn.layer.cornerRadius = 5.0;
    [self.addDetailsBtn setBackgroundColor:NAVBAR_BCG_COLOR];
    
    defaults =[NSUserDefaults standardUserDefaults];
    [defaults synchronize];
    
//    UINavigationBar *navBar =[[UINavigationBar alloc]initWithFrame:CGRectMake(0, 0, self.navigationController.navigationBar.frame.size.width, self.navigationController.navigationBar.frame.size.height)];
//    [navBar setBarTintColor:NAVBAR_BCG_COLOR];
//    [self.navigationController.navigationBar  addSubview:navBar];
//    
//    UINavigationItem *navItem =[[UINavigationItem alloc]initWithTitle:@"My Profile"];
//    navItem.rightBarButtonItem = rightBarButton;
//    navBar.items = @[navItem];
  //  NSArray *controllerArray =[self.navigationController viewControllers];
    
   

}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
//    self.navigationController.navigationBarHidden = YES;
  [self setNaviagationBarWithTitle:MyProfileNavBarTitle];
    
    global =[Globals sharedManager];
    [self fetchEditedConumerDetails];
}
-(void)editBtnClicked
{
//    BOOL isOnline =[defaults boolForKey:loginStatus];
//    if (isOnline) {

        if ([self checkInternetConnection]) {
            
            EditProfileViewController *editProfile =[self.storyboard instantiateViewControllerWithIdentifier:EditProfileViewControllerID];
            editProfile.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:editProfile animated:YES];
        }
        else
        {
            [self showAlertWithTitle:errorAlert andMessage:editProfileOfflineError andActionTitle:ok actionHandler:nil];
            
        }
    }
//    else
//    {
//        [self showAlertWithTitle:errorAlert andMessage:editProfileOfflineError andActionTitle:ok actionHandler:^(UIAlertAction *action) {
//            
//            NSArray *controllerArray =[self.navigationController viewControllers];
//            dispatch_async(dispatch_get_main_queue(), ^{
//                
//                [self.navigationController popToRootViewControllerAnimated:NO];
//                
//            });
//            
//        }];
//        
//
//        
//    }


//}

    
   

- (IBAction)addDetailsBtnAction:(id)sender {
    
    if ([self checkInternetConnection]) {
        
        EditProfileViewController *editProfile =[self.storyboard instantiateViewControllerWithIdentifier:EditProfileViewControllerID];
         editProfile.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:editProfile animated:YES];
    }
    else
    {
        [self showAlertWithTitle:errorAlert andMessage:editProfileOfflineError andActionTitle:ok actionHandler:nil];
        
    }

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark- TableViewDataSource and Delegate Methods
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return titleArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier =@"Cell";
    ConsumerContactCell *cell =[tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    
    if (!cell) {
        cell =[[ConsumerContactCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
      
    }
    [self setUpCell:cell atIndexPath:indexPath];
    
    return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *description;
    CGFloat titleLblHeight = 21;
    CGFloat titleLblOffset = 2;
    CGFloat descLblOffset = 23;
    CGFloat descBottomOffset = 8;
    
    if (indexPath.row == 0) {
        
      description   = fullAddress;
    }
    if (indexPath.row ==1) {
        
       description = consumer.home_phone;
    }
    if (indexPath.row == 2) {
        
        description = consumer.mobile_phone;
    }
    if (indexPath.row == 3) {
        
        description = consumer.alternate_email;
    }
    if (description !=nil) {
        CGFloat height =[self heightForText:description font:[UIFont systemFontOfSize:20] withinSize:CGSizeMake(tableView.frame.size.width-descLblOffset, self.view.frame.size.height)];
        
        return  height+titleLblHeight+titleLblOffset+descLblOffset+descBottomOffset;

    }
    
    return 0;
}
// To extend the rows dynamically based on label text
- (CGFloat)heightForText:(NSString*)text font:(UIFont*)font withinSize:(CGSize)size {
    
    NSDictionary *attributes = @{NSFontAttributeName :font};
    NSMutableAttributedString* attrStr=[[NSMutableAttributedString alloc]initWithString:text attributes:attributes];
    
    CGRect frame = [attrStr boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading context:nil];
    
    return frame.size.height;
}

//setting data for  tableview rows
- (void)setUpCell:(ConsumerContactCell *)cell atIndexPath:(NSIndexPath *)indexPath {
   
    cell.titleLabel.text =[titleArray objectAtIndex:indexPath.row];
    
    if (indexPath.row == 0) {
        
        cell.descriptionLabel.text = fullAddress;
    }
    if (indexPath.row ==1) {
        
        cell.descriptionLabel.text = consumer.home_phone;
    }
    if (indexPath.row == 2) {
        
        cell.descriptionLabel.text = consumer.mobile_phone;
    }
    if (indexPath.row == 3) {
        
        cell.descriptionLabel.text = consumer.alternate_email;
    }
    

}



//Fetching Conumer Details from database
-(void)fetchEditedConumerDetails
{
    
    consumerId = global.consumerId;
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"consumer_id = %ld",(long)consumerId];
    NSArray *profileArray =[cdm fetchDataFromEntity:profileEntity predicate:predicate];

    
    if (profileArray.count>0) {
        Profile *profile = [profileArray lastObject];
        consumer.foreName = profile.fore_name;
        consumer.surName = profile.sur_name;
        consumer.address2 = profile.address2;
        consumer.address1 = profile.address1;
        consumer.city = profile.city;
        consumer.country = profile.country;
        consumer.post_code = profile.post_code;
        consumer.mobile_phone= profile.mobile_phone;
        consumer.home_phone = profile.home_phone;
        consumer.alternate_email = profile.alternate_email;
        consumer.gender = profile.gender;
        consumer.emailId = profile.email;
        
        NSString *cityS = consumer.city;
        NSString *addresswww=consumer.address2;
        NSLog(@"%@,%@",cityS,addresswww);
        
        if(consumer.post_code ==nil)
        {
            _consumeContactTable.hidden = YES;
            _addDetailsBtn.hidden = NO;
            _descriptionLabel.hidden = NO;
            _descriptionLabel.text =[NSString stringWithFormat:@"Hi %@,it looks like you haven’t added your contact details. Please ensure that you fill in as much as possible. The information is used to help verify your identity and allow you to connect with other HealthVive users in a safer and more secure way.",consumer.foreName];
            
        }
        else
        {
            _consumeContactTable.hidden = NO;
            _addDetailsBtn.hidden = YES;
            _descriptionLabel.hidden = YES;
            
        }

        UIImage *image;
        NSString *genderLowerCase = [consumer.gender lowercaseString];
        if ([genderLowerCase isEqualToString:@"male"]) {
            image =[UIImage imageNamed:@"male-avatar-1x"];
        }
        else
        {
            image =[UIImage imageNamed:@"female-avatar-1x"];
        }
        fullAddress =[self completeAddresstring:consumer];
        self.profile_imageView.image =image;
        self.usrEmailLbl.text = consumer.emailId;
       self.usrNameLbl.text = [NSString stringWithFormat:@"%@ %@",consumer.foreName,consumer.surName];
        consumer.dob =  [self getDateString:profile.dob withFormat:@"dd MMM YYYY"];
        self.dobLbl.text = consumer.dob;
        self.genderLbl.text = consumer.gender;
      
        [_consumeContactTable reloadData];
        
    }
    
}

//preparing complete Address for View
-(NSString*)completeAddresstring:(Consumer*)consumerData
{
    NSMutableArray *appendDesc =[[NSMutableArray alloc]init];
    
    if (consumerData.address1 == nil || [consumerData.address1 isEqualToString:@""] ) {
    }
    else
    {
        [appendDesc  addObject:consumerData.address1];
        
    }
    if (consumerData.address2 == nil || [consumerData.address2 isEqualToString:@""]) {
        
    }
    else{
        [appendDesc addObject:consumerData.address2];
        
    }
    if (consumerData.city == nil || [consumerData.city isEqualToString:@""]) {
        
    }
    else{
        [appendDesc addObject:consumerData.city];
        
    }
    if (consumerData.post_code == nil || [consumerData.post_code isEqualToString:@""]) {
        
    }
    else{
        [appendDesc addObject:consumerData.post_code];
        
    }
    if (consumerData.country == nil || [consumerData.country isEqualToString:@""]) {
        
    }
    else{
        [appendDesc addObject:consumerData.country];
        
    }
    
    NSString *completeAddress = [NSString stringWithFormat:@"%@ .",[appendDesc componentsJoinedByString:@" , "]];

    return completeAddress;
}


@end
