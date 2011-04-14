//
//  SNSSettingViewController.m
//  AdbyMe
//
//  Created by Baekjoon Choi on 4/4/11.
//  Copyright 2011 Megalusion. All rights reserved.
//

#import "SNSSettingViewController.h"
#import "Address.h"
#import "SBJsonParser.h"
#import "AdbyMeAppDelegate.h"

#define LABEL_Y_WIDTH 283
#define LABEL_DEFAULT_Y 6
#define LABEL_SPACING 10

#define TWITTER 2048
#define FACEBOOK 2049
#define ME2DAY 2050

#define TWITTER_STR @"twitter"
#define FACEBOOK_STR @"facebook"
#define ME2DAY_STR @"me2day"

#define CONNECTED 2051
#define DISCONNECTED 2052

@implementation SNSSettingViewController
@synthesize twitterLabelBackgroundView;
@synthesize facebookLabelBackgroundView;
@synthesize me2dayLabelBackgroundView;
@synthesize request;
@synthesize twitterConnected;
@synthesize facebookConnected;
@synthesize me2dayConnected;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"SNS settings";
    }
    return self;
}

- (void)dealloc
{
    [request clearDelegatesAndCancel];
    
    [twitterLabelBackgroundView release];
    [facebookLabelBackgroundView release];
    [me2dayLabelBackgroundView release];
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
    [self updateLabels];

}

-(void) updateLabels {
    
    [self updateSnsLabel:TWITTER status:DISCONNECTED];
    [self updateSnsLabel:FACEBOOK status:DISCONNECTED];
    [self updateSnsLabel:ME2DAY status:DISCONNECTED];
    
    self.twitterConnected = FALSE;
    self.facebookConnected = FALSE;
    self.me2dayConnected = FALSE;
    
    AdbyMeAppDelegate *delegate = [[UIApplication sharedApplication]delegate];
    for (NSDictionary *dict in delegate.snaArray) {
        NSDictionary *dict2 = [dict objectForKey:@"Sna"];
        NSString *network = [dict2 objectForKey:@"network"];
        if ([network isEqualToString:TWITTER_STR]) {
            [self updateSnsLabel:TWITTER status:CONNECTED andSnsId:[dict2 objectForKey:@"username"] setDefault:NO];
            self.twitterConnected = YES;
        } else if ([network isEqualToString:FACEBOOK_STR]) {
            [self updateSnsLabel:FACEBOOK status:CONNECTED andSnsId:[dict2 objectForKey:@"username"] setDefault:NO];
            self.facebookConnected = YES;
        } else if ([network isEqualToString:ME2DAY_STR]) {
            [self updateSnsLabel:ME2DAY status:CONNECTED andSnsId:[dict2 objectForKey:@"username"] setDefault:NO];
            self.me2dayConnected = YES;
        }
    }
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

-(void)updateSnsLabel:(int)snstype status:(int)status andSnsId:(NSString *)snsId setDefault:(BOOL)isDefault{
    UIView *snsView;
    if (snstype == TWITTER) snsView = self.twitterLabelBackgroundView;
    else if (snstype == FACEBOOK) snsView = self.facebookLabelBackgroundView;
    else if(snstype == ME2DAY) snsView = self.me2dayLabelBackgroundView;
    
    for (int i = 0 ; i < [[snsView subviews] count]; ++i) {
        UIView *subView = [[snsView subviews] objectAtIndex:i];
        if ([subView isMemberOfClass:[UILabel class]])
            [[[snsView subviews] objectAtIndex:i] removeFromSuperview];
    }
    UIFont *cellFont = [UIFont fontWithName:@"Helvetica" size:17.0];
    CGSize constraintSize = CGSizeMake(LABEL_Y_WIDTH, MAXFLOAT);
   
    if (status == DISCONNECTED) {
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectZero];
        label.text = @"Tap to connect";
        label.font = cellFont;
        label.textColor = [UIColor colorWithRed:185.0/256.0 green:185.0/256.0 blue:185.0/256.0 alpha:1.0];
        CGSize labelSize = [label.text sizeWithFont:cellFont constrainedToSize:constraintSize lineBreakMode:UILineBreakModeWordWrap];
        CGRect frame = label.frame;
        frame.origin = CGPointZero;
        frame.origin.y = LABEL_DEFAULT_Y;
        frame.size = labelSize;
        [label setFrame:frame];
        [snsView addSubview:label];
        [label release];
    }
    else{
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectZero];
        label.text = snsId;
        label.font = cellFont;
        label.textColor = [UIColor blackColor];
        CGSize labelSize = [label.text sizeWithFont:cellFont constrainedToSize:constraintSize lineBreakMode:UILineBreakModeWordWrap];
        CGRect frame = label.frame;
        frame.origin = CGPointZero;
        frame.origin.y = LABEL_DEFAULT_Y;
        frame.size = labelSize;
        [label setFrame:frame];
        [snsView addSubview:label];
        
        [label release];
        if (isDefault) {
            label = [[UILabel alloc]initWithFrame:CGRectZero];
            label.text = @"(default)";
            label.textColor = [UIColor colorWithRed:127.0/256.0 green:127.0/256.0 blue:127.0/256.0 alpha:1.0];
            labelSize = [label.text sizeWithFont:cellFont constrainedToSize:constraintSize lineBreakMode:UILineBreakModeWordWrap];
            CGRect frame2 = label.frame;
            frame2.origin.x = frame.origin.x + frame.size.width + LABEL_SPACING;
            frame2.origin.y = LABEL_DEFAULT_Y;
            frame2.size = labelSize;
            
            [label setFrame:frame2];
            [snsView addSubview:label];
            [label release];
        }
    }

}

