//
//  MedicalContactsController.h
//  HealthVive
//
//  Created by Adarsha on 09/02/17.
//  Copyright © 2017 NousInfosystems. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MedicalContactsController : BaseViewController
@property (weak, nonatomic) IBOutlet UISegmentedControl *contactSegment;
@property (weak, nonatomic) IBOutlet UIView *contactsContainerView;
@property (weak, nonatomic) IBOutlet UIView *extView;

- (IBAction)onChangeOfSegment:(id)sender;
- (IBAction)addBarButtonAction:(id)sender;
@end
