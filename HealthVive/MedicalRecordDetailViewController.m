//
//  MedicalRecordDetailViewController.m
//  HealthVive
//
//  Created by Adarsha on 31/03/17.
//  Copyright © 2017 NousInfosystems. All rights reserved.
//

#import "MedicalRecordDetailViewController.h"
#import "AddMedicalRecordViewController.h"
#import "SummaryWebViewController.h"

@interface MedicalRecordDetailViewController (){
    
    NSArray *sectionTitleArray;
    NSArray *moreDetailsTitleArray;
    NSArray *moreDetailsDescriptionArray;
    NSArray *sectionDescriptionArray;
    Boolean isCollapsed ;
    UIBarButtonItem *editBarButton;
}

@end

@implementation MedicalRecordDetailViewController
@synthesize medicalRecordDetailTable;
@synthesize selectedMedicalEvent;
@synthesize isNavigatinFromSearch;

- (void)viewDidLoad {
    [super viewDidLoad];
  [self setNaviagationBarWithTitle:EventDetailsnavigationTitle];
  sectionTitleArray=[[NSArray alloc]initWithObjects:
                       @"Event Type",
                       @"Title",
                       @"Date Of Event",
                       @"More Details",
                       @"Created Date",
                       @"Description",
                       nil];
    
    
    
   NSString *eventType = [self getEventType:selectedMedicalEvent.event_type];
    NSString *eventDateStr = [self getDateString:selectedMedicalEvent.event_date withFormat:@"EEE dd MMM, YYYY | hh:mma"];
    
    NSString *createdDateStr =  [self getDateString:selectedMedicalEvent.created_date withFormat:@"EEE dd MMM, YYYY | hh:mma"];
    if(createdDateStr == nil ||[createdDateStr isEqualToString:@"(null)"] ){
        createdDateStr = @"--";
    }
    
    if(eventDateStr == nil || [eventDateStr isEqualToString:@"(null)"]){
        eventDateStr = @"--";
    }
    
    sectionDescriptionArray = [[NSArray alloc] initWithObjects:eventType,selectedMedicalEvent.title,eventDateStr,@"",createdDateStr,selectedMedicalEvent.content, nil];
    
    
    
    
    
    if(selectedMedicalEvent.body_locations == nil){
       selectedMedicalEvent.body_locations = @"--";
    }
    if(selectedMedicalEvent.symptom == nil){
        selectedMedicalEvent.symptom = @"--";
    }
    if(selectedMedicalEvent.provider_name == nil){
        selectedMedicalEvent.provider_name = @"--";
    }
    if(selectedMedicalEvent.provider_type == nil){
        selectedMedicalEvent.provider_type = @"--";
    }
    if(selectedMedicalEvent.care_type == nil){
        selectedMedicalEvent.care_type = @"--";
    }
    
    
    if(selectedMedicalEvent.summary_id == nil){
        moreDetailsTitleArray = [[NSArray alloc] initWithObjects:@"Body Location(s)",@"Symptom(s)",@"Name of Provider",@"Provider Type",@"Care Type", nil];
         moreDetailsDescriptionArray = [[NSArray alloc] initWithObjects:selectedMedicalEvent.body_locations,selectedMedicalEvent.symptom,selectedMedicalEvent.provider_name,selectedMedicalEvent.provider_type,selectedMedicalEvent.care_type, nil];
    }else{
        moreDetailsTitleArray =  [[NSArray alloc] initWithObjects:@"Body Location(s)",@"Symptom(s)",@"Name of Provider",@"Provider Type",@"Care Type",@"", nil];
        
        NSMutableAttributedString * str = [[NSMutableAttributedString alloc] initWithString:@"View Summary"];
        [str addAttribute: NSLinkAttributeName value: str range: NSMakeRange(0, str.length)];
      
         moreDetailsDescriptionArray = [[NSArray alloc] initWithObjects:selectedMedicalEvent.body_locations,selectedMedicalEvent.symptom,selectedMedicalEvent.provider_name,selectedMedicalEvent.provider_type,selectedMedicalEvent.care_type,str, nil];
    }
    
   
    
    medicalRecordDetailTable.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
   }

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self setNaviagationBarWithTitle:EventDetailsnavigationTitle];
    
    UIBarButtonItem *sendBarButton =[[UIBarButtonItem alloc]initWithTitle:@"Send" style:UIBarButtonItemStylePlain target:self action:@selector(sendMessageBtnAction)];
    sendBarButton.tintColor =[UIColor whiteColor];
    
    editBarButton = [[UIBarButtonItem alloc]initWithTitle:@"  Edit" style:UIBarButtonItemStylePlain target:self action:@selector(editBtnAction)];
    editBarButton.tintColor = [UIColor whiteColor];
    
    
    if (selectedMedicalEvent.event_type == MessageEvent) {
        
        if(selectedMedicalEvent.is_draft){
            self.navigationItem.rightBarButtonItems =@[editBarButton,sendBarButton];
        }else{
            self.navigationItem.rightBarButtonItems = nil;
        }
    }
    else if(selectedMedicalEvent.event_type == ProviderResponseEvent || selectedMedicalEvent.event_type == SummaryEvent){
        self.navigationItem.rightBarButtonItem = nil;
    }else{
        self.navigationItem.rightBarButtonItem = editBarButton;
    }
    

}
#pragma mark -
#pragma mark TableView DataSource and Delegate Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 3 && [[sectionTitleArray objectAtIndex:section] isEqualToString:@"More Details"]) {
        
        if(isCollapsed){
            return [moreDetailsTitleArray count];
        }else{
            return 0;
        }
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    static NSString *cellid=@"hello";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellid];
    if (cell==nil) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellid];
    }
    
    UIView *bgColorView = [[UIView alloc] init];
    bgColorView.backgroundColor = [UIColor whiteColor];
    [cell setSelectedBackgroundView:bgColorView];
   // BOOL manyCells  = [[arrayForBool objectAtIndex:indexPath.section] boolValue];
    BOOL manyCells = isCollapsed;
    
    /********** If the section supposed to be closed *******************/
    if(!manyCells)
    {
        cell.backgroundColor=[UIColor clearColor];
        
        cell.textLabel.text=@"";
    }
    /********** If the section supposed to be Opened *******************/
    else
    {
        
        if(selectedMedicalEvent.summary_id != nil && indexPath.row == 5){
             cell.detailTextLabel.attributedText = [moreDetailsDescriptionArray objectAtIndex:indexPath.row];
             cell.textLabel.text  = @"";
        }else{
              cell.textLabel.text = [moreDetailsTitleArray objectAtIndex:indexPath.row];
            cell.detailTextLabel.text = [moreDetailsDescriptionArray objectAtIndex:indexPath.row];
        }
      
        
        //cell.textLabel.text=[NSString stringWithFormat:@"%@ %d",[sectionTitleArray objectAtIndex:indexPath.section],indexPath.row+1];
       // cell.textLabel.font=[UIFont systemFontOfSize:15.0f];
       // cell.backgroundColor=[UIColor whiteColor];
        //cell.imageView.image=[UIImage imageNamed:@"point.png"];
       // cell.selectionStyle=UITableViewCellSelectionStyleNone ;
    }
    //cell.textLabel.textColor=[UIColor blackColor];
    
    /********** Add a custom Separator with cell *******************/
    UIView* separatorLineView = [[UIView alloc] initWithFrame:CGRectMake(15, 80, medicalRecordDetailTable.frame.size.width-15, 1)];
    separatorLineView.backgroundColor = [UIColor grayColor];
    //[cell.contentView addSubview:separatorLineView];
    
    return cell;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [sectionTitleArray count];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
   
    if(indexPath.row == 5 && selectedMedicalEvent.summary_id !=nil){
        
        NSString *summaryLink = [NSString stringWithFormat:@"%@%@",httpSummaryLink,selectedMedicalEvent.summary_id];
        NSMutableAttributedString * str = [[NSMutableAttributedString alloc] initWithString:summaryLink];
        
        [str addAttribute: NSLinkAttributeName value: str range: NSMakeRange(0, str.length)];
        
        SummaryWebViewController *webViewController = [[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"SummaryWebViewControllerID"];
        [webViewController setSummaryURL:summaryLink];
        
        [self.navigationController pushViewController:webViewController animated:YES];
        
    }
 
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([[sectionTitleArray objectAtIndex:indexPath.section] isEqualToString:@"More Details"]) {
        return 80;
    }
    return 0;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
  if ([[sectionTitleArray objectAtIndex:section] isEqualToString:@"More Details"]) {
      return 40;
  }if(section == 5){
      return 130;
  }else{
    return 70;
  }
}

