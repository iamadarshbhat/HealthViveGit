//
//  SearchEventsController.m
//  HealthVive
//
//  Created by Adarsha on 01/03/17.
//  Copyright © 2017 NousInfosystems. All rights reserved.
//

#import "SearchEventsController.h"
#import "CoreDataManager.h"
#import "SummaryEventListController.h"
#import "UIBarButtonItem+Badge.h"
#import "MedicalRecordCell.h"
#import "Medical_event+CoreDataClass.h"
#import "MedicalRecordsDetailViewController.h"
#import "Globals.h"


@interface SearchEventsController (){
    UIBarButtonItem  *countBarButton;
    UIBarButtonItem *filterBarButton;
    CoreDataManager *dataManager;
    NSMutableOrderedSet *searchedArray;
    NSMutableArray *tableArr;
    UISearchBar *searchBar;
    BOOL isFromBtnSelected;
    UIView *blurredDateView;
    UIView *blurredEventView;
    int selectedEventType;
    BOOL isSingleDay;
    NSMutableArray *filteringArray;
    Globals *globals;
}

@end

@implementation SearchEventsController
@synthesize eventsArrayForSummary;
@synthesize searchTableView;
@synthesize filterView;
@synthesize frmBtn;
@synthesize toBtn;
@synthesize btnSingleDay;
@synthesize btnRange;
@synthesize lineViewToBtn;
@synthesize datePickerView;
@synthesize datePickker;
@synthesize eventPopupView;
@synthesize btnSelectEventType;
@synthesize lblNoSearchResults;


- (void)viewDidLoad {
    [super viewDidLoad];
  
    globals = [Globals sharedManager];
    filterView.hidden = YES;
    datePickerView.hidden = YES;
    eventPopupView.hidden = YES;
    
    searchBar = [[UISearchBar alloc] init];
    searchBar.placeholder = @"Search";
    searchBar.delegate = self;
    tableArr = [[NSMutableArray alloc] init];
    [self.navigationItem setTitleView:searchBar];
    
    [self applyCornerToView:filterView];
    
    filterBarButton =[[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:filterImage] style:UIBarButtonItemStylePlain  target:self action:@selector(filterAction)];
    filterBarButton.tintColor = [UIColor whiteColor];
    filterBarButton.enabled = NO;
    
    countBarButton =[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:summaryListImage] style:UIBarButtonItemStylePlain target:self action:@selector(countBtnAction)];
    

    self.navigationItem.rightBarButtonItems = @[filterBarButton,countBarButton];

   
    dataManager = [CoreDataManager sharedManager];
    searchedArray = [[NSMutableOrderedSet alloc] init];
    searchTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    [btnSingleDay setImage:[UIImage imageNamed:radioCheckedImage] forState:UIControlStateNormal];
    [btnRange setImage:[UIImage imageNamed:radioUncheckedImage] forState:UIControlStateNormal];
    [frmBtn setTitle:@"Select Day" forState:UIControlStateNormal];
    [toBtn setHidden:YES];
    [lineViewToBtn setHidden:YES];
    
    blurredDateView = [[UIView alloc] initWithFrame:self.view.frame];
    [blurredDateView setBackgroundColor:[UIColor colorWithWhite:0.0 alpha:0.50]];
    
    blurredEventView = [[UIView alloc] initWithFrame:self.view.frame];
    [blurredEventView setBackgroundColor:[UIColor colorWithWhite:0.0 alpha:0.50]];

    selectedEventType = 0;
    isSingleDay = YES;
    datePickker.timeZone = [NSTimeZone localTimeZone];
    datePickker.calendar = [NSCalendar currentCalendar];
    lblNoSearchResults.hidden = YES;

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deletedEventNotification:) name:@"DeleteNotify" object:nil];

    UITapGestureRecognizer *singleFingerTap =
    [[UITapGestureRecognizer alloc] initWithTarget:self
                                            action:@selector(handleSingleTap:)];
    [blurredEventView addGestureRecognizer:singleFingerTap];

}

-(void)deletedEventNotification:(NSNotification *)notification{
    if(eventsArrayForSummary.count > 1){
         [self showBadgeOnEventsCounts:eventsArrayForSummary.count];
    }else{
        countBarButton.badgeValue = @"";
        countBarButton.badgeBGColor = [UIColor whiteColor];
        countBarButton.badge.textColor = [UIColor redColor];
        [countBarButton.badge.layer setBorderColor:[[UIColor redColor] CGColor]];
        [countBarButton.badge.layer setBorderWidth:1.0];
    }
   
}

