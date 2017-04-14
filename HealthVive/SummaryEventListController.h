//
//  SummaryEventListController.h
//  HealthVive
//
//  Created by Adarsha on 01/03/17.
//  Copyright © 2017 NousInfosystems. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SummaryEventListController : BaseViewController

@property NSMutableOrderedSet *summaryEventsList;
@property (weak, nonatomic) IBOutlet UITableView *summaryListTable;
@property (weak, nonatomic) IBOutlet UIView *emptySummaryListView;

@end
