//
//  AdViewController.h
//  AdbyMe
//
//  Created by Baekjoon Choi on 4/6/11.
//  Copyright 2011 Megalusion. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"
#import "WriteSloganViewController.h"
#import "PublishSloganViewController.h"

@interface AdViewController : UIViewController <ASIHTTPRequestDelegate, UITableViewDelegate, UITableViewDataSource, UIActionSheetDelegate, WriteSloganViewControllerDelegate, PublishSloganViewControllerDelegate> {
    
    NSString *adId;
    
    UIView *adHeaderView;
    UITableView *theTableView;
    
    NSDictionary *adDictionary;
    
    ASIFormDataRequest *request;
    
    UILabel *adTitleLabel;
    UILabel *uvLabel;
    UILabel *sloganLabel;
    UITextView *adTextView;
    UIImageView *adImageView;
    UILabel *cpcLabel;
    UIImageView *statusBgImageView;
    UIImageView *statusImageView;
    
    UIImageView *publishImage;
    UIButton *publishButton;
    
    NSMutableArray *sloganArray;
    
    NSString *sinceUrl;
    
    UITableViewCell *adCell;
    NSMutableDictionary *numberOfLinesDictionary;
    NSMutableDictionary *usernameDictionary;
    NSMutableDictionary *sloganDictionary;
    NSMutableDictionary *uvDictionary;
    NSMutableDictionary *imageUrlDictionary;
    NSMutableDictionary *sloganIdDictionary;
    NSMutableDictionary *numberOfPubDictionary;
    NSMutableDictionary *pubTimeDictionary;
    
    UIView *loadingView;
    
    UIBarButtonItem *refreshButton;
    
    BOOL noMoreUpdate;
    BOOL updating;
    
    UIView *footerView;

    NSMutableArray *imageArray;

    NSMutableDictionary *imageDownloadsInProgress;
    
    NSString *keyword;
    
    NSOperationQueue *queue;
    
    NSString *timeStamp;
}
@property (nonatomic, retain) NSString *timeStamp;
@property (nonatomic, retain) NSString *adId;
@property (nonatomic, retain) IBOutlet UIView *adHeaderView;
@property (nonatomic, retain) IBOutlet UITableView *theTableView;
@property (nonatomic, retain) NSDictionary *adDictionary;
@property (nonatomic, retain) ASIFormDataRequest *request;

@property (nonatomic, retain) IBOutlet UILabel *adTitleLabel;
@property (nonatomic, retain) IBOutlet UILabel *uvLabel;
@property (nonatomic, retain) IBOutlet UILabel *sloganLabel;
@property (nonatomic, retain) IBOutlet UITextView *adTextView;
@property (nonatomic, retain) IBOutlet UIImageView *adImageView;
@property (nonatomic, retain) IBOutlet UILabel *cpcLabel;


@property (nonatomic, retain) NSMutableArray *sloganArray;
@property (nonatomic, retain) NSString *sinceUrl;
@property (nonatomic, retain) IBOutlet UITableViewCell *adCell;
@property (nonatomic, retain) NSMutableDictionary *numberOfLinesDictionary;
@property (nonatomic, retain) NSMutableDictionary *usernameDictionary;
@property (nonatomic, retain) NSMutableDictionary *sloganDictionary;
@property (nonatomic, retain) NSMutableDictionary *uvDictionary;
@property (nonatomic, retain) NSMutableDictionary *sloganIdDictionary;
@property (nonatomic, retain) NSMutableDictionary *numberOfPubDictionary;
@property (nonatomic, retain) NSMutableDictionary *pubTimeDictionary;

@property (nonatomic, retain) IBOutlet UIView *loadingView;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *refreshButton;
@property (nonatomic, assign) BOOL noMoreUpdate;
@property (nonatomic, assign) BOOL updating;
@property (nonatomic, retain) IBOutlet UIView *footerView;
@property (nonatomic, retain) NSMutableArray *imageArray;
@property (nonatomic, retain) NSMutableDictionary *imageDownloadsInProgress;

@property (nonatomic, retain) NSMutableDictionary *imageUrlDictionary;
@property (nonatomic, retain) NSMutableDictionary *snsDictionary;

@property (nonatomic, retain) IBOutlet UIImageView *statusBgImageView;
@property (nonatomic, retain) IBOutlet UIImageView *statusImageView;
@property (nonatomic, retain) NSString *keyword;
@property (nonatomic, retain) NSOperationQueue *queue;

-(void)loadAd;
-(void)loadSlogan;
-(void)configHeaderView;
-(void)configCell:(UITableViewCell *)cell andIndexPath:(NSIndexPath *)indexPath;
-(void) addHeight:(double)addHeight forView:(UIView *)cellView;
-(void) addY:(double)addHeight forView:(UIView *)cellView;

-(IBAction) writeButtonClicked;
-(IBAction) goPageButtonClicked;
-(void) restoreCell:(UITableViewCell *)cell;

-(IBAction) refreshButtonClicked;
- (void)startImageDownload:(NSIndexPath *)indexPath andImageUrl:(NSString *)imageUrl;
@end

