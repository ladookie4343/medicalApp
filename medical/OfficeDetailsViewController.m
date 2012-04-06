//
//  OfficeDetailsViewController.m
//  medical
//
//  Created by Matt LaDuca on 4/1/12.
//  Copyright (c) 2012  PPA. All rights reserved.
//

#import "OfficeDetailsViewController.h"

@interface OfficeDetailsViewController()

- (UIView *)topSpacer;
- (UINavigationBar *)navBar;
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
    
    // add space near the top so that the navbar doesn't cover up the first cell.
    self.tableView.tableHeaderView = [self topSpacer];
    
    [self.view addSubview:[self navBar]];
}

- (UINavigationBar *)navBar
{
    UINavigationBar *navBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneButtonPressed)];
    UINavigationItem *item = [[UINavigationItem alloc] initWithTitle:@"Office Info"];
    item.rightBarButtonItem = rightButton;
    item.hidesBackButton = YES;
    [navBar pushNavigationItem:item animated:NO];
    return navBar;
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

- (UIView *)topSpacer
{
    UIView *containerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 300, 60)];
    UILabel *headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 20, 300, 80)];
    headerLabel.backgroundColor = [UIColor clearColor];
    [containerView addSubview:headerLabel];
    return containerView;
}

- (void)doneButtonPressed
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