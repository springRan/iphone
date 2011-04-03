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


@interface AdListViewController : UIViewController <UIActionSheetDelegate, ASIHTTPRequestDelegate>{
    UIBarButtonItem *settingButton;
    UIView *topView;
    UITableView *theTableView;
    NSArray *adArray;
}

@property (nonatomic, retain) IBOutlet UIBarButtonItem *settingButton;
@property (nonatomic, retain) IBOutlet UIView *topView;
@property (nonatomic, retain) IBOutlet UITableView *theTableView;
@property (nonatomic, retain) NSArray *adArray;

-(IBAction) settingButtonClicked;
-(void)logout;
-(void)loadAd;
@end
