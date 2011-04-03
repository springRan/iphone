//
//  LoginViewController.m
//  AdbyMe
//
//  Created by Baekjoon Choi on 4/3/11.
//  Copyright 2011 Megalusion. All rights reserved.
//

#import "LoginViewController.h"
#import "AdListViewController.h"
#import "CustomCellBackgroundView.h"

@implementation LoginViewController
@synthesize theTableView;
@synthesize emailField;
@synthesize passwordField;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        self.title = @"Login";
        // Custom initialization
    }
    return self;
}

- (void)dealloc
{
    [emailField release];
    [passwordField release];
    [theTableView release];
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

-(void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if ([self navigationController].navigationBarHidden == YES)
        [[self navigationController] setNavigationBarHidden:NO animated:YES];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"CellIdentifierLogIn";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil){
        cell = [[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier]autorelease];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    int row = [indexPath row];
    
    CustomCellBackgroundView *bgView = [[CustomCellBackgroundView alloc] initWithFrame:CGRectZero];
    
    UITextField *textField = [[UITextField alloc]initWithFrame:CGRectMake(8, 11, 280, 31)];

    [textField setFont:[UIFont fontWithName:@"Helvetica-Bold" size: 18.0]];
    textField.autocorrectionType = UITextAutocorrectionTypeNo;
    textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    [cell.contentView addSubview:textField];
    if (row == 0) {
        textField.placeholder = @"E-Mail";
        textField.secureTextEntry = NO;
        textField.keyboardType = UIKeyboardTypeEmailAddress;
        textField.returnKeyType = UIReturnKeyNext;
        textField.delegate = self;
        self.emailField = textField;
        bgView.position = CustomCellBackgroundViewPositionTop;
    } else if (row == 1) {
        textField.placeholder = @"Password";
        textField.secureTextEntry = YES;
        textField.keyboardType = UIKeyboardTypeDefault;
        textField.returnKeyType = UIReturnKeyGo;
        textField.delegate = self;
        self.passwordField = textField;
        bgView.position = CustomCellBackgroundViewPositionBottom;
    }
    [textField release];
    bgView.fillColor = [UIColor whiteColor];
    
    cell.backgroundView = bgView;
    
    return cell;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

}

-(void) loginCheck{
    AdListViewController *aViewController = [[AdListViewController alloc]initWithNibName:@"AdListViewController" bundle:nil];
    [[self navigationController] pushViewController:aViewController animated:YES];
    [aViewController release];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == self.emailField) {
        [self.passwordField becomeFirstResponder];
    } else if (textField == self.passwordField) {
        [self loginCheck];
    }
    return YES;
}

@end
