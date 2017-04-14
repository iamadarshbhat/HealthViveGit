//
//  MedicalRecordsViewController.m
//  HealthVive
//
//  Created by Sriram Sadhasivan (BLR GSS) on 03/02/17.
//  Copyright © 2017 NousInfosystems. All rights reserved.
//

#import "MedicalRecordsViewController.h"
#import "MedicalRecordCell.h"
#import "MedicalRecordsDetailViewController.h"
#import "AddMedicalRecordViewController.h"
#import "CoreDataManager.h"
#import "Globals.h"
#import "MedicalRecordReplyCell.h"
#import "UIBarButtonItem+Badge.h"
#import "SearchEventsController.h"
#import "SummaryEventListController.h"
#import "MedicalRecordDetailViewController.h"


@interface MedicalRecordsViewController ()
{
    NSMutableDictionary *dataDict;
    NSMutableArray *dataArray;
   
    NSMutableArray *medicalRecordKeys;
    NSMutableArray *allRecordValues;
    CoreDataManager *cdm;
    Globals *globals;
    NSMutableArray *eventArray ;
    NSMutableArray *eventDateArray;
    NSMutableDictionary *eventDateDict;
    NSMutableOrderedSet *eventSet;
    NSMutableArray *readArray;
    UIBarButtonItem *eventsCountBarButton;
    NSMutableOrderedSet *eventsArrayForSummary;
    
  }

@end

@implementation MedicalRecordsViewController
@synthesize tblHeaderView;


- (void)viewDidLoad {
    [super viewDidLoad];
   
    [self applyShadowToView:tblHeaderView];
    // Do any additional setup after loading the view.
    globals = [Globals sharedManager];
    eventArray = [[NSMutableArray alloc] init];
    eventDateArray = [[NSMutableArray alloc] init];
    eventDateDict = [[NSMutableDictionary alloc] init];
    
    
    
    UIBarButtonItem *addBarButton =[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addBtnAction)];
    addBarButton.tintColor = [UIColor whiteColor];
  
    eventsCountBarButton =[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:summaryListImage] style:UIBarButtonItemStylePlain target:self action:@selector(eventsCountBtnAction)];
    
    
    
    UIBarButtonItem *searchBarButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:searchImage] style:UIBarButtonItemStylePlain target:self action:@selector(searchButtonAction)];
    
    self.navigationItem.rightBarButtonItems = @[addBarButton,eventsCountBarButton];
    self.navigationItem.leftBarButtonItem = searchBarButton;
    
   

    
    //rightBarButton.badgeValue = @"5";
   // self.navigationItem.leftBarButtonItem.badgeBGColor = [UIColor redColor];
    
    cdm = [CoreDataManager sharedManager];
    allRecordValues =[[NSMutableArray alloc]init];
     medicalRecordKeys = [[NSMutableArray alloc]init];
 
    
    _medicalRecordTableView.delegate = self;
    _medicalRecordTableView.dataSource = self;

    _createEventBtn.layer.cornerRadius = 5.0;
    
    _medicalRecordTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
   

}

