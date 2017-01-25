//
//  MedicalContactController.m
//  HealthVive
//
//  Created by Adarsha on 25/01/17.
//  Copyright © 2017 NousInfosystems. All rights reserved.
//

#import "MedicalContactController.h"

@interface MedicalContactController ()

@end

@implementation MedicalContactController

- (void)viewDidLoad {
    [super viewDidLoad];
   [self setNaviagationBarWithTitle:medicalContactNavigationBarTitle];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
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
