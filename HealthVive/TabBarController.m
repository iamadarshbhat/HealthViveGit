//
//  TabBarController.m
//  HealthVive
//
//  Created by Sriram Sadhasivan (BLR GSS) on 23/01/17.
//  Copyright © 2017 NousInfosystems. All rights reserved.
//

#import "TabBarController.h"
#import "ConsumerProfileViewController.h"
#import "MedicalRecordsViewController.h"
#import "SettingsViewController.h"
#import "CoreDataManager.h"
#import "Profile+CoreDataClass.h"
#import "Globals.h"

#import "Consumer.h"


#import "My_contacts+CoreDataProperties.h"
#import "Globals.h"
#import "CoreDataManager.h"


@interface TabBarController (){
    Globals *globals;
    CoreDataManager *dataManager;
    CoreDataManager *cdm;
    Consumer *consumer;
}

@end

@implementation TabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tabBar setTintColor:NAVBAR_BCG_COLOR];
    // Do any additional setup after loading the view.
    globals = [Globals sharedManager];
    dataManager = [[CoreDataManager alloc] init];
   // [self saveDummyData];
    
    globals =[Globals sharedManager];
    cdm = [[CoreDataManager alloc] init];
    consumer =[[Consumer alloc]init];
    
    [self showTabBar];
    
   
   }