-(void)updateSnsLabel:(int)snstype status:(int)status{
    [self updateSnsLabel:snstype status:status andSnsId:@"" setDefault:NO];
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex != [actionSheet cancelButtonIndex]) {
        NSURL *url = [NSURL URLWithString:[Address disconnectSns:actionSheet.tag]];
        if(request){
            [request clearDelegatesAndCancel];
            [request release];
            request = nil;
        }
        self.request = [[ASIFormDataRequest alloc]initWithURL:url];
        [request setDelegate:self];
        if (actionSheet.tag == TWITTER) {
            [request setDidFinishSelector:@selector(twitterRequestDone:)];
        } else if (actionSheet.tag == FACEBOOK) {
            [request setDidFinishSelector:@selector(facebookRequestDone:)];            
        } else if(actionSheet.tag == ME2DAY) {
            [request setDidFinishSelector:@selector(me2dayRequestDone:)];            
        }
        
        [request startAsynchronous];
    }
}

-(IBAction) snsButtonClicked:(id)sender{
    UIButton *button = (UIButton *)sender;
    int buttonTag = button.tag;
    if (buttonTag == TWITTER) {
        NSLog(@"Twitter");
        if (self.twitterConnected) {
            UIActionSheet *actionSheet = [[UIActionSheet alloc]initWithTitle:@"" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:@"Remove account" otherButtonTitles:nil];
            actionSheet.tag = TWITTER;
            [actionSheet showInView:self.view];
            [actionSheet release];
        } else {
            SnsWebViewController *sViewController = [[SnsWebViewController alloc]initWithNibName:@"SnsWebViewController" bundle:nil];
            sViewController.requestURL = [Address connectSns:TWITTER];
            sViewController.delegate = self;
            sViewController.snsType = buttonTag;
            [[self navigationController] pushViewController:sViewController animated:YES];
        }
    } else if(buttonTag == FACEBOOK) {
        NSLog(@"Facebook");
        if (self.facebookConnected) {
            UIActionSheet *actionSheet = [[UIActionSheet alloc]initWithTitle:@"" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:@"Remove account" otherButtonTitles:nil];
            actionSheet.tag = FACEBOOK;
            [actionSheet showInView:self.view];
            [actionSheet release];
            
        } else {
            SnsWebViewController *sViewController = [[SnsWebViewController alloc]initWithNibName:@"SnsWebViewController" bundle:nil];
            sViewController.requestURL = [Address connectSns:FACEBOOK];
            sViewController.delegate = self;
            sViewController.snsType = buttonTag;
            [[self navigationController] pushViewController:sViewController animated:YES];
        }
    } else if(buttonTag == ME2DAY) {
        NSLog(@"Me2day");
        if (self.me2dayConnected) {
            UIActionSheet *actionSheet = [[UIActionSheet alloc]initWithTitle:@"" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:@"Remove account" otherButtonTitles:nil];
            actionSheet.tag = ME2DAY;
            [actionSheet showInView:self.view];
            [actionSheet release];
        } else {
            SnsWebViewController *sViewController = [[SnsWebViewController alloc]initWithNibName:@"SnsWebViewController" bundle:nil];
            sViewController.requestURL = [Address connectSns:ME2DAY];
            sViewController.delegate = self;
            sViewController.snsType = buttonTag;
            [[self navigationController] pushViewController:sViewController animated:YES];
        }
    }

}

