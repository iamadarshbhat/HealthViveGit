//
//  SummaryContactListController.h
//  HealthVive
//
//  Created by Adarsha on 14/02/17.
//  Copyright © 2017 NousInfosystems. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Medical_event+CoreDataProperties.h"

@protocol SummaryContactListDelegate <NSObject>
- (void)onCloseOfPopupView;


@optional
-(void)cancelledSendingMessage;
-(void)msgSentSuccessfully;
@end


@interface SummaryContactListController : BaseViewController
@property (weak, nonatomic) IBOutlet UIView *tblHeaderView;
@property (weak, nonatomic) IBOutlet UIView *popUpView;
@property(weak,nonatomic) id<SummaryContactListDelegate> summaryListDelegate;
@property (weak, nonatomic) IBOutlet UITableView *contactsTableView;
- (IBAction)cancelBtnAction:(id)sender;
- (IBAction)sendSummaryAction:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *lblNoProviders;
@property (weak, nonatomic) IBOutlet UIButton *btnSendSummary;
@property (nonatomic,assign)BOOL isMessageEvent;

@property(nonatomic,strong)Medical_event *eventData;
-(void)getSelectedEventItem:(Medical_event*)event;


@property NSString *summaryTitle;
@property NSString *summaryDescription;
@end
