//
//  LoginViewController.h
//  AdbyMe
//
//  Created by Baekjoon Choi on 4/3/11.
//  Copyright 2011 Megalusion. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASIHTTPRequest.h"


@interface HomeViewController : UIViewController {
    ASIHTTPRequest *request;
    UIActivityIndicatorView *activityView;
    UIButton *loginButton;
    UIButton *signupButton;
}

@property(nonatomic,retain) ASIHTTPRequest *request;
@property (nonatomic, retain) IBOutlet UIActivityIndicatorView *activityView;
@property (nonatomic, retain) IBOutlet UIButton *loginButton;
@property (nonatomic, retain) IBOutlet UIButton *signupButton;

-(void)startLoginCheck;
-(void)endLoginCheck;

-(IBAction) loginButtonClicked;
-(IBAction) signupButtonClicked;
@end
