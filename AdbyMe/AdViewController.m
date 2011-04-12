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
#define UPDOWN_VIEW 1026
#define UV_VIEW 1027
#define SLOGAN_LABEL 1028
#define LINK_BUTTON 1029
#define SLOGAN_BORDER 1030
#define CONTAINER_VIEW 1031
#define CREATE_DATE_LABEL 1032
#define UV_LABEL 1033
#define SCORE_LABEL 1034
#define SNS_IMAGE_VIEW 1035
#define ACTIVITY_VIEW 1036

#define FONT_HEIGHT 18

#define DISLIKE_ACTIONSHEET 2049
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

#define LIKEDISLIKE_ACTIONSHEET 10000

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
@synthesize bestSloganId;
@synthesize sloganArray;
@synthesize sinceUrl;
@synthesize adCell;
@synthesize numberOfLinesDictionary;
@synthesize userDictionary;
@synthesize sloganDictionary;
@synthesize linkDictionary;
@synthesize createdDictionary;
@synthesize uvDictionary;
@synthesize linkIdDictionary;
@synthesize linkScoreDictionary;
@synthesize loadingView;
@synthesize refreshButton;
@synthesize noMoreUpdate;
@synthesize updating;
@synthesize footerView;
@synthesize mainImageDownloader;
@synthesize imageArray;
@synthesize imageDownloadsInProgress;
@synthesize imageUrlDictionary;
@synthesize snsDictionary;
@synthesize statusBgImageView;
@synthesize statusImageView;



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
    NSArray *allDownloads = [self.imageDownloadsInProgress allValues];
    [allDownloads makeObjectsPerformSelector:@selector(cancelDownload)];

    [request clearDelegatesAndCancel];  // Cancel request.
    
    [adId release];
    [adHeaderView release];
    [theTableView release];
    [adDictionary release];
    [request release];
    [adTitleLabel release];
    [imageUrlDictionary release];
    [uvLabel release];
    [adImageView release];
    [cpcLabel release];
    [imageArray release];
    [imageDownloadsInProgress release];
    [sloganLabel release];
    [linkDictionary release];
    [adTextView release];
    [bestSloganId release];
    [createdDictionary release];
    [uvDictionary release];
    [sloganArray release];
    [sinceUrl release];
    [numberOfLinesDictionary release];
    [adCell release];
    [userDictionary release];
    [sloganDictionary release];
    [linkIdDictionary release];
    [linkScoreDictionary release];
    [loadingView release];
    [mainImageDownloader release];
    [footerView release];
    [statusBgImageView release];
    [statusImageView release];
    [refreshButton release];
    [snsDictionary release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
    NSArray *allDownloads = [self.imageDownloadsInProgress allValues];
	[allDownloads performSelector:@selector(cancelDownload)];
    
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [[NSBundle mainBundle] loadNibNamed:@"AdHeaderView" owner:self options:nil];
    self.theTableView.tableHeaderView = self.adHeaderView;
    self.numberOfLinesDictionary = [[NSMutableDictionary alloc]init];
    self.sloganDictionary = [[NSMutableDictionary alloc]init];
    self.userDictionary = [[NSMutableDictionary alloc]init];
    self.linkDictionary = [[NSMutableDictionary alloc]init];
    self.createdDictionary = [[NSMutableDictionary alloc]init];
    self.uvDictionary = [[NSMutableDictionary alloc]init];
    self.linkIdDictionary = [[NSMutableDictionary alloc]init];
    self.linkScoreDictionary = [[NSMutableDictionary alloc]init];
    self.imageUrlDictionary = [[NSMutableDictionary alloc]init];
    self.snsDictionary = [[NSMutableDictionary alloc]init];
    
    self.refreshButton = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"renewicon.png"] style:UIBarButtonItemStyleDone target:self action:@selector(refreshButtonClicked)];
    self.navigationItem.rightBarButtonItem = self.refreshButton;
    
    self.footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 50)];
    UIActivityIndicatorView *footerActivityIndicatorView = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [footerActivityIndicatorView startAnimating];
    [footerActivityIndicatorView setFrame:CGRectMake(150, 15, 20, 20)];
    [self.footerView addSubview:footerActivityIndicatorView];

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


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
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
    UIView *updownView = (UIView *)[cell viewWithTag:UPDOWN_VIEW];
    [updownView setFrame:CGRectMake(288, 21, 30, 53)];
    UIImageView *sloganBorder = (UIImageView *)[cell viewWithTag:SLOGAN_BORDER];
    [sloganBorder setFrame:CGRectMake(0, 93, 320, 2)];
    UILabel *sloganLabel2 = (UILabel *)[cell viewWithTag:SLOGAN_LABEL];
    [sloganLabel2 setFrame:CGRectMake(65, 7, 215, 35)];
    UIButton *linkButton = (UIButton *)[cell viewWithTag:LINK_BUTTON];
    [linkButton setFrame:CGRectMake(65, 7, 215, 35)];
    
}

