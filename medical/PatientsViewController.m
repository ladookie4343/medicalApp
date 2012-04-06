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
- (NSArray *)customToolBarItems;
- (void)infoPressed;
- (void)addPatient;
@end

@implementation PatientsViewController
@synthesize office = _office;
@synthesize patients = _patients;
@synthesize tableView = _tableView;


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self splitPatientsByLastname];
    
    self.navigationController.toolbarHidden = NO;
    self.toolbarItems = [self customToolBarItems];
}

- (NSArray *)customToolBarItems
{
    UIButton *infoUIButton = [UIButton buttonWithType:UIButtonTypeInfoLight];
    [infoUIButton addTarget:self action:@selector(infoPressed) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *info = [[UIBarButtonItem alloc] initWithCustomView:infoUIButton];
    
    UIBarButtonItem *fixedSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    fixedSpace.width = 243;
    
    
    UIBarButtonItem *addPatient = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addPatient)];
    addPatient.style = UIBarButtonItemStyleBordered;
    
    return [NSArray arrayWithObjects:addPatient, fixedSpace, info, nil];
}

- (void)infoPressed
{
    [self performSegueWithIdentifier:@"officeDetailsSegue" sender:self];
}

- (void)addPatient
{
    
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
