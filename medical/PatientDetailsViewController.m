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
@property (strong, nonatomic) NSMutableArray *allergyTextFields;
@property (strong, nonatomic) NSMutableArray *conditionsTextFields;

- (UIImage *)getImageForPatient:(Patient *)patient;
- (void)updatePhotoButton;
- (UILabel *)labelWithStat:(NSString *)stat;
- (UILabel *)labelWithText:(NSString *)text;

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
@synthesize allergyTextFields = _allergyTextFields;
@synthesize latestWeight = _latestWeight;
@synthesize bpSystolic = _bpSystolic;
@synthesize bpDiastolic = _bpDiastolic;
@synthesize conditionsTextFields = _conditionsTextFields;

#define STATS_SECTION 0
#define DETAILS_SECTION 1
#define ALLERGIES_SECTION 2
#define CONDITIONS_SECTION 3

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.tableView.tableHeaderView = self.tableHeaderView;
    self.allergyTextFields = [NSMutableArray new];
    
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
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"PatientCell"];
    
    if (indexPath.section == STATS_SECTION) {
        switch (indexPath.row) {
            case 0: {
                UILabel *statLabel = [self labelWithStat:@"height"];
                UILabel *actualStats = [self labelWithText:@"5' 8\""];
                [cell addSubview:statLabel];
                [cell addSubview:actualStats];
                break;
            }
            case 1: {
                UILabel *statLabel = [self labelWithStat:@"weight"];
                UILabel *actualStats = [self labelWithText:@"174 pounds"];
                [cell addSubview:statLabel];
                [cell addSubview:actualStats];
                break;
            }
            case 2: {
                UILabel *statLabel = [self labelWithStat:@"blood pressure"];
                UILabel *actualStats = [self labelWithText:@"131 / 82"];
                [cell addSubview:statLabel];
                [cell addSubview:actualStats];
                break;
            }
            default:
                break;
        }
    } else if (indexPath.section == DETAILS_SECTION) {
        switch (indexPath.row) {
            case 0:
                cell.textLabel.text = @"Visits";
                break;
            case 1:
                cell.textLabel.text = @"Surgeries";
                break;
            case 2:
                cell.textLabel.text = @"Tests";
                break;
            default:
                break;
        }
    } else if (indexPath.section == ALLERGIES_SECTION) {
        if (indexPath.row < self.patient.allergies.count) {
            UITextField *tf = [[UITextField alloc] initWithFrame:CGRectMake(10, 9, 270, 31)];
            tf.text = [self.patient.allergies objectAtIndex:indexPath.row];
            tf.enabled = self.editing;
            [cell addSubview:tf];
        } else {
            // add new allergy row
            UITextField *tf = [[UITextField alloc] initWithFrame:CGRectMake(10, 9, 270, 31)];
            tf.text = @"add new allergy";
            tf.enabled = YES;
            [cell addSubview:tf];
        }
    } else if (indexPath.section == CONDITIONS_SECTION) {
        if (indexPath.row < self.patient.medicalConditions.count) {
            UITextField *tf = [[UITextField alloc] initWithFrame:CGRectMake(10, 9, 270, 31)];
            tf.text = [self.patient.medicalConditions objectAtIndex:indexPath.row];
            tf.enabled = self.editing;
            [cell addSubview:tf];
        } else {
            // add new allergy row
            UITextField *tf = [[UITextField alloc] initWithFrame:CGRectMake(10, 9, 270, 31)];
            tf.text = @"add new medical condition";
            tf.enabled = YES;
            [cell addSubview:tf];
        }
    }
    return cell;
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
        for (int i = 0; i < self.allergyTextFields.count; i++) {
            ((UITextField *)[self.allergyTextFields objectAtIndex:i]).enabled = YES;
        }
        for (int i = 0; i < self.conditionsTextFields.count; i++) {
            ((UITextField *)[self.conditionsTextFields objectAtIndex:i]).enabled = YES;
        }
        [self.tableView insertRowsAtIndexPaths:allergiesInsertIndexPath 
                              withRowAnimation:UITableViewRowAnimationTop];
        [self.tableView insertRowsAtIndexPaths:conditionsInsertIndexPath 
                              withRowAnimation:UITableViewRowAnimationTop];
    } else {
        for (int i = 0; i < self.allergyTextFields.count; i++) {
            [((UITextField *)[self.allergyTextFields objectAtIndex:i]) resignFirstResponder];
            ((UITextField *)[self.allergyTextFields objectAtIndex:i]).enabled = NO;
        }
        for (int i = 0; i < self.conditionsTextFields.count; i++) {
            [((UITextField *)[self.conditionsTextFields objectAtIndex:i]) resignFirstResponder];
            ((UITextField *)[self.conditionsTextFields objectAtIndex:i]).enabled = NO;
        }
        
        if ([@"" isEqualToString:(NSString *)[self.allergyTextFields objectAtIndex:self.allergyTextFields.count - 1]]) {
            [self.tableView deleteRowsAtIndexPaths:allergiesInsertIndexPath 
                                  withRowAnimation:UITableViewRowAnimationTop];
        }
        
        if ([@"" isEqualToString:(NSString *)[self.conditionsTextFields objectAtIndex:self.conditionsTextFields.count - 1]]) {
            [self.tableView deleteRowsAtIndexPaths:conditionsInsertIndexPath 
                                  withRowAnimation:UITableViewRowAnimationTop];
        }
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

#pragma mark - Helpers

- (UILabel *)labelWithStat:(NSString *)stat
{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, 13, 55, 21)];
    label.text = stat;
    label.textAlignment = UITextAlignmentRight;
    label.backgroundColor = [UIColor clearColor];
    label.textColor = [UIColor colorWithRed:81/255.0 green:102/255.0 blue:145/255.0 alpha:1];
    label.font = [UIFont boldSystemFontOfSize:13.0];
    return label;
}

- (UILabel *)labelWithText:(NSString *)text
{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(83, 9, 197, 31)];
    label.text = text;
    label.font = [UIFont boldSystemFontOfSize:15];
    label.backgroundColor = [UIColor clearColor];
    return label;
}
@end



























