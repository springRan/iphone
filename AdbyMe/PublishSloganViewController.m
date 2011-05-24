//
//  WriteSloganViewController.m
//  AdbyMe
//
//  Created by Baekjoon Choi on 4/9/11.
//  Copyright 2011 Megalusion. All rights reserved.
//

#import "PublishSloganViewController.h"
#import "AdbyMeAppDelegate.h"
#import "Address.h"
#import "SBJsonParser.h"

#define TWITTER 1024
#define FACEBOOK 1025
#define ME2DAY 1026

#define MAX_COPY_LENGTH 140

#define SPACE_LENGTH 5

#define INITIAL_CHECK_ALERT_VIEW 2048
#define PUBLISH_ALERT_VIEW 2049

#define ADBY_ME 0
#define BIT_LY 1
#define GOO_GL 2

@implementation PublishSloganViewController
@synthesize snsType;
@synthesize publishButton;
@synthesize snsImageView;
@synthesize usernameLabel;
@synthesize leftCharLabel;
@synthesize sloganView;
@synthesize linkButton;
@synthesize sloganId;
@synthesize request;
@synthesize loadingView;
@synthesize delegate;
@synthesize hashId;
@synthesize link;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"publish slogan";
    }
    return self;
}

- (void)dealloc
{
    [request clearDelegatesAndCancel];
    [publishButton release];
    [snsImageView release];
    [usernameLabel release];
    [keyword release];
    [leftCharLabel release];
    [linkButton release];
    [loadingView release];
    [sloganView release];
    [sloganId release];
    [hashId release];
    [request release];
    
    delegate = nil;
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
    NSLog(@"viewDidLoad");
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.publishButton = [[UIBarButtonItem alloc]initWithTitle:@"Publish" style:UIBarButtonItemStylePlain target:self action:@selector(publishButtonClicked)];
    self.navigationItem.rightBarButtonItem = self.publishButton;
    
    UIImage *snsImage;
    NSString *networkString = @"twitter";
    if (self.snsType == TWITTER) {
        snsImage = [UIImage imageNamed:@"twlogo.png"];
        networkString = @"twitter";
    }
    else if(self.snsType == FACEBOOK) {
        snsImage = [UIImage imageNamed:@"fblogo.png"];
        networkString = @"facebook";
    }
    else if(self.snsType == ME2DAY) {
        snsImage = [UIImage imageNamed:@"m2logo.png"];
        networkString = @"me2day";
    }
    
    [self.snsImageView setImage:snsImage];
    [self.snsImageView setHighlightedImage:snsImage];

    AdbyMeAppDelegate *adbymeDelegate = [[UIApplication sharedApplication]delegate];
    for (NSDictionary *dict in adbymeDelegate.snaArray) {
        NSDictionary *dict2 = [dict objectForKey:@"Sna"];
        if([networkString isEqualToString:(NSString *)[dict2 objectForKey:@"network"]]) {
            self.usernameLabel.text = (NSString *)[dict2 objectForKey:@"username"];
            [self.usernameLabel sizeToFit];
        }
    }
    
    [self.sloganView becomeFirstResponder];
    
    NSURL *url = [NSURL URLWithString:[Address publishSlogan:self.sloganId andSnsType:self.snsType]];
    if(request){
        [request clearDelegatesAndCancel];
        [request release];
        request = nil;
    }
    self.request = [[ASIFormDataRequest alloc]initWithURL:url];
    [self.request setDelegate:self];
    [self.request setDidFinishSelector:@selector(initialCheckRequestDone:)];
    [self.request setDidFailSelector:@selector(initialCheckRequestFailed:)];
    [self.request startAsynchronous];    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(void)publishButtonClicked{
    if(request){
        [request clearDelegatesAndCancel];
        [request release];
        request = nil;
    }
    NSURL *url = [NSURL URLWithString:[Address publishSlogan:self.sloganId andSnsType:self.snsType]];
    self.request = [[ASIFormDataRequest alloc] initWithURL:url];
    [self.request setDelegate:self];
    [self.request setDidFinishSelector:@selector(publishRequestDone:)];
    [self.request setDidFailSelector:@selector(publichRequestFailed:)];
    [self.request setPostValue:self.hashId forKey:@"data[Pub][hash_id]"];
    [self.request setPostValue:self.link forKey:@"data[Pub][link]"];
    [self.request startAsynchronous];
}

-(void)updateLeftLabel:(int)length{
    int remain =  MAX_COPY_LENGTH - ([self.linkButton.titleLabel.text length] - SPACE_LENGTH) - length;
    if (remain < 0)
        leftCharLabel.textColor = [UIColor redColor];
    else 
        leftCharLabel.textColor = [UIColor blackColor];
    leftCharLabel.text = [NSString stringWithFormat:@"%d",remain];
}

-(void)setLinkButtonUrl:(NSString *)url{
    NSString *urlText = [NSString stringWithFormat:@"     %@",url];
    [self.linkButton setTitle:urlText forState:UIControlStateNormal];
    [self.linkButton setTitle:urlText forState:UIControlStateHighlighted];
}
 
- (void)initialCheckRequestDone:(ASIHTTPRequest *)aRequest {
    [self.loadingView removeFromSuperview];
    NSString *responseString = [aRequest responseString];
    NSLog(@"%@",responseString);
    SBJsonParser *parser = [SBJsonParser new];
    NSDictionary *dict = [parser objectWithString:responseString];
    NSString *error = [dict objectForKey:@"error"];
    if ([NSNull null] == (NSNull *)error) {
        //[self setCheckView:EMAIL_FIELD status:OK_STATUS message:@"OK"];
        NSString *link = [dict objectForKey:@"link"];
        if ((NSNull *)link == [NSNull null]) {
            UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"Publish Failed" message:@"Connect a SNS" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            alertView.tag = INITIAL_CHECK_ALERT_VIEW;
            [alertView show];
            [alertView release];
        } else {
            NSString *slogan = [dict objectForKey:@"slogan"];
            [self.sloganView setText:slogan];

            self.hashId = [dict objectForKey:@"hash_id"];

            self.link = [dict objectForKey:@"link"];
            
            [self setLinkButtonUrl:self.link];
        }
    } else {
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"Publish Failed" message:error delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        alertView.tag = INITIAL_CHECK_ALERT_VIEW;
        [alertView show];
        [alertView release];
    }
}

- (void)initialCheckRequestFailed:(ASIHTTPRequest *)aRequest {
    [self.loadingView removeFromSuperview];
    NSError *error = [aRequest error];
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"Publish Failed" message:@"" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    alertView.tag = INITIAL_CHECK_ALERT_VIEW;
    [alertView show];
    [alertView release];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    [[self navigationController] popViewControllerAnimated:YES];
}

- (void)publishRequestFailed:(ASIHTTPRequest *)aRequest {
    NSError *error = [aRequest error];
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"Publish Failed" message:@"" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alertView show];
    [alertView release];
}

