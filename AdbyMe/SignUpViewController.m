//
//  SignUpViewController.m
//  AdbyMe
//
//  Created by Baekjoon Choi on 4/3/11.
//  Copyright 2011 Megalusion. All rights reserved.
//

#import "SignUpViewController.h"
#import "CustomCellBackgroundView.h"

#define EMAIL_FIELD 1
#define USERNAME_FIELD 2
#define PASSWORD_FIELD 3
#define NAME_FIELD 4

#define HIDDEN_STATUS 1
#define OK_STATUS 2
#define WARN_STATUS 3

@implementation SignUpViewController
@synthesize emailTableView;
@synthesize usernameTableView;
@synthesize passwordTableView;
@synthesize nameTableView;
@synthesize emailTextField;
@synthesize usernameTextField;
@synthesize passwordTextField;
@synthesize nameTextField;
@synthesize scrollView;
@synthesize savedPosition;
@synthesize emailLabel;
@synthesize usernameLabel;
@synthesize passwordLabel;
@synthesize nameLabel;
@synthesize termsButton;
@synthesize submitButton;
@synthesize totalSavedControl;
@synthesize emailCheckView;
@synthesize usernameCheckView;
@synthesize passwordCheckView;
@synthesize nameCheckView;
    

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"Sign Up";
        // Custom initialization
    }
    return self;
}

