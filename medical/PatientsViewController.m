//
//  PatientsViewController.m
//  medical
//
//  Created by Matt LaDuca on 3/31/12.
//  Copyright (c) 2012  PPA. All rights reserved.
//

#import "PatientsViewController.h"
#import "Office.h"
#import "Patient.h"

@interface PatientsViewController ()
- (void)splitPatientsByLastname;
@end

@implementation PatientsViewController
@synthesize office = _office;
@synthesize patients = _patients;
@synthesize tableView = _tableView;

/*
 NSArray *items = [NSArray arrayWithObjects: customItem, customItem1, nil];
 [toolbar setItems:items animated:NO];
 */

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self splitPatientsByLastname];
    self.navigationController.toolbarHidden = NO;
    
    UIButton *infoUIButton = [UIButton buttonWithType:UIButtonTypeInfoLight];
    UIBarButtonItem *info = [[UIBarButtonItem alloc] initWithCustomView:infoUIButton];
    NSArray *items = [NSArray arrayWithObjects:[self.toolbarItems objectAtIndex:0], [self.toolbarItems objectAtIndex:1], info, nil];
    [self.navigationController.toolbar setItems:items animated:NO];
    
    
}

- (void)viewDidUnload
{
    [self setTableView:nil];
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(void)splitPatientsByLastname
{
}

#pragma mark - Button Pressed Methods

- (IBAction)logoutPressed:(UIBarButtonItem *)sender 
{
    [self.navigationController popToRootViewControllerAnimated:NO];
}

#pragma mark - Table View Methods


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
}

@end
