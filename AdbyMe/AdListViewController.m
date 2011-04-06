//
//  AdListViewController.m
//  AdbyMe
//
//  Created by Baekjoon Choi on 4/3/11.
//  Copyright 2011 Megalusion. All rights reserved.
//

#import "AdListViewController.h"
#import "Address.h"
#import "SBJsonParser.h"
#import "SNSSettingViewController.h"
#import "EarningViewController.h"
#import "AdbyMeAppDelegate.h"

#define SNSSETTINGS 0
#define EARNINGS 1
#define LOGOUT 2
#define CANCEL 3

#define DEFAULT_CELL_HEIGHT 104

#define FONT_HEIGHT 20

#define ADTEXT 1024
#define LIST_BORDER 1025
#define SLOGAN_WEBVIEW 1026
#define SLOGAN_BG 1027
#define SLOGAN_BORDER 1028
#define UV_ICON 1029
#define UV_TEXT 1030
#define COPY_ICON 1031
#define COPY_TEXT 1032
#define GO_ICON 1033
#define CONTAINER_VIEW 1034
#define CPC_TEXT 1035
#define AD_IMAGE 1036

@implementation AdListViewController

@synthesize settingButton;
@synthesize topView;
@synthesize theTableView;
@synthesize adArray;
@synthesize updateButton;
@synthesize adCell4;
@synthesize numberOfLinesDictionary;
@synthesize reservedLabel;
@synthesize availableLabel;
@synthesize imageArray;
@synthesize request;
@synthesize imageDownloadsInProgress;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"Ad List";
        // Custom initialization
    }
    return self;
}

- (void)dealloc
{
    
    [request clearDelegatesAndCancel];  // Cancel request.

    [theTableView release];
    [topView release];
    [settingButton release];
    [adArray release];
    [updateButton release];
    [adCell4 release];
    [reservedLabel release];
    [availableLabel release];
    [numberOfLinesDictionary release];
    [imageArray release];
    [imageDownloadsInProgress release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    NSArray *allDownloads = [self.imageDownloadsInProgress allValues];
	[allDownloads performSelector:@selector(cancelDownload)];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    self.numberOfLinesDictionary = [[NSMutableDictionary alloc]init];
    self.imageArray = [[NSMutableArray alloc]init];
    self.imageDownloadsInProgress = [[NSMutableDictionary alloc]init];
    self.settingButton = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"seticon.png"] style:UIBarButtonItemStyleDone target:self action:@selector(settingButtonClicked)];
    self.updateButton = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"renewicon.png"] style:UIBarButtonItemStyleDone target:self action:@selector(updateButtonClicked)];
    self.navigationItem.leftBarButtonItem = self.updateButton;
    self.navigationItem.rightBarButtonItem = self.settingButton;
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self loadAd];
    
    [self updateDashboard];

}
-(void)updateDashboard{
    AdbyMeAppDelegate *delegate = [[UIApplication sharedApplication]delegate];
    NSLog(@"%@",delegate.userDictionary);
    
    self.reservedLabel.text = [NSString stringWithFormat:@"$%@",[delegate.userDictionary objectForKey:@"reserved"]];
    self.availableLabel.text =[NSString stringWithFormat:@"$%@",[delegate.userDictionary objectForKey:@"deposit"]]; 
}
- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

-(void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    self.navigationItem.hidesBackButton = YES;
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
-(IBAction) settingButtonClicked{
    UIActionSheet *actionSheet = [[UIActionSheet alloc]initWithTitle:@"" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"SNS Settings",@"Earnings", @"Logout", nil];
    [actionSheet showInView:self.view];
    [actionSheet release];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    NSArray *allDownloads = [self.imageDownloadsInProgress allValues];
    [allDownloads makeObjectsPerformSelector:@selector(cancelDownload)];
}

-(void) logout{
    [[self navigationController]popViewControllerAnimated:YES];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == SNSSETTINGS) {
        SNSSettingViewController *sViewController = [[SNSSettingViewController alloc]initWithNibName:@"SNSSettingViewController" bundle:nil];
        [[self navigationController] pushViewController:sViewController animated:YES];
        [sViewController release];
    } else if (buttonIndex == EARNINGS) {
        EarningViewController *eViewController = [[EarningViewController alloc] initWithNibName:@"EarningViewController" bundle:nil];
        [[self navigationController] pushViewController:eViewController animated:YES];
        [eViewController release];
        
    } else if (buttonIndex == LOGOUT) {
        [self logout];
    } else if (buttonIndex == CANCEL) {
    }
}

