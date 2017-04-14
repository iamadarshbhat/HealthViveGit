//
//  MedicalContactDetailsController.m
//  HealthVive
//
//  Created by Adarsha on 27/01/17.
//  Copyright © 2017 NousInfosystems. All rights reserved.
//

#import "MedicalContactDetailsController.h"
#import "CoreDataManager.h"
#import "Globals.h"



@interface MedicalContactDetailsController (){
    UITextField *activeField;
    CoreDataManager *dataManager;
    Globals *globals;

   
}

@end

@implementation MedicalContactDetailsController
@synthesize scrollView;
@synthesize txtForeName;
@synthesize txtSurName;
@synthesize txtEmail;
@synthesize txtAddress;
@synthesize txtTelephone;
@synthesize txtSpecialism;
@synthesize medicalContact;
@synthesize isEditing;
@synthesize medicalContacts;


- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNaviagationBarWithTitle:contactDetailsNavigatinBarTitle];
    
    dataManager = [CoreDataManager sharedManager];
    globals = [Globals sharedManager];

    //[self.navigationItem.rightBarButtonItem setAction:@selector(doneButtonAction:)];
    [super setScrollView:scrollView andTextField:activeField];

    UIBarButtonItem * doneButton = [[UIBarButtonItem alloc]
                                    initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                    target:self
                                    action:@selector(doneButtonAction)];
    self.navigationItem.rightBarButtonItem = doneButton;
    
    UIBarButtonItem * backButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:backButtonImage] style:UIBarButtonItemStylePlain target:self action:@selector(backButtonAction)];
    self.navigationItem.leftBarButtonItem = backButton;

 
    
    if(medicalContact != nil){
        [self setValuesToFields];
    }
    
    if([txtForeName.text isEqualToString:@""]){
        self.navigationItem.rightBarButtonItem.enabled = false;
    }else{
        self.navigationItem.rightBarButtonItem.enabled = true;
    }
    
}

