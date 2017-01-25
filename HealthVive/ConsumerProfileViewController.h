//
//  ConsumerProfileViewController.h
//  HealthVive
//
//  Created by Sriram Sadhasivan (BLR GSS) on 20/01/17.
//  Copyright © 2017 NousInfosystems. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ConsumerProfileViewController : BaseViewController
@property (weak, nonatomic) IBOutlet UIImageView *profile_imageView;
@property (weak, nonatomic) IBOutlet UIButton *addDetailsBtn;
@property (weak, nonatomic) IBOutlet UITableView *consumeContactTable;
@property (weak, nonatomic) IBOutlet UILabel *usrNameLbl;
@property (weak, nonatomic) IBOutlet UILabel *usrEmailLbl;
@property (weak, nonatomic) IBOutlet UILabel *dobLbl;
@property (weak, nonatomic) IBOutlet UILabel *genderLbl;

@end
