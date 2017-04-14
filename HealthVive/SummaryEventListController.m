//
//  SummaryEventListController.m
//  HealthVive
//
//  Created by Adarsha on 01/03/17.
//  Copyright © 2017 NousInfosystems. All rights reserved.
//

#import "SummaryEventListController.h"
#import "MedicalRecordCell.h"
#import "Medical_event+CoreDataProperties.h"
#import "CoreDataManager.h"
#import "GenerateSummaryController.h"

@interface SummaryEventListController (){
    CoreDataManager *dataManager;
}
    


@end

@implementation SummaryEventListController
@synthesize summaryEventsList;
@synthesize summaryListTable;
@synthesize emptySummaryListView;

- (void)viewDidLoad {
    [super viewDidLoad];
    dataManager = [CoreDataManager sharedManager];
    
    summaryListTable.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
   UIBarButtonItem *generateBarButton =[[UIBarButtonItem alloc] initWithTitle:@"Generate" style:UIBarButtonItemStylePlain target:self action:@selector(generateSummary)];
    self.navigationItem.rightBarButtonItem = generateBarButton;
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
}


-(void)viewWillAppear:(BOOL)animated{
    [self setNaviagationBarWithTitle:SummaryEventListBarTitle];
    
    if(summaryEventsList.count == 0){
        [self showEmptySummaryView];
    }else{
        [self hideEmptySummaryView];
    }
        
}

#pragma mark- TableViewDataSource and Delegate Methods
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return summaryEventsList.count;
}



