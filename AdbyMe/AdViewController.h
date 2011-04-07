//
//  AdViewController.h
//  AdbyMe
//
//  Created by Baekjoon Choi on 4/6/11.
//  Copyright 2011 Megalusion. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASIHTTPRequest.h"

@interface AdViewController : UIViewController <ASIHTTPRequestDelegate> {
    NSString *adId;
    
    UIView *adHeaderView;
    UITableView *theTableView;
    
    NSDictionary *adDictionary;
    
    ASIHTTPRequest *request;
    
    UILabel *adTitleLabel;
    UILabel *uvLabel;
    UILabel *sloganLabel;
    UITextView *adTextView;
    UIImageView *adImageView;
    UILabel *cpcLabel;
    NSString *bestSloganId;
    
    NSArray *sloganArray;
    
}
@property (nonatomic, retain) NSString *adId;
@property (nonatomic, retain) IBOutlet UIView *adHeaderView;
@property (nonatomic, retain) IBOutlet UITableView *theTableView;
@property (nonatomic, retain) NSDictionary *adDictionary;
@property (nonatomic, retain) ASIHTTPRequest *request;

@property (nonatomic, retain) IBOutlet UILabel *adTitleLabel;
@property (nonatomic, retain) IBOutlet UILabel *uvLabel;
@property (nonatomic, retain) IBOutlet UILabel *sloganLabel;
@property (nonatomic, retain) IBOutlet UITextView *adTextView;
@property (nonatomic, retain) IBOutlet UIImageView *adImageView;
@property (nonatomic, retain) IBOutlet UILabel *cpcLabel;
@property (nonatomic, retain) NSString *bestSloganId;
@property (nonatomic, retain) NSArray *sloganArray;


-(void)loadAd;
-(void)loadSlogan;
-(void)configHeaderView;

@end