-(void)viewWillAppear:(BOOL)animated{
//    if(eventsArrayForSummary.count >0){
//        [self showBadgeOnEventsCounts:eventsArrayForSummary.count];
//    }
    [self setNaviagationBarWithTitle:@""];
    [searchTableView reloadData];

}


-(void)viewDidLayoutSubviews{

    if(eventsArrayForSummary.count >0){
        [self showBadgeOnEventsCounts:eventsArrayForSummary.count];
    }else{
        countBarButton.badgeValue = @"";
        countBarButton.badgeBGColor = [UIColor whiteColor];
        countBarButton.badge.textColor = [UIColor redColor];
        [countBarButton.badge.layer setBorderColor:[[UIColor redColor] CGColor]];
        [countBarButton.badge.layer setBorderWidth:1.0];
    }
}

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBart{
    [self getDataForSearchString:searchBart.text];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark- TableViewDataSource and Delegate Methods
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return tableArr.count;
}



-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    MedicalRecordCell *eventCell = [tableView dequeueReusableCellWithIdentifier:@"searchCell"] ;
    [eventCell.btnIsAddedToSummary addTarget:self action:@selector(addSearchEventTosummary:) forControlEvents:UIControlEventTouchUpInside];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        Medical_event *records = [tableArr objectAtIndex:indexPath.row];
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
            
            //Image for add summary button:
            if(records.is_added_to_summary == 0){
                [eventCell.btnIsAddedToSummary setImage:[UIImage imageNamed:addEventToSummaryImage] forState:UIControlStateNormal];
            }else{
                [eventCell.btnIsAddedToSummary setImage:[UIImage imageNamed:addedEventToSummaryImage] forState:UIControlStateNormal];
            }
           
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
            //eventCell.descriptionLabel.text = description;
            
            NSMutableAttributedString * attrStr = [[NSMutableAttributedString alloc] initWithData:[description dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType} documentAttributes:nil error:nil];
            UIFont *font = [UIFont fontWithName:@"SFUIText-Regular" size:13];
            
            [attrStr addAttribute:NSFontAttributeName value:font range:(NSRange){0,[attrStr length]}];
            
            eventCell.descriptionLabel.attributedText = attrStr;
            eventCell.descriptionLabel.textColor = [UIColor colorWithRed:102.0/255.0f green:102.0/255.0f blue:102.0/255.0f alpha:1.0];
            [eventCell.descriptionLabel setNumberOfLines:2];
            [eventCell.lblProviderType setText:records.provider_type];
            [eventCell.descriptionLabel sizeToFit];
            
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
    
    Medical_event *records = [tableArr objectAtIndex:indexPath.row];
    
//    if (records.body_locations.length>0) {
//        [appendDesc  addObject:records.body_locations];
//    }
//    if (records.symptom.length>0) {
//        [appendDesc  addObject:records.symptom];
//    }
//    
//    if (records.care_type.length>0) {
//        [appendDesc  addObject:records.care_type];
//    }
//    
//    if (records.content.length>0) {
//        [appendDesc  addObject:records.content];
//    }
//    
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

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    MedicalRecordsDetailViewController *detailView =[self.storyboard instantiateViewControllerWithIdentifier:medicalRecordsDetailViewControllerID];
    
    [detailView setIsNavigatinFromSearch:YES];
    Medical_event *records = [tableArr objectAtIndex:indexPath.row];
        if(records.response_id != 0){
            records.is_read = 1;
            [dataManager commitChanges];
        }
        [detailView getSelectedEventDetails:records];
        [self.navigationController pushViewController:detailView animated:NO];
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
    //cell.specToReplyConst.priority = 998;
  //  cell.specToTopConstraint.priority = 999;
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


//Filters the searched results
-(void)filterAction{
    [searchBar resignFirstResponder];
    [self showFilterView];
}

-(void)addSearchEventTosummary:(UIButton *)sender{
    CGPoint touchPoint = [sender convertPoint:CGPointZero toView:searchTableView]; // maintable --> replace your tableview name
    NSIndexPath *clickedButtonIndexPath = [searchTableView indexPathForRowAtPoint:touchPoint];
    Medical_event *addedEvent = [tableArr objectAtIndex:clickedButtonIndexPath.row];
    [addedEvent setIs_added_to_summary:1];
    [dataManager commitChanges];
    [sender setImage:[UIImage imageNamed:addedEventToSummaryImage] forState:UIControlStateNormal];
    
    [eventsArrayForSummary addObject:addedEvent];
    
    if(eventsArrayForSummary.count >0){
        [self showBadgeCountOnEventsCountBarButton:eventsArrayForSummary.count];
    }
}

