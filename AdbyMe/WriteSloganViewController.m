//
//  WriteSloganViewController.m
//  AdbyMe
//
//  Created by Baekjoon Choi on 4/9/11.
//  Copyright 2011 Megalusion. All rights reserved.
//

#import "WriteSloganViewController.h"
#import "AdbyMeAppDelegate.h"

#define TWITTER 1024
#define FACEBOOK 1025
#define ME2DAY 1026

@implementation WriteSloganViewController
@synthesize snsType;
@synthesize publishButton;
@synthesize snsImageView;
@synthesize usernameLabel;
@synthesize leftCharLabel;
@synthesize copyInputView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"Write slogan";
    }
    return self;
}

- (void)dealloc
{
    [publishButton release];
    [snsImageView release];
    [usernameLabel release];
    [leftCharLabel release];
    [copyInputView release];
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
    self.publishButton = [[UIBarButtonItem alloc]initWithTitle:@"Publish" style:UIBarButtonItemStyleDone target:self action:@selector(publishButtonClicked)];
    self.navigationItem.rightBarButtonItem = self.publishButton;

    UIImage *snsImage;
    if (self.snsType == TWITTER)
        snsImage = [UIImage imageNamed:@"twlogo.png"];
    else if(self.snsType == FACEBOOK)
        snsImage = [UIImage imageNamed:@"fblogo.png"];
    else if(self.snsType == ME2DAY)
        snsImage = [UIImage imageNamed:@"m2logo.png"];
    
    [self.snsImageView setImage:snsImage];
    [self.snsImageView setHighlightedImage:snsImage];
 
    AdbyMeAppDelegate *delegate = [[UIApplication sharedApplication]delegate];
    self.usernameLabel.text = [delegate.userDictionary objectForKey:@"username"];
    [self.usernameLabel sizeToFit];
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

-(void)publishButtonClicked{
    
}

@end
