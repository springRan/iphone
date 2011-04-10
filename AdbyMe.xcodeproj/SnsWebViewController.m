//
//  SnsWebViewController.m
//  AdbyMe
//
//  Created by Baekjoon Choi on 4/10/11.
//  Copyright 2011 Megalusion. All rights reserved.
//

#import "SnsWebViewController.h"


@implementation SnsWebViewController
@synthesize requestURL;
@synthesize webView;
@synthesize activityView;
@synthesize delegate;

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
    [requestURL release];
    [webView release];
    [activityView release];
    
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
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.requestURL]]];
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
-(void)webViewDidStartLoad:(UIWebView *)webView{
    NSLog(@"Start");
    [self.activityView startAnimating];
}

-(void)webViewDidFinishLoad:(UIWebView *)webView{
    NSLog(@"End");
    NSURL *url = [self.webView.request URL];
    NSString *urlString = [url absoluteString];
    NSRange range = [urlString rangeOfString:@"snas/callback"];
    if(range.location != NSNotFound) {
        NSString *json = [self.webView stringByEvaluatingJavaScriptFromString:@"document.documentElement.textContent"];
        [delegate connectFinished:json];
        [[self navigationController] popViewControllerAnimated:YES];
    }
    [self.activityView stopAnimating];

}



@end