-(void)showBadgeCountOnEventsCountBarButton:(NSInteger)count{
    countBarButton.badgeValue = [NSString stringWithFormat:@"%lu",(unsigned long)count] ;
    countBarButton.badgeBGColor = [UIColor whiteColor];
    countBarButton.badge.textColor = [UIColor redColor];
    [countBarButton.badge.layer setBorderColor:[[UIColor redColor] CGColor]];
    [countBarButton.badge.layer setBorderWidth:1.0];
}

//On click of events count bar button it will takes u to summary list screen
-(void)countBtnAction{
    SummaryEventListController *summaryList =[self.storyboard instantiateViewControllerWithIdentifier:SummaryEventListControllerID];
    [summaryList setSummaryEventsList:eventsArrayForSummary];
    summaryList.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:summaryList animated:YES];
}

-(void)showBadgeOnEventsCounts:(NSInteger)count{
    countBarButton.badgeValue = [NSString stringWithFormat:@"%ld",(long)count];
    countBarButton.badgeBGColor = [UIColor whiteColor];
    countBarButton.badge.textColor = [UIColor redColor];
    [countBarButton.badge.layer setBorderColor:[[UIColor redColor] CGColor]];
    [countBarButton.badge.layer setBorderWidth:1.0];
}

//Shows and Hides Filter View

-(void)showFilterView{
    [self addPopupView:filterView];
}
-(void)hideFilterView{
    [self removePopupView:filterView];
}

//Show and Hide Date Picker View

-(void)showDatePickerView{
    [self addDatePopupView:datePickerView];
     //datePickerView.hidden = false;
}
-(void)hideDatePickerView{
    //datePickerView.hidden = true;
    [self removeDatePopupView:datePickerView];
}


//Fetch the data for search string
-(void)getDataForSearchString:(NSString*)searchString{
    
    NSArray *array = [searchString componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    array = [array filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"SELF != ''"]];
    
    searchedArray = [[NSMutableOrderedSet alloc] init];
   
    for (NSString *searchStr in array) {
        NSArray *searchedArr =   [dataManager fetchDataFromEntity:medical_event predicate:[NSPredicate predicateWithFormat:@"((title CONTAINS[cd] %@) OR (provider_name CONTAINS[cd] %@) OR(provider_type CONTAINS[cd] %@) OR (body_locations CONTAINS[cd] %@) OR (care_type CONTAINS[cd] %@) OR (content CONTAINS[cd] %@) OR (symptom CONTAINS[cd] %@)) AND (consumer_id == %d)", searchStr , searchStr,searchStr,searchStr,searchStr,searchStr,searchStr,globals.consumerId]];
        
        [searchedArray addObjectsFromArray:searchedArr];
    }
   
    if(searchedArray.count > 0){
        [filterBarButton setEnabled:YES];
        tableArr = [[NSMutableArray alloc] initWithArray:[searchedArray array]];
    }else{
        [filterBarButton setEnabled:NO];
    }
    
    lblNoSearchResults.hidden = NO;
    dispatch_async(dispatch_get_main_queue(), ^{
        if(searchedArray.count == 0){
            lblNoSearchResults.text = @"No result(s) found.";
            //searchTableView.backgroundView = lblNoSearchResults;
        }else{
            lblNoSearchResults.text = @"";
            //searchTableView.backgroundView = lblNoSearchResults;
        }
        [searchBar resignFirstResponder];
        [searchTableView reloadData];
    });

    filteringArray = [[searchedArray array] mutableCopy];
  // [searchTableView reloadData];
    
}

