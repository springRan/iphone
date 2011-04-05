//
//  AdListViewController.h
//  AdbyMe
//
//  Created by Baekjoon Choi on 4/3/11.
//  Copyright 2011 Megalusion. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"


@interface AdListViewController : UIViewController <UIActionSheetDelegate, ASIHTTPRequestDelegate, UITableViewDelegate, UITableViewDataSource>{
    UIBarButtonItem *settingButton;
    UIBarButtonItem *updateButton;
    UIView *topView;
    UITableView *theTableView;
    NSArray *adArray;
    UITableViewCell *adCell4;
    NSMutableDictionary *numberOfLinesDictionary;
    
    UILabel *reservedLabel;
    UILabel *availableLabel;
}

@property (nonatomic, retain) IBOutlet UIBarButtonItem *settingButton;
@property (nonatomic, retain) IBOutlet UIView *topView;
@property (nonatomic, retain) IBOutlet UITableView *theTableView;
@property (nonatomic, retain) NSArray *adArray;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *updateButton;
@property (nonatomic, retain) IBOutlet UITableViewCell *adCell4;
@property (nonatomic, retain) NSMutableDictionary *numberOfLinesDictionary;
@property (nonatomic, retain) IBOutlet UILabel *reservedLabel;
@property (nonatomic, retain) IBOutlet UILabel *availableLabel;


-(void)configCell:(UITableViewCell *)cell andIndexPath:(NSIndexPath *)indexPath;
-(IBAction) settingButtonClicked;
-(IBAction) updateButtonClicked;
-(void)logout;
-(void)loadAd;
-(void)updateDashboard;
-(void)getHeight;
-(void) addHeight:(double)addHeight forView:(UIView *)cellView;
-(void) addY:(double)addHeight forView:(UIView *)cellView;
@end
