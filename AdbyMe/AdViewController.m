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
#import "HtmlString.h"
#import "WebViewController.h"
#import "DateDifference.h"

#define AVATAR_VIEW 1024
#define UV_VIEW 1027
#define SLOGAN_LABEL 1028
#define PUB_TIME_LABEL 1029
#define SLOGAN_BORDER 1030
#define CONTAINER_VIEW 1031
#define PUB_LABEL 1032
#define UV_LABEL 1033
#define PUB_IMAGE 1034

#define FONT_HEIGHT 18

#define WRITE_ACTIONSHEET 2048

#define TWITTER 0
#define FACEBOOK 1
#define ME2DAY 2
#define CANCEL 3

#define TWITTER_STR @"twitter"
#define FACEBOOK_STR @"facebook"
#define ME2DAY_STR @"me2day"

#define SLOGAN_LABEL_DEFAULT_X 65
#define SLOGAN_LABEL_DEFAULT_Y 7

#define PUB_LABEL_DEFAULT_X 0
#define PUB_LABEL_DEFAULT_Y 30

#define UPDATE_RATE 1.0

#define MAIN_IMAGE 4096

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
@synthesize sloganArray;
@synthesize sinceUrl;
@synthesize adCell;
@synthesize numberOfLinesDictionary;
@synthesize usernameDictionary;
@synthesize sloganDictionary;
@synthesize uvDictionary;
@synthesize imageUrlDictionary;
@synthesize sloganIdDictionary;
@synthesize numberOfPubDictionary;
@synthesize pubTimeDictionary;
@synthesize loadingView;
@synthesize refreshButton;
@synthesize noMoreUpdate;
@synthesize updating;
@synthesize footerView;
@synthesize imageArray;
@synthesize imageDownloadsInProgress;
@synthesize snsDictionary;
@synthesize statusBgImageView;
@synthesize statusImageView;
@synthesize keyword;
@synthesize queue;
@synthesize timeStamp;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"Ad View";
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
    [keyword release];
    [adTitleLabel release];
    [imageUrlDictionary release];
    [uvLabel release];
    [adImageView release];
    [cpcLabel release];
    [imageArray release];
    [queue release];
    [imageDownloadsInProgress release];
    [sloganLabel release];
    [adTextView release];
    [uvDictionary release];
    [sloganArray release];
    [sinceUrl release];
    [numberOfLinesDictionary release];
    [adCell release];
    [usernameDictionary release];
    [sloganDictionary release];
    [loadingView release];
    [footerView release];
    [statusBgImageView release];
    [statusImageView release];
    [refreshButton release];
    [snsDictionary release];
    [sloganIdDictionary release];
    [numberOfPubDictionary release];
    [pubTimeDictionary release];
    [publishImage release];
    [publishButton release];
    [timeStamp release];
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

//    NSLog([[[[NSDate date] timeIntervalSince1970] description]);
    self.timeStamp = [NSString stringWithFormat:@"%d", (long)[[NSDate date] timeIntervalSince1970]];
    
    [[NSBundle mainBundle] loadNibNamed:@"AdHeaderView" owner:self options:nil];
    self.theTableView.tableHeaderView = self.adHeaderView;
    self.numberOfLinesDictionary = [[NSMutableDictionary alloc]init];
    self.sloganDictionary = [[NSMutableDictionary alloc]init];
    self.usernameDictionary = [[NSMutableDictionary alloc]init];
    self.uvDictionary = [[NSMutableDictionary alloc]init];
    self.imageUrlDictionary = [[NSMutableDictionary alloc]init];
    self.snsDictionary = [[NSMutableDictionary alloc]init];
    self.sloganIdDictionary = [[NSMutableDictionary alloc]init];
    self.numberOfPubDictionary = [[NSMutableDictionary alloc]init];
    self.pubTimeDictionary = [[NSMutableDictionary alloc]init];
    self.queue = [[NSOperationQueue alloc]init];
    [self.queue setMaxConcurrentOperationCount:10];
    
    self.refreshButton = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"renewicon.png"] style:UIBarButtonItemStylePlain target:self action:@selector(refreshButtonClicked)];
    self.navigationItem.rightBarButtonItem = self.refreshButton;
    
    self.footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 50)];
    UIActivityIndicatorView *footerActivityIndicatorView = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [footerActivityIndicatorView startAnimating];
    [footerActivityIndicatorView setFrame:CGRectMake(150, 15, 20, 20)];
    [self.footerView addSubview:footerActivityIndicatorView];
    self.theTableView.tableFooterView = self.footerView;
    self.imageArray = [[NSMutableArray alloc]init];
    self.imageDownloadsInProgress = [[NSMutableDictionary alloc]init];

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


