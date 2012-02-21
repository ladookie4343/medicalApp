//
//  ViewController.m
//  medical
//
//  Created by Matt LaDuca on 2/11/12.
//  Copyright (c) 2012  PPA. All rights reserved.
//

#import "LoginViewController.h"

@interface LoginViewController()

@property (nonatomic, weak) UITextField *usernameField;
@property (nonatomic, weak) UITextField *passwordField;

- (void)fetchData:(NSData *)responseData;
- (UITextField *)newTextField:(NSString *)placeholderText;

@end

@implementation LoginViewController

@synthesize logOnButton = _logOnButton;
@synthesize tableView = _tableView;
@synthesize usernameField = _usernameField;
@synthesize passwordField = _passwordField;

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
	[self.logOnButton useGreenConfirmStyle];
    self.usernameField = [self newTextField:@"Enter your Username"];
    self.passwordField = [self newTextField:@"Enter your Password"];
}

- (void)viewDidUnload
{
    [self setLogOnButton:nil];
    [self setTableView:nil];
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
    [cell.contentView addSubview:label];
    if (indexPath.row == 0) {
        label.text = @"Username";
        [cell.contentView addSubview:self.usernameField];
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

#pragma mark - helper methods

- (UITextField *)newTextField:(NSString *)placeholderText
{
    UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(100, 10, 150, 25)];
    textField.font = [UIFont systemFontOfSize:16];
    textField.delegate = self;
    textField.returnKeyType = UIReturnKeyGo;
    textField.clearsOnBeginEditing = NO;
    textField.placeholder = placeholderText;
    textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    textField.autocorrectionType = UITextAutocorrectionTypeNo;
    
    return textField;
}


@end











