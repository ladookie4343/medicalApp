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

- (UIImage *)getImageForPatient:(Patient *)patient;
- (void)updatePhotoButton;

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
    
    self.allergies = [NSArray arrayWithObjects:@"Penicilin", @"Mold", nil];
    self.medicalConditions = [NSArray new];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.photoButton setImage:[self getImageForPatient:self.patient] forState:UIControlStateNormal];
    [self updatePhotoButton];
    [self.tableView reloadData];
}

#define kPatientImageAddress @"http://www.ladookie4343.com/MedicalApp/patientImages/"
     
- (UIImage *)getImageForPatient:(Patient *)patient
{
    NSString *imageName = self.patient.patientImage;
    NSString *imageURLstring = [kPatientImageAddress stringByAppendingString:imageName];
    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:imageURLstring]];
    return [UIImage imageWithData:data];
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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger rows = 0;
    
    switch (section) {
        case STATS_SECTION:
            rows = 3;
            break;
        case DETAILS_SECTION:
            rows = 3;
            break;
        case ALLERGIES_SECTION:
            rows = self.allergies.count;
            if (self.editing) {
                rows++;
            }
            break;
        case CONDITIONS_SECTION:
            rows = self.medicalConditions.count;
            if (self.editing) {
                rows++;
            }
            break;
        default:
            break;
    }
    return rows;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView 
{
    return 4;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString *title = nil;
    
    switch (section) {
        case ALLERGIES_SECTION:
            title = @"Allergies";
            break;
        case CONDITIONS_SECTION:
            title = @"Medical Conditions";
            break;
        default:
            break;
    }
    return title;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
}

#pragma mark - Editing rows

- (void)setEditing:(BOOL)editing animated:(BOOL)animated 
{
    [super setEditing:editing animated:animated];
    [self updatePhotoButton];
    [self.navigationItem setHidesBackButton:editing animated:YES];
    
    [self.tableView beginUpdates];
    
    NSUInteger allergiesCount = self.allergies.count;
    NSArray *allergiesInsertIndexPath = [NSArray arrayWithObject:[NSIndexPath indexPathForRow:allergiesCount inSection:ALLERGIES_SECTION]];
    
    NSUInteger conditionsCount = self.medicalConditions.count;
    NSArray *conditionsInsertIndexPath = [NSArray arrayWithObject:[NSIndexPath indexPathForRow:conditionsCount inSection:CONDITIONS_SECTION]];
    
    if (editing) {
        [self.tableView insertRowsAtIndexPaths:allergiesInsertIndexPath withRowAnimation:UITableViewRowAnimationTop];
        [self.tableView insertRowsAtIndexPaths:conditionsInsertIndexPath withRowAnimation:UITableViewRowAnimationTop];
    } else {
        [self.tableView deleteRowsAtIndexPaths:allergiesInsertIndexPath withRowAnimation:UITableViewRowAnimationTop];
        [self.tableView deleteRowsAtIndexPaths:conditionsInsertIndexPath withRowAnimation:UITableViewRowAnimationTop];
    }
    
    [self.tableView endUpdates];

    // if done editing save the conditions and allergies to database
    if (!editing) {
        
    }
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

#pragma mark - Photo stuff

- (void)updatePhotoButton
{
    self.photoButton.enabled = self.editing;
    
    if (self.editing) {
        // set photo button image to be editingImage.png
    }
}

@end



