-(void)configCell:(UITableViewCell *)cell andIndexPath:(NSIndexPath *)indexPath{
    
    //[self restoreCell:cell];
    
    NSString *user = (NSString *)[self.userDictionary objectForKey:indexPath];
    NSString *user_copy = (NSString *)[self.sloganDictionary objectForKey:indexPath];
    NSString *link = (NSString *)[self.linkDictionary objectForKey:indexPath];
    NSNumber *number = (NSNumber *)[self.numberOfLinesDictionary objectForKey:indexPath];
    int lines = [number intValue];

    UILabel *label = (UILabel *)[cell viewWithTag:SLOGAN_LABEL];
    label.text = user_copy;
    CGRect frame = label.frame;
    [label sizeToFit];
    frame.origin.x = SLOGAN_LABEL_DEFAULT_X;
    frame.origin.y = SLOGAN_LABEL_DEFAULT_Y;
    if(lines == 1)
        frame.origin.y = frame.origin.y -10;
    [label setFrame:frame];
    
    UIButton *linkButton = (UIButton *)[cell viewWithTag:LINK_BUTTON];
    [linkButton setTitle:link forState:UIControlStateNormal];
    [linkButton setTitle:link forState:UIControlStateHighlighted];
    
    if (lines > 2){
        double addHeight = (lines - 2) * FONT_HEIGHT;
        [self addHeight:addHeight forView:cell.contentView];
        [self addHeight:addHeight forView:label];
        [self addY:addHeight forView:linkButton];
        [self addY:addHeight forView:[cell viewWithTag:UV_VIEW]];
        [self addY:addHeight/2.0 forView:[cell viewWithTag:UPDOWN_VIEW]];
        [self addY:addHeight forView:[cell viewWithTag:SLOGAN_BORDER]];
        [self addHeight:addHeight forView:[cell viewWithTag:CONTAINER_VIEW]];
    }
    
    UIFont *cellFont = [UIFont fontWithName:@"Helvetica" size:14.0];
    CGSize constraintSize = CGSizeMake(215.0f, MAXFLOAT);
    CGSize labelSize = [user sizeWithFont:cellFont constrainedToSize:constraintSize lineBreakMode:UILineBreakModeWordWrap];
    label = [[UILabel alloc]initWithFrame:frame];
    label.text = user;
    label.font = cellFont;
    label.textColor = [UIColor colorWithRed:14.0/256.0 green:157.0/256.0 blue:209.0/256.0 alpha:1.0];
    UIView *containerView = [cell viewWithTag:CONTAINER_VIEW];
    [label sizeToFit];
    frame = label.frame;
    frame.size = labelSize;
    frame.origin.x = SLOGAN_LABEL_DEFAULT_X;
    frame.origin.y = SLOGAN_LABEL_DEFAULT_Y;
    frame.origin.y -= 1;
    [label setFrame:frame];
    [containerView addSubview:label];
    [label release];
    
    label = (UILabel *)[cell viewWithTag:CREATE_DATE_LABEL];
    NSString *createdString = (NSString *)[self.createdDictionary objectForKey:indexPath];
    NSRange range = [createdString rangeOfString:@"+"];
    
    createdString = [createdString substringToIndex:range.location];
    label.text = [NSDateFormatter dateDifferenceStringFromString:createdString withFormat:@"yyyy-MM-dd HH:mm:ss+00"];
    
    NSNumberFormatter *formatter2 = [[[NSNumberFormatter alloc]init]autorelease];
    [formatter2 setNumberStyle:NSNumberFormatterDecimalStyle];
    
    label = (UILabel *)[cell viewWithTag:UV_LABEL];
    label.text =  [formatter2 stringFromNumber:[NSNumber numberWithInt:[(NSString *)[self.uvDictionary objectForKey:indexPath] intValue]]];
    
    label = (UILabel *)[cell viewWithTag:SCORE_LABEL];
    label.text = (NSString *)[self.linkScoreDictionary objectForKey:indexPath];
    
    UIImageView *imageView = (UIImageView *)[cell viewWithTag:AVATAR_VIEW];
    imageView.image = nil;
    UIImage *image = (UIImage *)[self.imageArray objectAtIndex:[indexPath row]];
    //UIActivityIndicatorView *activity = (UIActivityIndicatorView *)[cell viewWithTag:ACTIVITY_VIEW];
    //[activity setHidden:NO];
    //[activity startAnimating];

    if ((NSNull *)image == [NSNull null]) {
        if(theTableView.dragging == NO && theTableView.decelerating == NO){
            [self startImageDownload:indexPath andImageUrl:[self.imageUrlDictionary objectForKey:indexPath]];
        }
    } else {
        //[activity stopAnimating];
        imageView.image = image;
    }
    
    UIImageView *snsImageView = (UIImageView *)[cell viewWithTag:SNS_IMAGE_VIEW];
    UIImage *snsImage;
    NSString *sns = [self.snsDictionary objectForKey:indexPath];
    if ((NSNull *)sns != [NSNull null]) {
        if ([sns isEqualToString:TWITTER_STR]) {
            snsImage = [UIImage imageNamed:@"twlogo.png"];
        } else if([sns isEqualToString:FACEBOOK_STR]) {
            snsImage = [UIImage imageNamed:@"fblogo.png"];
        } else if([sns isEqualToString:ME2DAY_STR]) {
            snsImage = [UIImage imageNamed:@"m2logo.png"];
        } else {
            snsImage = [UIImage imageNamed:@"adbylogo.png"];
        }
    } else {
        snsImage = [UIImage imageNamed:@"adbylogo.png"];
    }
    snsImageView.image = snsImage;
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

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSNumber *number = (NSNumber *)[self.numberOfLinesDictionary objectForKey:indexPath];
    int lines = [number intValue];
    if (lines <= 2)
        return 95.0;
    else
        return 95.0 + FONT_HEIGHT*(lines-2);
}

