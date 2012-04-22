//
//  PatientDetailsViewController.m
//  medical
//
//  Created by Matt LaDuca on 4/17/12.
//  Copyright (c) 2012  PPA. All rights reserved.
//

#import "PatientDetailsViewController.h"
#import "Patient.h"

@interface PatientDetailsViewController ()

@property (strong, nonatomic) NSArray *allergies;
@property (strong, nonatomic) NSArray *medicalConditions;

@end

@implementation PatientDetailsViewController

@synthesize tableView = _tableView;
@synthesize tableHeaderView = _tableHeaderView;
@synthesize photoButton = _photoButton;
@synthesize nameLabel = _nameLabel;
@synthesize ageLabel = _ageLabel;
@synthesize bloodTypeLabel = _bloodTypeLabel;
@synthesize patient = _patient;
@synthesize allergies = _allergies;
@synthesize medicalConditions = _medicalConditions;

#define STATS_SECTION 0
#define DETAILS_SECTION 1
#define ALLERGIES_SECTION 2
#define CONDITIONS_SECTION 3

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.tableView.tableHeaderView = self.tableHeaderView;
    
    self.nameLabel.text = @"Matthew LaDuca";
    self.ageLabel.text = @"28";
    self.bloodTypeLabel.text = @"O+";
    
    
}

- (void)viewDidUnload
{
    [self setTableView:nil];
    [self setTableView:nil];
    [self setTableHeaderView:nil];
    [self setPhotoButton:nil];
    [self setNameLabel:nil];
    [self setAgeLabel:nil];
    [self setBloodTypeLabel:nil];
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - UITableView Delegate/Datasource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView 
{
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
}

#pragma mark -
#pragma mark Editing rows

- (void)setEditing:(BOOL)editing animated:(BOOL)animated 
{
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath 
{
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath 
{
    
}


- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath 
{

}


- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath 
{

}

@end