-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"SloganCellIdentifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil){
        [[NSBundle mainBundle] loadNibNamed:@"AdCell3" owner:self options:nil];
        cell = self.adCell;
        self.adCell = nil;
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    [self configCell:cell andIndexPath:indexPath];
    
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

-(void)restoreCell:(UITableViewCell *)cell{
    UIView *containerView = (UIView *)[cell viewWithTag:CONTAINER_VIEW];
    [containerView setFrame:CGRectMake(0, 0, 320, 95)];
    UIImageView *avatarView = (UIImageView *)[cell viewWithTag:AVATAR_VIEW];
    [avatarView setFrame:CGRectMake(7, 7, 48, 48)];
    UIView *uvView = (UIView *)[cell viewWithTag:UV_VIEW];
    [uvView setFrame:CGRectMake(65, 66, 220, 24)];
    UIImageView *sloganBorder = (UIImageView *)[cell viewWithTag:SLOGAN_BORDER];
    [sloganBorder setFrame:CGRectMake(0, 93, 320, 2)];
    UILabel *sloganLabel2 = (UILabel *)[cell viewWithTag:SLOGAN_LABEL];
    [sloganLabel2 setFrame:CGRectMake(65, 7, 220, 35)];
}

-(void)configCell:(UITableViewCell *)cell andIndexPath:(NSIndexPath *)indexPath{

    NSString *username = (NSString *)[self.usernameDictionary objectForKey:indexPath];
    NSString *user_slogan = (NSString *)[self.sloganDictionary objectForKey:indexPath];
    
    UILabel *label = (UILabel *)[cell viewWithTag:SLOGAN_LABEL];

    // slogan
    label.text = user_slogan;
    CGRect frame = label.frame;

    // line수에 따라 cell의 높이가 달라짐
    NSNumber *number = (NSNumber *)[self.numberOfLinesDictionary objectForKey:indexPath];
    int lines = [number intValue];
    double addHeight = (lines - 1) * FONT_HEIGHT;
    [self addHeight:addHeight forView:cell.contentView];
    [self addHeight:addHeight forView:label];
    [self addY:addHeight forView:[cell viewWithTag:UV_VIEW]];
    [self addY:addHeight forView:[cell viewWithTag:SLOGAN_BORDER]];
    [self addY:(addHeight/2) forView:[cell viewWithTag:PUB_IMAGE]];
    [self addHeight:addHeight forView:[cell viewWithTag:CONTAINER_VIEW]];

    // user id 임의 삽입
    UIFont *cellFont = [UIFont fontWithName:@"Helvetica" size:14.0];
    CGSize constraintSize = CGSizeMake(220.0f, MAXFLOAT);
    CGSize labelSize = [username sizeWithFont:cellFont constrainedToSize:constraintSize lineBreakMode:UILineBreakModeWordWrap];
    
    label = [[UILabel alloc]initWithFrame:frame];
    label.text = username;
    label.font = cellFont;
    label.textColor = [UIColor colorWithRed:14.0/256.0 green:157.0/256.0 blue:209.0/256.0 alpha:1.0];
    UIView *containerView = [cell viewWithTag:CONTAINER_VIEW];
    [label sizeToFit];
    frame = label.frame;
    frame.size = labelSize;
    frame.origin.x = SLOGAN_LABEL_DEFAULT_X;
    frame.origin.y = SLOGAN_LABEL_DEFAULT_Y;
    [label setFrame:frame];
    [containerView addSubview:label];
    [label release];
    
    //
    NSNumberFormatter *formatter2 = [[[NSNumberFormatter alloc]init]autorelease];
    [formatter2 setNumberStyle:NSNumberFormatterDecimalStyle];

    // published
    label = (UILabel *)[cell viewWithTag:PUB_LABEL];
    NSString *pub = [[formatter2 stringFromNumber:[NSNumber numberWithInt:[(NSString *)[self.numberOfPubDictionary objectForKey:indexPath] intValue]]] stringByAppendingString:@"명"];
    label.text =  [pub stringByAppendingString:@"이 퍼블리쉬 했습니다."];
    
    // published blue number overwrite.
    cellFont = [UIFont fontWithName:@"Helvetica" size:12.0];
    constraintSize = CGSizeMake(156.0f, MAXFLOAT);
    labelSize = [pub sizeWithFont:cellFont constrainedToSize:constraintSize lineBreakMode:UILineBreakModeWordWrap];
    label = [[UILabel alloc]initWithFrame:frame];
    label.text = pub;
    label.font = cellFont;
    label.textColor = [UIColor colorWithRed:14.0/256.0 green:157.0/256.0 blue:209.0/256.0 alpha:1.0];
    containerView = [cell viewWithTag:UV_VIEW];
    [label sizeToFit];
    frame = label.frame;
    frame.size = labelSize;
    frame.origin.x = PUB_LABEL_DEFAULT_X;
    frame.origin.y = PUB_LABEL_DEFAULT_Y;
    [label setFrame:frame];
    [containerView addSubview:label];
    [label release];

    // uv
    label = (UILabel *)[cell viewWithTag:UV_LABEL];
    label.text =  [formatter2 stringFromNumber:[NSNumber numberWithInt:[(NSString *)[self.uvDictionary objectForKey:indexPath] intValue]]];

    // avatar
    UIImageView *imageView = (UIImageView *)[cell viewWithTag:AVATAR_VIEW];
    imageView.image = nil;
    
    UIImage *image = (UIImage *)[self.imageArray objectAtIndex:[indexPath row]];

    if ((NSNull *)image == [NSNull null]) {
        if(theTableView.dragging == NO && theTableView.decelerating == NO){
            [self startImageDownload:indexPath andImageUrl:[self.imageUrlDictionary objectForKey:indexPath]];
        }
    } else {
        // [activity stopAnimating];
        imageView.image = image;
    }
    
    // published time
    label = (UILabel *)[cell viewWithTag:PUB_TIME_LABEL];
    label.text = [NSDateFormatter dateDifferenceStringFromTimestamp:
                  [[self.pubTimeDictionary objectForKey:indexPath] longValue]];
    

    // TODO(siwonred): Add ACTIVITY_VIEW for loading image.
    // UIActivityIndicatorView *activity = (UIActivityIndicatorView *)[cell viewWithTag:ACTIVITY_VIEW];
    // [activity setHidden:NO];
    // [activity startAnimating];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if ([self.sloganArray count] > 0 )
        return ([self.sloganArray count]);
    else
        return 0;
}

