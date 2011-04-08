//
//  WriteSloganViewController.h
//  AdbyMe
//
//  Created by Baekjoon Choi on 4/9/11.
//  Copyright 2011 Megalusion. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WriteSloganViewController : UIViewController {
    int snsType;
    UIBarButtonItem *publishButton;
    UIImageView *snsImageView;
    UILabel *usernameLabel;
    UILabel *leftCharLabel;
    UITextView *copyInputView;
    UIButton *linkButton;
}
@property (nonatomic, assign) int snsType;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *publishButton;
@property (nonatomic, retain) IBOutlet UIImageView *snsImageView;
@property (nonatomic, retain) IBOutlet UILabel *usernameLabel;
@property (nonatomic, retain) IBOutlet UILabel *leftCharLabel;
@property (nonatomic, retain) IBOutlet UITextView *copyInputView;

-(void)publishButtonClicked;

@end