-(void)showTabBar
{
    
    UIStoryboard *mainStoryBoard =  [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    
    ConsumerProfileViewController *profileView =[mainStoryBoard instantiateViewControllerWithIdentifier:ConsumerProfileViewControllerId];
    UINavigationController *profileViewNav =[[UINavigationController alloc]initWithRootViewController:profileView];
    
    
    MedicalRecordsViewController *medicalRecords =[mainStoryBoard instantiateViewControllerWithIdentifier:medicalRecordViewControllerID];
    UINavigationController *medicalRecNav =[[UINavigationController alloc]initWithRootViewController:medicalRecords];
    
    
    MedicalContactsController *medicalContactController
    = [mainStoryBoard instantiateViewControllerWithIdentifier:medicalContactsControllerId];
    UINavigationController *medicalContactNav =[[UINavigationController alloc]initWithRootViewController:medicalContactController];
    
    [medicalContactNav.navigationBar setTranslucent:false];
    medicalContactNav.navigationBar.shadowImage = [[UIImage alloc] init];
    [medicalContactNav.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
    
    
    SettingsViewController *settingsController = [mainStoryBoard instantiateViewControllerWithIdentifier:settingsViewControllerID];
    UINavigationController  *settingsNav =[[UINavigationController alloc]initWithRootViewController:settingsController];
    

    
    int  consumerId = globals.consumerId;
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
        
       }
  
    if (consumer.post_code != nil) {
        self.viewControllers = @[medicalContactNav,medicalRecNav,profileViewNav,settingsNav];
        
        
        UITabBarItem *medicalRecordItem = [[[self tabBar] items] objectAtIndex:1];
        [medicalRecordItem setTitle:@"Health Log"];
        [medicalRecordItem setImage:[UIImage imageNamed:medicalRecordTabDefaultImage]];
        [medicalRecordItem setSelectedImage:[UIImage imageNamed:medicalRecordTabSelectedImage]];
        
        
        UITabBarItem *medicalContact = [[[self tabBar] items] objectAtIndex:0];
        [medicalContact setTitle:@"Contact"];
        [medicalContact setImage:[UIImage imageNamed:medContactsTabDefaultImage]];
        [medicalContact setSelectedImage:[UIImage imageNamed:medContactsTabSelectedImage]];
        
        UITabBarItem *profileItem = [[[self tabBar] items] objectAtIndex:2];
        [profileItem setTitle:@"Profile"];
        [profileItem setImage:[UIImage imageNamed:profileTabDefaultImage]];
        [profileItem setSelectedImage:[UIImage imageNamed:profileTabSelectedImage]];

        
        UITabBarItem *settingsItem = [[[self tabBar] items] objectAtIndex:3];
        [settingsItem setTitle:@"Settings"];
        [settingsItem setImage:[UIImage imageNamed:settingsTabDefaultImage]];
        [settingsItem setSelectedImage:[UIImage imageNamed:settingsTabSelectedImage]];
        
    }
    else{
         self.viewControllers = @[profileViewNav,medicalContactNav,medicalRecNav,settingsNav];
        
        UITabBarItem *profileItem = [[[self tabBar] items] objectAtIndex:0];
        [profileItem setTitle:@"Profile"];
        [profileItem setImage:[UIImage imageNamed:profileTabDefaultImage]];
        [profileItem setSelectedImage:[UIImage imageNamed:profileTabSelectedImage]];

        
        
        
        UITabBarItem *medicalContact = [[[self tabBar] items] objectAtIndex:1];
        [medicalContact setTitle:@"Contact"];
        [medicalContact setImage:[UIImage imageNamed:medContactsTabDefaultImage]];
        [medicalContact setSelectedImage:[UIImage imageNamed:medContactsTabSelectedImage]];
        
        UITabBarItem *mediclaRecordItem = [[[self tabBar] items] objectAtIndex:2];
        [mediclaRecordItem setTitle:@"Health Log"];
        [mediclaRecordItem setImage:[UIImage imageNamed:medicalRecordTabDefaultImage]];
        [mediclaRecordItem setSelectedImage:[UIImage imageNamed:medicalRecordTabSelectedImage]];

        
        UITabBarItem *settingsItem = [[[self tabBar] items] objectAtIndex:3];
        [settingsItem setTitle:@"Settings"];
        [settingsItem setImage:[UIImage imageNamed:settingsTabDefaultImage]];
        [settingsItem setSelectedImage:[UIImage imageNamed:settingsTabSelectedImage]];
    }
    
   
    
    
}


- (void)didReceiveMemoryWarning {
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


-(void)saveDummyData{
    My_contacts *medicalContactModel = [[My_contacts alloc] initWithEntity:[NSEntityDescription entityForName:medicalContactEntity inManagedObjectContext:dataManager.managedObjectContext] insertIntoManagedObjectContext:nil];
    [medicalContactModel setFore_name:@"Bill"];
    [medicalContactModel setSur_name:@"Johnson"];
    [medicalContactModel setEmail:@"provider2@test.com"];
    [medicalContactModel setAddress:@""];
    [medicalContactModel setPhone:@""];
    [medicalContactModel setInvite_status:1];
    [medicalContactModel setSpecialism:@"Obstetrician"];

    [self saveMedicalContactToLocalDB:medicalContactModel];
}

-(void)saveMedicalContactToLocalDB:(My_contacts *)newContact{
    
    
        NSMutableDictionary *dict  = [[NSMutableDictionary alloc] init];
       // [dict setValue:[NSNumber numberWithInt:0] forKey:@"id"];
        [dict setValue:[NSNumber numberWithInt:globals.consumerId] forKey:@"consumer_id"];
        [dict setValue:newContact.fore_name forKey:@"fore_name"];
        [dict setValue:newContact.sur_name forKey:@"sur_name"];
        [dict setValue:newContact.email forKey:@"email"];
        [dict setValue:newContact.phone forKey:@"phone"];
        [dict setValue:newContact.specialism forKey:@"specialism"];
        [dict setValue:newContact.address forKey:@"address"];
        [dict setValue:[NSNumber numberWithInt:newContact.invite_status] forKey:@"invite_status"];
        [dict setValue:[NSDate date] forKey:@"created_date"];
        [dict setValue:[NSDate date] forKey:@"modified_date"];
        [dict setValue:[NSNumber numberWithInt:1] forKey:@"is_active"];
        
        [dataManager saveDetailsToEntity:medicalContactEntity andValues:dict];
        
        NSDictionary *aDictionary = [NSDictionary dictionaryWithObjectsAndKeys:newContact,@"medicalContactModelInsertKey",nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:InsertMedicalContactNotification object:nil userInfo:aDictionary];
    
}


@end