-(void)viewDidLayoutSubviews{
    if(eventsArrayForSummary.count > 0){
      [self showBadgeOnEventsCountBarButton:eventsArrayForSummary.count];
    }else{
        eventsCountBarButton.badgeValue = @"";
        eventsCountBarButton.badgeBGColor = [UIColor whiteColor];
        eventsCountBarButton.badge.textColor = [UIColor redColor];
        [eventsCountBarButton.badge.layer setBorderColor:[[UIColor redColor] CGColor]];
        [eventsCountBarButton.badge.layer setBorderWidth:1.0];

    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
     // NSLog(@"Inside view aill appear");
    if([self checkInternetConnection]){
        [self callApiToGetEventTypes];
    }
    
    [self setNaviagationBarWithTitle:HealthLogNavigationTitle];
     [self fetchEventDetails];
    
}
-(void)addBtnAction
{
    AddMedicalRecordViewController *addRecored =[self.storyboard instantiateViewControllerWithIdentifier:AddMedicalRecordViewControllerID];
    addRecored.isEditing = NO;
    addRecored.hidesBottomBarWhenPushed=YES;
    addRecored.isFromRecords = YES;
    [self.navigationController pushViewController:addRecored animated:YES];
}

-(void)eventsCountBtnAction{
    SummaryEventListController *summaryList =[self.storyboard instantiateViewControllerWithIdentifier:SummaryEventListControllerID];
    summaryList.hidesBottomBarWhenPushed=YES;
    [summaryList setSummaryEventsList:eventsArrayForSummary];
    [self.navigationController pushViewController:summaryList animated:YES];

}

-(void)searchButtonAction{
    SearchEventsController *searchEvent =[self.storyboard instantiateViewControllerWithIdentifier:SearchEventsControllerId];
    searchEvent.hidesBottomBarWhenPushed=YES;
    [searchEvent setEventsArrayForSummary:eventsArrayForSummary];
    [self.navigationController pushViewController:searchEvent animated:YES];
}
- (IBAction)createEventBtnAction:(id)sender {
    
    AddMedicalRecordViewController *addRecored =[self.storyboard instantiateViewControllerWithIdentifier:AddMedicalRecordViewControllerID];
    addRecored.isEditing = NO;
    addRecored.hidesBottomBarWhenPushed=YES;
    addRecored.isFromRecords = YES;
    [self.navigationController pushViewController:addRecored animated:YES];

}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark- TableViewDataSource and Delegate Methods
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return eventSet.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    NSString *dateKey = [eventSet objectAtIndex:section];
    
    if([dateKey isEqualToString:@"EventNotifications"]){
        return 0;
    }else{
        NSMutableArray *evetnArr = [eventDateDict valueForKey:dateKey];
        return evetnArr.count;
    }
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    
    if(readArray.count >0 && section == 0){
        return [NSString stringWithFormat:@"You have %lu unread response",(unsigned long)readArray.count];
    }else{
       return [eventSet objectAtIndex:section];
    }
    
   
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
   NSString *headerCellIdentifier = @"HeaderCell";
   NSString *cellIdentifier =@"Cell";
    UITableViewCell *tableCell ;
 
    if(readArray.count > 0 && indexPath.section == 0){
        NSString *dateKey =  [eventSet objectAtIndex:indexPath.section];
        NSMutableArray *eventArr =  [eventDateDict valueForKey:dateKey];
        NSString *providerName = [eventArr objectAtIndex:indexPath.row];
        
    MedicalRecordReplyCell *cell  =[tableView dequeueReusableCellWithIdentifier:headerCellIdentifier forIndexPath:indexPath];
        tableCell = cell;
        cell.lblReply.text = [NSString stringWithFormat:@"%@ has sent you a reply.",providerName];
        [cell.eventReplyImage setImage:[UIImage imageNamed:replyImage]];
    
    }else{

    MedicalRecordCell *cell =[tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
        [cell.btnIsAddedToSummary addTarget:self action:@selector(addEventTosummary:) forControlEvents:UIControlEventTouchUpInside];
    tableCell = cell;
    
    if (!cell) {
        cell =[[MedicalRecordCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
   

    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSString *dateKey =  [eventSet objectAtIndex:indexPath.section];
        NSMutableArray *eventArr =  [eventDateDict valueForKey:dateKey];
        Medical_event *records = [eventArr objectAtIndex:indexPath.row];
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
        
       
      
//        NSMutableArray *appendDesc =[[NSMutableArray alloc]init];
//        
//        if (records.body_locations.length>0) {
//             [appendDesc  addObject:records.body_locations];
//        }
//        if (records.symptom.length>0) {
//            [appendDesc  addObject:records.symptom];
//        }
//
//        if (records.care_type.length>0) {
//            [appendDesc  addObject:records.care_type];
//        }
//
//        if (records.content.length>0) {
//            [appendDesc  addObject:records.content];
//        }
    
        NSString *description;
        if (records.content !=nil) {
            description   = records.content;
        }
        else
        {
            description = @"";
        }
        
 
        dispatch_async(dispatch_get_main_queue(), ^{
            
            //[cell.typeLabel  setTextAlignment:NSTextAlignmentCenter];
            //Image for add summary button:
            if(records.is_added_to_summary == 0){
                [cell.btnIsAddedToSummary setImage:[UIImage imageNamed:addEventToSummaryImage] forState:UIControlStateNormal];
            }else{
                [cell.btnIsAddedToSummary setImage:[UIImage imageNamed:addedEventToSummaryImage] forState:UIControlStateNormal];
            }
            //Type label :
           // NSString *eventTypeString =[self getEventType:records.event_type];
            UIImage *eventTypeImage =[self getEventTypeImage:records.event_type];
            
            
            
            if (records.event_type == HealthEvent || records.event_type == ProviderResponseEvent) {
                cell.eventTypeImage.hidden = YES;
                [self moveTitleToMargin:cell];
            }
            else{
                cell.eventTypeImage.hidden = NO;
                cell.eventTypeImage.image = eventTypeImage;
                [self moveTitleToImage:cell];
            }
            
            if(records.provider_type == nil || [records.provider_type isEqualToString:@""]){
                  [self moveDescriptionToProviderTitle:cell];
            }else{
                [self moveDescriptionToProviderType:cell];
            }
            
            cell.dateLabel.text = eventDate;
             //cell.dateLabel.text = createdDate;
            cell.titleLabel.text = records.title;
          //  cell.descriptionLabel.text = description;
            
            NSMutableAttributedString * attrStr = [[NSMutableAttributedString alloc] initWithData:[description dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType} documentAttributes:nil error:nil];
            UIFont *font = [UIFont fontWithName:@"SFUIText-Regular" size:13];
            
            [attrStr addAttribute:NSFontAttributeName value:font range:(NSRange){0,[attrStr length]}];
            
            cell.descriptionLabel.attributedText = attrStr;
           cell.descriptionLabel.textColor = [UIColor colorWithRed:102.0/255.0f green:102.0/255.0f blue:102.0/255.0f alpha:1.0];
            [cell.descriptionLabel setNumberOfLines:2];
            [cell.lblProviderType setText:records.provider_type];
            [cell.descriptionLabel sizeToFit];
            
            [self moveReplyLabelToBorder:cell];
            //response id will not be zero when it comes from server.
            if(records.response_id != 0) {
                
                if(records.is_reply == 0){
                    [self moveReplyLabelToBorder:cell];
                    if(records.is_read == 1){
                        [cell.repliedLabel setTextColor:[UIColor colorWithRed:102.0/255.0f green:102.0/255.0f blue:102.0f/255.0f alpha:1.0]];
                        [cell.repliedLabel setText:[NSString stringWithFormat:@"%@ %@",@"From",records.provider_name]];
                        
                        [cell.repliedImage setImage:[UIImage imageNamed:replySeenImage]];
                    }else{
                        
                        [cell.repliedLabel setTextColor:[UIColor colorWithRed:233.0/255.0f green:52.0/255.0f blue:52.0/255.0f alpha:1.0]];
                        [cell.repliedLabel setText:[NSString stringWithFormat:@"%@ %@",@"From",records.provider_name]];
                        [cell.repliedImage setImage:[UIImage imageNamed:replyImage]];
                        
                    }
 
                }else{
                    
                     [self moveReplyLabelToImage:cell];
                    if(records.is_read == 1){
                        [cell.repliedLabel setTextColor:[UIColor colorWithRed:102.0/255.0f green:102.0/255.0f blue:102.0f/255.0f alpha:1.0]];
                        [cell.repliedLabel setText:[NSString stringWithFormat:@"%@ %@",@"Reply from",records.provider_name]];
                        
                        [cell.repliedImage setImage:[UIImage imageNamed:replySeenImage]];
                        
                    }else{
                        
                        [cell.repliedLabel setTextColor:[UIColor colorWithRed:233.0/255.0f green:52.0/255.0f blue:52.0/255.0f alpha:1.0]];
                        [cell.repliedLabel setText:[NSString stringWithFormat:@"%@ %@",@"Reply from",records.provider_name]];
                        [cell.repliedImage setImage:[UIImage imageNamed:replyImage]];
                        
                    }

                }
                
                
                [self showReplyLabel:cell];
                [self moveDateToReplyLabel:cell];
            }else{
                [self hideReplyLabel:cell];
                [self moveDateToTopMargin:cell];
            }
            
            if(records.event_type == MessageEvent){
            if(records.is_draft){
                [cell.repliedLabel setTextColor:[UIColor colorWithRed:233.0/255.0f green:52.0/255.0f blue:52.0/255.0f alpha:1.0]];
                [cell.repliedLabel setText:[NSString stringWithFormat:@"Draft"]];
                
                [cell.repliedImage setImage:nil];
                [self showReplyLabel:cell];
                [self moveDateToReplyLabel:cell];
            }else{
                [cell.repliedLabel setTextColor:[UIColor colorWithRed:102.0/255.0f green:102.0/255.0f blue:102.0f/255.0f alpha:1.0]];
                [cell.repliedLabel setText:[NSString stringWithFormat:@"Sent to %@",records.messaging_provider_name]];
                [self showReplyLabel:cell];
                [self moveDateToReplyLabel:cell];
            }
            }
            
            
            if(records.event_type == SummaryEvent){
                [cell.repliedLabel setTextColor:[UIColor colorWithRed:102.0/255.0f green:102.0/255.0f blue:102.0f/255.0f alpha:1.0]];
                [cell.repliedLabel setText:[NSString stringWithFormat:@"Sent to %@",records.messaging_provider_name]];
                [self showReplyLabel:cell];
                [self moveDateToReplyLabel:cell];
            }
    
        });
        
    });
   
    }
    return tableCell;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    MedicalRecordDetailViewController *detailViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"MedicalRecordDetailViewControllerID"];
     [self.navigationController pushViewController:detailViewController animated:NO];

    //[detailViewController setSelectedMedicalEvent:<#(Medical_event *)#>]
    
    //[detailView setIsNavigatinFromSearch:NO];
    
        NSString *dateKey =  [eventSet objectAtIndex:indexPath.section];
        if(![dateKey  isEqualToString: @"EventNotifications"]){
           NSMutableArray *eventArr =  [eventDateDict valueForKey:dateKey];
           Medical_event *records = [eventArr objectAtIndex:indexPath.row];
          if(records.response_id != 0){
                records.is_read = 1;
                [readArray removeObject:records.provider_name];
                [cdm commitChanges];
            }
            [detailViewController setSelectedMedicalEvent:records];
        }
    
    
    //*********************Old Code starts **************
    
//    MedicalRecordsDetailViewController *detailView =[self.storyboard instantiateViewControllerWithIdentifier:medicalRecordsDetailViewControllerID];
//    [detailView setIsNavigatinFromSearch:NO];
//    
//   // Medical_event *records = [dataArray objectAtIndex:indexPath.row];
//    
//    NSString *dateKey =  [eventSet objectAtIndex:indexPath.section];
//    
//    if(![dateKey  isEqualToString: @"EventNotifications"]){
//        
//        NSMutableArray *eventArr =  [eventDateDict valueForKey:dateKey];
//        Medical_event *records = [eventArr objectAtIndex:indexPath.row];
//        
//        
//        
//        if(records.response_id != 0){
//            records.is_read = 1;
//            [readArray removeObject:records.provider_name];
//            [cdm commitChanges];
//        }
//        [detailView getSelectedEventDetails:records];
//        [self.navigationController pushViewController:detailView animated:NO];
//        
//
//    }
    
    //*********************Old Code ends **************
}


- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        UIAlertController *alertController = [UIAlertController
                                              alertControllerWithTitle:InfoAlert
                                              message:deleteEventMessage
                                              preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancelAction = [UIAlertAction
                                       actionWithTitle:NSLocalizedString(@"Yes", @"Cancel action")
                                       style:UIAlertActionStyleDefault
                                       handler:^(UIAlertAction *action)
                                       {
                                           [self deleteMedicalRecord:indexPath];
                                       }];
        
        UIAlertAction *okAction = [UIAlertAction
                                   actionWithTitle:NSLocalizedString(@"No", @"OK action")
                                   style:UIAlertActionStyleDefault
                                   handler:^(UIAlertAction *action)
                                   {
                                       NSLog(@"OK action");
                                       
                                   }];
        
        [alertController addAction:cancelAction];
        [alertController addAction:okAction];
        [self presentViewController:alertController animated:YES completion:nil];
        

        
    }
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    if(readArray.count > 0 && indexPath.section == 0){
        return 44;
    }else{
        NSString *dateKey =  [eventSet objectAtIndex:indexPath.section];
        NSMutableArray *eventArr =  [eventDateDict valueForKey:dateKey];
        Medical_event *records = [eventArr objectAtIndex:indexPath.row];
       
        
//        if (records.body_locations.length>0) {
//            [appendDesc  addObject:records.body_locations];
//        }
//        if (records.symptom.length>0) {
//            [appendDesc  addObject:records.symptom];
//        }
//        
//        if (records.care_type.length>0) {
//            [appendDesc  addObject:records.care_type];
//        }
        
//        if (records.content.length>0) {
//            [appendDesc  addObject:records.content];
//        }
        NSString *description;
        if(records.content !=nil){
        description   = records.content;
        
        }else
        {
            description = @"";
        }
//------
        
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
        
        
        
        
//       
//        if([description isEqualToString:@""] && [records.provider_type isEqualToString:@""]){
//            return 80;
//        }else if([description isEqualToString:@""]){
//            return 100;
//        }else if(records.response_id != 0){
//            return 130;
//        }else if(records.provider_type == nil && records.response_id == 0){
//            return 100;
//        }else{
//            return 130;
//        }
    }
}

