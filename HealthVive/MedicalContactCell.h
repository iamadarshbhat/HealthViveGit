//
//  MedicalContactCell.h
//  HealthVive
//
//  Created by Adarsha on 27/01/17.
//  Copyright © 2017 NousInfosystems. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MedicalContactCell : UITableViewCell<UIGestureRecognizerDelegate>
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *emailOrSpecialityLabel;
@property (weak, nonatomic) IBOutlet UIView *myContentView;

@end