-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
   
    MedicalRecordCell *eventCell = [tableView dequeueReusableCellWithIdentifier:@"summaryCell"] ;
   
    
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            
            Medical_event *records = [summaryEventsList objectAtIndex:indexPath.row];
            NSString *eventDate;
            NSString *createdDate;
            
            
            if (records.event_date == nil) {
                eventDate = @"";
            }
            else
            {
                //eventDate =[self getDateString:records.event_date withFormat:@"EEE dd MMM, YYYY | hh:mma"];
                 eventDate =[self getDateString:records.event_date withFormat:@"EEE dd | hh:mma"];
            }
            
            if(records.created_date == nil){
                createdDate = @"";
            }else{
                createdDate =[self getDateString:records.created_date withFormat:@"EEE dd MMM, YYYY hh:mma"];
            }
            
 
            NSString *description;
            if (records.content !=nil) {
                description   = records.content;
            }
            else
            {
                description = @"";
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
          
                //Image for delete summary button:
               
                [eventCell.btnIsAddedToSummary setImage:[UIImage imageNamed:rejectedImage] forState:UIControlStateNormal];
                 [eventCell.btnIsAddedToSummary addTarget:self action:@selector(deleteEventFromSummaryList:) forControlEvents:UIControlEventTouchUpInside];
                //Type label :
              
                UIImage *eventTypeImage =[self getEventTypeImage:records.event_type];
                
                
                
                if (records.event_type == HealthEvent || records.event_type == ProviderResponseEvent) {
                    eventCell.eventTypeImage.hidden = YES;
                    [self moveTitleToMargin:eventCell];
                }
                else{
                    eventCell.eventTypeImage.hidden = NO;
                    eventCell.eventTypeImage.image = eventTypeImage;
                    [self moveTitleToImage:eventCell];
                }
                
                if(records.provider_type == nil || [records.provider_type isEqualToString:@""]){
                    [self moveDescriptionToProviderTitle:eventCell];
                }else{
                    [self moveDescriptionToProviderType:eventCell];
                }
            
                eventCell.dateLabel.text = eventDate;
                //cell.dateLabel.text = createdDate;
                eventCell.titleLabel.text = records.title;
               // eventCell.descriptionLabel.text = description;
                NSMutableAttributedString * attrStr = [[NSMutableAttributedString alloc] initWithData:[description dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType} documentAttributes:nil error:nil];
                UIFont *font = [UIFont fontWithName:@"SFUIText-Regular" size:13];
                
                [attrStr addAttribute:NSFontAttributeName value:font range:(NSRange){0,[attrStr length]}];
                
                eventCell.descriptionLabel.attributedText = attrStr;
                eventCell.descriptionLabel.textColor = [UIColor colorWithRed:102.0/255.0f green:102.0/255.0f blue:102.0/255.0f alpha:1.0];
                [eventCell.descriptionLabel setNumberOfLines:2];
                [eventCell.lblProviderType setText:records.provider_type];
                [eventCell.descriptionLabel sizeToFit];

                //response id will not be zero when it comes from server.
                [self moveReplyLabelToBorder:eventCell];
                //response id will not be zero when it comes from server.
                if(records.response_id != 0) {
                    
                    if(records.is_reply == 0){
                        [self moveReplyLabelToBorder:eventCell];
                        if(records.is_read == 1){
                            [eventCell.repliedLabel setTextColor:[UIColor colorWithRed:102.0/255.0f green:102.0/255.0f blue:102.0f/255.0f alpha:1.0]];
                            [eventCell.repliedLabel setText:[NSString stringWithFormat:@"%@ %@",@"Message from",records.provider_name]];
                            
                            [eventCell.repliedImage setImage:[UIImage imageNamed:replySeenImage]];
                        }else{
                            
                            [eventCell.repliedLabel setTextColor:[UIColor colorWithRed:233.0/255.0f green:52.0/255.0f blue:52.0/255.0f alpha:1.0]];
                            [eventCell.repliedLabel setText:[NSString stringWithFormat:@"%@ %@",@"Message from",records.provider_name]];
                            [eventCell.repliedImage setImage:[UIImage imageNamed:replyImage]];
                            
                        }
                        
                    }else{
                        
                        [self moveReplyLabelToImage:eventCell];
                        if(records.is_read == 1){
                            [eventCell.repliedLabel setTextColor:[UIColor colorWithRed:102.0/255.0f green:102.0/255.0f blue:102.0f/255.0f alpha:1.0]];
                            [eventCell.repliedLabel setText:[NSString stringWithFormat:@"%@ %@",@"Reply from",records.provider_name]];
                            
                            [eventCell.repliedImage setImage:[UIImage imageNamed:replySeenImage]];
                            
                        }else{
                            
                            [eventCell.repliedLabel setTextColor:[UIColor colorWithRed:233.0/255.0f green:52.0/255.0f blue:52.0/255.0f alpha:1.0]];
                            [eventCell.repliedLabel setText:[NSString stringWithFormat:@"%@ %@",@"Reply from",records.provider_name]];
                            [eventCell.repliedImage setImage:[UIImage imageNamed:replyImage]];
                            
                        }
                        
                    }
                    
                    
                    [self showReplyLabel:eventCell];
                    [self moveDateToReplyLabel:eventCell];
                }else{
                    [self hideReplyLabel:eventCell];
                    [self moveDateToTopMargin:eventCell];
                }
                
                if(records.event_type == MessageEvent){
                    if(records.is_draft){
                        [eventCell.repliedLabel setTextColor:[UIColor colorWithRed:233.0/255.0f green:52.0/255.0f blue:52.0/255.0f alpha:1.0]];
                        [eventCell.repliedLabel setText:[NSString stringWithFormat:@"Draft"]];
                        
                        [eventCell.repliedImage setImage:nil];
                        [self showReplyLabel:eventCell];
                        [self moveDateToReplyLabel:eventCell];
                    }else{
                        [eventCell.repliedLabel setTextColor:[UIColor colorWithRed:102.0/255.0f green:102.0/255.0f blue:102.0f/255.0f alpha:1.0]];
                        [eventCell.repliedLabel setText:[NSString stringWithFormat:@"Sent to %@",records.messaging_provider_name]];
                        [self showReplyLabel:eventCell];
                        [self moveDateToReplyLabel:eventCell];
                    }
                }
                
            });
            
        });
        
    return eventCell;

}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    Medical_event *records = [summaryEventsList objectAtIndex:indexPath.row];
    NSString *description;
    if(records.content !=nil){
        description   = records.content;
        
    }else
    {
        description = @"";
    }
    
    
    
    CGFloat rowHeight = 80;
    
    if(records.event_type == MessageEvent || records.event_type == ProviderResponseEvent){
        
        if(![records.provider_type  isEqualToString: @""] && ![description isEqualToString:@""]){
            rowHeight = rowHeight+80;
        }
        if ([records.provider_type  isEqualToString: @""] && ![description  isEqualToString: @""]){
            rowHeight = rowHeight + 40;
        }
        if (![records.provider_type  isEqualToString: @""] && [description  isEqualToString: @""]){
            rowHeight = rowHeight + 40;
        }
        
        
        
        
    }else if (records.event_type == SummaryEvent){
        if(![description isEqualToString:@""]){
            rowHeight = rowHeight + 40;
        }
    }else if(records.event_type == HealthEvent || records.event_type == Calendarevent){
        if(![records.provider_type  isEqualToString: @""] && ![description isEqualToString:@""]){
            rowHeight = rowHeight+60;
        }
        if ([records.provider_type  isEqualToString: @""] && ![description  isEqualToString: @""]){
            rowHeight = rowHeight + 30;
        }
        if (![records.provider_type  isEqualToString: @""] && [description  isEqualToString: @""]){
            rowHeight = rowHeight + 30;
        }
        
    }
    
    
    return rowHeight;
    

    
}


