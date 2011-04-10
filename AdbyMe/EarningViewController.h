//
//  EarningViewController.h
//  AdbyMe
//
//  Created by Baekjoon Choi on 4/4/11.
//  Copyright 2011 Megalusion. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface EarningViewController : UIViewController <UITableViewDelegate, UITableViewDataSource> {
    UIView *headerView;
    UITableView *theTableView;
    UITableViewCell *earningLifeTimeCell;
    UITableViewCell *earningCell;
}
@property (nonatomic, retain) IBOutlet UIView *headerView;
@property (nonatomic, retain) IBOutlet UITableView *theTableView;
@property (nonatomic, retain) IBOutlet UITableViewCell *earningLifeTimeCell;
@property (nonatomic, retain) IBOutlet UITableViewCell *earningCell;


@end
