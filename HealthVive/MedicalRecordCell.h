//
//  MedicalRecordCell.h
//  HealthVive
//
//  Created by Sriram Sadhasivan (BLR GSS) on 06/02/17.
//  Copyright © 2017 NousInfosystems. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MedicalRecordCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *typeLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *titleToTopConst;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *specToReplyConst;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *specToTopConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *titleToSpecConst;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *titleToReplyConst;
@property(weak,nonatomic) IBOutlet UIImageView *repliedImage;

@property (weak, nonatomic) IBOutlet UIImageView *eventTypeImage;
@property (weak, nonatomic) IBOutlet UIButton *btnIsAddedToSummary;
@property (weak, nonatomic) IBOutlet UILabel *repliedLabel;
@property (weak, nonatomic) IBOutlet UILabel *lblProviderType;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *titleToDateConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *titleToProviderTypeConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *titleToLeftMarginConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *dateToReplyLableConst;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *titleToImageConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *dateToTopConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *descToProviderTypeConst;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *descToTitleConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *replyLabelLeftConst;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *replyToreplyImageConst;


@end