- (CGFloat)heightForText:(NSString*)text font:(UIFont*)font withinSize:(CGSize)size {
    
    NSDictionary *attributes = @{NSFontAttributeName :font};
    NSMutableAttributedString* attrStr=[[NSMutableAttributedString alloc]initWithString:text attributes:attributes];
    
    CGRect frame = [attrStr boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading context:nil];
    
    return frame.size.height;
}

- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    //Header View for all sections
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, 30)];
    
    
    if (readArray.count >0 && section == 0){
        //Header View Top Reply labels
        UILabel *replyLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, 0, tableView.bounds.size.width, 30)];
        replyLabel.textColor = [UIColor colorWithRed:233.0/255.0f green:52.0/255.0f blue:52.0/255.0f alpha:1.0];
        UIFont *font = [UIFont fontWithName:@"SFUIText-Regular" size:13];
        replyLabel.font = font;
        replyLabel.text = [NSString stringWithFormat:@"You have %lu unread response",(unsigned long)readArray.count];
        replyLabel.textAlignment = NSTextAlignmentLeft;

      [headerView addSubview:replyLabel];
        UIImageView *bellImage =  [[UIImageView alloc] initWithFrame:CGRectMake(10, 5, 16.0, 16.0)];
        [bellImage setImage:[UIImage imageNamed:replyNotificationImage]];
      [headerView addSubview:bellImage];
        [headerView setBackgroundColor:[UIColor whiteColor]];

        
    } else{
        UILabel *headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, tableView.bounds.size.width, 30)];
        UIFont *headerFont = [UIFont fontWithName:@"SFUIText-Regular" size:13];
        headerLabel.font = headerFont;
        [headerLabel setText:[eventSet objectAtIndex:section]];
        [headerLabel setTextColor:[UIColor blackColor]];
        [headerView addSubview:headerLabel];
        [headerView setBackgroundColor:[UIColor groupTableViewBackgroundColor]];

    }
    return headerView;
}