-(void)getDataForFilterItems{
   
    NSDate *fromDate  = [self getDateFromString:frmBtn.titleLabel.text WithFormat:@"dd/MM/yyyy"];
    NSDate *toDate  = [self getDateFromString:toBtn.titleLabel.text WithFormat:@"dd/MM/yyyy"];
    
    
  
    
    NSPredicate *dateRangePredicate;
    if(isSingleDay){
        if(fromDate == nil){
            dateRangePredicate =[NSPredicate
             predicateWithFormat:@"event_type = %d ",selectedEventType];
        }else{
            
           // NSDate *incrDate = [fromDate dateByAddingTimeInterval:60*60*24];
            NSDate *prevDate = [fromDate dateByAddingTimeInterval:-24*60*60];
            NSDate *postDate = [fromDate dateByAddingTimeInterval:24*60*60];
            dateRangePredicate = [NSPredicate
                                  predicateWithFormat:@"event_type = %d AND (event_date > %@ AND event_date < %@)",selectedEventType,prevDate,postDate];
        }
        
    }else{
         if(fromDate == nil || toDate == nil){
            dateRangePredicate = [NSPredicate
                                  predicateWithFormat:@"event_type = %d",selectedEventType];
        }else{
            
            NSDate *prevDate = [fromDate dateByAddingTimeInterval:-24*60*60];
            NSDate *postDate = [toDate dateByAddingTimeInterval:24*60*60];
            
            dateRangePredicate = [NSPredicate
                                  predicateWithFormat:@"event_type = %d AND (event_date > %@ AND event_date < %@)",selectedEventType,prevDate,postDate];
        }
        
    }
    
   
   NSMutableArray *filteredArray =  [[filteringArray filteredArrayUsingPredicate:dateRangePredicate] mutableCopy];
    
    tableArr = [[NSMutableArray alloc] initWithArray:filteredArray];
    
    
   // NSMutableArray *orderedArray = [[NSMutableArray alloc] initWithArray:[searchedArray array]];
    
  //  NSArray *searchedArr =    [orderedArray filteredArrayUsingPredicate:dateRangePredicate];
   
    
   // if(searchedArr.count > 0){
        //searchedArray = [searchedArr mutableCopy];
  //  }
    
    NSLog(@"Search Array : %lu",(unsigned long)searchedArray.count);
//    if(searchedArray.count > 0){
//        [filterBarButton setEnabled:YES];
//    }else{
//        [filterBarButton setEnabled:NO];
//    }
    
    
    
    lblNoSearchResults.hidden = NO;
    dispatch_async(dispatch_get_main_queue(), ^{
        if(tableArr.count == 0){
            lblNoSearchResults.text = @"No result(s) found.";
            //searchTableView.backgroundView = lblNoSearchResults;
        }else{
            lblNoSearchResults.text = @"";
           // searchTableView.backgroundView = lblNoSearchResults;
        }
        [searchBar resignFirstResponder];
        [searchTableView reloadData];
    });
}


- (IBAction)clearBtnAction:(id)sender {
    [tableArr removeAllObjects];
    selectedEventType = 0;
    isSingleDay = YES;
    [btnSingleDay setImage:[UIImage imageNamed:radioCheckedImage] forState:UIControlStateNormal];
    [btnRange setImage:[UIImage imageNamed:radioUncheckedImage] forState:UIControlStateNormal];
    [frmBtn setTitle:@"Select Day" forState:UIControlStateNormal];
    [toBtn setHidden:YES];
    [lineViewToBtn setHidden:YES];

    [btnSelectEventType setTitle:@"Health" forState:UIControlStateNormal];
}
- (IBAction)singleDayBtnAction:(id)sender {
    [btnSingleDay setImage:[UIImage imageNamed:radioCheckedImage] forState:UIControlStateNormal];
    [btnRange setImage:[UIImage imageNamed:radioUncheckedImage] forState:UIControlStateNormal];
    [frmBtn setTitle:@"Select Day" forState:UIControlStateNormal];
    [toBtn setHidden:YES];
    [lineViewToBtn setHidden:YES];
    isSingleDay = YES;
    
}

- (IBAction)dateRangeBtnAction:(id)sender {
    [btnSingleDay setImage:[UIImage imageNamed:radioUncheckedImage] forState:UIControlStateNormal];
    [btnRange setImage:[UIImage imageNamed:radioCheckedImage] forState:UIControlStateNormal];
    [toBtn setHidden:NO];
    [frmBtn setTitle:@"From" forState:UIControlStateNormal];
    [toBtn setTitle:@"To" forState:UIControlStateNormal];
    [lineViewToBtn setHidden:NO];
    isSingleDay = NO;

}
- (IBAction)frmBtnAction:(id)sender {
    isFromBtnSelected = YES;
    NSDate *prevFromDate;
    if([frmBtn.titleLabel.text isEqualToString:@"Select Day"] || [frmBtn.titleLabel.text isEqualToString:@"From"]){
        prevFromDate = [NSDate date];
    }else{
        prevFromDate  =  [self getDateFromString:frmBtn.titleLabel.text WithFormat:@"dd/MM/yyyy"];
    }
   
    [datePickker setDate:prevFromDate];
    [self showDatePickerView];
}

