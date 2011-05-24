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
    UIBarButtonItem *writeButton;
    UIImageView *userImageView;
    UILabel *usernameLabel;
    UILabel *leftCharLabel;
    UITextView *copyInputView;
    UIView *keywordView;
    UILabel *keywordLabel;
    NSString *adId;
    ASIFormDataRequest *request;
    
    UIView *loadingView;
    
    NSString *keyword;
    NSOperationQueue *queue;
    
    id <WriteSloganViewControllerDelegate> delegate;
}
@property (nonatomic, retain) IBOutlet UIBarButtonItem *writeButton;
@property (nonatomic, retain) IBOutlet UIImageView *userImageView;
@property (nonatomic, retain) IBOutlet UILabel *usernameLabel;
@property (nonatomic, retain) IBOutlet UILabel *leftCharLabel;
@property (nonatomic, retain) IBOutlet UITextView *copyInputView;
@property (nonatomic, retain) IBOutlet UIView *keywordView;
@property (nonatomic, retain) IBOutlet UILabel *keywordLabel;
@property (nonatomic, retain) NSString *adId;
@property (nonatomic, retain) ASIFormDataRequest *request;
@property (nonatomic, retain) IBOutlet UIView *loadingView;
@property (nonatomic, assign) id <WriteSloganViewControllerDelegate> delegate;
@property (nonatomic, retain) NSString *keyword;
@property (nonatomic, retain) NSOperationQueue *queue;

-(void)writeButtonClicked;
-(void)updateLeftLabel:(int)length;

@end

@protocol WriteSloganViewControllerDelegate 

- (void)writeSuccess;

@end
