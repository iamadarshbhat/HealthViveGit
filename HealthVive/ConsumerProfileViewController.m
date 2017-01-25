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

@interface ConsumerProfileViewController ()
{
    NSMutableArray *titleArray;
    NSMutableArray *descArray;
    NSUserDefaults *defaults;
    
  NSString *ctitle;
   NSString *surName;
    NSDate *dob;
  NSString *gender;

}

@end

@implementation ConsumerProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    
    self.navigationController.navigationBar.hidden =NO;
    self.navigationItem.title = @"My Profile";
    // self.navigationItem.hidesBackButton = YES;
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName : [UIColor whiteColor]};
    self.navigationController.navigationBar.barTintColor = NAVBAR_BCG_COLOR;
    self.navigationController.navigationBar.translucent = NO;
    
    
    UIBarButtonItem *rightBarButton =[[UIBarButtonItem alloc] initWithTitle:@"Edit" style:UIBarButtonItemStylePlain target:self action:@selector(editBtnClicked)];
    rightBarButton.tintColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = rightBarButton;
    
    titleArray =[[NSMutableArray alloc] initWithObjects:@"Address",@"Home",@"Mobile",@"Alternate Email", nil];
    
    
    _consumeContactTable.delegate = self;
    _consumeContactTable.dataSource = self;
    
    self.profile_imageView.layer.cornerRadius = self.profile_imageView.frame.size.width / 2;
    self.profile_imageView.clipsToBounds = YES;
    
    self.addDetailsBtn.layer.cornerRadius = 5.0;
    [self.addDetailsBtn setBackgroundColor:NAVBAR_BCG_COLOR];
    
    defaults =[NSUserDefaults standardUserDefaults];
    [defaults synchronize];
    
   [self getConsumerDetails];
    
    
}
-(void)editBtnClicked
{
    EditProfileViewController *editProfile =[self.storyboard instantiateViewControllerWithIdentifier:@"EditProfileViewControllerID"];
    
    [self.navigationController pushViewController:editProfile animated:NO];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
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
    
    cell.titleLabel.text =[titleArray objectAtIndex:indexPath.row];
    
    return cell;
    
}
-(void)getConsumerDetails
{
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
      
        NSString *token =[NSString stringWithFormat:@"%@",[defaults valueForKey:@"access_token"]];
        
        APIHandler *reqHandler =[[APIHandler alloc] init];
        [reqHandler makeRequest:token serverUrl:getConsumerProfile completion:^(NSDictionary *result, NSError *error) {
            
            if (error == nil) {
                NSLog(@"%@",result);
                NSDictionary *dict =[result valueForKey:@"Result"];
                NSString *foreName =[dict valueForKey:@"ForeName"];
                NSString *lastName =[dict valueForKey:@"LastName"];
                NSString*email =[dict valueForKey:@"EmailID"];
                NSString *gender =[dict valueForKey:@"Gender"];
                NSString *title =[dict valueForKey:@"Title"];
                NSDate *dob =[NSDate date];
                
                NSString *dateString =[self convertDateToString:dob];
                dispatch_async(dispatch_get_main_queue(), ^{
                    UIImage *image;
                    if ([gender isEqualToString:@"Male"]) {
                        
                        image =[UIImage imageNamed:@"male-avatar-1x"];
                    }
                    else
                    {
                        image =[UIImage imageNamed:@"female-avatar-1x"];
                    }
                    self.profile_imageView.image =image;
                    self.usrEmailLbl.text = email;
                    self.usrNameLbl.text = foreName;
                    self.dobLbl.text = dateString;
                    self.genderLbl.text = gender;
                    
                    
                });

            }
            
        }];
        
    });
    

}


-(NSString*)convertDateToString:(NSDate*)date
{
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    
    dateFormatter.dateFormat = @"dd-MMM-yyyy";
    
    NSString *yourDate = [dateFormatter stringFromDate:date];
    
    return yourDate;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
