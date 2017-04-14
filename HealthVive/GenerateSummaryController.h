//
//  GenerateSummaryController.h
//  HealthVive
//
//  Created by Adarsha on 07/03/17.
//  Copyright © 2017 NousInfosystems. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SummaryContactListController.h"

@interface GenerateSummaryController : BaseViewController<SummaryContactListDelegate,UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UITextField *txtTitle;
@property (weak, nonatomic) IBOutlet UITextView *txtDescription;

@end
