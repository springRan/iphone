//
//  WriteSloganViewController.m
//  AdbyMe
//
//  Created by Baekjoon Choi on 4/9/11.
//  Copyright 2011 Megalusion. All rights reserved.
//

#import "WriteSloganViewController.h"
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

@implementation WriteSloganViewController
@synthesize snsType;
@synthesize publishButton;
@synthesize snsImageView;
@synthesize usernameLabel;
@synthesize leftCharLabel;
@synthesize copyInputView;
@synthesize linkButton;
@synthesize keywordView;
@synthesize keywordLabel;
@synthesize adId;
@synthesize request;
@synthesize loadingView;
@synthesize delegate;
@synthesize keyword;

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
    [keyword release];
    [leftCharLabel release];
    [linkButton release];
    [keywordView release];
    [loadingView release];
    [keywordLabel release];
    [copyInputView release];
    [adId release];
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
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.publishButton = [[UIBarButtonItem alloc]initWithTitle:@"Publish" style:UIBarButtonItemStylePlain target:self action:@selector(publishButtonClicked)];
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
    
    if ((NSNull *)keyword == [NSNull null] || keyword == nil) {
        self.keywordView.hidden = YES;
        CGRect frame = self.copyInputView.frame;
        frame.size.height += self.keywordView.frame.size.height;
        [self.copyInputView setFrame:frame];
    } else {
        self.keywordLabel.text = self.keyword;
    }
 
    AdbyMeAppDelegate *adbymeDelegate = [[UIApplication sharedApplication]delegate];
    self.usernameLabel.text = [adbymeDelegate.userDictionary objectForKey:@"username"];
    [self.usernameLabel sizeToFit];
    
    [self.copyInputView becomeFirstResponder];
    
    NSURL *url = [NSURL URLWithString:[Address writeCopy:adId andSnsType:self.snsType]];
    self.request = [[ASIFormDataRequest alloc]initWithURL:url];
    [self.request setDelegate:self];
    [self.request setDidFinishSelector:@selector(initialCheckRequestDone:)];
    [self.request setDidFailSelector:@selector(initialCheckRequestFailed:)];
    [self.request startAsynchronous];
    
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
    [self.request clearDelegatesAndCancel];
    NSURL *url = [NSURL URLWithString:[Address writeCopy:adId andSnsType:self.snsType]];
    self.request = [[ASIFormDataRequest alloc] initWithURL:url];
    [self.request setDelegate:self];
    [self.request setDidFinishSelector:@selector(publishRequestDone:)];
    [self.request setDidFailSelector:@selector(publichRequestFailed:)];
    [self.request setPostValue:self.copyInputView.text forKey:@"data[Slogan][copy]"];
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
- (void)textViewDidChange:(UITextView *)textView{
    [self updateLeftLabel:[textView.text length]];
}
-(void)setLinkButtonUrl:(NSString *)url{
    NSString *urlText = [NSString stringWithFormat:@"     %@",url];
    [self.linkButton setTitle:urlText forState:UIControlStateNormal];
    [self.linkButton setTitle:urlText forState:UIControlStateHighlighted];
    [self updateLeftLabel:[self.copyInputView.text length]];
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
            UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"Write Failed" message:@"Connect a SNS" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            alertView.tag = INITIAL_CHECK_ALERT_VIEW;
            [alertView show];
            [alertView release];
        } else {
            [self setLinkButtonUrl:[dict objectForKey:@"link"]];
        }
    } else {
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"Write Failed" message:error delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        alertView.tag = INITIAL_CHECK_ALERT_VIEW;
        [alertView show];
        [alertView release];
    }
}

- (void)initialCheckRequestFailed:(ASIHTTPRequest *)aRequest {
    [self.loadingView removeFromSuperview];
    NSError *error = [aRequest error];
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"Write Failed" message:[error description] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    alertView.tag = INITIAL_CHECK_ALERT_VIEW;
    [alertView show];
    [alertView release];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    [[self navigationController] popViewControllerAnimated:YES];
}

- (void)publishRequestFailed:(ASIHTTPRequest *)aRequest {
    NSError *error = [aRequest error];
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"Write Failed" message:[error description] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alertView show];
    [alertView release];
}

- (void)publishRequestDone:(ASIHTTPRequest *)aRequest {
    NSString *responseString = [aRequest responseString];
    NSLog(@"Email Request Done");
    NSLog(@"%@",responseString);
    SBJsonParser *parser = [SBJsonParser new];
    NSDictionary *dict = [parser objectWithString:responseString];
    NSString *error = [dict objectForKey:@"error"];
    if ([NSNull null] == (NSNull *)error) {
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"Write Success" message:@"" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];
        [alertView release];
        [delegate writeSuccess];
    } else {
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"Write Failed" message:error delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];
        [alertView release];
    }
}
-(IBAction) linkButtonClicked {
    UIActionSheet *actionSheet = [[UIActionSheet alloc]initWithTitle:@"" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"adby.me", @"bit.ly", @"goo.gl", nil];
    [actionSheet showInView:self.view];
    [actionSheet release];
}

- (void)linkRequestDone:(ASIHTTPRequest *)aRequest {
    NSString *response = [aRequest responseString];
    [self setLinkButtonUrl:response];
}
- (void)linkRequestFailed:(ASIHTTPRequest *)aRequest {
    NSError *error = [aRequest error];
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"Change Link Failed" message:[error description] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alertView show];
    [alertView release];
}
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex != [actionSheet cancelButtonIndex]) {
        [request clearDelegatesAndCancel];
        NSURL *url = [NSURL URLWithString:[Address makeShortLink:adId andLinkType:buttonIndex]];
        request = [[ASIFormDataRequest alloc]initWithURL:url];
        [request setDelegate:self];
        [request setDidFinishSelector:@selector(linkRequestDone:)];
        [request setDidFailSelector:@selector(linkRequestFailed:)];
        [request startAsynchronous];
    }
}
@end
