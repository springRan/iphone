//
//  AdListViewController.m
//  AdbyMe
//
//  Created by Baekjoon Choi on 4/3/11.
//  Copyright 2011 Megalusion. All rights reserved.
//

#import "AdListViewController.h"

#define SNSSETTINGS 0
#define EARNINGS 1
#define LOGOUT 2

@implementation AdListViewController

@synthesize settingButton;
@synthesize topView;
@synthesize theTableView;

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
    self.settingButton = [[UIBarButtonItem alloc]initWithTitle:@"Setting" style:UIBarButtonItemStyleBordered target:self action:@selector(settingButtonClicked)];
    self.navigationItem.rightBarButtonItem = self.settingButton;
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
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
    UIActionSheet *actionSheet = [[UIActionSheet alloc]initWithTitle:@"" delegate:self cancelButtonTitle:@"Logout" destructiveButtonTitle:nil otherButtonTitles:@"SNS Settings",@"Earnings", nil];
    [actionSheet showInView:self.view];
    [actionSheet release];
}

-(void) logout{
    [[self navigationController]popViewControllerAnimated:YES];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    switch (buttonIndex){
        case SNSSETTINGS:
            break;
        case EARNINGS:
            break;
        case LOGOUT:
            [self logout];
            break;
        default:
            break;
    }
}

@end