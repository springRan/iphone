//
//  EarningViewController.m
//  AdbyMe
//
//  Created by Baekjoon Choi on 4/4/11.
//  Copyright 2011 Megalusion. All rights reserved.
//

#import "EarningViewController.h"
#import "Address.h"
#import "SBJsonParser.h"

@implementation EarningViewController
@synthesize headerView;
@synthesize theTableView;
@synthesize earningLifeTimeCell;
@synthesize earningCell;
@synthesize request;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"Earnings";
        // Custom initialization
    }
    return self;
}

- (void)dealloc
{
    [headerView release];
    [theTableView release];
    [earningLifeTimeCell release];
    [earningCell release];
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
    [self loadEarning];
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


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"EarningLifetimeCellIdentifier";
    static NSString *CellIdentifier2 = @"EarningCellIdentifier";
    
    int row = [indexPath row];
    
    if (row == 0) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (cell == nil){
            [[NSBundle mainBundle] loadNibNamed:@"EarningCellLifetime" owner:self options:nil];
            cell = self.earningLifeTimeCell;
            self.earningLifeTimeCell = nil;
        }
        return cell;
    } else {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier2];
        
        if (cell == nil){ 
            [[NSBundle mainBundle] loadNibNamed:@"EarningCell" owner:self options:nil];
            cell = self.earningCell;
            self.earningCell = nil;
        }
        
        return cell;
    }
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 10;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return self.headerView;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 35.0;
}

-(void)loadEarning{
    [self.request clearDelegatesAndCancel];
    NSURL *url = [NSURL URLWithString:[Address earningURL]];
    self.request = [[ASIHTTPRequest alloc]initWithURL:url];
    [self.request setDelegate:self];
    [self.request startAsynchronous];
}


- (void)requestFinished:(ASIHTTPRequest *)aRequest
{
    // Use when fetching text data
    NSString *responseString = [aRequest responseString];
    SBJsonParser *parser = [SBJsonParser new];
    NSDictionary *dict = [parser objectWithString:responseString];
    NSLog(@"%@",dict);
    NSString *error = [dict objectForKey:@"error"];
    if ([NSNull null] == (NSNull *)error) {
        
    } else {
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"Loading Failed" message:error delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];
        [alertView release];
        
    }
}

- (void)requestFailed:(ASIHTTPRequest *)aRequest
{
    NSError *error = [aRequest error];
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"Loading Failed" message:[error description] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alertView show];
    [alertView release];
}

@end