-(void)loadAd{
    if([self.loadingView superview] == nil)
        [self.view addSubview:self.loadingView];
    NSURL *url = [NSURL URLWithString:[Address adUrl:self.adId]];
    NSLog(@"%@",url);
    [self.request clearDelegatesAndCancel];
    self.request = [[ASIFormDataRequest alloc] initWithURL:url];
    [self.request setDelegate:self];
    [self.request startAsynchronous];
    self.noMoreUpdate = NO;

}

- (void)requestFinished:(ASIFormDataRequest *)aRequest
{
    // Use when fetching text data
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
}

- (void)requestFailed:(ASIFormDataRequest *)aRequest
{
    NSError *error = [aRequest error];
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"Failed" message:[error description] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
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
    self.sloganLabel.text = [NSString stringWithFormat:@"%@ slogans",[adDict objectForKey:@"copy"]];
    
    //NSURL *url = [NSURL URLWithString:[adDict objectForKey:@"image"]];
    //NSData *data = [NSData dataWithContentsOfURL:url];
    //adImageView.image = [UIImage imageWithData:data];
    mainImageDownloader = [[ImageDownloader alloc]init];
    mainImageDownloader.delegate = self;
    mainImageDownloader.feedURL = [adDict objectForKey:@"image"];
    [mainImageDownloader startDownload];
    
    self.cpcLabel.text = [NSString stringWithFormat:@"$%@",[adDict objectForKey:@"cpc"]];
    
    self.bestSloganId = [adDict objectForKey:@"best_slogan_id"];
    
    NSString *status = [adDict objectForKey:@"status"];
    if ([status isEqualToString:@"active"]){
        CGRect frame = statusImageView.frame;
        frame.size.width = 15;
        frame.origin.x = 11;
        [statusImageView setFrame:frame];
        [statusImageView setImage:[UIImage imageNamed:@"activeicon.png"]];
        [statusBgImageView setImage:[UIImage imageNamed:@"activeCPUV.png"]];
    } else{
        cpcLabel.text = @"Paused";
        CGRect frame = statusImageView.frame;
        frame.size.width = 7;
        frame.origin.x = 15;
        [statusImageView setFrame:frame];
        [statusImageView setImage:[UIImage imageNamed:@"pausedicon.png"]];
        [statusBgImageView setImage:[UIImage imageNamed:@"pausedCPUV.png"]];
    }
}

