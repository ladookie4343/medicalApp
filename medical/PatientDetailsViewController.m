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

@property (nonatomic, strong) NSMutableArray *textFields;

- (UIImage *)getImageForPatient:(Patient *)patient;
- (void)updatePhotoButton;
- (UILabel *)labelWithStat:(NSString *)stat;
- (UILabel *)labelWithText:(NSString *)text;
- (NSString *) calculateAgeFromDOB:(NSDate *)dob;
- (NSString *)convertInchesToFeet:(NSString *)inches;
- (NSString *)singleStringForSystolic:(NSString *)systolic diastolic:(NSString *)diastolic;
- (UITextField *)textFieldWithPlaceholder:(NSString *)placeholder;
@end

@implementation PatientDetailsViewController

@synthesize tableHeaderView = __tableHeaderView;
@synthesize photoButton = __photoButton;
@synthesize nameLabel = __nameLabel;
@synthesize ageLabel = __ageLabel;
@synthesize bloodTypeLabel = __bloodTypeLabel;
@synthesize patient = __patient;
@synthesize textFields = __textFields;

#define STATS_SECTION 0
#define DETAILS_SECTION 1
#define ALLERGIES_SECTION 2
#define CONDITIONS_SECTION 3

#define PLACEHOLDER @"placeholder"

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
    self.textFields = [NSMutableArray new];
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

#pragma mark - tableview datasource & delegate

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
            if (self.editing) {
             rows++;
             }
            break;
        case CONDITIONS_SECTION:
            rows = self.patient.medicalConditions.count;
            if (self.editing) {
             rows++;
             }
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
    } else if (indexPath.section == ALLERGIES_SECTION || indexPath.section == CONDITIONS_SECTION) {
        static NSString *editableCellId = @"EditableCell";
        cell = [self.tableView dequeueReusableCellWithIdentifier:editableCellId];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault 
                                          reuseIdentifier:editableCellId];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
       
        NSMutableArray *items;
        int rowCount;
        NSString *insertString;
        NSString *placeHolder;
        if (indexPath.section == ALLERGIES_SECTION) {
            items = self.patient.allergies;
            rowCount = self.patient.allergies.count;
            insertString = @"Add New Allergy";
            placeHolder = @"Enter a new allergy.";
        } else {
            items = self.patient.medicalConditions;
            rowCount = self.patient.medicalConditions.count;
            insertString = @"Add new medical condition...";
            placeHolder = @"Enter a new medical condition.";
        }
        
        if (indexPath.row == rowCount) {
            cell.textLabel.text = insertString;
        } else {
            if ([PLACEHOLDER isEqualToString:[items objectAtIndex:indexPath.row]]) {
                UITextField *textField = [self textFieldWithPlaceholder:placeHolder];
                [self.textFields addObject:textField];
                [cell.contentView addSubview:textField];
            } else {
                cell.textLabel.text = [self.patient.allergies objectAtIndex:indexPath.row];
            }
            
        }
    }
    
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == ALLERGIES_SECTION || indexPath.section == CONDITIONS_SECTION) {
        return  YES;
    }
    return NO;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        if (indexPath.section == ALLERGIES_SECTION) {
            [self.patient.allergies removeObjectAtIndex:indexPath.row];
        } else if (indexPath.section == CONDITIONS_SECTION) {
            [self.patient.medicalConditions removeObjectAtIndex:indexPath.row];
        }
        [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        if (indexPath.section == ALLERGIES_SECTION) {
            [self.patient.allergies addObject:PLACEHOLDER];
        } else if (indexPath.section == CONDITIONS_SECTION) {
            [self.patient.medicalConditions addObject:PLACEHOLDER];
        }
        [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationTop];
    }   
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated
{
    [super setEditing:editing animated:animated];
    [self.navigationItem setHidesBackButton:editing animated:YES];
    
    if (editing) {
        NSIndexPath *allergyIndexPath = [NSIndexPath indexPathForRow:self.patient.allergies.count 
                                                           inSection:ALLERGIES_SECTION];
        NSIndexPath *conditionsIndexPath = [NSIndexPath indexPathForRow:self.patient.medicalConditions.count 
                                                              inSection:CONDITIONS_SECTION];
        NSArray *paths = [NSArray arrayWithObjects:allergyIndexPath, conditionsIndexPath, nil];
        [self.tableView insertRowsAtIndexPaths:paths withRowAnimation:UITableViewRowAnimationTop];
    } else {
        NSIndexPath *allergyIndexPath = [NSIndexPath indexPathForRow:self.patient.allergies.count 
                                                           inSection:ALLERGIES_SECTION];
        NSIndexPath *conditionsIndexPath = [NSIndexPath indexPathForRow:self.patient.medicalConditions.count 
                                                              inSection:CONDITIONS_SECTION];
        NSArray *paths = [NSArray arrayWithObjects:allergyIndexPath, conditionsIndexPath, nil];
        [self.tableView deleteRowsAtIndexPaths:paths withRowAnimation:UITableViewRowAnimationFade];
        for (UITextField *textField in self.textFields) {
            [textField resignFirstResponder];
        }
    }
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == ALLERGIES_SECTION && indexPath.row == self.patient.allergies.count) {
        return UITableViewCellEditingStyleInsert;
    } else if (indexPath.section == CONDITIONS_SECTION && indexPath.row == self.patient.medicalConditions.count) {
        return UITableViewCellEditingStyleInsert;
    } else {
        return UITableViewCellEditingStyleDelete;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
}

#pragma mark - text field delegates & helpers

- (UITextField *)textFieldWithPlaceholder:(NSString *)placeholder
{    
    UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(20, 12, 240, 31)];
    textField.delegate = self;
    textField.returnKeyType = UIReturnKeyDone;
    textField.placeholder = placeholder;
    textField.enabled = YES;
    return textField;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
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
