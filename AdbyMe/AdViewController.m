//
//  AdViewController.m
//  AdbyMe
//
//  Created by Baekjoon Choi on 4/6/11.
//  Copyright 2011 Megalusion. All rights reserved.
//

#import "AdViewController.h"
#import "Address.h"
#import "SBJsonParser.h"

@implementation AdViewController
@synthesize adId;
@synthesize adHeaderView;
@synthesize theTableView;
@synthesize adDictionary;
@synthesize request;
@synthesize adTitleLabel;
@synthesize uvLabel;
@synthesize sloganLabel;
@synthesize adTextView;
@synthesize adImageView;
@synthesize cpcLabel;
@synthesize bestSloganId;
@synthesize sloganArray;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"Ad View";
        // Custom initialization
    }
    return self;
}

- (void)dealloc
{
    [request clearDelegatesAndCancel];  // Cancel request.
    
    [adId release];
    [adHeaderView release];
    [theTableView release];
    [adDictionary release];
    [request release];
    [adTitleLabel release];
    [uvLabel release];
    [adImageView release];
    [cpcLabel release];
    [sloganLabel release];
    [adTextView release];
    [bestSloganId release];
    [sloganArray release];
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
    [[NSBundle mainBundle] loadNibNamed:@"AdHeaderView" owner:self options:nil];
    self.theTableView.tableHeaderView = self.adHeaderView;
    [self loadAd];
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
    static NSString *CellIdentifier = @"CellIdentifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil){
        cell = [[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier]autorelease];
    }
    
    cell.textLabel.text = @"!!";
    return cell;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.sloganArray count];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

-(void)loadAd{
    NSURL *url = [NSURL URLWithString:[Address adUrl:self.adId]];
    request = [[ASIHTTPRequest alloc] initWithURL:url];
    [request startAsynchronous];
    [request setDelegate:self];
}

- (void)requestFinished:(ASIHTTPRequest *)aRequest
{
    // Use when fetching text data
    NSString *responseString = [aRequest responseString];
    SBJsonParser *parser = [SBJsonParser new];
    NSError *error = nil;
    adDictionary = [parser objectWithString:responseString error:&error];
    
    [self configHeaderView];
    
    [self loadSlogan];
    
    [self.theTableView reloadData];
}

- (void)requestFailed:(ASIHTTPRequest *)aRequest
{
    NSError *error = [aRequest error];
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"Failed" message:[error description] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alertView show];
    [alertView release];
}

-(void)configHeaderView{
    NSDictionary *adDict = [self.adDictionary objectForKey:@"ad"];
    adDict = [adDict objectForKey:@"Ad"];
    
//    NSLog(@"%@",adDict);
    
    adTextView.text = [adDict objectForKey:@"text"];
    adTitleLabel.text = [adDict objectForKey:@"title"];
    uvLabel.text = [adDict objectForKey:@"uv"];
    sloganLabel.text = [NSString stringWithFormat:@"%@ slogans",[adDict objectForKey:@"copy"]];
    
    NSURL *url = [NSURL URLWithString:[adDict objectForKey:@"image"]];
    NSData *data = [NSData dataWithContentsOfURL:url];
    adImageView.image = [UIImage imageWithData:data];
    
    cpcLabel.text = [NSString stringWithFormat:@"$ %@",[adDict objectForKey:@"cpc"]];
    
    bestSloganId = [adDict objectForKey:@"best_slogan_id"];
}

-(void)loadSlogan{
    self.sloganArray = [self.adDictionary objectForKey:@"slogans"];
    /*for(NSDictionary *dict in self.sloganArray){
        NSLog(@"--");
        for(NSString *key in dict)
            NSLog(@"%@",key);
    }*/
    /*
     2011-04-07 20:14:44.610 AdbyMe[29354:40b] --
     2011-04-07 20:14:44.611 AdbyMe[29354:40b] Slogan
     2011-04-07 20:14:44.612 AdbyMe[29354:40b] Link
     2011-04-07 20:14:44.613 AdbyMe[29354:40b] User
     2011-04-07 20:14:44.614 AdbyMe[29354:40b] Sna
     2011-04-07 20:14:44.614 AdbyMe[29354:40b] best
     */
    
}

@end
