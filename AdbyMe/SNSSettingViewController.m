//
//  SNSSettingViewController.m
//  AdbyMe
//
//  Created by Baekjoon Choi on 4/4/11.
//  Copyright 2011 Megalusion. All rights reserved.
//

#import "SNSSettingViewController.h"

#define LABEL_Y_WIDTH 283
#define LABEL_DEFAULT_Y 6

#define TWITTER 2048
#define FACEBOOK 2049
#define ME2DAY 2050

#define CONNECTED 2051
#define DISCONNECTED 2052



@implementation SNSSettingViewController
@synthesize twitterLabelBackgroundView;
@synthesize facebookLabelBackgroundView;
@synthesize me2dayLabelBackgroundView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"SNS settings";
    }
    return self;
}

- (void)dealloc
{
    [twitterLabelBackgroundView release];
    [facebookLabelBackgroundView release];
    [me2dayLabelBackgroundView release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self updateSnsLabel:TWITTER status:CONNECTED andSnsId:@"Onasup" setDefault:YES];
    [self updateSnsLabel:FACEBOOK status:DISCONNECTED];
    [self updateSnsLabel:ME2DAY status:CONNECTED andSnsId:@"최완섭" setDefault:NO];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(void)updateSnsLabel:(int)snstype status:(int)status andSnsId:(NSString *)snsId setDefault:(BOOL)isDefault{
    UIView *snsView;
    if (snstype == TWITTER) snsView = self.twitterLabelBackgroundView;
    else if (snstype == FACEBOOK) snsView = self.facebookLabelBackgroundView;
    else if(snstype == ME2DAY) snsView = self.me2dayLabelBackgroundView;
    
    for (int i = 0 ; i < [[snsView subviews] count]; ++i) {
        [[[snsView subviews] objectAtIndex:i] removeFromSuperview];
    }
    UIFont *cellFont = [UIFont fontWithName:@"Helvetica" size:17.0];
    CGSize constraintSize = CGSizeMake(LABEL_Y_WIDTH, MAXFLOAT);
    //CGSize labelSize = [adTitle sizeWithFont:cellFont constrainedToSize:constraintSize lineBreakMode:UILineBreakModeWordWrap];
   
    if (status == DISCONNECTED) {
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectZero];
        label.text = @"Tap to connect";
        CGSize labelSize = [label.text sizeWithFont:cellFont constrainedToSize:constraintSize lineBreakMode:UILineBreakModeWordWrap];
        CGRect frame = label.frame;
        frame.origin = CGPointZero;
        frame.size = labelSize;
        [snsView addSubview:label];
        [label release];
    }

}

-(void)updateSnsLabel:(int)snstype status:(int)status{
    [self updateSnsLabel:snstype status:status andSnsId:@"" setDefault:NO];
}

@end
