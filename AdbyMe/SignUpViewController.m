//
//  SignUpViewController.m
//  AdbyMe
//
//  Created by Baekjoon Choi on 4/3/11.
//  Copyright 2011 Megalusion. All rights reserved.
//

#import "SignUpViewController.h"
#import "CustomCellBackgroundView.h"
#import "Address.h"
#import "SBJsonParser.h"
#import "AdListViewController.h"

#define EMAIL_FIELD 1
#define USERNAME_FIELD 2
#define PASSWORD_FIELD 3
#define NAME_FIELD 4

#define HIDDEN_STATUS 1
#define OK_STATUS 2
#define WARN_STATUS 3


@implementation SignUpViewController

@synthesize emailTextField;
@synthesize usernameTextField;
@synthesize passwordTextField;
@synthesize nameTextField;
@synthesize scrollView;
@synthesize savedPosition;
@synthesize emailLabel;
@synthesize usernameLabel;
@synthesize passwordLabel;
@synthesize nameLabel;
@synthesize termsButton;
@synthesize submitButton;
@synthesize totalSavedControl;
@synthesize emailCheckView;
@synthesize usernameCheckView;
@synthesize passwordCheckView;
@synthesize nameCheckView;
@synthesize activityBarButton;
@synthesize activityIndicatorView;
@synthesize request;
@synthesize shouldPop;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"Sign Up";
        // Custom initialization
    }
    return self;
}

- (void)dealloc
{
    [request clearDelegatesAndCancel];  // Cancel request.
    
    [emailTextField release];
    [usernameTextField release];
    [passwordTextField release];
    [nameTextField release];
    [scrollView release];
    [savedPosition release];
    [emailLabel release];
    [usernameLabel release];
    [passwordLabel release];
    [nameLabel release];
    [termsButton release];
    [submitButton release];
    [emailCheckView release];
    [usernameCheckView release];
    [passwordCheckView release];
    [nameCheckView release];
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

-(void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if ([self navigationController].navigationBarHidden == YES)
        [[self navigationController] setNavigationBarHidden:NO animated:YES];

}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    if (shouldPop)
        [[self navigationController]popViewControllerAnimated:NO];
    shouldPop = YES;
}
#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [scrollView setContentSize:CGSizeMake(320.0, 480.0)];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    self.totalSavedControl = 18;

    [self setCheckView:EMAIL_FIELD status:HIDDEN_STATUS];
    [self setCheckView:USERNAME_FIELD status:HIDDEN_STATUS];
    [self setCheckView:PASSWORD_FIELD status:HIDDEN_STATUS];
    [self setCheckView:NAME_FIELD status:HIDDEN_STATUS];

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

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == self.emailTextField) {
        [self.usernameTextField becomeFirstResponder];
    } else if (textField == self.usernameTextField) {
        [self.passwordTextField becomeFirstResponder];
    } else if (textField == self.passwordTextField) {
        [self.nameTextField becomeFirstResponder];
    } else if (textField == self.nameTextField) {
        [self.nameTextField resignFirstResponder];
    }
    return YES;
}
-(void) savePosition{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]initWithCapacity:self.totalSavedControl];
    self.savedPosition = dict;
    [dict release];
    
    for (int i = 1; i <= self.totalSavedControl; ++i) {
        UIView *control = [self.scrollView viewWithTag:i];
        [savedPosition setValue:[NSValue valueWithCGRect:control.frame] forKey:[NSString stringWithFormat:@"%d",i]];
    }
    
}

-(void)adjustPosition{
    if (savedPosition == nil) {
        [self savePosition];
    }
    for (NSString *key in self.savedPosition) {
        NSValue *val = [self.savedPosition valueForKey:key];
        CGRect frame = [val CGRectValue];
        UIView *control = [self.scrollView viewWithTag:[key intValue]];
        [control setFrame:frame];
    }
}

-(void)keyboardWillShow:(NSNotification *)notification{
    NSLog(@"Keyboard Show");
    [UIView beginAnimations:nil context:nil];
	CGRect frame = [self.scrollView frame];
	frame.size.height -= 216.0;
	[self.scrollView setFrame:frame];
    [self adjustPosition];
    [UIView setAnimationDuration:1.0];
    [UIView commitAnimations];
}

-(void)keyboardWillHide:(NSNotification *)notification{
	NSLog(@"Keyboard Hide");
    [UIView beginAnimations:nil context:nil];
	CGRect frame = [self.scrollView frame];
	frame.size.height += 216.0;
	[self.scrollView setFrame:frame];
    [self adjustPosition];
    [UIView setAnimationDuration:1.0];
    [UIView commitAnimations];
    
}

-(void)focusPosition:(UITextField *)textField{
    UILabel *focusLabel;
    /*
    if (textField == self.usernameTextField) {
        focusLabel = self.usernameLabel;
    } else if (textField == self.passwordTextField) {
        focusLabel = self.passwordLabel;
    } else if (textField == self.emailTextField) {
        focusLabel = self.emailLabel;
    } else if (textField == self.nameTextField) {
        focusLabel = self.nameLabel;
    }
    */
    if (self.savedPosition == nil)
        [self savePosition];
    
//    CGRect frame = focusLabel.frame;
    
//    [self.scrollView setContentOffset:CGPointMake(0, frame.origin.y) animated:YES];
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    [self focusPosition:textField];
    return YES;
}