-(void)loadSlogan{
    self.sloganArray = [self.adDictionary objectForKey:@"slogans"];
    [self.numberOfLinesDictionary removeAllObjects];
    [self.sloganDictionary removeAllObjects];
    [self.userDictionary removeAllObjects];
    [self.linkDictionary removeAllObjects];
    [self.createdDictionary removeAllObjects];
    [self.uvDictionary removeAllObjects];
    [self.linkIdDictionary removeAllObjects];
    [self.linkScoreDictionary removeAllObjects];
    [self.imageUrlDictionary removeAllObjects];
    [self.snsDictionary removeAllObjects];
    
    NSDictionary *dict;
    NSDictionary *dict2;
    UIFont *cellFont = [UIFont fontWithName:@"Helvetica" size:14.0];
    CGSize constraintSize = CGSizeMake(215.0f, MAXFLOAT);
        
    for(int i = 0; i<[self.sloganArray count]; i++){
        NSIndexPath *indexPath  = [NSIndexPath indexPathForRow:i inSection:0];
        
        dict = [self.sloganArray objectAtIndex:i];
        dict2 = [dict objectForKey:@"User"];
        NSString *user = [dict2 objectForKey:@"username"];
        
        dict2 = [dict objectForKey:@"Slogan"];
        NSString *copy = [dict2 objectForKey:@"copy"];
        
        NSString *user_copy = [NSString stringWithFormat:@"%@ %@",user,copy];
        [self.userDictionary setObject:user forKey:indexPath];
        [self.sloganDictionary setObject:user_copy forKey:indexPath];
        
        CGSize labelSize = [user_copy sizeWithFont:cellFont constrainedToSize:constraintSize lineBreakMode:UILineBreakModeWordWrap];
        
        int numberOfLines = labelSize.height / 18.0;
        
        [self.numberOfLinesDictionary setObject:[NSNumber numberWithInt:numberOfLines] forKey:indexPath];
        
        [self.linkDictionary setObject:(NSString *)[dict2 objectForKey:@"link"] forKey:indexPath];
        
        [self.createdDictionary setObject:(NSString *)[dict2 objectForKey:@"created"] forKey:indexPath];
        
        dict2 = [dict objectForKey:@"Link"];
        
        [self.uvDictionary setObject:(NSString *)[dict2 objectForKey:@"uv"] forKey:indexPath];
        [self.linkIdDictionary setObject:(NSString *)[dict2 objectForKey:@"id"] forKey:indexPath];
        int like,dislike;
        like = [(NSString *)[dict2 objectForKey:@"like"] intValue];
        dislike = [(NSString *)[dict2 objectForKey:@"dislike"] intValue];
        [self.linkScoreDictionary setObject:[NSString stringWithFormat:@"%d",like-dislike] forKey:indexPath];
        
        dict2 = [dict objectForKey:@"Sna"];
        [self.imageUrlDictionary setObject:(NSString *)[dict2 objectForKey:@"avatar"] forKey:indexPath];
        [self.snsDictionary setObject:(NSString *)[dict2 objectForKey:@"network"] forKey:indexPath];
        //NSLog(@"%@",user_copy);
        //NSLog(@"%lf %lf",labelSize.width, labelSize.height);
        [self.imageArray addObject:[NSNull null]];
    }
    
    self.sinceUrl = [self.adDictionary objectForKey:@"since_url"];
    if((NSNull *)self.sinceUrl == [NSNull null])
        noMoreUpdate = YES;
    //NSLog(@"%@",sinceUrl);
}

