//
//  TabBarController.m
//  HealthVive
//
//  Created by Sriram Sadhasivan (BLR GSS) on 23/01/17.
//  Copyright © 2017 NousInfosystems. All rights reserved.
//

#import "TabBarController.h"
#import "ConsumerProfileViewController.h"

@interface TabBarController ()

@end

@implementation TabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
   UIStoryboard *mainStoryBoard =  [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    
    ConsumerProfileViewController *profileView =[mainStoryBoard instantiateViewControllerWithIdentifier:ConsumerProfileViewControllerId];
    UINavigationController *profileViewNav =[[UINavigationController alloc]initWithRootViewController:profileView];
   
    

    MedicalContactController *medicalContactController = [mainStoryBoard instantiateViewControllerWithIdentifier:medicalContactControllerID];
    UINavigationController *medicalContactNav =[[UINavigationController alloc]initWithRootViewController:medicalContactController];

    self.viewControllers = @[profileViewNav,medicalContactNav];
    UITabBarItem *tabItem = [[[self tabBar] items] objectAtIndex:0];
    [tabItem setTitle:@"Profile"];
   
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

@end