-(void) setCheckView:(int)field status:(int)status{
    [self setCheckView:field status:status message:@""];
}
-(void) setCheckView:(int)field status:(int)status message:(NSString *)message{
    UIView *checkView;
    switch (field) {
        case EMAIL_FIELD:
            checkView = self.emailCheckView;
            break;
        case USERNAME_FIELD:
            checkView = self.usernameCheckView;
            break;
        case PASSWORD_FIELD:
            checkView = self.passwordCheckView;
            break;
        case NAME_FIELD:
            checkView = self.nameCheckView;
            break;
        default:
            return;
            break;
    }
    UIImageView *imageView = (UIImageView *)[checkView viewWithTag:1];
    UILabel *label = (UILabel *)[checkView viewWithTag:2];
    if (status == HIDDEN_STATUS) {
        [checkView setHidden:YES];
    } else {
        [checkView setHidden:NO];
        if (status == OK_STATUS) {
            [imageView setImage:[UIImage imageNamed:@"okicon.png"]];
        } else {
            [imageView setImage:[UIImage imageNamed:@"warnicon.png"]];
        }
        label.text = message;
        [label sizeToFit];
        float width = label.frame.size.width;
        CGRect frame = label.frame;
        frame.origin.x = checkView.frame.size.width - width;
        [label setFrame:frame];
        frame = imageView.frame;
        frame.origin.x = label.frame.origin.x - frame.size.width - 5.0;
        [imageView setFrame:frame];
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    if (textField == self.emailTextField) {
        NSURL *url = [NSURL URLWithString:[Address checkEmailURL]];
        self.request = [ASIFormDataRequest requestWithURL:url];
        [request setPostValue:self.emailTextField.text forKey:@"data[User][email]"];
        [request setDelegate:self];
        [request setDidFinishSelector:@selector(emailRequestDone:)];
        [request setDidFailSelector:@selector(requestWentWrong:)];
        [request startAsynchronous];
    } else if (textField == self.usernameTextField) {
        NSURL *url = [NSURL URLWithString:[Address checkUsernameURL]];
        self.request = [ASIFormDataRequest requestWithURL:url];
        [request setPostValue:self.usernameTextField.text forKey:@"data[User][username]"];
        [request setDelegate:self];
        [request setDidFinishSelector:@selector(usernameRequestDone:)];
        [request setDidFailSelector:@selector(requestWentWrong:)];
        [request startAsynchronous];
        
    } else if (textField == self.passwordTextField) {
        if ([self.passwordTextField.text length] <= 4) {
            [self setCheckView:PASSWORD_FIELD status:WARN_STATUS message:@"Very Weak"];
        } else {
            [self setCheckView:PASSWORD_FIELD status:OK_STATUS message:@"OK"];
        }
    } else if (textField == self.nameTextField) {
        
    }
}

- (void)emailRequestDone:(ASIHTTPRequest *)aRequest {
    NSString *responseString = [aRequest responseString];
    NSLog(@"Email Request Done");
    NSLog(@"%@",responseString);
    SBJsonParser *parser = [SBJsonParser new];
    NSDictionary *dict = [parser objectWithString:responseString];
    NSString *error = [dict objectForKey:@"error"];
    if ([NSNull null] == (NSNull *)error) {
        [self setCheckView:EMAIL_FIELD status:OK_STATUS message:@"OK"];
    } else {
        [self setCheckView:EMAIL_FIELD status:WARN_STATUS message:error];
    }

}

- (void)usernameRequestDone:(ASIHTTPRequest *)aRequest{
    NSString *responseString = [aRequest responseString];
    NSLog(@"Username Request Done");
    NSLog(@"%@",responseString);
    SBJsonParser *parser = [SBJsonParser new];
    NSDictionary *dict = [parser objectWithString:responseString];
    NSString *error = [dict objectForKey:@"error"];
    if ([NSNull null] == (NSNull *)error) {
        [self setCheckView:USERNAME_FIELD status:OK_STATUS message:@"OK"];        
    } else {
        [self setCheckView:USERNAME_FIELD status:WARN_STATUS message:error];
    }
}

- (void)registerRequestDone:(ASIHTTPRequest *)aRequest{
    NSString *responseString = [aRequest responseString];
    NSLog(@"Username Request Done");
    NSLog(@"%@",responseString);
    SBJsonParser *parser = [SBJsonParser new];
    NSDictionary *dict = [parser objectWithString:responseString];
    NSString *error = [dict objectForKey:@"error"];
    if ([NSNull null] == (NSNull *)error) {
        NSLog(@"Success");
        AdListViewController *aViewController = [[AdListViewController alloc]initWithNibName:@"AdListViewController" bundle:nil];
        [[self navigationController] pushViewController:aViewController animated:YES];
        [aViewController release];
    } else {
        NSLog(@"Failed");
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"Sign Up Failed" message:error delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];
        [alertView release];
    }
    [self.activityIndicatorView stopAnimating];
}

-(IBAction) submitClicked{
    NSURL *url = [NSURL URLWithString:[Address registerURL]];
    if (request) {
        [request clearDelegatesAndCancel];
        [request release];
        request = nil;
    }
    self.request = [ASIFormDataRequest requestWithURL:url];
    [request setPostValue:self.emailTextField.text forKey:@"data[User][email]"];
    [request setPostValue:self.usernameTextField.text forKey:@"data[User][username]"];
    [request setPostValue:self.passwordTextField.text forKey:@"data[User][password]"];
    [request setPostValue:self.nameTextField.text forKey:@"data[User][name]"];
    [request setDelegate:self];
    [request setDidFinishSelector:@selector(registerRequestDone:)];
    [request setDidFailSelector:@selector(requestWentWrong:)];
    [request startAsynchronous];
    [self.activityIndicatorView startAnimating];
}

-(IBAction) termsClicked{
    
}

- (void)requestWentWrong:(ASIHTTPRequest *)aRequest {
    NSError *error = [aRequest error];
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"Login Failed" message:[error description] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alertView show];
    [alertView release];
}

                                                
@end