//Add event to summary
-(void)addEventTosummary:(UIButton *)sender{
    CGPoint touchPoint = [sender convertPoint:CGPointZero toView:_medicalRecordTableView]; // maintable --> replace your tableview name
    NSIndexPath *clickedButtonIndexPath = [_medicalRecordTableView indexPathForRowAtPoint:touchPoint];
    
    NSString *dateKey =  [eventSet objectAtIndex:clickedButtonIndexPath.section];
    NSMutableArray *eventArr =  [eventDateDict valueForKey:dateKey];
    Medical_event *addedEvent = [eventArr objectAtIndex:clickedButtonIndexPath.row];
    [addedEvent setIs_added_to_summary:1];
    [cdm commitChanges];
    [sender setImage:[UIImage imageNamed:addedEventToSummaryImage] forState:UIControlStateNormal];
    
    [eventsArrayForSummary addObject:addedEvent];
    
    if(eventsArrayForSummary.count >0){
        [self showBadgeOnEventsCountBarButton:eventsArrayForSummary.count];
    }
}

-(void)showBadgeOnEventsCountBarButton:(NSInteger)count{
    eventsCountBarButton.badgeValue = [NSString stringWithFormat:@"%lu",(unsigned long)count] ;
    eventsCountBarButton.badgeBGColor = [UIColor whiteColor];
    eventsCountBarButton.badge.textColor = [UIColor redColor];
    [eventsCountBarButton.badge.layer setBorderColor:[[UIColor redColor] CGColor]];
    [eventsCountBarButton.badge.layer setBorderWidth:1.0];
}