// row clicked -> publish
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UIActionSheet *actionSheet = [[UIActionSheet alloc]initWithTitle:nil delegate:self  cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"twitter",@"facebook",@"me2day", nil];
//    actionSheet.tag = WRITE_ACTIONSHEET;
    actionSheet.tag = (NSInteger) [self.sloganIdDictionary objectForKey:indexPath];
    [actionSheet showInView:self.view];
    [actionSheet release];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSNumber *number = (NSNumber *)[self.numberOfLinesDictionary objectForKey:indexPath];
    int lines = [number intValue];
    return 81.0 + FONT_HEIGHT*(lines-1);
}

-(void)loadAd{
    if([self.loadingView superview] == nil)
        [self.view addSubview:self.loadingView];
        self.refreshButton.enabled = NO;
    NSURL *url = [NSURL URLWithString:[Address adUrl:self.adId]];
    NSLog(@"%@",url);
    if(request){
        [request clearDelegatesAndCancel];
        [request release];
        request = nil;
    }
    self.request = [[ASIFormDataRequest alloc] initWithURL:url];
    [self.request setDelegate:self];
    [self.request startAsynchronous];
    self.noMoreUpdate = NO;
    
}

- (void)requestFinished:(ASIFormDataRequest *)aRequest
{
    // Use when fetching text data
        self.refreshButton.enabled = YES;
    NSString *responseString = [aRequest responseString];
    SBJsonParser *parser = [SBJsonParser new];
    NSError *error = nil;
    self.adDictionary = [parser objectWithString:responseString error:&error];
    [self.imageArray removeAllObjects];
    [self.imageDownloadsInProgress removeAllObjects];
    [self.loadingView removeFromSuperview];
    
    [self configHeaderView];
    
    [self loadSlogan];
    
    
    [self.theTableView reloadData];
    [self.theTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
    [self.theTableView setContentOffset:CGPointMake(0, 0)];
}

- (void)requestFailed:(ASIFormDataRequest *)aRequest
{
        self.refreshButton.enabled = YES;
    NSError *error = [aRequest error];
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"Failed" message:@"" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alertView show];
    [alertView release];
}

