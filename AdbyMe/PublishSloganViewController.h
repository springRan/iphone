//
//  PublishSloganViewController.h
//  AdbyMe
//
//  Created by 훈 남궁 on 11. 5. 21..
//  Copyright 2011 Megalusion. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASIFormDataRequest.h"
#import "ASIHTTPRequest.h"

@protocol PublishSloganViewControllerDelegate;

@interface PublishSloganViewController : UIViewController <UITextViewDelegate, ASIHTTPRequestDelegate, UIAlertViewDelegate, UIActionSheetDelegate> {
    int snsType;
    NSString *sloganId;
    UIBarButtonItem *publishButton;
    UIImageView *snsImageView;
    UILabel *usernameLabel;
    UILabel *leftCharLabel;
    UITextView *sloganView;
    UIButton *linkButton;
    NSString *hashId;
    NSString *link;
    ASIFormDataRequest *request;
    
    UIView *loadingView;
    
    NSString *keyword;
    
    id <PublishSloganViewControllerDelegate> delegate;
}
@property (nonatomic, assign) int snsType;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *publishButton;
@property (nonatomic, retain) IBOutlet UIImageView *snsImageView;
@property (nonatomic, retain) IBOutlet UILabel *usernameLabel;
@property (nonatomic, retain) IBOutlet UILabel *leftCharLabel;
@property (nonatomic, retain) IBOutlet UITextView *sloganView;
@property (nonatomic, retain) IBOutlet UIButton *linkButton;
@property (nonatomic, retain) ASIFormDataRequest *request;
@property (nonatomic, retain) IBOutlet UIView *loadingView;
@property (nonatomic, assign) id <PublishSloganViewControllerDelegate> delegate;
@property (nonatomic, retain) NSString *sloganId;
@property (nonatomic, retain) NSString *hashId;
@property (nonatomic, retain) NSString *link;

-(void)publishButtonClicked;
-(void)updateLeftLabel:(int)length;
-(void)setLinkButtonUrl:(NSString *)url;
-(IBAction) linkButtonClicked;

@end

@protocol PublishSloganViewControllerDelegate 

- (void)writeSuccess;

@end