#pragma mark - Creating View for TableView Section

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
   UIView *sectionView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 280,0)];
    [sectionView setBackgroundColor:[UIColor whiteColor]];
    //UITableViewCell *sectionView  = [tableView dequeueReusableCellWithIdentifier:@"hello"];
    sectionView.tag=section;
    UILabel *titleLabel;
    UILabel *descriptionLabel;
    UIView* separatorLineView;
    UIImageView *moreImageView;
    if(![[sectionTitleArray objectAtIndex:section] isEqualToString:@"More Details"]){
       titleLabel =[[UILabel alloc]initWithFrame:CGRectMake(15, 5, medicalRecordDetailTable.frame.size.width-10, 20)];
        titleLabel.backgroundColor=[UIColor clearColor];
        titleLabel.textColor=[UIColor colorWithRed:51.0/255.0f green:51.0/255.0f blue:51.0/255.0f alpha:1.0];
        titleLabel.font=[UIFont fontWithName:@"SFUIText-Regular" size:16];    titleLabel.text=[NSString stringWithFormat:@"%@",[sectionTitleArray objectAtIndex:section]];
        [sectionView addSubview:titleLabel];

         if(section == 5 && [[sectionTitleArray objectAtIndex:section] isEqualToString:@"Description"]){
             descriptionLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 30, medicalRecordDetailTable.frame.size.width-10, 130)];
         }else{
             descriptionLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 30, medicalRecordDetailTable.frame.size.width-10, 40)];
         }
        
       
        descriptionLabel.numberOfLines = 10;
        descriptionLabel.backgroundColor=[UIColor clearColor];
        descriptionLabel.textColor=[UIColor colorWithRed:102.0/255.0f green:102.0/255.0f blue:102.0/255.0f alpha:1.0];
        descriptionLabel.font=[UIFont fontWithName:@"SFUIText-Regular" size:16];
        
        NSString *descriptionStr = [NSString stringWithFormat:@"%@",[sectionDescriptionArray objectAtIndex:section]];
        if(section == 5 && [[sectionTitleArray objectAtIndex:section] isEqualToString:@"Description"]){
           
            NSMutableAttributedString * attrStr = [[NSMutableAttributedString alloc] initWithData:[descriptionStr dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType} documentAttributes:nil error:nil];
            UIFont *font = [UIFont fontWithName:@"SFUIText-Regular" size:13];
            
            [attrStr addAttribute:NSFontAttributeName value:font range:(NSRange){0,[attrStr length]}];
            
            descriptionLabel.attributedText = attrStr;
            descriptionLabel.textColor = [UIColor colorWithRed:102.0/255.0f green:102.0/255.0f blue:102.0/255.0f alpha:1.0];
        }else{
            descriptionLabel.text= descriptionStr;
        }
        
        [sectionView addSubview:descriptionLabel];
        
        separatorLineView = [[UIView alloc] initWithFrame:CGRectMake(15, 70, medicalRecordDetailTable.frame.size.width-15, 1)];
        separatorLineView.backgroundColor = [UIColor groupTableViewBackgroundColor];
        
        if(moreImageView !=nil){
            [moreImageView removeFromSuperview];
        }
        
    }else{
      
        NSLog(@"is Collapsed %hhu",isCollapsed);
        moreImageView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 5, 22, 22)];
        if(isCollapsed){
            [moreImageView setImage:[UIImage imageNamed:minusImage]];
        }else{
           [moreImageView setImage:[UIImage imageNamed:plusImage]];
        }
       
        
        [sectionView addSubview:moreImageView];
        
        titleLabel =[[UILabel alloc]initWithFrame:CGRectMake(45, 5, medicalRecordDetailTable.frame.size.width-10, 20)];
        titleLabel.backgroundColor=[UIColor clearColor];
        titleLabel.textColor=[UIColor colorWithRed:51.0/255.0f green:51.0/255.0f blue:51.0/255.0f alpha:1.0];
        titleLabel.font=[UIFont fontWithName:@"SFUIText-Regular" size:16];    titleLabel.text=[NSString stringWithFormat:@"%@",[sectionTitleArray objectAtIndex:section]];
        
        [sectionView addSubview:titleLabel];
        
        [descriptionLabel removeFromSuperview];
        separatorLineView = [[UIView alloc] initWithFrame:CGRectMake(15, 40, medicalRecordDetailTable.frame.size.width-15, 1)];
        separatorLineView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    }
   
   
    
    //********* Add a custom Separator with Section view ******************
    
    //[sectionView addSubview:separatorLineView];
    
    /********** Add UITapGestureRecognizer to SectionView   **************/
    
    if (section == 3 && [[sectionTitleArray objectAtIndex:section] isEqualToString:@"More Details"]) {
    UITapGestureRecognizer  *headerTapped   = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(sectionHeaderTapped:)];
    [sectionView addGestureRecognizer:headerTapped];
    }
    
    return  sectionView;
    
    
}