-(void)reloadSlogan:(NSDictionary *)moreAdDictionary{
    NSArray *moreSloganArray = [moreAdDictionary objectForKey:@"slogans"];
    
    NSDictionary *dict;
    NSDictionary *dict2;
    UIFont *cellFont = [UIFont fontWithName:@"Helvetica" size:14.0];
    CGSize constraintSize = CGSizeMake(215.0f, MAXFLOAT);
    
    for(int i = 0; i<[moreSloganArray count]; i++){
        NSIndexPath *indexPath  = [NSIndexPath indexPathForRow:i+[self.sloganArray count] inSection:0];
        
        dict = [moreSloganArray objectAtIndex:i];
        dict2 = [dict objectForKey:@"User"];
        NSString *user = [dict2 objectForKey:@"username"];
        
        dict2 = [dict objectForKey:@"Slogan"];
        NSString *copy = [dict2 objectForKey:@"copy"];
        
        NSString *user_copy = [NSString stringWithFormat:@"%@ %@",user,copy];
        [self.userDictionary setObject:user forKey:indexPath];
        [self.sloganDictionary setObject:user_copy forKey:indexPath];
        
        CGSize labelSize = [user_copy sizeWithFont:cellFont constrainedToSize:constraintSize lineBreakMode:UILineBreakModeWordWrap];
        
        int numberOfLines = labelSize.height / 18.0;
        
        [self.numberOfLinesDictionary setObject:[NSNumber numberWithInt:numberOfLines] forKey:indexPath];
        
        [self.linkDictionary setObject:(NSString *)[dict2 objectForKey:@"link"] forKey:indexPath];
        
        [self.createdDictionary setObject:(NSString *)[dict2 objectForKey:@"created"] forKey:indexPath];
        
        dict2 = [dict objectForKey:@"Link"];
        
        [self.uvDictionary setObject:(NSString *)[dict2 objectForKey:@"uv"] forKey:indexPath];
        [self.linkIdDictionary setObject:(NSString *)[dict2 objectForKey:@"id"] forKey:indexPath];
        int like,dislike;
        like = [(NSString *)[dict2 objectForKey:@"like"] intValue];
        dislike = [(NSString *)[dict2 objectForKey:@"dislike"] intValue];
        [self.linkScoreDictionary setObject:[NSString stringWithFormat:@"%d",like-dislike] forKey:indexPath];
        
        dict2 = [dict objectForKey:@"Sna"];
        [self.imageUrlDictionary setObject:(NSString *)[dict2 objectForKey:@"avatar"] forKey:indexPath];
        [self.snsDictionary setObject:(NSString *)[dict2 objectForKey:@"network"] forKey:indexPath];
        [self.imageArray addObject:[NSNull null]];
    }
    
    self.sinceUrl = [moreAdDictionary objectForKey:@"since_url"];
    if((NSNull *)self.sinceUrl == [NSNull null])
        noMoreUpdate = YES;
    [self.sloganArray addObjectsFromArray:moreSloganArray];
}

-(IBAction) likeButtonClicked:(int)row{
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:0];
    NSLog(@"Like");
    NSLog(@"%d",[indexPath row]);
    
    NSURL *url = [NSURL URLWithString:[Address likeUrl:(NSString *)[self.linkIdDictionary objectForKey:indexPath]]];
    
    [self.request clearDelegatesAndCancel];
    self.request = [[ASIFormDataRequest alloc] initWithURL:url];
    self.request.userInfo = [NSDictionary dictionaryWithObject:[NSNumber numberWithInt:row] forKey:@"row"];
    [self.request setDelegate:self];
    [self.request setDidFinishSelector:@selector(likeRequestDone:)];
    [self.request startAsynchronous];
}
-(IBAction) dislikeButtonClicked:(int)row{
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:0];
    NSLog(@"Dislike");
    NSLog(@"%d",[indexPath row]);
    UIActionSheet *actionSheet = [[UIActionSheet alloc]initWithTitle:nil delegate:self  cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"irrelevant subject",@"malicious contents",@"plagiarism", @"false message", nil];
    actionSheet.tag = DISLIKE_ACTIONSHEET+[indexPath row];
    [actionSheet showInView:self.view];
    [actionSheet release];
}

