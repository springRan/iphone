//
//  LoginViewController.m
//  AdbyMe
//
//  Created by Baekjoon Choi on 4/3/11.
//  Copyright 2011 Megalusion. All rights reserved.
//

#import "LoginViewController.h"
#import "AdListViewController.h"
#import "CustomCellBackgroundView.h"
#import "Address.h"
#import "AdListViewController.h"
#import "AdbyMeAppDelegate.h"

@implementation LoginViewController
@synthesize emailField;
@synthesize passwordField;
@synthesize activityBarButton;
@synthesize activityIndicatorView;
@synthesize request;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        self.title = @"Login";
        // Custom initialization
    }
    return self;
}

- (void)dealloc
{
    
    [request clearDelegatesAndCancel];  // Cancel request.

    [emailField release];
    [passwordField release];
    [activityBarButton release];
    [activityIndicatorView release];
    [request release];
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
    self.activityIndicatorView = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    self.activityIndicatorView.hidesWhenStopped = YES;

    self.activityBarButton = [[UIBarButtonItem alloc]initWithCustomView:self.activityIndicatorView];
    self.navigationItem.rightBarButtonItem = self.activityBarButton;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

-(void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if ([self navigationController].navigationBarHidden == YES)
        [[self navigationController] setNavigationBarHidden:NO animated:YES];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(void) loginCheck{
    //NSLog(@"%@",[Address loginURL]);
    NSURL *url = [NSURL URLWithString:[Address loginURL]];
    if(request){
        [request clearDelegatesAndCancel];
        [request release];
        request = nil;
    }
    request = [[ASIFormDataRequest alloc] initWithURL:url];
    [request setPostValue:emailField.text forKey:@"data[User][username_or_email]"];
    [request setPostValue:passwordField.text forKey:@"data[User][password]"];
    [request setDelegate:self];
    [request startAsynchronous];

    [self.activityIndicatorView startAnimating];

}

- (void)requestFinished:(ASIHTTPRequest *)aRequest
{
    [self.activityIndicatorView stopAnimating];
    // Use when fetching text data
    NSString *responseString = [aRequest responseString];
    SBJsonParser *parser = [SBJsonParser new];
    NSDictionary *dict = [parser objectWithString:responseString];
    NSString *error = [dict objectForKey:@"error"];
    if ([NSNull null] == (NSNull *)error) {
        AdbyMeAppDelegate *delegate = [[UIApplication sharedApplication]delegate];
        delegate.userDictionary = [dict objectForKey:@"user"];
        AdListViewController *aViewController = [[AdListViewController alloc]initWithNibName:@"AdListViewController" bundle:nil];
        [[self navigationController] pushViewController:aViewController animated:YES];
        [aViewController release];
    } else {
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"Login Failed" message:error delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];
        [alertView release];
    }
//    NSLog(@"%@",dict);
}

- (void)requestFailed:(ASIHTTPRequest *)aRequest
{
    [self.activityIndicatorView stopAnimating];
    NSError *error = [aRequest error];
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"Login Failed" message:[error description] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alertView show];
    [alertView release];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == self.emailField) {
        [self.passwordField becomeFirstResponder];
    } else if (textField == self.passwordField) {
        [self loginCheck];
    }
    return YES;
}

@end