-(void)configHeaderView{
    NSDictionary *adDict = [self.adDictionary objectForKey:@"ad"];
    adDict = [adDict objectForKey:@"Ad"];
        
    self.adTextView.text = [adDict objectForKey:@"text"];
    self.adTitleLabel.text = [adDict objectForKey:@"title"];
    NSNumberFormatter *formatter2 = [[[NSNumberFormatter alloc]init]autorelease];
    [formatter2 setNumberStyle:NSNumberFormatterDecimalStyle];

    self.uvLabel.text = [formatter2 stringFromNumber:[NSNumber numberWithInt:[(NSString *)[adDict objectForKey:@"uv"] intValue]]];
    self.sloganLabel.text = [NSString stringWithFormat:@"%@ slogans",[adDict objectForKey:@"slogan"]];
    
    ASIHTTPRequest *imageRequest = [[ASIHTTPRequest alloc]initWithURL:[NSURL URLWithString:[adDict objectForKey:@"image"]]];
    [imageRequest setDelegate:self];
    [imageRequest setDidFinishSelector:@selector(imageDownloadRequestDone:)];
    [imageRequest setDidFailSelector:@selector(imageDownloadRequestFail:)];
    imageRequest.userInfo =[NSDictionary dictionaryWithObject:@"main" forKey:@"type"];
    [self.queue addOperation:imageRequest];
    [self retain];
    [imageRequest release];
    
    self.cpcLabel.text = (NSString *)[adDict objectForKey:@"cpuv"];
    
    NSString *status = [adDict objectForKey:@"status"];
    if ([status isEqualToString:@"active"]){
        CGRect frame = statusImageView.frame;
        frame.size.width = 15;
        frame.origin.x = 11;
        [statusImageView setFrame:frame];
        [statusImageView setImage:[UIImage imageNamed:@"activeicon.png"]];
        [statusBgImageView setImage:[UIImage imageNamed:@"activeCPUV_1.png"]];
    } else{
        cpcLabel.text = @"Paused";
        CGRect frame = statusImageView.frame;
        frame.size.width = 7;
        frame.origin.x = 15;
        [statusImageView setFrame:frame];
        [statusImageView setImage:[UIImage imageNamed:@"pausedicon.png"]];
        [statusBgImageView setImage:[UIImage imageNamed:@"pausedCPUV_1.png"]];
    }
    
    SBJsonParser *parser = [SBJsonParser new];
    NSString *keywordJson = [adDict objectForKey:@"keyword"];
    if ((NSNull *)keywordJson != [NSNull null]) {
        NSArray *arr = [parser objectWithString:keywordJson];
        self.keyword = @"";
        self.keyword = [arr objectAtIndex:0];
        for (int i = 1; i < [arr count]; ++i) {
            self.keyword = [NSString stringWithFormat:@"%@ or %@",self.keyword, [arr objectAtIndex:i]];
        }
    }
    else self.keyword = nil;
}

