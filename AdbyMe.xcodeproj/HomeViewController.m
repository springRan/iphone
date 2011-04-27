//
//  LoginViewController.m
//  AdbyMe
//
//  Created by Baekjoon Choi on 4/3/11.
//  Copyright 2011 Megalusion. All rights reserved.
//

#import "HomeViewController.h"
#import "LoginViewController.h"
#import "SignUpViewController.h"
#import "Address.h"
#import "AdbyMeAppDelegate.h"
#import "AdListViewController.h"

#define SIMPLE 2048
#define LINKED 2049

@implementation HomeViewController
@synthesize request;
@synthesize activityView;
@synthesize loginButton;
@synthesize signupButton;
@synthesize notificationUrl;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc
{
    [request clearDelegatesAndCancel];
    [request release];
    [activityView release];
    [loginButton release];
    [signupButton release];
    [notificationUrl release];
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
    [self startLoginCheck];
    if (self.request != nil) {
        [request clearDelegatesAndCancel];
        [request release];
        request = nil;
    }
    self.request = [[ASIHTTPRequest alloc]initWithURL:[NSURL URLWithString:[Address loginCheckURL]]];
    [self.request setDelegate:self];
    [self.request startAsynchronous];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

-(void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if ([self navigationController].navigationBarHidden == NO)
        [[self navigationController] setNavigationBarHidden:YES animated:YES];
}

-(void) viewDidDisappear:(BOOL)animated{
                [self endLoginCheck];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(IBAction) loginButtonClicked{
    LoginViewController *lViewController = [[LoginViewController alloc]initWithNibName:@"LoginViewController" bundle:nil];
    [[self navigationController] pushViewController:lViewController animated:YES];
    [lViewController release];
}


-(IBAction) signupButtonClicked{
    SignUpViewController *sViewController = [[SignUpViewController alloc]initWithNibName:@"SignUpViewController" bundle:nil];
    [[self navigationController] pushViewController:sViewController animated:YES];
    [sViewController release];
}
- (void)requestFinished:(ASIHTTPRequest *)aRequest{
    // Use when fetching text data
    NSString *responseString = [aRequest responseString];
    SBJsonParser *parser = [SBJsonParser new];
    NSDictionary *dict = [parser objectWithString:responseString];
    NSString *error = [dict objectForKey:@"error"];
    NSLog(@"%@",dict);
    NSDictionary *dict2 = [dict objectForKey:@"message"];
    
    if ([NSNull null] == (NSNull *)error || error==nil) {
        AdbyMeAppDelegate *delegate = [[UIApplication sharedApplication]delegate];
        delegate.userDictionary = [[dict objectForKey:@"user"] objectForKey:@"User"];
        NSMutableArray *arr = [dict objectForKey:@"snas"];
        if ((NSNull *)arr == [NSNull null]) {
            delegate.snaArray = [[NSMutableArray alloc]initWithCapacity:3];
        } else {
            delegate.snaArray = arr;
        }
        [self goNext:dict2 success:YES];
    } else {
        [self goNext:dict2 success:NO];
/*        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"Login Failed" message:error delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];
        [alertView release];*/
        
    }
}

-(void)comeOnNextPage{
    AdListViewController *aViewController = [[AdListViewController alloc]initWithNibName:@"AdListViewController" bundle:nil];
    [[self navigationController] pushViewController:aViewController animated:YES];
    [aViewController release];
}

-(void)goNext:(NSDictionary *)messageDictionary success:(BOOL)success{
    NSString *idString = [messageDictionary objectForKey:@"id"];
    NSString *urlString = [messageDictionary objectForKey:@"url"];
    NSString *messageString = [messageDictionary objectForKey:@"string"];
    self.notificationUrl = urlString;
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if (idString && [defaults valueForKey:idString] == nil) {
        [defaults setBool:YES forKey:idString];
        [defaults synchronize];
        if (urlString == nil){
            UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"Notification" message:messageString delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            alertView.tag = SIMPLE*10;
            if(success)
                alertView.tag += 1;
            [alertView show];
            [alertView release];
        } else {
            UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"Notification" message:messageString delegate:self cancelButtonTitle:@"OK" otherButtonTitles:@"Cancel", nil];
            alertView.tag = LINKED*10;   
            if(success)
                alertView.tag += 1;
            [alertView show];
            [alertView release];
        }
    } else{
        if(success)
            [self comeOnNextPage];
        else
            [self endLoginCheck];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    int type = alertView.tag / 10;
    int success = alertView.tag % 10;
    if (type == SIMPLE){
        if(success)
            [self comeOnNextPage];
        else
            [self endLoginCheck];
    } else if(type == LINKED){
        if (buttonIndex == [alertView cancelButtonIndex]){
            [[UIApplication sharedApplication]openURL:[NSURL URLWithString:self.notificationUrl]];
        }
        else{
            if(success)
                [self comeOnNextPage];
            else
                [self endLoginCheck];
        }
    }
}


- (void)requestFailed:(ASIHTTPRequest *)aRequest
{
    [self endLoginCheck];
    NSError *error = [aRequest error];
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"Login Failed" message:@"" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alertView show];
    [alertView release];
}


-(void)startLoginCheck{
    [self.loginButton setHidden:YES];
    [self.signupButton setHidden:YES];
    [self.activityView setHidden:NO];
    [self.activityView startAnimating];
}
-(void)endLoginCheck{
    [self.loginButton setHidden:NO];
    [self.signupButton setHidden:NO];
    [self.activityView setHidden:YES];
    [self.activityView stopAnimating];
    
}

@end
