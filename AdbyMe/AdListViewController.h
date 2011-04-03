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
    UITableViewCell *adCell;
}

@property (nonatomic, retain) IBOutlet UIBarButtonItem *settingButton;
@property (nonatomic, retain) IBOutlet UIView *topView;
@property (nonatomic, retain) IBOutlet UITableView *theTableView;
@property (nonatomic, retain) NSArray *adArray;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *updateButton;
@property (nonatomic, retain) IBOutlet UITableViewCell *adCell;


-(IBAction) settingButtonClicked;
-(IBAction) updateButtonClicked;
-(void)logout;
-(void)loadAd;
@end