-(void)loadSlogan{
    self.sloganArray = [self.adDictionary objectForKey:@"slogans"];
    [self.numberOfLinesDictionary removeAllObjects];
    [self.usernameDictionary removeAllObjects];
    [self.sloganDictionary removeAllObjects];
    [self.uvDictionary removeAllObjects];
    [self.imageUrlDictionary removeAllObjects];
    [self.sloganIdDictionary removeAllObjects];
    [self.numberOfPubDictionary removeAllObjects];
    [self.pubTimeDictionary removeAllObjects];

    NSDictionary *sloganDict;
    NSDictionary *userDict;
    UIFont *cellFont = [UIFont fontWithName:@"Helvetica" size:14.0];
    CGSize constraintSize = CGSizeMake(220.0f, MAXFLOAT);
    for(int i = 0; i<[self.sloganArray count]; i++){
        NSIndexPath *indexPath  = [NSIndexPath indexPathForRow:i inSection:0];

        sloganDict = [self.sloganArray objectAtIndex:i];

        // user
        userDict = [sloganDict objectForKey:@"User"];
        NSString *username = [userDict objectForKey:@"username"];
        [self.usernameDictionary setObject:username forKey:indexPath];
        [self.imageUrlDictionary setObject:(NSString *)[userDict objectForKey:@"avatar"] forKey:indexPath];

        // slogan
        sloganDict = [sloganDict objectForKey:@"Slogan"];

        NSString *slogan = [sloganDict objectForKey:@"slogan"];
        NSString *user_slogan = [NSString stringWithFormat:@"%@ %@", username, slogan];
        [self.sloganDictionary setObject:user_slogan forKey:indexPath];
        CGSize labelSize = [user_slogan sizeWithFont:cellFont constrainedToSize:constraintSize lineBreakMode:UILineBreakModeWordWrap];
        int numberOfLines = labelSize.height / 18.0;
        [self.numberOfLinesDictionary setObject:[NSNumber numberWithInt:numberOfLines] forKey:indexPath];
        [self.numberOfPubDictionary setObject:(NSString *)[sloganDict objectForKey:@"pub"] forKey:indexPath];
        [self.pubTimeDictionary setObject:(NSString *)[(NSDictionary *)[sloganDict objectForKey:@"published"] objectForKey:@"sec"] forKey:indexPath];
        [self.uvDictionary setObject:(NSString *)[sloganDict objectForKey:@"uv"] forKey:indexPath];
        [self.sloganIdDictionary setObject:(NSString *)[sloganDict objectForKey:@"_id"] forKey:indexPath];

        [self.imageArray addObject:[NSNull null]];
    }
    
    self.sinceUrl = [self.adDictionary objectForKey:@"since_url"];
    if((NSNull *)self.sinceUrl == [NSNull null]){
        noMoreUpdate = YES;
        [self.footerView removeFromSuperview];
        self.theTableView.tableFooterView = nil;

    }
    //NSLog(@"%@",sinceUrl);
}

