//
//  EarningViewController.h
//  AdbyMe
//
//  Created by Baekjoon Choi on 4/4/11.
//  Copyright 2011 Megalusion. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASIHTTPRequest.h"

@interface EarningViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, ASIHTTPRequestDelegate> {
    UIView *headerView;
    UITableView *theTableView;
    UITableViewCell *earningLifeTimeCell;
    UITableViewCell *earningCell;
    
    ASIHTTPRequest *request;
    NSString *sinceUrl;
    
    NSMutableArray *earningsArray;
    NSDictionary *userDictionary;

    UIView *footerView;
    
    BOOL updating;
}
@property (nonatomic, retain) IBOutlet UIView *headerView;
@property (nonatomic, retain) IBOutlet UITableView *theTableView;
@property (nonatomic, retain) IBOutlet UITableViewCell *earningLifeTimeCell;
@property (nonatomic, retain) IBOutlet UITableViewCell *earningCell;
@property (nonatomic, retain) ASIHTTPRequest *request;
@property (nonatomic, retain) NSString *sinceUrl;
@property (nonatomic, retain) NSMutableArray *earningsArray;
@property (nonatomic, retain) NSDictionary *userDictionary;
@property (nonatomic, retain) IBOutlet UIView *footerView;
@property (nonatomic, assign) BOOL updating;

-(void)loadEarning;
-(void)configHeaderCell:(UITableViewCell *)cell;
-(void)configCell:(UITableViewCell *)cell row:(int)row;
-(void)loadingStart;
-(void)loadingEnd;
-(void)updateMore;
-(void) startMoreUpdate;
@end
