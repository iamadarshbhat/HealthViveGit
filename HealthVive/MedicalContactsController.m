//
//  MedicalContactsController.m
//  HealthVive
//
//  Created by Adarsha on 09/02/17.
//  Copyright © 2017 NousInfosystems. All rights reserved.
//

#import "MedicalContactsController.h"
#import "ActiveContactsController.h"
#import "ArchivedContactsController.h"
#import "CoreDataManager.h"
#import "Globals.h"

@interface MedicalContactsController (){
    NSMutableArray *medicalcontacts;
    CoreDataManager *dataManager;
    ActiveContactsController *activeContactsController;
    ArchivedContactsController *archivedContactsController;
    Globals *globals;
}

@end

@implementation MedicalContactsController
@synthesize contactsContainerView;
@synthesize contactSegment;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    globals = [Globals sharedManager];
    dataManager = [CoreDataManager sharedManager];
    //medicalcontacts = [[NSMutableArray alloc] initWithArray:[self getMedicalContasFromLocalDB]];

    if(archivedContactsController == nil){
         archivedContactsController = [[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:archivedContactControllerID];
        [self addChildController:archivedContactsController];
    }
    if(activeContactsController == nil){
        activeContactsController = [[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:activeContactControllerID];
        [self addChildController:activeContactsController];
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(insertMedicalRecord:) name:InsertMedicalContactNotification object:nil];

}

-(void)viewWillAppear:(BOOL)animated{
     [self setNaviagationBarWithTitle:medicalContactNavigationBarTitle];
}

//Returns all medical contacts saved in the db
-(NSMutableArray*)getMedicalContasFromLocalDB{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"is_active == %@ && consumer_id == %@",[NSNumber numberWithInteger:1],[NSNumber numberWithInteger:globals.consumerId]];
    NSArray *medicalContactss = [dataManager fetchDataFromEntity:medicalContactEntity predicate:predicate sortBy:@"fore_name"];
    return [medicalContactss mutableCopy];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




- (IBAction)onChangeOfSegment:(id)sender {
    [self changeTheViewController];
}

-(void)changeTheViewController{
    if (contactSegment.selectedSegmentIndex == 0) {
        [self removeChildController:archivedContactsController];
        [self addChildController:activeContactsController];
    } else {
        [self removeChildController:activeContactsController];
        [self addChildController:archivedContactsController];
    }
}

//Adds new view on change of segment
-(void)addChildController:(UIViewController *)childViewController{
    
    [self addChildViewController:childViewController];
    [contactsContainerView addSubview:childViewController.view];
    
    childViewController.view.frame = contactsContainerView.bounds;
    childViewController.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight ;
    [childViewController didMoveToParentViewController:self];
}

//Removes new view on change of segment
-(void)removeChildController:(UIViewController *)childViewController{
    [childViewController willMoveToParentViewController:nil];
    [childViewController.view removeFromSuperview];
    [childViewController removeFromParentViewController];
}

- (IBAction)addBarButtonAction:(id)sender {
    medicalcontacts = [[NSMutableArray alloc] initWithArray:[self getMedicalContasFromLocalDB]];
    MedicalContactDetailsController *contactDetail = [[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:medicalContactDetailsControllerID];
    [contactDetail setIsEditing:NO];
    [contactDetail setMedicalContacts:[self getAllMedicalContasFromLocalDB]];
    [self.navigationController pushViewController:contactDetail animated:YES];
}


-(void)insertMedicalRecord:(NSNotification *)notification{

    if(contactSegment.selectedSegmentIndex == 1){
        [contactSegment setSelectedSegmentIndex:0];
        [self changeTheViewController];
    }
}

//Returns all medical contacts saved in the db
-(NSMutableArray*)getAllMedicalContasFromLocalDB{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"consumer_id == %@",[NSNumber numberWithInteger:globals.consumerId]];
    NSArray *medicalContactss = [dataManager fetchDataFromEntity:medicalContactEntity predicate:predicate sortBy:@"fore_name"];
    return [medicalContactss mutableCopy];
}
@end