-(void)reloadSlogan:(NSDictionary *)moreAdDictionary{
    NSArray *moreSloganArray = [moreAdDictionary objectForKey:@"slogans"];
    
    NSDictionary *sloganDict;
    NSDictionary *userDict;
    UIFont *cellFont = [UIFont fontWithName:@"Helvetica" size:14.0];
    CGSize constraintSize = CGSizeMake(220.0f, MAXFLOAT);
    
    for(int i = 0; i<[moreSloganArray count]; i++){
        NSIndexPath *indexPath  = [NSIndexPath indexPathForRow:i+[self.sloganArray count] inSection:0];
        
        sloganDict = [moreSloganArray objectAtIndex:i];
        
        // user
        userDict = [sloganDict objectForKey:@"User"];
        NSString *username = [userDict objectForKey:@"username"];
        [self.usernameDictionary setObject:username forKey:indexPath];
        [self.imageUrlDictionary setObject:(NSString *)[userDict objectForKey:@"avatar"] forKey:indexPath];
        
        // slogan
        sloganDict = [sloganDict objectForKey:@"Slogan"];
        NSString *slogan = [sloganDict objectForKey:@"slogan"];
        NSString *user_slogan = [NSString stringWithFormat:@"%@ %@", username, slogan];
        [self.sloganDictionary setObject:user_slogan forKey:indexPath];
        CGSize labelSize = [user_slogan sizeWithFont:cellFont constrainedToSize:constraintSize lineBreakMode:UILineBreakModeWordWrap];
        int numberOfLines = labelSize.height / 18.0;
        [self.numberOfLinesDictionary setObject:[NSNumber numberWithInt:numberOfLines] forKey:indexPath];
        [self.numberOfPubDictionary setObject:(NSString *)[sloganDict objectForKey:@"pub"] forKey:indexPath];
        [self.pubTimeDictionary setObject:(NSString *)[(NSDictionary *)[sloganDict objectForKey:@"published"] objectForKey:@"sec"] forKey:indexPath];
        [self.uvDictionary setObject:(NSString *)[sloganDict objectForKey:@"uv"] forKey:indexPath];
        [self.sloganIdDictionary setObject:(NSString *)[sloganDict objectForKey:@"_id"] forKey:indexPath];
        
        [self.imageArray addObject:[NSNull null]];
    }
    
    self.sinceUrl = [moreAdDictionary objectForKey:@"since_url"];
    if((NSNull *)self.sinceUrl == [NSNull null])
        noMoreUpdate = YES;
    [self.sloganArray addObjectsFromArray:moreSloganArray];
}

-(IBAction) writeButtonClicked{
    WriteSloganViewController *wViewController = [[WriteSloganViewController alloc]initWithNibName:@"WriteSloganViewController" bundle:nil];
    wViewController.keyword = self.keyword;
    wViewController.adId = self.adId;
    wViewController.delegate = self;
    [[self navigationController] pushViewController:wViewController animated:YES];
    [wViewController release];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
//  if (actionSheet.tag == WRITE_ACTIONSHEET)
    if (buttonIndex != CANCEL){
        PublishSloganViewController *pViewController = [[PublishSloganViewController alloc]initWithNibName:@"PublishSloganViewController" bundle:nil];
        pViewController.snsType = 1024+buttonIndex;
        pViewController.sloganId = [NSString stringWithFormat:@"%@", actionSheet.tag];
        pViewController.delegate = self;
        [[self navigationController] pushViewController:pViewController animated:YES];
        [pViewController release];
    }
}

-(IBAction) goPageButtonClicked{
    NSString *urlString=@"";
    NSDictionary *dict = [self.adDictionary objectForKey:@"ad"];
    dict = [dict objectForKey:@"Ad"];
    urlString = [dict objectForKey:@"link"];
    NSLog(@"web view with %@", urlString);
    WebViewController *wViewController = [[WebViewController alloc]initWithNibName:@"WebViewController" bundle:nil];
    wViewController.requestURL = urlString;
    [[self navigationController] pushViewController:wViewController animated:YES];
    [wViewController release];
}

