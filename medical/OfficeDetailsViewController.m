//
//  OfficeDetailsViewController.m
//  medical
//
//  Created by Matt LaDuca on 4/1/12.
//  Copyright (c) 2012  PPA. All rights reserved.
//

#import "OfficeDetailsViewController.h"

@interface OfficeDetailsViewController()

- (UIView *)officeNameHeader;
- (void)doneButtonPressed;

@end



@implementation OfficeDetailsViewController

@synthesize office = _office;
@synthesize phoneNumber;
@synthesize email;
@synthesize website;
@synthesize location;

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - View lifecycle


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tableView.tableHeaderView = [self officeNameHeader];
}

- (void)viewWillAppear:(BOOL)animated
{
    self.location.text = @"12909 Woodliegh Ave\nTampa, FL\nUnited States";
}

- (void)viewDidUnload
{
    [self setPhoneNumber:nil];
    [self setEmail:nil];
    [self setWebsite:nil];
    [self setLocation:nil];
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - helpers

- (UIView *)officeNameHeader
{
    UIView *containerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 300, 60)];
    UILabel *headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 20, 300, 40)];
    
    headerLabel.text = [NSString stringWithFormat:@"Matt's Dental Office"];
    headerLabel.textColor = [UIColor whiteColor];
    headerLabel.shadowColor = [UIColor blackColor];
    headerLabel.shadowOffset = CGSizeMake(0, 1);
    headerLabel.font = [UIFont boldSystemFontOfSize:22];
    headerLabel.backgroundColor = [UIColor clearColor];
    headerLabel.textAlignment = UITextAlignmentCenter;
    [containerView addSubview:headerLabel];
    
    return containerView;
}

- (IBAction)doneButtonPressed:(UIBarButtonItem *)sender 
{
    [self dismissModalViewControllerAnimated:YES];
}


#pragma mark - tableview methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    /*samples
     
     [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://itunesconnect.apple.com"]];
     
     // Where is Apple on the map anyway?
     NSString* addressText = @"1 Infinite Loop, Cupertino, CA 95014";
     // URL encode the spaces
     addressText =  [addressText stringByAddingPercentEscapesUsingEncoding: NSASCIIStringEncoding];	
     NSString* urlText = [NSString stringWithFormat:@"http://maps.google.com/maps?q=%@", addressText];
     // lets throw this text on the log so we can view the url in the event we have an issue
     NSLog(@"%@", urlText);
     [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlText]];
     
     */
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    switch (indexPath.section) {
        case 1:
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"mailto://devprograms@apple.com"]];
            
            break;
            
        default:
            break;
    }
    
}

@end