-(void)loadAd{
    NSURL *url = [NSURL URLWithString:[Address adListURL]];
    NSArray *allDownloads = [self.imageDownloadsInProgress allValues];
    [allDownloads makeObjectsPerformSelector:@selector(cancelDownload)];
    
    request = [ASIHTTPRequest requestWithURL:url];
    [request startAsynchronous];
    [request setDelegate:self];
}

- (void)requestFinished:(ASIHTTPRequest *)aRequest
{
    // Use when fetching text data
    NSString *responseString = [aRequest responseString];
    SBJsonParser *parser = [SBJsonParser new];
    self.adArray = [parser objectWithString:responseString];
    [self.imageArray removeAllObjects];
    int n = [self.adArray count];
    for (int i = 0; i < n; i++) {
        [self.imageArray addObject:[NSNull null]];
    }
    [self.imageDownloadsInProgress removeAllObjects];
    [self getHeight];
    [self.theTableView reloadData];
}

-(void)getHeight{
    [self.numberOfLinesDictionary removeAllObjects];
    UIFont *cellFont = [UIFont fontWithName:@"Helvetica-Bold" size:16.0];
    CGSize constraintSize = CGSizeMake(180.0f, MAXFLOAT);
    for (int i = 0; i < [self.adArray count]; i++) {
        NSDictionary *dict = [self.adArray objectAtIndex:i];
        NSDictionary *adDict = [dict objectForKey:@"Ad"];
        NSString *adTitle = [adDict objectForKey:@"title"];
        NSLog(@"%@",adTitle);
        //adTitle = @"I know what you did last summer. So Listen to me baby right now. I love you";
        CGSize labelSize = [adTitle sizeWithFont:cellFont constrainedToSize:constraintSize lineBreakMode:UILineBreakModeWordWrap];
        NSString *rowString = [NSString stringWithFormat:@"row%d",i];
        int numberOfLines = labelSize.height / FONT_HEIGHT;
        [self.numberOfLinesDictionary setValue:[NSNumber numberWithInt:numberOfLines] forKey:rowString];
    }
}
- (void)requestFailed:(ASIHTTPRequest *)aRequest
{
    NSError *error = [aRequest error];
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"Failed" message:[error description] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alertView show];
    [alertView release];
}

-(IBAction) updateButtonClicked{
    [self loadAd];
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"CellIdentifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil){
        [[NSBundle mainBundle] loadNibNamed:@"AdCell4" owner:self options:nil];
		cell = self.adCell4;
		self.adCell4 = nil;
    }
    
    [self configCell:cell andIndexPath:indexPath];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

-(void) addHeight:(double)addHeight forView:(UIView *)cellView{
    CGRect frame = cellView.frame;
    frame.size.height += addHeight;
    [cellView setFrame:frame];
}
-(void) addY:(double)addHeight forView:(UIView *)cellView{
    CGRect frame = cellView.frame;
    frame.origin.y += addHeight;
    [cellView setFrame:frame];
}