//To get type of event image
-(UIImage*)getEventTypeImage:(int)eveType
{
    UIImage *eventImage;
    switch (eveType) {
        case 0:
            eventImage = [UIImage imageNamed:@""];
            break;
        case 1:
            eventImage = [UIImage imageNamed:@"CalEvent"];
            break;
        case 2:
            eventImage = [UIImage imageNamed:@"summary-icon"];
            break;
        case 3:
            eventImage = [UIImage imageNamed:@"evemsg"];
            break;
            
        default:
            break;
    }
    
    return eventImage;
}

//Hides the reply label for the local event
-(void)hideReplyLabel:(MedicalRecordCell*)cell{
    cell.specToReplyConst.priority = 998;
    cell.specToTopConstraint.priority = 999;
    cell.repliedLabel.alpha = 0;
    cell.repliedImage.alpha = 0;
}

//Shows the reply label when event from server
-(void)showReplyLabel:(MedicalRecordCell *)cell{
   // cell.specToReplyConst.priority = 999;
   // cell.specToTopConstraint.priority = 998;
    cell.repliedLabel.alpha = 1;
    cell.repliedImage.alpha = 1;
}

//Moves Title to up when provider type is not there.
-(void)moveTitleUp:(MedicalRecordCell *)cell{
   // cell.titleToDateConstraint.priority = 999;
    //cell.titleToProviderTypeConstraint.priority = 998;
    cell.lblProviderType.alpha = 0;
}
//Move title to down when provider type is there.
-(void)moveTitleDown:(MedicalRecordCell *)cell{
    cell.titleToDateConstraint.priority = 998;
    cell.titleToProviderTypeConstraint.priority = 999;
    cell.lblProviderType.alpha = 1;
}

//Removes the event from summary
-(void)deleteEventFromSummaryList:(UIButton *)sender{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"DeleteNotify" object:nil];
    CGPoint touchPoint = [sender convertPoint:CGPointZero toView:summaryListTable];
    NSIndexPath *clickedButtonIndexPath = [summaryListTable indexPathForRowAtPoint:touchPoint];
    Medical_event *removedEvent = [summaryEventsList objectAtIndex:clickedButtonIndexPath.row];
    [removedEvent setIs_added_to_summary:0];
    [dataManager commitChanges];
    [summaryEventsList removeObject:removedEvent];
    [summaryListTable deleteRowsAtIndexPaths:@[clickedButtonIndexPath] withRowAnimation:UITableViewRowAnimationFade];
    
    if(summaryEventsList.count == 0){
        [self showEmptySummaryView];
    }else{
        [self hideEmptySummaryView];
    }
   
}

-(void)generateSummary{
    
    GenerateSummaryController *generateSummary =[self.storyboard instantiateViewControllerWithIdentifier:GenerateSummaryControllerID];
    generateSummary.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:generateSummary animated:YES];
    
}


//Shows and Hides the empty summary view.
-(void)showEmptySummaryView{
    [self.navigationItem.rightBarButtonItem setEnabled:NO];
    [emptySummaryListView setHidden:NO];
    [summaryListTable setHidden:YES];
}
-(void)hideEmptySummaryView{
    [self.navigationItem.rightBarButtonItem setEnabled:YES];
    [emptySummaryListView setHidden:YES];
    [summaryListTable setHidden:NO];
}

-(void)moveDateToTopMargin:(MedicalRecordCell *)cell{
    cell.dateToTopConstraint.priority = 999;
    cell.dateToReplyLableConst.priority = 998;
}
-(void)moveDateToReplyLabel:(MedicalRecordCell *)cell{
    cell.dateToTopConstraint.priority = 998;
    cell.dateToReplyLableConst.priority = 999;
}

-(void)moveTitleToMargin:(MedicalRecordCell *)cell{
    cell.titleToLeftMarginConstraint.priority = 999;
    cell.titleToImageConstraint.priority = 998;
}
-(void)moveTitleToImage:(MedicalRecordCell *)cell{
    cell.titleToLeftMarginConstraint.priority = 998;
    cell.titleToImageConstraint.priority = 999;
}

-(void)moveDescriptionToProviderType:(MedicalRecordCell *)cell{
    cell.descToTitleConstraint.priority = 998;
    cell.descToProviderTypeConst.priority = 999;
}

-(void)moveDescriptionToProviderTitle:(MedicalRecordCell *)cell{
    cell.descToTitleConstraint.priority = 999;
    cell.descToProviderTypeConst.priority = 998;
}
-(void)moveReplyLabelToBorder:(MedicalRecordCell *)cell{
    [cell.repliedImage setHidden:YES];
    cell.replyLabelLeftConst.priority = 999;
    cell.replyToreplyImageConst.priority = 998;
}

-(void)moveReplyLabelToImage:(MedicalRecordCell *)cell{
    [cell.repliedImage setHidden:NO];
    cell.replyLabelLeftConst.priority = 998;
    cell.replyToreplyImageConst.priority = 999;
}
@end
