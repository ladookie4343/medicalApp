//
//  PatientDetailsViewController.m
//  medical
//
//  Created by Matt LaDuca on 4/25/12.
//  Copyright (c) 2012  PPA. All rights reserved.
//

#import "PatientDetailsViewController.h"
#import "Patient.h"

@interface PatientDetailsViewController ()

- (UIImage *)getImageForPatient:(Patient *)patient;
- (void)updatePhotoButton;
- (UILabel *)labelWithStat:(NSString *)stat;
- (UILabel *)labelWithText:(NSString *)text;
- (UITextField *)textFieldForSection:(int)section Row:(int)row;
- (NSString *) calculateAgeFromDOB:(NSDate *)dob;
- (NSString *)convertInchesToFeet:(NSString *)inches;
- (NSString *)singleStringForSystolic:(NSString *)systolic diastolic:(NSString *)diastolic;

@end

@implementation PatientDetailsViewController

@synthesize tableHeaderView = __tableHeaderView;
@synthesize photoButton = _photoButton;
@synthesize nameLabel = _nameLabel;
@synthesize ageLabel = _ageLabel;
@synthesize bloodTypeLabel = _bloodTypeLabel;
@synthesize patient = __patient;

#define STATS_SECTION 0
#define DETAILS_SECTION 1
#define ALLERGIES_SECTION 2
#define CONDITIONS_SECTION 3

- (id)initWithStyle:(UITableViewStyle)style
{
    return [super initWithStyle:style];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tableView.tableHeaderView = self.tableHeaderView;
    self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.nameLabel.text = [self.patient.firstname stringByAppendingFormat:@" %@", self.patient.lastname];
    self.ageLabel.text = [self calculateAgeFromDOB:self.patient.dob];
    self.photoButton.backgroundColor = [UIColor clearColor];
    self.bloodTypeLabel.text = self.patient.bloodType;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.photoButton setImage:[self getImageForPatient:self.patient] forState:UIControlStateNormal];
    [self updatePhotoButton];
    [self.tableView reloadData];
}

- (void)viewDidUnload
{
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

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
}

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
            rows = self.patient.allergies.count;
            /*if (self.editing) {
             rows++;
             }*/
            break;
        case CONDITIONS_SECTION:
            rows = self.patient.medicalConditions.count;
            /*if (self.editing) {
             rows++;
             }*/
            break;
        default:
            break;
    }
    return rows;
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
    UITableViewCell *cell = nil;
    
    if (indexPath.section == STATS_SECTION) {
        static NSString *statCellId = @"StatCell";
        cell = [self.tableView dequeueReusableCellWithIdentifier:statCellId];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault 
                                          reuseIdentifier:statCellId];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.userInteractionEnabled = NO;
        switch (indexPath.row) {
            case 0: {
                UILabel *textLabel = [self labelWithText:@"height"];
                UILabel *statLabel = [self labelWithStat:[self convertInchesToFeet:self.patient.height]];
                [cell addSubview:textLabel];
                [cell addSubview:statLabel];
                break; 
            }
            case 1: {
                UILabel *textLabel = [self labelWithText:@"weight"];
                NSString *weight;
                if (self.patient.latestWeight == nil) {
                    weight = @"No previous record.";
                } else {
                    weight = [NSString stringWithFormat:@"%@ pounds", self.patient.latestWeight];
                }
                UILabel *statLabel = [self labelWithStat:weight];
                [cell addSubview:textLabel];
                [cell addSubview:statLabel];
                break;
            }
            case 2: {
                UILabel *textLabel = [self labelWithText:@"blood pressure"];
                UILabel *statLabel = [self labelWithStat:[self singleStringForSystolic:self.patient.latestBPSys diastolic:self.patient.latestBPDia]];
                [cell addSubview:textLabel];
                [cell addSubview:statLabel];
                break;
            }
            default:
                break;
        }
    } else if (indexPath.section == DETAILS_SECTION) {
        static NSString *detailCellId = @"DetailCell";
        cell = [self.tableView dequeueReusableCellWithIdentifier:detailCellId];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault 
                                          reuseIdentifier:detailCellId];
        }
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
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
        static NSString *allergyCellId = @"AllergyCell";
        cell = [self.tableView dequeueReusableCellWithIdentifier:allergyCellId];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault 
                                          reuseIdentifier:allergyCellId];
        }
        cell.textLabel.text = @"foo";
    } else if (indexPath.section == CONDITIONS_SECTION) {
        static NSString *conditionCellId = @"ConditionCell";
        cell = [self.tableView dequeueReusableCellWithIdentifier:conditionCellId];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault 
                                          reuseIdentifier:conditionCellId];
        }
        cell.textLabel.text = @"foo";
    }
    
    return cell;
}

