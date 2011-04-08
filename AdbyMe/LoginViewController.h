//
//  LoginViewController.h
//  AdbyMe
//
//  Created by Baekjoon Choi on 4/3/11.
//  Copyright 2011 Megalusion. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"
#import "SBJsonParser.h"

@interface LoginViewController : UIViewController <UITextFieldDelegate, ASIHTTPRequestDelegate> {    
    UITextField *emailField;
    UITextField *passwordField;
    
    UIBarButtonItem *activityBarButton;
    UIBarButtonItem *loginButton;
    UIActivityIndicatorView *activityIndicatorView;
    
    ASIFormDataRequest *request;
}
@property (nonatomic, retain) IBOutlet UITextField *emailField;
@property (nonatomic, retain) IBOutlet UITextField *passwordField;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *activityBarButton;
@property (nonatomic, retain) IBOutlet UIActivityIndicatorView *activityIndicatorView;
@property (nonatomic, retain) ASIFormDataRequest *request;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *loginButton;

-(void) loginCheck;

@end
