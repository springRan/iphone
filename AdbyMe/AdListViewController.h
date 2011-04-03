//
//  AdListViewController.h
//  AdbyMe
//
//  Created by Baekjoon Choi on 4/3/11.
//  Copyright 2011 Megalusion. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface AdListViewController : UIViewController <UIActionSheetDelegate>{
    UIBarButtonItem *settingButton;
    UIView *topView;
    UITableView *theTableView;
}

@property (nonatomic, retain) IBOutlet UIBarButtonItem *settingButton;
@property (nonatomic, retain) IBOutlet UIView *topView;
@property (nonatomic, retain) IBOutlet UITableView *theTableView;

-(IBAction) settingButtonClicked;
-(void)logout;
@end