-(void)configCell:(UITableViewCell *)cell andIndexPath:(NSIndexPath *)indexPath{
    int row = [indexPath row];
    NSString *rowString = [NSString stringWithFormat:@"row%d",row];
    
    NSDictionary *dict = [self.adArray objectAtIndex:row];
    NSDictionary *adDict = [dict objectForKey:@"Ad"];
    
    UILabel *titleLabel = (UILabel *)[cell viewWithTag:ADTEXT];
    NSString *adTitle = [adDict objectForKey:@"title"];
    //adTitle = @"I know what you did last summer. So Listen to me baby right now. I love you";
    titleLabel.text =  adTitle;
    
    NSNumber *number = [self.numberOfLinesDictionary valueForKey:rowString];
    int numberOfLines = [number intValue];
    
    if (numberOfLines > 3) {
        double addHeight = (numberOfLines - 3) * 20.0;
        [self addHeight:addHeight forView:cell.contentView];
        [self addHeight:addHeight forView:[cell viewWithTag:ADTEXT]];
        //[self addHeight:addHeight forView:[cell viewWithTag:LIST_BORDER]];
        [self addHeight:addHeight forView:[cell viewWithTag:SLOGAN_BG]];
        [self addHeight:addHeight forView:[cell viewWithTag:CONTAINER_VIEW]];
        [self addY:addHeight forView:[cell viewWithTag:SLOGAN_BORDER]];
        //[self addY:addHeight forView:[cell viewWithTag:SLOGAN_WEBVIEW]];
        [self addY:addHeight forView:[cell viewWithTag:UV_ICON]];
        [self addY:addHeight forView:[cell viewWithTag:UV_TEXT]];
        [self addY:addHeight forView:[cell viewWithTag:COPY_ICON]];
        [self addY:addHeight forView:[cell viewWithTag:COPY_TEXT]];
        [self addY:addHeight/2 forView:[cell viewWithTag:GO_ICON]];
    }
    
    UILabel *uvLabel = (UILabel *)[cell viewWithTag:UV_TEXT];
    uvLabel.text = [adDict objectForKey:@"uv"];
    
    UILabel *copyLabel = (UILabel *)[cell viewWithTag:COPY_TEXT];
    copyLabel.text = [adDict objectForKey:@"copy"];
    
    UILabel *cpcLabel = (UILabel *)[cell viewWithTag:CPC_TEXT];
    cpcLabel.text = [NSString stringWithFormat:@"$ %@",[adDict objectForKey:@"cpc"]];
    
    UIImageView *imageView = (UIImageView *)[cell viewWithTag:AD_IMAGE];
    UIImage *image = (UIImage *)[self.imageArray objectAtIndex:row];
    if ((NSNull *)image == [NSNull null]) {
        if(theTableView.dragging == NO && theTableView.decelerating == NO){
            [self startImageDownload:indexPath andImageUrl:[adDict objectForKey:@"image"]];
        }
    } else {
        imageView.image = image;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    int row = [indexPath row];
    NSString *rowString = [NSString stringWithFormat:@"row%d",row];
    NSNumber *number = [self.numberOfLinesDictionary valueForKey:rowString];
    int numberOfLines = [number intValue];
    if (numberOfLines <= 3)
        return DEFAULT_CELL_HEIGHT;
    else
        return DEFAULT_CELL_HEIGHT + (numberOfLines-3)*20.0;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSLog(@"count: %d",[self.adArray count]);
    return [self.adArray count];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"%d",[indexPath row]);
}

- (void)startImageDownload:(NSIndexPath *)indexPath andImageUrl:(NSString *)imageUrl
{
	ImageDownloader *imageDownloader = [imageDownloadsInProgress objectForKey:indexPath];
	if (imageDownloader == nil) 
	{
		imageDownloader = [[ImageDownloader alloc] init];
		imageDownloader.indexPathInTableView = indexPath;
		imageDownloader.delegate = self;
		imageDownloader.feedURL = imageUrl;
		[imageDownloadsInProgress setObject:imageDownloader forKey:indexPath];
		[imageDownloader startDownload];
		[imageDownloader release];   
	}
}

- (void)loadImagesForOnscreenRows
{
	if ([self.imageArray count] > 0)
	{
		NSArray *visiblePaths = [self.theTableView indexPathsForVisibleRows];
		for (NSIndexPath *indexPath in visiblePaths)
		{
            //			UIImage *currentImage = [self.realimageArray objectAtIndex:indexPath.row];
			
			if ([self.imageArray objectAtIndex:indexPath.row] == [NSNull null]) // avoid the app icon download if the app already has an icon
			{
                int row = [indexPath row];
                
                NSDictionary *dict = [self.adArray objectAtIndex:row];
                NSDictionary *adDict = [dict objectForKey:@"Ad"];
                
				[self startImageDownload:indexPath andImageUrl:[adDict objectForKey:@"image"]];
			}
		}
	}
}

- (void)imageDidLoad:(NSIndexPath *)indexPath
{
	ImageDownloader *imageDownloader = [imageDownloadsInProgress objectForKey:indexPath];
	if (imageDownloader != nil)
	{
		UITableViewCell *cell = [self.theTableView cellForRowAtIndexPath:imageDownloader.indexPathInTableView];
		
		// Display the newly loaded image
		UIImageView *imageView = (UIImageView *)[cell viewWithTag:AD_IMAGE];
		imageView.image = imageDownloader.downloadedImage;
		int row = [indexPath row];
		[self.imageArray replaceObjectAtIndex:row withObject:imageDownloader.downloadedImage];
	}
}

#pragma mark -
#pragma mark Deferred image loading (UIScrollViewDelegate)

// Load images for all onscreen rows when scrolling is finished
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
	if (!decelerate)
	{
		[self loadImagesForOnscreenRows];
	}
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
	[self loadImagesForOnscreenRows];
}


@end
