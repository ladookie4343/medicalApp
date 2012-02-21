//
//  ViewController.m
//  medical
//
//  Created by Matt LaDuca on 2/11/12.
//  Copyright (c) 2012  PPA. All rights reserved.
//

#import "LoginViewController.h"

@interface LoginViewController()

- (void)fetchData:(NSData *)responseData;

@end

@implementation LoginViewController

@synthesize logOnButton = _logOnButton;
@synthesize tableView;

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
	[self.logOnButton useGreenConfirmStyle];
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
    } else {
        label.text = @"Password";
    }
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

@end











