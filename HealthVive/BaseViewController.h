//
//  ViewController.h
//  HealthVive
//
//  Created by Adarsha on 10/01/17.
//  Copyright © 2017 NousInfosystems. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseViewController : UIViewController<UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource>

@property UIScrollView *parentScrollView;
@property UITextField *activeField;
@property UITableView *parentTableView;
@property UITableViewCell *parentTableViewCell;
@property NSString *parenttableIdentier;
@property NSMutableArray *parentTableDataArray;

-(void)setScrollView:(UIScrollView *)scrollView andTextField:(UITextField *)textField;
-(void)setTableView:(UITableView *)tableView andTableViewCell:(UITableViewCell *)tableViewCell withIdentifier:(NSString *) identifier andData : (NSArray *) arrayData;
-(void)applyColorToButton:(UIButton *)button;
-(void)applyCornerToView:(UIView *)view;
-(void)applyCornerColorToView:(UIView *)view withColor: (UIColor *)color;
-(void)applyColorToPlaceHolderText:(UITextField*)textField;
-(void)applyColorToPlaceHolderTextForError:(UITextField *)textField withErrorMessage:(NSString *)errorMessage;
-(NSString *)getTrimmedStringForString:(NSString *)string;

-(void)setButtonEnabled:(Boolean)isEnabled forButton:(UIButton *)button;

-(void)startFade:(UIView *)view;
-(void)startfadOut:(UIView *)view;
-(BOOL)IsValidEmail:(NSString *)checkString;

-(void)showAlertWithTitle:(NSString*)title andMessage:(NSString*)msg andActionTitle:(NSString*)actionTitle actionHandler:(void (^ __nullable)(UIAlertAction *action))handler;






@end