//Deletes the medical record
-(void)deleteMedicalRecord :(NSIndexPath *)indexPath{
    
    NSString *dateKey =  [eventSet objectAtIndex:indexPath.section];
    NSMutableArray *eventArr =  [eventDateDict valueForKey:dateKey];
    Medical_event *records = [eventArr objectAtIndex:indexPath.row];
    
    
    [cdm.managedObjectContext deleteObject:records];
    [cdm commitChanges];
    
    [eventArr removeObjectAtIndex:indexPath.row];
    [readArray removeObject:records.provider_name];
    
  NSArray *tempArr =   [eventDateDict valueForKey:dateKey];
    if(tempArr.count == 0){
        //[eventDateDict removeObjectForKey:dateKey];
        [eventSet removeObjectAtIndex:indexPath.section];
        [_medicalRecordTableView deleteSections:[NSIndexSet indexSetWithIndex:indexPath.section]  withRowAnimation:UITableViewRowAnimationFade];
    }else{
        [_medicalRecordTableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
                                       withRowAnimation:UITableViewRowAnimationFade];
    }
    
    if (eventSet.count <= 1) {
        _contentView.hidden =YES;
    }
}


//fetch eventDetails
-(void)fetchEventDetails
{
   
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:medical_event];
    [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"consumer_id == %d",globals.consumerId]];
    NSSortDescriptor *sortDesc =[[NSSortDescriptor alloc]initWithKey:@"event_date" ascending:NO];
     NSSortDescriptor *sortDesc1 =[[NSSortDescriptor alloc]initWithKey:@"created_date" ascending:NO];
    [fetchRequest setSortDescriptors:@[sortDesc,sortDesc1]];
    dataArray = [[cdm.managedObjectContext executeFetchRequest:fetchRequest error:nil] mutableCopy];
    
   NSMutableArray *addedEventToSummaryArray =  [[dataArray filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"is_added_to_summary == %d",1]] mutableCopy];
    eventsArrayForSummary = [[NSMutableOrderedSet alloc] init];
    [eventsArrayForSummary addObjectsFromArray:addedEventToSummaryArray];
    
    
    //To Show Read notifications on header cell :Starts
    NSMutableArray *filteredArray = [[dataArray filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"is_read == %@ && response_id != %@",[NSNumber numberWithInt:0],[NSNumber numberWithInteger:0]]] mutableCopy];
    readArray = [[NSMutableArray alloc] init];

    for (Medical_event *event in filteredArray) {
        [readArray addObject:event.provider_name];
    }
    
    
    
    
    eventSet = [[NSMutableOrderedSet alloc] init];
   
   
   
    
   
    NSMutableArray *eventDatearr = [[NSMutableArray alloc] init];
    NSMutableArray *eventsArray = [[NSMutableArray alloc] init];
    
    //For Notifications on Top
    if(readArray.count > 0){
       
        for(NSString *event in readArray){
            [eventSet addObject:@"EventNotifications"];
            [eventDatearr addObject:@"EventNotifications"];
            [eventsArray addObject:event];
        }
    }
    
    
    
    //Preparing Section : Starts

    for (Medical_event *event in dataArray) {
        NSString *monthYear;
        if(event.event_date == nil){
          monthYear  =  [self getDateString:event.created_date withFormat:@"MMM yyyy"];
        }else{
           monthYear = [self getDateString:event.event_date withFormat:@"MMM yyyy"];
        }
        [eventDatearr addObject:monthYear];
        [eventSet addObject:monthYear];
        [eventsArray addObject:event];
    }

    
    for (NSString *eventDate in eventSet) {
        
        NSMutableArray *tempArr = [[NSMutableArray alloc] init];
        
        for(int i=0; i<eventDatearr.count; i++){
            if([eventDate isEqualToString:eventDatearr[i]]){
              [tempArr addObject:eventsArray[i]];
          }
      }
        [eventDateDict setObject:tempArr forKey:eventDate];
    }
    //Preparing Section : Ends
    
    //Showing empty content view
    if (dataArray.count >0) {
        _contentView.hidden =NO;
        [_medicalRecordTableView reloadData];
    }
    else{
        _contentView.hidden =YES;
    }
    
}



- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
//    if([segue.identifier isEqualToString:@"sendSummarySegue"]){
//        SummaryContactListController *summaryVC = segue.destinationViewController;
//        summaryVC.summaryListDelegate = self;
//        
//        [self.tabBarController.tabBar setHidden:YES];
//        [self setPresentationStyleForSelfController:self presentingController:summaryVC];
//    }
   
}

- (void)setPresentationStyleForSelfController:(UIViewController *)selfController presentingController:(UIViewController *)presentingController
{
    if ([NSProcessInfo instancesRespondToSelector:@selector(isOperatingSystemAtLeastVersion:)])
    {
        //iOS 8.0 and above
        presentingController.providesPresentationContextTransitionStyle = YES;
        presentingController.definesPresentationContext = YES;
        
        [presentingController setModalPresentationStyle:UIModalPresentationOverCurrentContext];
    }
    else
    {
        [selfController setModalPresentationStyle:UIModalPresentationCurrentContext];
        [selfController.navigationController setModalPresentationStyle:UIModalPresentationCurrentContext];
    }
}

-(void)onCloseOfPopupView{
    [self.tabBarController.tabBar setHidden:NO];
}

-(void)callApiToGetEventTypes{
    APIHandler *reqHandler =[[APIHandler alloc]init];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *token = [defaults valueForKey:access_tokenKey];
    
    NSString *url = [NSString stringWithFormat:@"%@%@",BaseURL,httpSendAllProviderResponseToConsumer];
    [self showProgressHudWithText:@"Loading..."];
    [reqHandler makeRequest:token serverUrl:url completion:^(NSDictionary *result, NSError *error) {
        if (error == nil) {
            NSArray *resultArray = [result objectForKey:httpResult];
            NSLog(@"Results callApiToGetEventTypes-- %@",resultArray);
            [self insertEventFromServerToDb:resultArray];
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [_medicalRecordTableView reloadData];
                [self hideProgressHud];
            });
            
            
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                [self hideProgressHud];
            });
             [self handleServerError:error];
        }
        
    }];
  
}

