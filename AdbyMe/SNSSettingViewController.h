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
    
    ASIFormDataRequest *request;
}

@property (nonatomic, retain) IBOutlet UIView *twitterLabelBackgroundView;
@property (nonatomic, retain) IBOutlet UIView *facebookLabelBackgroundView;
@property (nonatomic, retain) IBOutlet UIView *me2dayLabelBackgroundView;
@property (nonatomic, retain) ASIFormDataRequest *request;

-(void)updateSnsLabel:(int)snstype status:(int)status andSnsId:(NSString *)snsId setDefault:(BOOL)isDefault;

-(void)updateSnsLabel:(int)snstype status:(int)status;
-(IBAction) snsButtonClicked:(id)sender;
@end
