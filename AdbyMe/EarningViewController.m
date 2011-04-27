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

#define DATE_LABEL 1024
#define UV_LABEL 1025
#define EARNINGS_LABEL 1026
#define STATUS_LABEL 1027

#define UPDATE_RATE 1.0

@implementation EarningViewController
@synthesize headerView;
@synthesize theTableView;
@synthesize earningLifeTimeCell;
@synthesize earningCell;
@synthesize request;
@synthesize sinceUrl;
@synthesize earningsArray;
@synthesize userDictionary;
@synthesize footerView;
@synthesize updating;

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
    [request clearDelegatesAndCancel];
    [headerView release];
    [userDictionary release];
    [theTableView release];
    [earningLifeTimeCell release];
    [footerView release];
    [earningCell release];
    [request release];
    [earningsArray release];
    [sinceUrl release];
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
    self.earningsArray = [[NSMutableArray alloc]init];
    self.footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 50)];
    [self.footerView setBackgroundColor:[UIColor clearColor]];
    UIActivityIndicatorView *footerActivityIndicatorView = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [footerActivityIndicatorView startAnimating];
    [footerActivityIndicatorView setFrame:CGRectMake(150, 15, 20, 20)];
    [self.footerView addSubview:footerActivityIndicatorView];
    self.updating = NO;
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
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        [self configHeaderCell:cell];
        return cell;
    } else {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier2];
        
        if (cell == nil){ 
            [[NSBundle mainBundle] loadNibNamed:@"EarningCell" owner:self options:nil];
            cell = self.earningCell;
            self.earningCell = nil;
        }
        cell.selectionStyle=UITableViewCellSelectionStyleNone;        
        [self configCell:cell row:[indexPath row]];
        return cell;
    }
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if ([self.earningsArray count] == 0)
        return 0;
    else {
        return [self.earningsArray count] + 1;
    }
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
    [self loadingStart];
    if(request){
        [request clearDelegatesAndCancel];
        [request release];
        request = nil;
    }
    NSURL *url = [NSURL URLWithString:[Address earningURL]];
    self.request = [[ASIHTTPRequest alloc]initWithURL:url];
    [self.request setDelegate:self];
    [self.request startAsynchronous];
}

-(void)loadingStart{
    self.updating = YES;
    [self.theTableView setTableFooterView:self.footerView];
}

-(void)loadingEnd{
    self.updating = NO;
    [self.footerView removeFromSuperview];
    self.theTableView.tableFooterView = nil;
}

- (void)requestFinished:(ASIHTTPRequest *)aRequest
{
    [self loadingEnd];
    // Use when fetching text data
    NSString *responseString = [aRequest responseString];
    SBJsonParser *parser = [SBJsonParser new];
    NSDictionary *dict = [parser objectWithString:responseString];
    NSLog(@"%@",dict);
    NSString *error = [dict objectForKey:@"error"];
    if ([NSNull null] == (NSNull *)error || error == nil) {
        NSDictionary *dict2 = [dict objectForKey:@"user"];
        self.userDictionary = [dict2 objectForKey:@"User"];
        NSArray *arr = [dict objectForKey:@"user_log_table"];
        [self.earningsArray addObjectsFromArray:arr];
        self.sinceUrl = [dict objectForKey:@"since_url"];
        [self.theTableView reloadData];
    } else {
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"Loading Failed" message:error delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];
        [alertView release];
        
    }
}

- (void)requestFailed:(ASIHTTPRequest *)aRequest
{
    [self loadingEnd];
    NSError *error = [aRequest error];
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"Loading Failed" message:@"" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alertView show];
    [alertView release];
}
-(void)configHeaderCell:(UITableViewCell *)cell{
    UILabel *label = (UILabel *) [cell viewWithTag:UV_LABEL];
    NSNumberFormatter *formatter = [[[NSNumberFormatter alloc]init]autorelease];
    [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
    
    label.text = [formatter stringFromNumber:[NSNumber numberWithInt:[(NSString *)[self.userDictionary objectForKey:@"uv"] intValue]]];
    
    label = (UILabel *) [cell viewWithTag:EARNINGS_LABEL];
    label.text = [NSString stringWithFormat:@"$%@",[self.userDictionary objectForKey:@"amount"]];
    
}
-(void)configCell:(UITableViewCell *)cell row:(int)row{
    UILabel *label = (UILabel *) [cell viewWithTag:DATE_LABEL];
    NSDictionary *dict = [self.earningsArray objectAtIndex:row - 1];
    
    label.text = [dict objectForKey:@"datetime"];
    
    NSNumberFormatter *formatter = [[[NSNumberFormatter alloc]init]autorelease];
    [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
    
    label = (UILabel *)[cell viewWithTag:UV_LABEL];
    
    label.text = [formatter stringFromNumber:[NSNumber numberWithInt:[(NSString *)[dict objectForKey:@"uv"] intValue]]];
    
    label = (UILabel *) [cell viewWithTag:EARNINGS_LABEL];
    label.text = [NSString stringWithFormat:@"$%@",[dict objectForKey:@"amount"]];    
    
    label = (UILabel *) [cell viewWithTag:STATUS_LABEL];
    label.text = [NSString stringWithFormat:@"%@",[dict objectForKey:@"status"]];    
}

-(void)updateMore{
    if (self.sinceUrl == nil || [self.sinceUrl length] == 0 ||  updating)
        return;
    NSArray *visiblePaths = [self.theTableView indexPathsForVisibleRows];
    for (NSIndexPath *indexPath in visiblePaths)
    {
        int row = [indexPath row]-1;
        if (row >= UPDATE_RATE * ([self.earningsArray count]-1)) {
            [self startMoreUpdate];
            return;
        }
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self updateMore];
}

-(void) startMoreUpdate{
    NSLog(@"%@",self.sinceUrl);
    [self loadingStart];
    
    NSURL *url = [NSURL URLWithString:[Address makeUrl:self.sinceUrl]];
    if(request){
        [request clearDelegatesAndCancel];
        [request release];
        request = nil;
    }
    self.request = [[ASIHTTPRequest alloc] initWithURL:url];
    [self.request setDelegate:self];
    [self.request setDidFinishSelector:@selector(moreRequestDone:)];
    [self.request startAsynchronous];
}


- (void)moreRequestDone:(ASIHTTPRequest *)aRequest{
    [self loadingEnd];
    NSString *responseString = [aRequest responseString];
    SBJsonParser *parser = [SBJsonParser new];
    NSError *error = nil;
    NSDictionary *dict = [parser objectWithString:responseString error:&error];
    NSArray *arr = [dict objectForKey:@"user_log_table"];
    [self.earningsArray addObjectsFromArray:arr];
    self.sinceUrl = [dict objectForKey:@"since_url"];
    [self.theTableView reloadData];
}


@end
