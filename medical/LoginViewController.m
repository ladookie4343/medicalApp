//
//  ViewController.m
//  medical
//
//  Created by Matt LaDuca on 2/11/12.
//  Copyright (c) 2012  PPA. All rights reserved.
//

#import "LoginViewController.h"

@interface LoginViewController()

@property (nonatomic, strong) UITextField *usernameField;
@property (nonatomic, strong) UITextField *passwordField;
@property (nonatomic, strong) UISegmentedControl *userIDPass;

- (void)fetchData:(NSData *)responseData;
- (UITextField *)newUsernameTextField;
- (UITextField *)newPasswordTextField;
- (UIBarButtonItem *)userIDPassBarButton;
- (UIButton *)logOnButton;
- (NSArray *)keyboardToolbarItems;
- (void)tryLogOn;

@end

@implementation LoginViewController

@synthesize tableView = _tableView;
@synthesize keyboardToolbar = _keyboardToolbar;
@synthesize usernameField = _usernameField;
@synthesize passwordField = _passwordField;
@synthesize userIDPass = _userIDPass;

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.usernameField = [self newUsernameTextField];
    self.passwordField = [self newPasswordTextField];
    self.keyboardToolbar.items = [self keyboardToolbarItems];    
    
    [self.view addSubview:[self logOnButton]];
}

- (void)viewDidUnload
{
    [self setTableView:nil];
    [self setKeyboardToolbar:nil];
    [super viewDidUnload];
}

#pragma mark -


#define kBgQueue dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
#define kLadookieURL [NSURL URLWithString: @"http://www.ladookie4343.com/MedicalApp/doctorlogin.php"]

- (void)logOnPressed:(UIButton *)sender 
{
    [self tryLogOn];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    [self tryLogOn];
    return YES;
}

- (void)tryLogOn
{
    // NSString *username = self.userTextField.text;
    // NSString *password = self.passwordTextField.text;
    
    dispatch_async(kBgQueue, ^{
        NSData *data = [NSData dataWithContentsOfURL:kLadookieURL];
        [self performSelectorOnMainThread:@selector(fetchData:) withObject:data waitUntilDone:YES];
    });
    
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil 
                                                    message:@"I pooped!"
                                                   delegate:nil 
                                          cancelButtonTitle:@"OK" 
                                          otherButtonTitles:nil];
    [alert show];
}

- (void)fetchData:(NSData *)responseData
{
    NSError *error;
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:responseData 
                                                         options:kNilOptions 
                                                           error:&error];
    NSString *firstname = [json objectForKey:@"firstname"];
    NSString *type = [json objectForKey:@"type"];
    NSString *experience = [json objectForKey:@"years_experience"];
    
    NSLog(@"%@, %@, %@", firstname, type, experience);
    NSLog(@"%@", json);
}
#pragma mark


#pragma mark Tableview datasource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault 
                                                   reuseIdentifier:nil];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10.0, 10.0, 100, 20)];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont boldSystemFontOfSize:15];
    [cell.contentView addSubview:label];
    if (indexPath.row == 0) {
        label.text = @"User ID";
        [cell addSubview:self.usernameField];
    } else {
        label.text = @"Password";
        [cell.contentView addSubview:self.passwordField];
    }
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

#pragma mark - textfield accessory view methods

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (textField == self.usernameField) {
        self.userIDPass.selectedSegmentIndex = 0;
    } else {
        self.userIDPass.selectedSegmentIndex = 1;
    }
    textField.inputAccessoryView = self.keyboardToolbar;
}

- (void)userIDPassPressed:(UISegmentedControl *)sender
{
    if (sender.selectedSegmentIndex == 0) {
        [self.usernameField becomeFirstResponder];
    } else {
        [self.passwordField becomeFirstResponder];
    }
}

- (void)closeKeyboard
{
    if ([self.usernameField isEditing]) {
        [self.usernameField resignFirstResponder];
    } else {
        [self.passwordField resignFirstResponder];
    }
}


#pragma mark - helper methods

- (UITextField *)newUsernameTextField
{
    UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(103.0, 5.0, 202.0, 35.0)];
    textField.font = [UIFont boldSystemFontOfSize:14];
    textField.delegate = self;
    textField.returnKeyType = UIReturnKeyGo;
    textField.clearsOnBeginEditing = NO;
    textField.placeholder = @"Enter your User ID";
    textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    textField.autocorrectionType = UITextAutocorrectionTypeNo;
    textField.enabled = YES;
    textField.secureTextEntry = NO;
    textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    textField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    return textField;
}

- (UITextField *)newPasswordTextField
{
    UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(93.0, 5.0, 204.0, 35.0)];
    textField.font = [UIFont boldSystemFontOfSize:14];
    textField.delegate = self;
    textField.returnKeyType = UIReturnKeyGo;
    textField.clearsOnBeginEditing = NO;
    textField.placeholder = @"Enter your Password";
    textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    textField.autocorrectionType = UITextAutocorrectionTypeNo;
    textField.enabled = YES;
    textField.secureTextEntry = YES;
    textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    textField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    return textField;
}

- (UIButton *)logOnButton
{
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(10, 250, 300, 38)];
    [button setTitle:@"Log On" forState:UIControlStateNormal];
    UIImage *buttonImage = [[UIImage imageNamed:@"green_button.png"] resizableImageWithCapInsets:
                            UIEdgeInsetsMake(0, 11, 0, 11)];
    [button addTarget:self action:(@selector(logOnPressed:)) forControlEvents:UIControlEventTouchUpInside];
    [button setBackgroundImage:buttonImage forState:UIControlStateNormal];
    return button;
}

- (NSArray *)keyboardToolbarItems;
{
    UIBarButtonItem *userIDPassButton =  [self userIDPassBarButton];    
    UIBarButtonItem *flex = [[UIBarButtonItem alloc] 
                             initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace 
                                                  target:nil 
                                                  action:nil];
    flex.width = 105;
    
    UIBarButtonItem *done = [[UIBarButtonItem alloc] initWithTitle:@"Done" 
                                                             style:UIBarButtonItemStyleBordered 
                                                            target:self 
                                                            action:@selector(closeKeyboard)];
    done.tintColor = [UIColor colorWithWhite:0.25 alpha:1];
    return [[NSArray alloc] initWithObjects: userIDPassButton, flex, done, nil];
}

- (UIBarButtonItem *)userIDPassBarButton
{
    self.userIDPass = [[UISegmentedControl alloc] initWithItems:
                                    [[NSArray alloc] initWithObjects:@"User ID", @"Password", nil]];
    self.userIDPass.segmentedControlStyle = UISegmentedControlStyleBar;
    [self.userIDPass addTarget:self 
                        action:@selector(userIDPassPressed:) 
              forControlEvents:UIControlEventValueChanged];
    self.userIDPass.tintColor = [UIColor colorWithWhite:0.25 alpha:1];
    return [[UIBarButtonItem alloc] initWithCustomView:self.userIDPass];
}


@end











