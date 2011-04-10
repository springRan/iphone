//
//  EarningViewController.m
//  AdbyMe
//
//  Created by Baekjoon Choi on 4/4/11.
//  Copyright 2011 Megalusion. All rights reserved.
//

#import "EarningViewController.h"


@implementation EarningViewController
@synthesize headerView;
@synthesize theTableView;
@synthesize earningLifeTimeCell;
@synthesize earningCell;

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

@end
