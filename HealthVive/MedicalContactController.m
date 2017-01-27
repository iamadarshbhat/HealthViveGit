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
@synthesize btnAddContact;
@synthesize medicalContacttableView;

- (void)viewDidLoad {
    [super viewDidLoad];
   [self setNaviagationBarWithTitle:medicalContactNavigationBarTitle];
    [self applyCornerToView:btnAddContact];
   
    UINib *nib = [UINib nibWithNibName:@"MedicalContactCell" bundle:nil];
    [medicalContacttableView registerNib:nib forCellReuseIdentifier:@"medicalContactCellId"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}


//On click of add Button
- (IBAction)addContactAction:(id)sender {
    
    [self.navigationController pushViewController:[[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:medicalContactDetailsControllerID] animated:YES];
}

// On click of + Button
- (IBAction)addBarButtonAction:(id)sender {
    [self.navigationController pushViewController:[[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:medicalContactDetailsControllerID] animated:YES];
}



#pragma mark Table View
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
   // UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"reuseId"];
    //cell.textLabel.text = @"Chandana Adarsh Bhat";
  
    MedicalContactCell *cell = [tableView dequeueReusableCellWithIdentifier:@"medicalContactCellId"];
    [cell.nameLabel setText:@"Martin Roberts"];
    [cell.emailOrSpecialityLabel setText:@"martinr@example.com"];
    
    
    return cell;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 13;
}




-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return true;
}
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        //add code here for when you hit delete
    }
}


@end