-(void)backButtonAction{
    
    if([self validateForBackButton]){
        UIAlertController *alertController = [UIAlertController
                                              alertControllerWithTitle:errorAlert
                                              message:backPressErrorMessage
                                              preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancelAction = [UIAlertAction
                                       actionWithTitle:NSLocalizedString(@"Cancel", @"Cancel action")
                                       style:UIAlertActionStyleCancel
                                       handler:^(UIAlertAction *action)
                                       {
                                           [self.navigationController popViewControllerAnimated:YES];
                                       }];
        
        UIAlertAction *okAction = [UIAlertAction
                                   actionWithTitle:NSLocalizedString(@"OK", @"OK action")
                                   style:UIAlertActionStyleDefault
                                   handler:^(UIAlertAction *action)
                                   {
                                       NSLog(@"OK action");
                                   }];
        
        [alertController addAction:cancelAction];
        [alertController addAction:okAction];
        [self presentViewController:alertController animated:YES completion:nil];
    }else{
       [self.navigationController popViewControllerAnimated:YES]; 
    }
   
}



//Pops the view to previous view
-(void)doneButtonAction{
   if([self validateForm]){
       
    if(isEditing){
        NSArray *emailObjs = [medicalContacts filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"email == %@",txtEmail.text]];
        
        if(emailObjs.count >0 && ![[self getTrimmedStringForString:txtEmail.text]  isEqual: @""]){
            My_contacts *contact = [emailObjs objectAtIndex:0];
            if([contact isEqual:medicalContact]){
                
             NSArray *isArchivedContact =    [medicalContacts filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"email == %@ && is_active == %@",txtEmail.text,[NSNumber numberWithInt:0]]];
                if(isArchivedContact.count == 0){
                    [self updateMedicalRecordToLocalDB];
                }else{
                    [self showAlertWithTitle:errorAlert andMessage:@"Contact with the same email already exists." andActionTitle:ok actionHandler:nil];
                }
                
                
            }else{
              [self showAlertWithTitle:errorAlert andMessage:@"Contact with the same email already exists." andActionTitle:ok actionHandler:nil];
            }
        }else{
            [self updateMedicalRecordToLocalDB];
        }
       
    }else{
      //  CoreDataManager *core = [[CoreDataManager alloc] init];
      
        My_contacts *medicalContactModel = [[My_contacts alloc] initWithEntity:[NSEntityDescription entityForName:medicalContactEntity inManagedObjectContext:dataManager.managedObjectContext] insertIntoManagedObjectContext:nil];
        [medicalContactModel setFore_name:txtForeName.text];
        [medicalContactModel setSur_name:txtSurName.text];
        [medicalContactModel setEmail:txtEmail.text];
        [medicalContactModel setAddress:txtAddress.text];
        [medicalContactModel setPhone:txtTelephone.text];
        [medicalContactModel setSpecialism:txtSpecialism.text];
        [medicalContactModel setInvited_by_consumer:1];
        [medicalContactModel setInvite_status:0];
        [self saveMedicalContactToLocalDB:medicalContactModel];
       
        
    }
       [self.navigationController popViewControllerAnimated:YES];
   }
  
   }
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark Text Field Delegate methods
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    activeField = textField;
    [self applyColorToPlaceHolderText:activeField WithColor:[UIColor lightGrayColor]];
    
    if(textField == txtForeName){
        [txtForeName setPlaceholder:foreNameMedPlaceHolderText];
    }else if (textField == txtSurName){
        [txtSurName setPlaceholder:surNameMedPlaceHolderText];
    }else if (textField == txtEmail){
        [txtEmail setPlaceholder:emailMedPlaceHolderText];
    }
    
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    activeField = nil;
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return true;
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    NSUInteger newLength = [[self getTrimmedStringForString:textField.text] length] + [[self getTrimmedStringForString:string] length] - range.length;

    if(textField == txtForeName){
        if (newLength == 0) {
            self.navigationItem.rightBarButtonItem.enabled = false;
        }else{
            self.navigationItem.rightBarButtonItem.enabled = true;
        }
    }
    
    if(range.length + range.location > textField.text.length)
    {
        return NO;
    }
    
    if(textField == txtForeName){
        return newLength <= foreNameMaximumLength;
    }else if (textField == txtSurName){
        return newLength <= surNameMaximumLength;
    }else if(textField == txtEmail){
        return newLength <= emailMaximumLength;
    }else if(textField == txtAddress){
        return newLength <= addressFldMaxLenght;
    }else if (textField == txtTelephone){
        return newLength <= phoneNumMaxLength;
    }
    return true;
}

//Fills all the values to edit
-(void)setValuesToFields{
    [txtForeName setText:medicalContact.fore_name];
    [txtSurName setText:medicalContact.sur_name];
    [txtEmail setText:medicalContact.email];
    [txtAddress setText:medicalContact.address];
    [txtSpecialism setText:medicalContact.specialism];
    [txtTelephone setText:medicalContact.phone];
    
}

//validates form
-(BOOL)validateForm{
    BOOL flag = true;
    if(txtForeName.text.length == 1){
        [self applyColorToPlaceHolderTextForError:txtForeName withErrorMessage:foreNameInlineError];
        flag = false;
    } if (txtSurName.text.length == 1){
         [self applyColorToPlaceHolderTextForError:txtSurName withErrorMessage:surNameInlineError];
        flag = false;
    }if (txtEmail.text.length >0 && txtEmail.text.length < 6){
         [self applyColorToPlaceHolderTextForError:txtEmail withErrorMessage:invalidEmail];
        flag = false;
    } if (txtEmail.text.length >0 && ![self IsValidEmail:txtEmail.text]){
         [self applyColorToPlaceHolderTextForError:txtEmail withErrorMessage:invalidEmail];
        flag = false;
    }
    if (txtAddress.text.length == 1){
        [self applyColorToPlaceHolderTextForError:txtAddress withErrorMessage:addressErrorMsg];
        flag = false;
    }
    
   
    
    return flag;
}