- (void)publishRequestDone:(ASIHTTPRequest *)aRequest {
    NSString *responseString = [aRequest responseString];
    NSLog(@"%@",responseString);
    SBJsonParser *parser = [SBJsonParser new];
    NSDictionary *dict = [parser objectWithString:responseString];
    NSString *error = [dict objectForKey:@"error"];
    if ([NSNull null] == (NSNull *)error) {
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"Publish Success" message:@"" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];
        [alertView release];
        [delegate writeSuccess];
    } else {
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"Publish Failed" message:error delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];
        [alertView release];
    }
}

// link button clicked
-(IBAction) linkButtonClicked {
    NSLog(@"linkButtonClicked");
    UIActionSheet *actionSheet = [[UIActionSheet alloc]initWithTitle:@"" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"adby.me", @"bit.ly", @"goo.gl", nil];
    [actionSheet showInView:self.view];
    [actionSheet release];
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex != [actionSheet cancelButtonIndex]) {
        if(request){
            [request clearDelegatesAndCancel];
            [request release];
            request = nil;
        }
        NSURL *url = [NSURL URLWithString:[Address makeShortLink:self.hashId andLinkType:buttonIndex]];
        request = [[ASIFormDataRequest alloc]initWithURL:url];
        [request setDelegate:self];
        [request setDidFinishSelector:@selector(linkRequestDone:)];
        [request setDidFailSelector:@selector(linkRequestFailed:)];
        [request startAsynchronous];
    }
}
- (void)linkRequestDone:(ASIHTTPRequest *)aRequest {
    NSString *response = [aRequest responseString];
    
    SBJsonParser *parser = [SBJsonParser new];
    NSDictionary *dict = [parser objectWithString:response];
    self.link = [dict objectForKey:@"link"];
    
    [self setLinkButtonUrl:self.link];
}
- (void)linkRequestFailed:(ASIHTTPRequest *)aRequest {
    NSError *error = [aRequest error];
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"Change Link Failed" message:@"" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alertView show];
    [alertView release];                                    
}
@end