#pragma mark - tableview datasource & delegate

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
}

- (UITextField *)textFieldForSection:(int)section Row:(int)row
{
    BOOL allergySection = section == ALLERGIES_SECTION ? YES : NO;
    
    NSArray *array = allergySection ? self.patient.allergies : self.patient.medicalConditions;
    UITextField *tf = [[UITextField alloc] initWithFrame:CGRectMake(20, 12, 240, 31)];
    tf.delegate = self;
    tf.returnKeyType = UIReturnKeyDone;
    
    if (row < array.count) {
        if (allergySection) {
            tf.text = [self.patient.allergies objectAtIndex:row];
        } else {
            tf.text = [self.patient.medicalConditions objectAtIndex:row];
        }
        tf.enabled = self.editing;
    }
    return tf;
}


#pragma mark - Helper methods

#define kPatientImageAddress @"http://www.ladookie4343.com/MedicalApp/patientImages/"

- (UIImage *)getImageForPatient:(Patient *)patient
{
    NSString *imageName = self.patient.patientImage;
    NSString *imageURLstring = [kPatientImageAddress stringByAppendingString:imageName];
    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:imageURLstring]];
    return [UIImage imageWithData:data];
}

- (void)updatePhotoButton
{
    self.photoButton.enabled = self.editing;
    
    if (self.patient.patientImage == @"") {
        [self.photoButton setImage:[UIImage imageNamed:@"noImage.png"] forState:UIControlStateNormal];
    }
    
    if (self.editing) {
        // set photo button image to be editingImage.png
        [self.photoButton setImage:[UIImage imageNamed:@"editImage.png"] forState:UIControlStateNormal];
    }
}

- (UILabel *)labelWithText:(NSString *)text
{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, 13, 95, 21)];
    label.text = text;
    label.textAlignment = UITextAlignmentRight;
    label.backgroundColor = [UIColor clearColor];
    label.textColor = [UIColor colorWithRed:81/255.0 green:102/255.0 blue:145/255.0 alpha:1];
    label.font = [UIFont boldSystemFontOfSize:13.0];
    return label;
}

- (UILabel *)labelWithStat:(NSString *)stat
{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(123, 9, 197, 31)];
    label.text = stat;
    label.font = [UIFont boldSystemFontOfSize:15];
    label.backgroundColor = [UIColor clearColor];
    return label;
}


- (NSString *) calculateAgeFromDOB:(NSDate *)dob
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    unsigned unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit;
    NSDateComponents *dateComponentsNow = [calendar components:unitFlags fromDate:[NSDate date]];
    NSDateComponents *dateComponentsBirth = [calendar components:unitFlags fromDate:dob];
    
    if (([dateComponentsNow month] < [dateComponentsBirth month]) ||
        (([dateComponentsNow month] == [dateComponentsBirth month]) && ([dateComponentsNow day] < [dateComponentsBirth day]))) {
        return [NSString stringWithFormat:@"%d", [dateComponentsNow year] - [dateComponentsBirth year] - 1];
    } else {
        return [NSString stringWithFormat:@"%d", [dateComponentsNow year] - [dateComponentsBirth year]];
    }
}

- (NSString *)convertInchesToFeet:(NSString *)inches
{
    int inchesTotal = inches.intValue;
    
    int feetComponent = inchesTotal / 12;
    int inchesComponent = inchesTotal - (feetComponent * 12);
    
    return [NSString stringWithFormat:@"%d' %d\"", feetComponent, inchesComponent];
}

- (NSString *)singleStringForSystolic:(NSString *)systolic diastolic:(NSString *)diastolic
{
    if (systolic == nil || diastolic == nil) {
        return @"No previous record.";
    }
    return [NSString stringWithFormat:@"%@ / %@", systolic, diastolic];
}

@end
