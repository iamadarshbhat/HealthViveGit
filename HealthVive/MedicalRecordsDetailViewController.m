//
//  MedicalRecordsDetailViewController.m
//  HealthVive
//
//  Created by Sriram Sadhasivan (BLR GSS) on 06/02/17.
//  Copyright © 2017 NousInfosystems. All rights reserved.
//

#import "MedicalRecordsDetailViewController.h"
#import "MedicalRecordDetailViewCell.h"
#import "AddMedicalRecordViewController.h"
#import "SummaryWebViewController.h"


#define TITLELBLTOP 8
#define TITLELBLHEIGHT 21
#define TITLELBLBOTTOM 8
#define DESCLBLBOTTOM 8

@interface MedicalRecordsDetailViewController ()
{
    NSArray *titleArray;
    NSString *eventTypeString;
      
}

@end

@implementation MedicalRecordsDetailViewController
@synthesize lblEventDate;
@synthesize lblEventTitle;
@synthesize isNavigatinFromSearch;

- (void)viewDidLoad {
    [super viewDidLoad];

    _medicalRecordDetailTableView.delegate = self;
    _medicalRecordDetailTableView.dataSource = self;
    
    [self setNaviagationBarWithTitle:EventDetailsnavigationTitle];
  
    NSString *eventDateStr;
    if(_eventDetails.event_date == nil){
        eventDateStr = @"--";;
    }else{
        eventDateStr = [self getDateString:_eventDetails.event_date withFormat:@"EEE dd MMM, YYYY | hh:mma"];
    }
    
    if(_eventDetails.summary_id == nil){
          titleArray =[[NSArray alloc]initWithObjects:@"Event Type",eventDateStr,@"BodyLocation(s)",@"Symptom(s)",@"Name of Provider",@"Provider Type",@"Care Type",@"Description",@"Created Date",nil];
    }else{
         titleArray =[[NSArray alloc]initWithObjects:@"Event Type",eventDateStr,@"BodyLocation(s)",@"Symptom(s)",@"Name of Provider",@"Provider Type",@"Care Type",@"Description",@"Created Date",@"View Summary Link",nil];
    }
    [lblEventTitle setText:_eventDetails.title];
    if(_eventDetails.event_date == nil){
         [lblEventDate setText:@"--"];
    }else{
         [lblEventDate setText:[self getDateString:_eventDetails.event_date withFormat:@"EEE dd MMM, YYYY | hh:mma"]];
    }
   
    
    UIBarButtonItem *sendBarButton =[[UIBarButtonItem alloc]initWithTitle:@"Send" style:UIBarButtonItemStylePlain target:self action:@selector(sendMessageBtnAction)];
    sendBarButton.tintColor =[UIColor whiteColor];
    
      UIBarButtonItem *rightBarButton = [[UIBarButtonItem alloc]initWithTitle:@"  Edit" style:UIBarButtonItemStylePlain target:self action:@selector(editBtnAction)];
    rightBarButton.tintColor = [UIColor whiteColor];

    
    if (_eventDetails.event_type == MessageEvent) {
       self.navigationItem.rightBarButtonItems =@[rightBarButton,sendBarButton];
    }
    else if(_eventDetails.event_type == ProviderResponseEvent || _eventDetails.event_type == SummaryEvent){
        self.navigationItem.rightBarButtonItem = nil;
    }else{
          self.navigationItem.rightBarButtonItem = rightBarButton;
    }
    
    [_medicalRecordDetailTableView reloadData];
    

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self setNaviagationBarWithTitle:EventDetailsnavigationTitle];
}
-(void)editBtnAction
{
    
    AddMedicalRecordViewController *addRecored =[self.storyboard instantiateViewControllerWithIdentifier:AddMedicalRecordViewControllerID];
    addRecored.isEditing = YES;
    addRecored.hidesBottomBarWhenPushed=YES;
    addRecored.isFromRecords = NO;
    [addRecored setIsNavigatingFromSearch:isNavigatinFromSearch];
    [addRecored getSelectedEventDetails:_eventDetails];
    [self.navigationController pushViewController:addRecored animated:YES];
    
}
-(void)sendMessageBtnAction
{
    dispatch_async(dispatch_get_main_queue(), ^{
        SummaryContactListController *summary =[self.storyboard instantiateViewControllerWithIdentifier:SummaryContactListControllerID];
        NSLog(@"title-%@",_eventDetails.title);
        [summary getSelectedEventItem:_eventDetails];
        summary.isMessageEvent = YES;
        summary.summaryListDelegate = self;
        [self presentViewController:summary animated:YES completion:nil];
        
        
    });

    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return  titleArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier =@"Cell";
    MedicalRecordDetailViewCell *cell =[tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    
    if (!cell) {
        cell =[[MedicalRecordDetailViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        
    }
    UIView *bgColorView = [[UIView alloc] init];
    bgColorView.backgroundColor = [UIColor whiteColor];
    [cell setSelectedBackgroundView:bgColorView];
    
    [self setUpCell:cell atIndexPath:indexPath];
    return cell;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
   
    CGFloat titleLblHeight = 21;
    CGFloat titleLblOffset = 2;
    CGFloat titleLblOffset1 = 8;
    CGFloat descLblOffset = 30;
    CGFloat descBottomOffset = 8;
    
    
    NSString *description;
    if (indexPath.row == 0) {
     eventTypeString=  [self getEventType:_eventDetails.event_type];
        description = eventTypeString;
        
    }
      if (indexPath.row == 1) {
          description = _eventDetails.title;
      }
    
    if (indexPath.row == 2) {
       description = _eventDetails.body_locations;
        
    }
    if (indexPath.row == 3) {
        description = _eventDetails.symptom;
        
    }
    if (indexPath.row == 4) {
       description = _eventDetails.provider_name;
        
    }
    if (indexPath.row == 5) {
       description = _eventDetails.provider_type;
        
    }
    if (indexPath.row == 6) {
       description = _eventDetails.care_type;
        
    }
    if (indexPath.row == 7) {
        description = _eventDetails.content;
    }
    if(indexPath.row == 8){
       NSString *createdDateStr =  [self getDateString:_eventDetails.created_date withFormat:@"EEE dd MMM, YYYY | hh:mma"];
        if(createdDateStr == nil ||[createdDateStr isEqualToString:@"(null)"] ){
            description = @"--";
        }else{
            description = createdDateStr;
        }
        
    }
    if(indexPath.row == 9){
       description = @"Summary Link";
    }
    
    
    if (description !=nil) {
        CGFloat height =[self heightForText:description font:[UIFont systemFontOfSize:16] withinSize:CGSizeMake(tableView.frame.size.width-descLblOffset, self.view.frame.size.height)];
        
        return  height+titleLblHeight+titleLblOffset+descLblOffset+descBottomOffset+titleLblOffset1;
        
    }
    
    return 0;
}

- (CGFloat)heightForText:(NSString*)text font:(UIFont*)font withinSize:(CGSize)size {
    
    NSDictionary *attributes = @{NSFontAttributeName :font};
    NSMutableAttributedString* attrStr=[[NSMutableAttributedString alloc]initWithString:text attributes:attributes];
    
    CGRect frame = [attrStr boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading context:nil];
    
    return frame.size.height;
}

- (void)setUpCell:(MedicalRecordDetailViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    
      eventTypeString=  [self getEventType:_eventDetails.event_type];
    dispatch_async(dispatch_get_main_queue(), ^{
        cell.titleLabel.text =[titleArray objectAtIndex:indexPath.row];
        NSString *description;
        if (indexPath.row == 0) {
          description = eventTypeString;
            }
        
        if (indexPath.row == 1) {
            description = _eventDetails.title;
            
        }
        
        if (indexPath.row == 2) {
            description = _eventDetails.body_locations;
            
        }
        if (indexPath.row == 3) {
            description = _eventDetails.symptom;
            
        }
        if (indexPath.row == 4) {
            description = _eventDetails.provider_name;
            
        }
        if (indexPath.row == 5) {
            description = _eventDetails.provider_type;
            
        }
        if (indexPath.row == 6) {
            description = _eventDetails.care_type;
            
        }
        if (indexPath.row == 7) {
            description = _eventDetails.content;
            
        }
        if(indexPath.row == 8){
            NSString *createdDateStr =  [self getDateString:_eventDetails.created_date withFormat:@"EEE dd MMM, YYYY | hh:mma"];
            if(createdDateStr == nil){
                description = @"--";
            }else{
                description = createdDateStr;
            }
        }
        if(indexPath.row == 9){
           
            NSMutableAttributedString * str = [[NSMutableAttributedString alloc] initWithString:@"View Summary"];
          
           
            [str addAttribute: NSLinkAttributeName value: str range: NSMakeRange(0, str.length)];
           
            //description = @"Adarsha";
           
            [cell.detailledLabel setAttributedText:str];
         
            
        }else{
          cell.detailledLabel.text = description;
        }
        
    });
  }

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.row == 9){
        
        NSString *summaryLink = [NSString stringWithFormat:@"%@%@",httpSummaryLink,_eventDetails.summary_id];
        NSMutableAttributedString * str = [[NSMutableAttributedString alloc] initWithString:summaryLink];
        
        [str addAttribute: NSLinkAttributeName value: str range: NSMakeRange(0, str.length)];
        
        SummaryWebViewController *webViewController = [[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"SummaryWebViewControllerID"];
        [webViewController setSummaryURL:summaryLink];
        
        [self.navigationController pushViewController:webViewController animated:YES];

            }
}
-(void)getSelectedEventDetails:(Medical_event*)eventDetails
{
    eventDetails.is_read = 1;
    _eventDetails = eventDetails;
    
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
@end
