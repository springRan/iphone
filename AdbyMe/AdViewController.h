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

@interface AdViewController : UIViewController <ASIHTTPRequestDelegate, UITableViewDelegate, UITableViewDataSource, UIActionSheetDelegate> {
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
    NSString *bestSloganId;
    
    NSArray *sloganArray;
    
    NSString *sinceUrl;
    
    UITableViewCell *adCell;
    NSMutableDictionary *numberOfLinesDictionary;
    NSMutableDictionary *userDictionary;
    NSMutableDictionary *sloganDictionary;
    NSMutableDictionary *linkDictionary;
    NSMutableDictionary *createdDictionary;
    NSMutableDictionary *uvDictionary;
    NSMutableDictionary *linkIdDictionary;
    NSMutableDictionary *linkScoreDictionary;
    
    UIView *loadingView;
    
    UIBarButtonItem *refreshButton;
}
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
@property (nonatomic, retain) NSString *bestSloganId;
@property (nonatomic, retain) NSArray *sloganArray;
@property (nonatomic, retain) NSString *sinceUrl;
@property (nonatomic, retain) IBOutlet UITableViewCell *adCell;
@property (nonatomic, retain) NSMutableDictionary *numberOfLinesDictionary;
@property (nonatomic, retain) NSMutableDictionary *userDictionary;
@property (nonatomic, retain) NSMutableDictionary *sloganDictionary;
@property (nonatomic, retain) NSMutableDictionary *linkDictionary;
@property (nonatomic, retain) NSMutableDictionary *createdDictionary;
@property (nonatomic, retain) NSMutableDictionary *uvDictionary;
@property (nonatomic, retain) NSMutableDictionary *linkIdDictionary;
@property (nonatomic, retain) NSMutableDictionary *linkScoreDictionary;

@property (nonatomic, retain) IBOutlet UIView *loadingView;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *refreshButton;


-(void)loadAd;
-(void)loadSlogan;
-(void)configHeaderView;
-(void)configCell:(UITableViewCell *)cell andIndexPath:(NSIndexPath *)indexPath;
-(void) addHeight:(double)addHeight forView:(UIView *)cellView;
-(void) addY:(double)addHeight forView:(UIView *)cellView;
-(IBAction) likeButtonClicked:(int)row;
-(IBAction) dislikeButtonClicked:(int)row;
-(IBAction) writeButtonClicked;
-(IBAction) linkButtonClicked:(id)sender;
-(IBAction) goPageButtonClicked;

-(IBAction) likeDislikeButtonClicked:(id)sender;
-(IBAction) refreshButtonClicked;
@end
