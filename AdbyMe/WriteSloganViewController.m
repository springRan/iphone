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

#define MAX_COPY_LENGTH 100

#define SPACE_LENGTH 5

#define INITIAL_CHECK_ALERT_VIEW 2048
#define PUBLISH_ALERT_VIEW 2049

@implementation WriteSloganViewController
@synthesize writeButton;
@synthesize userImageView;
@synthesize usernameLabel;
@synthesize leftCharLabel;
@synthesize copyInputView;
@synthesize keywordView;
@synthesize keywordLabel;
@synthesize adId;
@synthesize request;
@synthesize loadingView;
@synthesize delegate;
@synthesize keyword;
@synthesize queue;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"Write slogan";
    }
    return self;
}

- (void)dealloc
{
    [request clearDelegatesAndCancel];
    [writeButton release];
    [userImageView release];
    [usernameLabel release];
    [keyword release];
    [leftCharLabel release];
    [keywordView release];
    [loadingView release];
    [keywordLabel release];
    [copyInputView release];
    [adId release];
    [request release];
    [queue release];
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

    // write button
    self.writeButton = [[UIBarButtonItem alloc]initWithTitle:@"Write" style:UIBarButtonItemStylePlain target:self action:@selector(writeButtonClicked)];
    self.navigationItem.rightBarButtonItem = self.writeButton;

    // keyword
    if ((NSNull *)keyword == [NSNull null] || keyword == nil) {
        self.keywordView.hidden = YES;
        CGRect frame = self.copyInputView.frame;
        frame.size.height += self.keywordView.frame.size.height;
        [self.copyInputView setFrame:frame];
    } else {
        self.keywordLabel.text = self.keyword;
    }
 

    AdbyMeAppDelegate *adbymeDelegate = [[UIApplication sharedApplication]delegate];

    // user avatar
    self.queue = [[NSOperationQueue alloc]init];
    [self.queue setMaxConcurrentOperationCount:10];
    NSString *imageURL = [adbymeDelegate.userDictionary objectForKey:@"avatar"];
    if ([NSNull null] == (NSNull *)imageURL) {
        imageURL = @"https://www.adby.me/img/noFace.jpg";
    }
    ASIHTTPRequest *imageRequest = [[ASIHTTPRequest alloc]initWithURL:[NSURL URLWithString:imageURL]];
    [imageRequest setDelegate:self];
    [imageRequest setDidFinishSelector:@selector(imageDownloadRequestDone:)];
    [imageRequest setDidFailSelector:@selector(imageDownloadRequestFail:)];
    [queue addOperation:imageRequest];
    [self retain];
    [imageRequest release];
    
    // user name
    self.usernameLabel.text = [adbymeDelegate.userDictionary objectForKey:@"username"];
    [self.usernameLabel sizeToFit];
    [self.copyInputView becomeFirstResponder];

}
- (void)imageDownloadRequestFail:(ASIHTTPRequest *)aRequest {
    NSLog(@"imageDownloadRequestFail");
    [self release];
}
- (void)imageDownloadRequestDone:(ASIHTTPRequest *)aRequest {
    NSLog(@"imageDownloadRequestDone");
    NSData *imageData = [aRequest responseData];
    UIImage *myImage = [[UIImage alloc] initWithData:imageData];
    [self.userImageView setImage:myImage];
    [self.userImageView setHighlightedImage:myImage];
    [self release];
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

-(void)writeButtonClicked{
    NSLog(@"writeButtonClicked");
    
    if(request){
        [request clearDelegatesAndCancel];
        [request release];
        request = nil;
    }
    NSURL *url = [NSURL URLWithString:[Address writeSlogan:adId]];

    self.request = [[ASIFormDataRequest alloc] initWithURL:url];
    [self.request setDelegate:self];
    [self.request setDidFinishSelector:@selector(writeRequestDone:)];
    [self.request setDidFailSelector:@selector(writeRequestFailed:)];
    [self.request setPostValue:self.copyInputView.text forKey:@"data[Slogan][slogan]"];
    [self.request startAsynchronous];
}

-(void)updateLeftLabel:(int)length{
    //  SPACE_LENGTH - [self.linkButton.titleLabel.text length]
    int remain =  MAX_COPY_LENGTH - length;
    if (remain < 0)
        leftCharLabel.textColor = [UIColor redColor];
    else 
        leftCharLabel.textColor = [UIColor blackColor];
    leftCharLabel.text = [NSString stringWithFormat:@"%d",remain];
}
- (void)textViewDidChange:(UITextView *)textView{
    [self updateLeftLabel:[textView.text length]];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    [[self navigationController] popViewControllerAnimated:YES];
}

- (void)writeRequestFailed:(ASIHTTPRequest *)aRequest {
    NSError *error = [aRequest error];
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"Write Failed" message:@"" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alertView show];
    [alertView release];
}

- (void)writeRequestDone:(ASIHTTPRequest *)aRequest {
    NSString *responseString = [aRequest responseString];
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
@end