- (void)likeRequestDone:(ASIFormDataRequest *)aRequest{
    NSString *responseString = [aRequest responseString];
    NSLog(@"%@",responseString);
    SBJsonParser *parser = [SBJsonParser new];
    NSDictionary *dict = [parser objectWithString:responseString];
    NSString *error = [dict objectForKey:@"error"];
    if ([NSNull null] == (NSNull *)error) {
        NSLog(@"Like Success");
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"Like Success" message:@"" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];
        [alertView release];
        NSDictionary *dict = [aRequest userInfo];
        NSNumber *number = (NSNumber *)[dict objectForKey:@"row"];
        int row = [number intValue];
        UITableViewCell *cell = [self.theTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:row inSection:0]];
        UILabel *label = (UILabel *)[cell viewWithTag:SCORE_LABEL];
        int curScore = [label.text intValue];
        curScore++;
        label.text = [NSString stringWithFormat:@"%d",curScore];
    } else {
        NSLog(@"Like Failed");
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"Vote Failed" message:error delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];
        [alertView release];
    }
}

- (void)dislikeRequestDone:(ASIFormDataRequest *)aRequest{
    NSString *responseString = [aRequest responseString];
    NSLog(@"%@",responseString);
    SBJsonParser *parser = [SBJsonParser new];
    NSDictionary *dict = [parser objectWithString:responseString];
    NSString *error = [dict objectForKey:@"error"];
    if ([NSNull null] == (NSNull *)error) {
        NSLog(@"Disike Success");
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"Dislike Success" message:@"" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];
        [alertView release];
        NSDictionary *dict = [aRequest userInfo];
        NSNumber *number = (NSNumber *)[dict objectForKey:@"row"];
        int row = [number intValue];
        UITableViewCell *cell = [self.theTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:row inSection:0]];
        UILabel *label = (UILabel *)[cell viewWithTag:SCORE_LABEL];
        int curScore = [label.text intValue];
        curScore--;
        label.text = [NSString stringWithFormat:@"%d",curScore];

    } else {
        NSLog(@"Disike Failed");
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"Vote Failed" message:error delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];
        [alertView release];
    }
}

-(IBAction) writeButtonClicked{
    UIActionSheet *actionSheet = [[UIActionSheet alloc]initWithTitle:nil delegate:self  cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"twitter",@"facebook",@"me2day", nil];
    actionSheet.tag = WRITE_ACTIONSHEET;
    [actionSheet showInView:self.view];
    [actionSheet release];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (actionSheet.tag == WRITE_ACTIONSHEET) {
        if (buttonIndex != CANCEL){
            WriteSloganViewController *wViewController = [[WriteSloganViewController alloc]initWithNibName:@"WriteSloganViewController" bundle:nil];
            wViewController.snsType = 1024+buttonIndex;
            wViewController.adId = self.adId;
            wViewController.delegate = self;
            [[self navigationController] pushViewController:wViewController animated:YES];
            [wViewController release];
        }
    } else if(actionSheet.tag >= LIKEDISLIKE_ACTIONSHEET) {
        if (buttonIndex == 2)
            return;
        int row = actionSheet.tag - LIKEDISLIKE_ACTIONSHEET;
        if (buttonIndex == 0){
            [self likeButtonClicked:row];
        } else if(buttonIndex == 1) {
            [self dislikeButtonClicked:row];
        }
        
    } else if (actionSheet.tag >= DISLIKE_ACTIONSHEET) {
        if(buttonIndex == 4)
            return;
        NSString *reason = @"unfaithful";
        if (buttonIndex == 0) {
            reason = @"unfaithful";
        } else if (buttonIndex == 1) {
            reason = @"malicious";
        } else if(buttonIndex == 2) {
            reason = @"steal";
        } else if(buttonIndex == 3) {
            reason = @"unclear";
        } 
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:actionSheet.tag-DISLIKE_ACTIONSHEET inSection:0];
        NSURL *url = [NSURL URLWithString:[Address dislikeUrl:(NSString *)[self.linkIdDictionary objectForKey:indexPath]]];
        [self.request clearDelegatesAndCancel];
        self.request = [[ASIFormDataRequest alloc] initWithURL:url];
        self.request.userInfo = [NSDictionary dictionaryWithObject:[NSNumber numberWithInt:[indexPath row]] forKey:@"row"];
        [self.request setPostValue:reason forKey:@"data[LinkLikeUv][reason]"];
        [self.request setDelegate:self];
        [self.request setDidFinishSelector:@selector(dislikeRequestDone:)];
        [self.request startAsynchronous];
    }
}
-(IBAction) linkButtonClicked:(id)sender{
    UIButton *button = (UIButton *)sender;
    WebViewController *wViewController = [[WebViewController alloc]initWithNibName:@"WebViewController" bundle:nil];
    wViewController.requestURL = button.titleLabel.text;
    [[self navigationController] pushViewController:wViewController animated:YES];
    [wViewController release];
}