-(void)insertEventFromServerToDb:(NSArray *)resultArray{
    
    for (NSDictionary *resultDict in resultArray) {
                [resultDict valueForKey:@"DateOfEvent"];
        
        NSInteger responseId = [[resultDict valueForKey:@"ID"] integerValue];
        
        if(![self checkServerDataExistsInDB:responseId]){
            NSString *title = [resultDict valueForKey:@"Title"];
            NSString *bodyLocation = [resultDict valueForKey:@"BodyLocation"];
            NSString *eventDateStr =  [resultDict valueForKey:@"DateOfEvent"];
            NSString *createdDateStr = [resultDict valueForKey:@"CreatedDate"];
            NSString *providerName = [resultDict valueForKey:@"ProviderName"];
            NSString *description = [resultDict valueForKey:@"Description"];
            
            NSInteger isReply = [[resultDict valueForKey:@"IsReply"] integerValue];
            
            Medical_event *medicalEventRecord = [[Medical_event alloc] initWithEntity:[NSEntityDescription entityForName:medical_event inManagedObjectContext:cdm.managedObjectContext] insertIntoManagedObjectContext:cdm.managedObjectContext];
            medicalEventRecord.consumer_id = globals.consumerId;
            medicalEventRecord.provider_type = @"";
            medicalEventRecord.title = title;
            medicalEventRecord.provider_name = providerName;
            medicalEventRecord.content = description;
            medicalEventRecord.response_id = responseId;
            medicalEventRecord.is_reply = isReply;
            if(![bodyLocation isKindOfClass:[NSNull class]]){
               medicalEventRecord.body_locations = bodyLocation;
            }
            if(![eventDateStr isKindOfClass:[NSNull class]]){
                
                NSArray *strArr = [eventDateStr componentsSeparatedByString:@"."];
                NSDate *eventdate;
                if(strArr.count > 1){
                 eventdate  = [self getDateFromString:eventDateStr WithFormat:@"yyyy-MM-dd'T'HH:mm:ss.SS"];
                }else{
                eventdate = [self getDateFromString:eventDateStr WithFormat:@"yyyy-MM-dd'T'HH:mm:ss"];
                }
                
               
                if(![eventdate isKindOfClass:[NSNull class]]){
                    medicalEventRecord.event_date = eventdate;
                }
            }
            
            
            if(![createdDateStr isKindOfClass:[NSNull class]]){
                
                NSArray *strArr = [createdDateStr componentsSeparatedByString:@"."];
                NSDate *createdDate;
                if(strArr.count > 1){
                    createdDate  = [self getDateFromString:createdDateStr WithFormat:@"yyyy-MM-dd'T'HH:mm:ss.SS"];
                }else{
                    createdDate = [self getDateFromString:createdDateStr WithFormat:@"yyyy-MM-dd'T'HH:mm:ss"];
                }
                
                
                if(![createdDate isKindOfClass:[NSNull class]]){
                    medicalEventRecord.created_date = createdDate;
                }
            }

            medicalEventRecord.symptom = @"";
            medicalEventRecord.care_type = @"";
            medicalEventRecord.event_type = ProviderResponseEnum;
            [cdm commitChanges];
        }
    }
}