- (void)connectFinished:(id)sender json:(NSString *)json{
    SBJsonParser *parser = [SBJsonParser new];
    NSDictionary *dict = [parser objectWithString:json];
    dict = [dict objectForKey:@"sna"];
    SnsWebViewController *sViewController = (SnsWebViewController *)sender;
    int snsType = sViewController.snsType;
    AdbyMeAppDelegate *delegate = [[UIApplication sharedApplication]delegate];
    NSLog(@"%@",delegate.snaArray);
    NSMutableDictionary *snaDict = [NSMutableDictionary dictionaryWithCapacity:3];
    [snaDict setValue:[dict objectForKey:@"username"] forKey:@"username"];
    [snaDict setValue:[dict objectForKey:@"extern_id"] forKey:@"extern_id"];
    NSString *snsString = @"";
    if (snsType == TWITTER) {
        snsString = TWITTER_STR;
    } else if (snsType == FACEBOOK) {
        snsString = FACEBOOK_STR;
    } else if (snsType == ME2DAY) {
        snsString = ME2DAY_STR;
    }
    [snaDict setValue:snsString forKey:@"network"];
    NSMutableDictionary *snaContainerDict = [NSMutableDictionary dictionaryWithCapacity:1];
    [snaContainerDict setObject:snaDict forKey:@"Sna"];
    [delegate.snaArray addObject:snaContainerDict];
    NSLog(@"%@",delegate.snaArray);
    [self updateLabels];
}

- (void)twitterRequestDone:(ASIHTTPRequest *)aRequest {
    NSString *responseString = [aRequest responseString];
    SBJsonParser *parser = [SBJsonParser new];
    NSDictionary *dict = [parser objectWithString:responseString];
    NSString *error = [dict objectForKey:@"error"];
    if ([NSNull null] == (NSNull *)error) {
        [self removeRequestDone:TWITTER];
    } else {
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"Remove Account Failed" message:error delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];
        [alertView release];
    }
}
- (void)facebookRequestDone:(ASIHTTPRequest *)aRequest {
    NSString *responseString = [aRequest responseString];
    SBJsonParser *parser = [SBJsonParser new];
    NSDictionary *dict = [parser objectWithString:responseString];
    NSString *error = [dict objectForKey:@"error"];
    if ([NSNull null] == (NSNull *)error) {
        [self removeRequestDone:FACEBOOK];
    } else {
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"Remove Account Failed" message:error delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];
        [alertView release];
    }
}
- (void)me2dayRequestDone:(ASIHTTPRequest *)aRequest {
    NSString *responseString = [aRequest responseString];
    SBJsonParser *parser = [SBJsonParser new];
    NSDictionary *dict = [parser objectWithString:responseString];
    NSString *error = [dict objectForKey:@"error"];
    if ([NSNull null] == (NSNull *)error) {
        [self removeRequestDone:ME2DAY];
    } else {
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"Remove Account Failed" message:error delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];
        [alertView release];
    }
}

- (void)requestFailed:(ASIHTTPRequest *)aRequest
{
    NSError *error = [aRequest error];
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"Remove Account Failed" message:[error description] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alertView show];
    [alertView release];
}

-(void)removeRequestDone:(int)snsType{
    NSString *snsString = @"";
    if (snsType == TWITTER) {
        self.twitterConnected = NO;
        snsString = TWITTER_STR;
    } else if (snsType == FACEBOOK) {
        self.facebookConnected = NO;
        snsString = FACEBOOK_STR;
    } else if (snsType == ME2DAY) {
        self.me2dayConnected = NO;
        snsString = ME2DAY_STR;
    }
    AdbyMeAppDelegate *delegate = [[UIApplication sharedApplication] delegate];
    for(NSDictionary *dict in delegate.snaArray) {
        NSDictionary *dict2 = [dict objectForKey:@"Sna"];
        NSString *network = [dict2 objectForKey:@"network"];
        if ([network isEqualToString:snsString]) {
            [delegate.snaArray removeObject:dict];
            break;
        }
    }
    [self updateLabels];
}

@end