-(IBAction) goPageButtonClicked{
    NSString *urlString=@"";
    NSDictionary *dict = [self.adDictionary objectForKey:@"best_slogan"];
    if (dict!= nil) {
        NSDictionary *dict2 = [dict objectForKey:@"Slogan"];
        urlString = [dict2 objectForKey:@"link"];
    }
    else {
        NSDictionary *dict2 = [dict objectForKey:@"ad"];
        dict2 = [dict2 objectForKey:@"Ad"];
        urlString = [dict2 objectForKey:@"link"];
    }
    WebViewController *wViewController = [[WebViewController alloc]initWithNibName:@"WebViewController" bundle:nil];
    wViewController.requestURL = urlString;
    [[self navigationController] pushViewController:wViewController animated:YES];
    [wViewController release];
}

-(IBAction) likeDislikeButtonClicked:(id)sender{
    UIButton *button = (UIButton *)sender;
    UIView *parent = [button superview];
    UITableViewCell *cell;
    while (parent != nil) {
        if( [parent isMemberOfClass:[UITableViewCell class]] ){
            cell = (UITableViewCell *)parent;
            break;
        }
        parent = [parent superview];
    }
    NSIndexPath *indexPath = [theTableView indexPathForCell:cell];
    NSLog(@"Like");
    NSLog(@"%d",[indexPath row]);

    UIActionSheet *actionSheet = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Like", @"Dislike", nil];
    actionSheet.tag = LIKEDISLIKE_ACTIONSHEET + [indexPath row];
    [actionSheet showInView:self.view];
    [actionSheet release];
    
}

-(IBAction) refreshButtonClicked{
    [self loadAd];
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
			if ([self.imageArray objectAtIndex:indexPath.row] == [NSNull null]) // avoid the app icon download if the app already has an icon
			{
				[self startImageDownload:indexPath andImageUrl:[self.imageUrlDictionary  objectForKey:indexPath]];
			}
		}
	}
}


-(void) startMoreUpdate{
    updating = YES;
    NSLog(@"%@",self.sinceUrl);
    self.theTableView.tableFooterView = self.footerView;
    NSURL *url = [NSURL URLWithString:[Address makeUrl:self.sinceUrl]];
    self.request = [[ASIFormDataRequest alloc] initWithURL:url];
    [self.request setDelegate:self];
    [self.request setDidFinishSelector:@selector(moreRequestDone:)];
    [self.request startAsynchronous];
}

- (void)moreRequestDone:(ASIFormDataRequest *)aRequest{
    [self.footerView removeFromSuperview];
    self.theTableView.tableFooterView = nil;
    NSString *responseString = [aRequest responseString];
    SBJsonParser *parser = [SBJsonParser new];
    NSError *error = nil;
    NSDictionary *temp = [parser objectWithString:responseString error:&error];
    [self reloadSlogan:temp];
    [self.theTableView reloadData];
    updating = NO;
}

-(void)updateMore{
    if (noMoreUpdate || updating)
        return;
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

-(void)imageDidLoad:(id)sender indexPath:(NSIndexPath *)indexPath{
    ImageDownloader *imageDownloader = (ImageDownloader *)sender;
    if (imageDownloader == self.mainImageDownloader){
        adImageView.image = imageDownloader.downloadedImage;
    } else{
        ImageDownloader *imageDownloader = [imageDownloadsInProgress objectForKey:indexPath];
        if (imageDownloader != nil)
        {
            UITableViewCell *cell = [self.theTableView cellForRowAtIndexPath:imageDownloader.indexPathInTableView];
            //UIActivityIndicatorView *activity = (UIActivityIndicatorView *)[cell viewWithTag:ACTIVITY_VIEW];
            //[activity stopAnimating];
            // Display the newly loaded image
            UIImageView *imageView = (UIImageView *)[cell viewWithTag:AVATAR_VIEW];
            imageView.image = imageDownloader.downloadedImage;
            int row = [indexPath row];
            [self.imageArray replaceObjectAtIndex:row withObject:imageDownloader.downloadedImage];
        }   
    }
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