-(IBAction) refreshButtonClicked{
    [self loadAd];
}

- (void)startImageDownload:(NSIndexPath *)indexPath andImageUrl:(NSString *)imageUrl
{
	ASIHTTPRequest *imageDownloader = [imageDownloadsInProgress objectForKey:indexPath];
	if (imageDownloader == nil) 
	{
        NSURL *url = [NSURL URLWithString:imageUrl];
		imageDownloader = [[ASIHTTPRequest alloc] initWithURL:url];
        imageDownloader.userInfo =[NSDictionary dictionaryWithObject:indexPath forKey:@"indexPath"];
		imageDownloader.delegate = self;
		[imageDownloadsInProgress setObject:imageDownloader forKey:indexPath];
        [imageDownloader setDidFinishSelector:@selector(imageDownloadRequestDone:)];
        [imageDownloader setDidFailSelector:@selector(imageDownloadRequestFail:)];
        [self.queue addOperation:imageDownloader];
        [self retain];
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
			if ([self.imageArray objectAtIndex:indexPath.row] == [NSNull null]) // avoid the app icon download if the app already has an icon
			{
				[self startImageDownload:indexPath andImageUrl:[self.imageUrlDictionary  objectForKey:indexPath]];
			}
		}
	}
}


-(void) startMoreUpdate{
    updating = YES;
    self.refreshButton.enabled = NO;
    NSLog(@"%@",self.sinceUrl);
    NSURL *url = [NSURL URLWithString:[Address makeUrl:self.sinceUrl]];
    if(request){
        [request clearDelegatesAndCancel];
        [request release];
        request = nil;
    }
    self.request = [[ASIFormDataRequest alloc] initWithURL:url];
    [self.request setDelegate:self];
    [self.request setDidFinishSelector:@selector(moreRequestDone:)];
    [self.request startAsynchronous];
}

- (void)moreRequestDone:(ASIFormDataRequest *)aRequest{
    self.refreshButton.enabled = YES;
    NSString *responseString = [aRequest responseString];
    SBJsonParser *parser = [SBJsonParser new];
    NSError *error = nil;
    NSDictionary *temp = [parser objectWithString:responseString error:&error];
    [self reloadSlogan:temp];
    [self.theTableView reloadData];
    updating = NO;
}

-(void)updateMore{
    if (noMoreUpdate || updating) {
        return;
    }
    NSArray *visiblePaths = [self.theTableView indexPathsForVisibleRows];
    for (NSIndexPath *indexPath in visiblePaths)
    {
        int row = [indexPath row];
        if (row >= UPDATE_RATE * ([self.sloganArray count]-1)) {
            [self startMoreUpdate];
            return;
        }
    }
}

- (void)imageDownloadRequestFail:(ASIHTTPRequest *)aRequest {
    [self release];
}
- (void)imageDownloadRequestDone:(ASIHTTPRequest *)aRequest {
    NSData *data = [aRequest responseData];
    NSIndexPath *indexPath = [aRequest.userInfo valueForKey:@"indexPath"];
    if (indexPath == nil) {
        self.adImageView.image = [UIImage imageWithData:data];
    }
    else{
        UITableViewCell *cell = [self.theTableView cellForRowAtIndexPath:indexPath];
        UIImageView *imageView = (UIImageView *)[cell viewWithTag:AVATAR_VIEW];
        UIImage *image = [UIImage imageWithData:data];
        imageView.image = image;
        int row = [indexPath row];
        [self.imageArray replaceObjectAtIndex:row withObject:image];
    }
    [self release];
}

#pragma mark -
#pragma mark Deferred image loading (UIScrollViewDelegate)

// Load images for all onscreen rows when scrolling is finished
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [self loadImagesForOnscreenRows];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
	[self loadImagesForOnscreenRows];
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self updateMore];
}

- (void)writeSuccess{
    [self loadAd];
}

@end