- (void)dealloc
{
    [emailTableView release];
    [usernameTableView release];
    [passwordTableView release];
    [nameTableView release];
    [emailTextField release];
    [usernameTextField release];
    [passwordTextField release];
    [nameTextField release];
    [scrollView release];
    [savedPosition release];
    [emailLabel release];
    [usernameLabel release];
    [passwordLabel release];
    [nameLabel release];
    [termsButton release];
    [submitButton release];
    [emailCheckView release];
    [usernameCheckView release];
    [passwordCheckView release];
    [nameCheckView release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

-(void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if ([self navigationController].navigationBarHidden == YES)
        [[self navigationController] setNavigationBarHidden:NO animated:YES];
}
#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [scrollView setContentSize:CGSizeMake(320.0, 542.0)];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    self.totalSavedControl = 14;

    [self setCheckView:EMAIL_FIELD status:WARN_STATUS message:@"Wrong Email Format"];
    [self setCheckView:USERNAME_FIELD status:OK_STATUS message:@"OK"];
    [self setCheckView:PASSWORD_FIELD status:WARN_STATUS message:@"Very Weak"];
    [self setCheckView:NAME_FIELD status:HIDDEN_STATUS];
	
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
    static NSString *CellIdentifier = @"CellIdentifierSignUp";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil){
        cell = [[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier]autorelease];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    CustomCellBackgroundView *bgView = [[CustomCellBackgroundView alloc] initWithFrame:CGRectZero];
    bgView.position = CustomCellBackgroundViewPositionSingle;
    UITextField *textField = [[UITextField alloc]initWithFrame:CGRectMake(8, 11, 280, 31)];
    
    [textField setFont:[UIFont fontWithName:@"Helvetica-Bold" size: 18.0]];
    textField.autocorrectionType = UITextAutocorrectionTypeNo;
    textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    [cell.contentView addSubview:textField];
    

    if (tableView == self.emailTableView) {
        textField.placeholder = @"E-Mail";
        textField.secureTextEntry = NO;
        textField.keyboardType = UIKeyboardTypeEmailAddress;
        textField.returnKeyType = UIReturnKeyNext;
        textField.delegate = self;
        self.emailTextField = textField;
    } else if (tableView == self.usernameTableView) {
        textField.placeholder = @"Username";
        textField.secureTextEntry = NO;
        textField.keyboardType = UIKeyboardTypeDefault;
        textField.returnKeyType = UIReturnKeyNext;
        textField.delegate = self;
        self.usernameTextField = textField;
    } else if (tableView == self.passwordTableView) {
        textField.placeholder = @"Password";
        textField.secureTextEntry = YES;
        textField.keyboardType = UIKeyboardTypeDefault;
        textField.returnKeyType = UIReturnKeyNext;
        textField.delegate = self;
        self.passwordTextField = textField;
    } else if (tableView == self.nameTableView) {
        textField.placeholder = @"Name";
        textField.secureTextEntry = NO;
        textField.keyboardType = UIKeyboardTypeDefault;
        textField.returnKeyType = UIReturnKeyDone;
        textField.delegate = self;
        self.nameTextField = textField;
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
    return 1;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == self.emailTextField) {
        [self.usernameTextField becomeFirstResponder];
    } else if (textField == self.usernameTextField) {
        [self.passwordTextField becomeFirstResponder];
    } else if (textField == self.passwordTextField) {
        [self.nameTextField becomeFirstResponder];
    } else if (textField == self.nameTextField) {
        [self.nameTextField resignFirstResponder];
    }
    return YES;
}
-(void) savePosition{
    
    self.savedPosition = [[NSMutableDictionary alloc]initWithCapacity:self.totalSavedControl];
    
    for (int i = 1; i <= self.totalSavedControl; ++i) {
        UIView *control = [self.scrollView viewWithTag:i];
        [savedPosition setValue:[NSValue valueWithCGRect:control.frame] forKey:[NSString stringWithFormat:@"%d",i]];
    }
    
}

-(void)adjustPosition{
    if (savedPosition == nil) {
        [self savePosition];
    }
    for (NSString *key in self.savedPosition) {
        NSValue *val = [self.savedPosition valueForKey:key];
        CGRect frame = [val CGRectValue];
        UIView *control = [self.scrollView viewWithTag:[key intValue]];
        [control setFrame:frame];
    }
}

-(void)keyboardWillShow:(NSNotification *)notification{
    NSLog(@"Keyboard Show");
	CGRect frame = [self.scrollView frame];
	frame.size.height -= 216.0;
	[self.scrollView setFrame:frame];
    [self adjustPosition];
    
}

-(void)keyboardWillHide:(NSNotification *)notification{
	NSLog(@"Keyboard Hide");
	CGRect frame = [self.scrollView frame];
	frame.size.height += 216.0;
	[self.scrollView setFrame:frame];
    [self adjustPosition];
    
}

-(void)focusPosition:(UITextField *)textField{
    UILabel *focusLabel;
    
    if (textField == self.usernameTextField) {
        focusLabel = self.usernameLabel;
    } else if (textField == self.passwordTextField) {
        focusLabel = self.passwordLabel;
    } else if (textField == self.emailTextField) {
        focusLabel = self.emailLabel;
    } else if (textField == self.nameTextField) {
        focusLabel = self.nameLabel;
    }
    
    if (self.savedPosition == nil)
        [self savePosition];
    
    CGRect frame = focusLabel.frame;
    
    [self.scrollView setContentOffset:CGPointMake(0, frame.origin.y) animated:YES];
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    [self focusPosition:textField];
    return YES;
}

-(void) setCheckView:(int)field status:(int)status{
    [self setCheckView:field status:status message:@""];
}
-(void) setCheckView:(int)field status:(int)status message:(NSString *)message{
    UIView *checkView;
    switch (field) {
        case EMAIL_FIELD:
            checkView = self.emailCheckView;
            break;
        case USERNAME_FIELD:
            checkView = self.usernameCheckView;
            break;
        case PASSWORD_FIELD:
            checkView = self.passwordCheckView;
            break;
        case NAME_FIELD:
            checkView = self.nameCheckView;
            break;
        default:
            return;
            break;
    }
    UIImageView *imageView = (UIImageView *)[checkView viewWithTag:1];
    UILabel *label = (UILabel *)[checkView viewWithTag:2];
    if (status == HIDDEN_STATUS) {
        [checkView setHidden:YES];
    } else {
        [checkView setHidden:NO];
        if (status == OK_STATUS) {
            [imageView setImage:[UIImage imageNamed:@"okicon.png"]];
        } else {
            [imageView setImage:[UIImage imageNamed:@"warnicon.png"]];
        }
        label.text = message;
        [label sizeToFit];
        float width = label.frame.size.width;
        NSLog(@"lf",width);
        CGRect frame = label.frame;
        frame.origin.x = checkView.frame.size.width - width;
        [label setFrame:frame];
        frame = imageView.frame;
        frame.origin.x = label.frame.origin.x - frame.size.width - 5.0;
        [imageView setFrame:frame];
    }
}

@end
