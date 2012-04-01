//
//  PatientsViewController.m
//  medical
//
//  Created by Matt LaDuca on 3/31/12.
//  Copyright (c) 2012  PPA. All rights reserved.
//

#import "PatientsViewController.h"

@interface PatientsViewController ()

@end

@implementation PatientsViewController
@synthesize tableView;
@synthesize infoButton;


- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewDidUnload
{
    [self setTableView:nil];
    [self setInfoButton:nil];
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


#pragma mark - Button Pressed Methods

- (IBAction)logoutPressed:(UIBarButtonItem *)sender 
{
}

- (IBAction)infoButtonPressed:(UIBarButtonItem *)sender 
{
}

- (IBAction)addNewPatientButtonPressed:(UIBarButtonItem *)sender 
{
}


@end
