//
//  SignUpViewController.h
//  AdbyMe
//
//  Created by Baekjoon Choi on 4/3/11.
//  Copyright 2011 Megalusion. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"

@interface SignUpViewController : UIViewController <UITextFieldDelegate, ASIHTTPRequestDelegate> {
    
    UITextField *emailTextField;
    UITextField *usernameTextField;
    UITextField *passwordTextField;
    UITextField *nameTextField;
    
    UILabel *emailLabel;
    UILabel *usernameLabel;
    UILabel *passwordLabel;
    UILabel *nameLabel;
    
    UIButton *termsButton;
    UIButton *submitButton;
    
    UIScrollView *scrollView;
 
    NSMutableDictionary *savedPosition;
    
    UIView *emailCheckView;
    UIView *usernameCheckView;
    UIView *passwordCheckView;
    UIView *nameCheckView;
    
    int totalSavedControl;
    
    UIBarButtonItem *activityBarButton;
    UIActivityIndicatorView *activityIndicatorView;
    
    ASIFormDataRequest *request;
}

@property (nonatomic, retain) IBOutlet UITextField *emailTextField;
@property (nonatomic, retain) IBOutlet UITextField *usernameTextField;
@property (nonatomic, retain) IBOutlet UITextField *passwordTextField;
@property (nonatomic, retain) IBOutlet UITextField *nameTextField;

@property (nonatomic, retain) IBOutlet UIScrollView *scrollView;
@property (nonatomic, retain) NSMutableDictionary *savedPosition;
@property (nonatomic, retain) IBOutlet UILabel *emailLabel;
@property (nonatomic, retain) IBOutlet UILabel *usernameLabel;
@property (nonatomic, retain) IBOutlet UILabel *passwordLabel;
@property (nonatomic, retain) IBOutlet UILabel *nameLabel;
@property (nonatomic, retain) IBOutlet UIButton *termsButton;
@property (nonatomic, retain) IBOutlet UIButton *submitButton;

@property (nonatomic, assign) int totalSavedControl;

@property (nonatomic, retain) IBOutlet UIView *emailCheckView;
@property (nonatomic, retain) IBOutlet UIView *usernameCheckView;
@property (nonatomic, retain) IBOutlet UIView *passwordCheckView;
@property (nonatomic, retain) IBOutlet UIView *nameCheckView;

@property (nonatomic, retain) IBOutlet UIBarButtonItem *activityBarButton;
@property (nonatomic, retain) IBOutlet UIActivityIndicatorView *activityIndicatorView;

@property (nonatomic, retain) ASIFormDataRequest *request;


-(void) savePosition;
-(void) adjustPosition;
-(void) focusPosition:(UITextField *)textField;

-(void) setCheckView:(int)field status:(int)status;
-(void) setCheckView:(int)field status:(int)status message:(NSString *)message;

- (void)emailRequestDone:(ASIHTTPRequest *)request;
- (void)usernameRequestDone:(ASIHTTPRequest *)request;
- (void)registerRequestDone:(ASIHTTPRequest *)request;
- (void)requestWentWrong:(ASIHTTPRequest *)request;

-(IBAction) submitClicked;
-(IBAction) termsClicked;
@end

