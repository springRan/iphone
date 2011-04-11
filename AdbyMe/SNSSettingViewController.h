//
//  SNSSettingViewController.h
//  AdbyMe
//
//  Created by Baekjoon Choi on 4/4/11.
//  Copyright 2011 Megalusion. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASIFormDataRequest.h"
#import "SnsWebViewController.h"

@interface SNSSettingViewController : UIViewController <UIActionSheetDelegate, ASIHTTPRequestDelegate, SnsWebViewControllerDelegate>{
    UIView *twitterLabelBackgroundView;
    UIView *facebookLabelBackgroundView;
    UIView *me2dayLabelBackgroundView;
    
    BOOL twitterConnected;
    BOOL facebookConnected;
    BOOL me2dayConnected;
    
    
    ASIFormDataRequest *request;
}

@property (nonatomic, retain) IBOutlet UIView *twitterLabelBackgroundView;
@property (nonatomic, retain) IBOutlet UIView *facebookLabelBackgroundView;
@property (nonatomic, retain) IBOutlet UIView *me2dayLabelBackgroundView;
@property (nonatomic, retain) ASIFormDataRequest *request;
@property (nonatomic, assign) BOOL twitterConnected;
@property (nonatomic, assign) BOOL facebookConnected;
@property (nonatomic, assign) BOOL me2dayConnected;

-(void)updateSnsLabel:(int)snstype status:(int)status andSnsId:(NSString *)snsId setDefault:(BOOL)isDefault;
-(void)updateLabels;
-(void)updateSnsLabel:(int)snstype status:(int)status;
-(IBAction) snsButtonClicked:(id)sender;
-(void)removeRequestDone:(int)snsType;
@end
