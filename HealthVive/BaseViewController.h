//
//  ViewController.h
//  HealthVive
//
//  Created by Adarsha on 10/01/17.
//  Copyright © 2017 NousInfosystems. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
#import "Reachability.h"
@interface BaseViewController : UIViewController<UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource>


@property UIScrollView *parentScrollView;
@property UITextField *activeField;
@property UITableView *parentTableView;
@property UITableViewCell *parentTableViewCell;
@property NSString *parenttableIdentier;
@property NSMutableArray *parentTableDataArray;
@property UIView *blurredView;



-(void)setScrollView:(UIScrollView *)scrollView andTextField:(UITextField *)textField;
-(void)setTableView:(UITableView *)tableView andTableViewCell:(UITableViewCell *)tableViewCell withIdentifier:(NSString *) identifier andData : (NSArray *) arrayData;
-(void)applyColorToButton:(UIButton *)button;
-(void)applyCornerToView:(UIView *)view;
-(void)applyCornerColorToView:(UIView *)view withColor: (UIColor *)color;
-(void)applyColorToPlaceHolderText:(UITextField*)textField;
-(void)applyColorToPlaceHolderText:(UITextField *)textField WithColor:(UIColor*)color;
-(void)applyColorToPlaceHolderTextForError:(UITextField *)textField withErrorMessage:(NSString *)errorMessage;
-(NSString *)getTrimmedStringForString:(NSString *)string;

-(void)setButtonEnabled:(Boolean)isEnabled forButton:(UIButton *)button;

-(void)startFade:(UIView *)view;
-(void)startfadOut:(UIView *)view;


-(BOOL)IsValidEmail:(NSString *)checkString;
-(void)setImageAndTextInsetsToButton:(UIButton *)btn andImage:(UIImage *) image withLeftSpace:(CGFloat)space;
-(void)setImageInsetsToButton:(UIButton *)btn andImage:(UIImage *)image;
-(void)setLeftImageForTextField:(UITextField *)textField withImage:(UIImage *)image;
-(void)addPopupView:(UIView *)view;
-(void)removePopupView:(UIView *) view;
-(void)setTintColor:(UIColor*)color toButton:(UIButton *)btn;
-(void)setAlpha:(CGFloat)alpha toBtn:(UIButton*)button;
-(NSString *)getDateString:(NSDate*)date withFormat:(NSString*)formatString;
-(void)showProgressHudWithText:(NSString *)text;
-(void)hideProgressHud;
-(BOOL)checkInternetConnection;
-(void)setNaviagationBarWithTitle:(NSString *)title;
-(void)showAlertWithTitle:(NSString*)title andMessage:(NSString*)msg andActionTitle:(NSString*)actionTitle actionHandler:(void (^ __nullable)(UIAlertAction *action))handler;



@end

