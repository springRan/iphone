//
//  WriteSloganViewController.h
//  AdbyMe
//
//  Created by Baekjoon Choi on 4/9/11.
//  Copyright 2011 Megalusion. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASIFormDataRequest.h"
#import "ASIHTTPRequest.h"

@protocol WriteSloganViewControllerDelegate;

@interface WriteSloganViewController : UIViewController <UITextViewDelegate, ASIHTTPRequestDelegate, UIAlertViewDelegate, UIActionSheetDelegate> {
    int snsType;
    UIBarButtonItem *publishButton;
    UIImageView *snsImageView;
    UILabel *usernameLabel;
    UILabel *leftCharLabel;
    UITextView *copyInputView;
    UIButton *linkButton;
    UIView *keywordView;
    UILabel *keywordLabel;
    NSString *adId;
    ASIFormDataRequest *request;
    
    UIView *loadingView;
    
    id <WriteSloganViewControllerDelegate> delegate;
}
@property (nonatomic, assign) int snsType;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *publishButton;
@property (nonatomic, retain) IBOutlet UIImageView *snsImageView;
@property (nonatomic, retain) IBOutlet UILabel *usernameLabel;
@property (nonatomic, retain) IBOutlet UILabel *leftCharLabel;
@property (nonatomic, retain) IBOutlet UITextView *copyInputView;
@property (nonatomic, retain) IBOutlet UIButton *linkButton;
@property (nonatomic, retain) IBOutlet UIView *keywordView;
@property (nonatomic, retain) IBOutlet UILabel *keywordLabel;
@property (nonatomic, retain) NSString *adId;
@property (nonatomic, retain) ASIFormDataRequest *request;
@property (nonatomic, retain) IBOutlet UIView *loadingView;
@property (nonatomic, assign) id <WriteSloganViewControllerDelegate> delegate;

-(void)publishButtonClicked;
-(void)updateLeftLabel:(int)length;
-(void)setLinkButtonUrl:(NSString *)url;
-(IBAction) linkButtonClicked;

@end

@protocol WriteSloganViewControllerDelegate 

- (void)writeSuccess;

@end
