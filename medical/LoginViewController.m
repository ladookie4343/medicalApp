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

- (void)fetchData:(NSData *)responseData;
- (UITextField *)newTextFieldwithPlaceholder:(NSString *)placeholderText 
                                      xCoord:(CGFloat)x 
                                      yCoord:(CGFloat)y 
                                      secure:(BOOL)secure;
- (UIBarButtonItem *)prevNextBarButton;

@end

@implementation LoginViewController

@synthesize tableView = _tableView;
@synthesize keyboardToolbar = _keyboardToolbar;
@synthesize usernameField = _usernameField;
@synthesize passwordField = _passwordField;

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.usernameField = [self newTextFieldwithPlaceholder:@"Enter your User ID" 
                                                    xCoord:100.0 
                                                    yCoord:5.0 
                                                    secure:NO];
    
    self.passwordField = [self newTextFieldwithPlaceholder:@"Enter your Password" 
                                                    xCoord:90.0 
                                                    yCoord:5.0 
                                                    secure:YES];
    
    UIBarButtonItem *userIDPassButton =  [self prevNextBarButton];    
    UIBarButtonItem *flex = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace 
                                                                          target:nil 
                                                                          action:nil];
    flex.width = 115;
    
    UIBarButtonItem *done = [[UIBarButtonItem alloc] initWithTitle:@"Done" 
                                                             style:UIBarButtonItemStyleBordered 
                                                            target:self 
                                                            action:@selector(closeKeyboard)];
    done.tintColor = [UIColor colorWithWhite:0.25 alpha:1];
    
    self.keyboardToolbar.items = [[NSArray alloc] initWithObjects: userIDPassButton, flex, done, nil];
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

- (IBAction)buttonPressed:(UIButton *)sender 
{
    // NSString *username = self.userTextField.text;
    // NSString *password = self.passwordTextField.text;
    
    dispatch_async(kBgQueue, ^{
        NSData *data = [NSData dataWithContentsOfURL:kLadookieURL];
        [self performSelectorOnMainThread:@selector(fetchData:) withObject:data waitUntilDone:YES];
    });
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    
    [textField resignFirstResponder];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil 
                                                    message:@"I pooped!"
                                                   delegate:nil 
                                          cancelButtonTitle:@"OK" 
                                          otherButtonTitles:nil];
    [alert show];
    return YES;
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
    label.font = [UIFont boldSystemFontOfSize:14];
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
    textField.inputAccessoryView = self.keyboardToolbar;
}

- (void)prevNextPressed
{
    
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

- (UIBarButtonItem *)prevNextBarButton
{
    UISegmentedControl *prevNext = [[UISegmentedControl alloc] initWithItems:
                                    [[NSArray alloc] initWithObjects:@"Previous", @"Next", nil]];
    prevNext.segmentedControlStyle = UISegmentedControlStyleBar;
    [prevNext addTarget:self action:@selector(prevNextPressed) forControlEvents:UIControlEventValueChanged];
    prevNext.tintColor = [UIColor colorWithWhite:0.25 alpha:1];
    return [[UIBarButtonItem alloc] initWithCustomView:prevNext];
}

- (UITextField *)newTextFieldwithPlaceholder:(NSString *)placeholderText xCoord:(CGFloat)x 
                                      yCoord:(CGFloat)y secure:(BOOL)secure
{
    UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(x, y, 250, 35.0)];
    textField.font = [UIFont boldSystemFontOfSize:14];
    textField.delegate = self;
    textField.returnKeyType = UIReturnKeyGo;
    textField.clearsOnBeginEditing = NO;
    textField.placeholder = placeholderText;
    textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    textField.autocorrectionType = UITextAutocorrectionTypeNo;
    textField.enabled = YES;
    textField.secureTextEntry = secure;
    textField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    return textField;
}


@end