-(BOOL)checkServerDataExistsInDB:(NSInteger)responseId{
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"response_id == %@",[NSNumber numberWithInteger:responseId]];
    NSArray *medicalContactss = [cdm fetchDataFromEntity:medical_event predicate:predicate];
    
    
    return [medicalContactss count];
}

//Hides the reply label for the local event
-(void)hideReplyLabel:(MedicalRecordCell*)cell{
   // cell.specToReplyConst.priority = 998;
    //cell.specToTopConstraint.priority = 999;
    cell.repliedLabel.alpha = 0;
    cell.repliedImage.alpha = 0;
}

//Shows the reply label when event from server
-(void)showReplyLabel:(MedicalRecordCell *)cell{
   // cell.specToReplyConst.priority = 999;
    //cell.specToTopConstraint.priority = 998;
    cell.repliedLabel.alpha = 1;
    cell.repliedImage.alpha = 1;
}

//Moves Title to up when provider type is not there.
-(void)moveTitleUp:(MedicalRecordCell *)cell{
    cell.titleToDateConstraint.priority = 999;
    cell.titleToProviderTypeConstraint.priority = 998;
    cell.lblProviderType.alpha = 0;
}
//Move title to down when provider type is there.
-(void)moveTitleDown:(MedicalRecordCell *)cell{
    cell.titleToDateConstraint.priority = 998;
    cell.titleToProviderTypeConstraint.priority = 999;
    cell.lblProviderType.alpha = 1;
}

//To get type of event image
-(UIImage*)getEventTypeImage:(LocalEvenType)eveType
{
    UIImage *eventImage;
    switch (eveType) {
        case HealthEvent:
            eventImage = [UIImage imageNamed:@""];
            break;
        case Calendarevent:
            eventImage = calEventImage;
            break;
        case SummaryEvent:
            eventImage = SummaryEventImage;
            break;
        case MessageEvent:
            eventImage = messageEventImage;
            break;
            
        default:
            break;
    }
    
    return eventImage;
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
