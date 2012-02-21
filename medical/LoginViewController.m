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

@synthesize userTextField = _userTextField;
@synthesize passwordTextField = _passwordTextField;



#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
	
}

- (void)viewDidUnload
{
    [self setUserTextField:nil];
    [self setPasswordTextField:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

#define kBgQueue dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
#define kLadookieURL [NSURL URLWithString: @"http://www.ladookie4343.com/MedicalApp/doctorlogin.php"]

- (IBAction)buttonPressed:(UIButton *)sender 
{
    NSString *username = self.userTextField.text;
    NSString *password = self.passwordTextField.text;
    
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



/*
 UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title 
                                                 message:message
                                                delegate:nil 
                                       cancelButtonTitle:@"OK" 
                                       otherButtonTitles:nil];
 [alert show];

*/


@end
