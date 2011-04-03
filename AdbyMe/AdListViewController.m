//
//  AdListViewController.m
//  AdbyMe
//
//  Created by Baekjoon Choi on 4/3/11.
//  Copyright 2011 Megalusion. All rights reserved.
//

#import "AdListViewController.h"
#import "Address.h"
#import "SBJsonParser.h"
#import "SNSSettingViewController.h"
#import "EarningViewController.h"

#define SNSSETTINGS 0
#define EARNINGS 1
#define LOGOUT 2
#define CANCEL 3

@implementation AdListViewController

@synthesize settingButton;
@synthesize topView;
@synthesize theTableView;
@synthesize adArray;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"Ad List";
        // Custom initialization
    }
    return self;
}

- (void)dealloc
{
    [theTableView release];
    [topView release];
    [settingButton release];
    [adArray release];
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
    self.settingButton = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"seticon.png"] style:UIBarButtonItemStyleDone target:self action:@selector(settingButtonClicked)];
    self.navigationItem.rightBarButtonItem = self.settingButton;
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self loadAd];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

-(void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    self.navigationItem.hidesBackButton = YES;
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
-(IBAction) settingButtonClicked{
    UIActionSheet *actionSheet = [[UIActionSheet alloc]initWithTitle:@"" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"SNS Settings",@"Earnings", @"Logout", nil];
    [actionSheet showInView:self.view];
    [actionSheet release];
}

-(void) logout{
    [[self navigationController]popViewControllerAnimated:YES];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == SNSSETTINGS) {
        SNSSettingViewController *sViewController = [[SNSSettingViewController alloc]initWithNibName:@"SNSSettingViewController" bundle:nil];
        [[self navigationController] pushViewController:sViewController animated:YES];
        [sViewController release];
    } else if (buttonIndex == EARNINGS) {
        EarningViewController *eViewController = [[EarningViewController alloc] initWithNibName:@"EarningViewController" bundle:nil];
        [[self navigationController] pushViewController:eViewController animated:YES];
        [eViewController release];
        
    } else if (buttonIndex == LOGOUT) {
        [self logout];
    } else if (buttonIndex == CANCEL) {
    }
}

-(void)loadAd{
    NSURL *url = [NSURL URLWithString:[Address adListURL]];
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    [request startAsynchronous];
    [request setDelegate:self];
}

- (void)requestFinished:(ASIHTTPRequest *)request
{
    // Use when fetching text data
    NSString *responseString = [request responseString];
    SBJsonParser *parser = [SBJsonParser new];
    self.adArray = [parser objectWithString:responseString];
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    NSError *error = [request error];
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"Failed" message:[error description] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alertView show];
    [alertView release];
}

@end