#pragma mark - Table header gesture tapped

- (void)sectionHeaderTapped:(UITapGestureRecognizer *)gestureRecognizer{
    
    
    isCollapsed  = !isCollapsed;
    
   // NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:gestureRecognizer.view.tag];
    
    
   // if (indexPath.row == 0) {
       // BOOL collapsed  = [[arrayForBool objectAtIndex:indexPath.section] boolValue];
       // for (int i=0; i<[sectionTitleArray count]; i++) {
          //  if (indexPath.section==i) {
            //    [arrayForBool replaceObjectAtIndex:i withObject:[NSNumber numberWithBool:!collapsed]];
            //}
        //}
    
        [medicalRecordDetailTable reloadSections:[NSIndexSet indexSetWithIndex:gestureRecognizer.view.tag] withRowAnimation:UITableViewRowAnimationAutomatic];
        
   // }
    
}


-(void)editBtnAction
{
    
    AddMedicalRecordViewController *addRecored =[self.storyboard instantiateViewControllerWithIdentifier:AddMedicalRecordViewControllerID];
    addRecored.isEditing = YES;
    addRecored.hidesBottomBarWhenPushed=YES;
    addRecored.isFromRecords = NO;
    [addRecored setIsNavigatingFromSearch:isNavigatinFromSearch];
    [addRecored getSelectedEventDetails:selectedMedicalEvent];
    [self.navigationController pushViewController:addRecored animated:YES];
    
}
-(void)sendMessageBtnAction
{
    dispatch_async(dispatch_get_main_queue(), ^{
        SummaryContactListController *summary =[self.storyboard instantiateViewControllerWithIdentifier:SummaryContactListControllerID];
     
        [summary getSelectedEventItem:selectedMedicalEvent];
        summary.isMessageEvent = YES;
        summary.summaryListDelegate = self;
        [self presentViewController:summary animated:YES completion:nil];
        
        
    });
    
    
}

//PopUp View For to get list of Providers
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
    if([segue.identifier isEqualToString:@"sendSummarySegue"]){
        SummaryContactListController *summaryVC = segue.destinationViewController;
        summaryVC.summaryListDelegate = self;
        
        [self.tabBarController.tabBar setHidden:YES];
        [self setPresentationStyleForSelfController:self presentingController:summaryVC];
    }
    
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

- (void)onCloseOfPopupView{
    // [self.navigationController popToRootViewControllerAnimated:YES];
}

-(void)cancelledSendingMessage{
    //Dont remove this method
    
}

-(void)msgSentSuccessfully{
 UIBarButtonItem *barItem = [self.navigationItem.rightBarButtonItems objectAtIndex:1] ;
    barItem =  nil;
  
}

@end