- (IBAction)toBtnAction:(id)sender {
    isFromBtnSelected = NO;
    NSDate *prevFromDate;
    if([toBtn.titleLabel.text isEqualToString:@"To"]){
        prevFromDate = [NSDate date];
    }else{
        prevFromDate  =  [self getDateFromString:toBtn.titleLabel.text WithFormat:@"dd/MM/yyyy"];
    }
    [datePickker setDate:prevFromDate];

     [self showDatePickerView];
}
- (IBAction)datePickerValueChanged:(id)sender {
}

- (IBAction)applyFilterAction:(id)sender {
    
   int eventType = selectedEventType;
    NSString *fromDate = frmBtn.titleLabel.text;
    NSString *toDate = toBtn.titleLabel.text;
    
    NSLog(@"filter items Event Type: %d,From date - :%@ To Date - %@",eventType,fromDate,toDate);
    
    [self removePopupView:filterView];
    [self getDataForFilterItems];;
}

//On click of health event
- (IBAction)healthEventAction:(id)sender {
    selectedEventType = 0;
    [btnSelectEventType setTitle:@"Health" forState:UIControlStateNormal];
    [self removeEventPopup:eventPopupView];

}


//On click of calender event
- (IBAction)calendarEventAction:(id)sender {
    selectedEventType = 1;
    [btnSelectEventType setTitle:@"Calendar" forState:UIControlStateNormal];
    [self removeEventPopup:eventPopupView];
}
//On click of message event
- (IBAction)messageEventAction:(id)sender {
    selectedEventType = 3;
     [btnSelectEventType setTitle:@"Message" forState:UIControlStateNormal];
     [self removeEventPopup:eventPopupView];
}



- (IBAction)selectEventTypeAction:(id)sender {
    [self addEventPopup:eventPopupView];
}

- (IBAction)datePickerCancelAction:(id)sender {
    [self hideDatePickerView];

}

- (IBAction)datePickerOkAction:(id)sender {
     NSString *selectedDate= [self getDateString:datePickker.date withFormat:@"dd/MM/yyyy"];
    if(isFromBtnSelected){
        [frmBtn setTitle:selectedDate forState:UIControlStateNormal];
    }else{
       
        [toBtn setTitle:selectedDate forState:UIControlStateNormal];
    }
    [self hideDatePickerView];
}


-(void)addDatePopupView:(UIView *)view{
    view.hidden = false;
    
    [self.view addSubview:blurredDateView];
    [self.view bringSubviewToFront:view];
}
-(void)removeDatePopupView:(UIView *)view{
    view.hidden = true;
    [self.view sendSubviewToBack:view];
    [blurredDateView removeFromSuperview];
}

-(void)addEventPopup:(UIView *)view{
    view.hidden = false;
    [self.view addSubview:blurredEventView];
    [self.view bringSubviewToFront:view];
}

-(void)removeEventPopup:(UIView *)view{
    view.hidden = true;
    [self.view sendSubviewToBack:view];
    [blurredEventView removeFromSuperview];
}

//Add event to summary
-(void)addEventTosummary:(UIButton *)sender{
    CGPoint touchPoint = [sender convertPoint:CGPointZero toView:searchTableView]; // maintable --> replace your tableview name
    NSIndexPath *clickedButtonIndexPath = [searchTableView indexPathForRowAtPoint:touchPoint];
    
   
    Medical_event *addedEvent = [tableArr objectAtIndex:clickedButtonIndexPath.row];
    [addedEvent setIs_added_to_summary:1];
    [dataManager commitChanges];
    [sender setImage:[UIImage imageNamed:addedEventToSummaryImage] forState:UIControlStateNormal];
    
    [eventsArrayForSummary addObject:addedEvent];
    
    if(eventsArrayForSummary.count >0){
       [self showBadgeOnEventsCounts:eventsArrayForSummary.count];
    }
}
- (IBAction)cancelPopupAction:(id)sender {
    [self hideFilterView];
}
//The event handling method for Scrreen touch
- (void)handleSingleTap:(UITapGestureRecognizer *)recognizer {
    [self removeEventPopup:eventPopupView];
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
