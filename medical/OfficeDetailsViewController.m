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
    self.phoneNumber.text = self.office.phone;
    self.email.text = self.office.email;
    self.website.text = self.office.website;
    self.location.text = [NSString stringWithFormat:@"%@\n%@, %@ %@\nUnited States", self.office.street, self.office.city, self.office.state, self.office.zipcode];
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
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    switch (indexPath.section) {
        case 0:
            break;
        case 1:
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"mailto://%@", self.office.email]]];
            break;
        case 2:
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://%@", self.office.website]]];
            break;
        case 3: {
            NSString *address = [NSString stringWithFormat:@"%@, %@, %@ %@", self.office.street, self.office.city, self.office.state, self.office.zipcode];
            address = [address stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding];
            NSString *url = [NSString stringWithFormat:@"http://maps.google.com/maps?q=%@", address];
            NSLog(@"%@", url);
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
            break;
        }
        default:
            break;
    }
    
}

@end







