-(BOOL)validateForBackButton{
    if([self getTrimmedStringForString:txtForeName.text].length > 0){
        return true;
    }else if([self getTrimmedStringForString:txtSurName.text].length > 0){
        return true;
    }
    else if([self getTrimmedStringForString:txtEmail.text].length > 0){
                return true;
    }
   else if([self getTrimmedStringForString:txtSpecialism.text].length > 0){
                return true;
    }
    else if([self getTrimmedStringForString:txtAddress.text].length > 0){
                return true;
    }
    else if([self getTrimmedStringForString:txtTelephone.text].length > 0){
                return true;
    }else{
    return false;
    }
    
}



//Saves the Medical Contact to Local DB
-(void)saveMedicalContactToLocalDB:(My_contacts *)newContact{
    medicalContacts = [[NSMutableArray alloc] initWithArray:[self getAllMedicalConactsFromLocalDB]];

    NSArray *emailIds = [medicalContacts filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"email == %@",newContact.email]];
    
    
    if(emailIds.count > 0 && txtEmail.text.length >0){
        [self showAlertWithTitle:errorAlert andMessage:@"Contact with the same email already exists." andActionTitle:ok actionHandler:nil];
    }else{
        NSMutableDictionary *dict  = [[NSMutableDictionary alloc] init];
        [dict setValue:[NSNumber numberWithInt:0] forKey:@"id"];
        [dict setValue:[NSNumber numberWithInt:globals.consumerId] forKey:@"consumer_id"];
        [dict setValue:newContact.fore_name forKey:@"fore_name"];
        [dict setValue:newContact.sur_name forKey:@"sur_name"];
        [dict setValue:newContact.email forKey:@"email"];
        [dict setValue:newContact.phone forKey:@"phone"];
        [dict setValue:newContact.specialism forKey:@"specialism"];
        [dict setValue:newContact.address forKey:@"address"];
        [dict setValue:[NSNumber numberWithInt:newContact.invite_status] forKey:@"invite_status"];
        [dict setValue:[NSDate date] forKey:@"created_date"];
        [dict setValue:[NSDate date] forKey:@"modified_date"];
        [dict setValue:[NSNumber numberWithInt:1] forKey:@"is_active"];
        
        [dict setValue:[NSNumber numberWithInt:newContact.invited_by_consumer]forKey:@"invited_by_consumer"];
        [dataManager saveDetailsToEntity:medicalContactEntity andValues:dict];
        
         NSDictionary *aDictionary = [NSDictionary dictionaryWithObjectsAndKeys:newContact,@"medicalContactModelInsertKey",nil];
         [[NSNotificationCenter defaultCenter] postNotificationName:InsertMedicalContactNotification object:nil userInfo:aDictionary];
    }
   }


-(void)updateMedicalRecordToLocalDB{

    [medicalContact setFore_name:txtForeName.text];
    [medicalContact setSur_name:txtSurName.text];
    [medicalContact setEmail:txtEmail.text];
    [medicalContact setPhone:txtTelephone.text];
    [medicalContact setAddress:txtAddress.text];
    [medicalContact setSpecialism:txtSpecialism.text];
    [dataManager commitChanges];
        
    NSDictionary *aDictionary = [NSDictionary dictionaryWithObjectsAndKeys:medicalContact,@"medicalContactModelUpdateKey",nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:UpdateMedicalContactNotification object:nil userInfo:aDictionary];
}

//Returns all active medical contacts saved in the db
-(NSMutableArray*)getActiveMedicalContasFromLocalDB{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"is_active == %@ && consumer_id == %@",[NSNumber numberWithInteger:1],[NSNumber numberWithInteger:globals.consumerId]];
    NSArray *medicalContactss = [dataManager fetchDataFromEntity:medicalContactEntity predicate:predicate sortBy:@"fore_name"];
    return [medicalContactss mutableCopy];
}

-(NSMutableArray *)getAllMedicalConactsFromLocalDB{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"consumer_id == %@",[NSNumber numberWithInteger:globals.consumerId]];
    NSArray *medicalContactss = [dataManager fetchDataFromEntity:medicalContactEntity predicate:predicate sortBy:@"fore_name"];
    return [medicalContactss mutableCopy];
  
}

@end
