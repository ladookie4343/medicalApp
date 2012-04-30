//
//  PatientDetailsViewController.m
//  medical
//
//  Created by Matt LaDuca on 4/25/12.
//  Copyright (c) 2012  PPA. All rights reserved.
//

#import "PatientDetailsViewController.h"
#import "Patient.h"
#import "Utilities.h"
#import "Office.h"
#import <QuartzCore/QuartzCore.h>


@interface PatientDetailsViewController ()

@property (nonatomic, strong) NSMutableArray *allergyTextFields;
@property (nonatomic, strong) NSMutableArray *conditionsTextFields;
@property (nonatomic, assign) int allergyCountBeforeEditing;
@property (nonatomic, assign) int conditionCountBeforeEditing;
@property (nonatomic, assign) BOOL begginingEditMode;

- (UIImage *)getImageForPatient:(Patient *)patient;
- (void)updatePhotoButton;
- (UILabel *)labelWithStat:(NSString *)stat;
- (UILabel *)labelWithText:(NSString *)text;
- (NSString *) calculateAgeFromDOB:(NSDate *)dob;
- (NSString *)convertInchesToFeet:(NSString *)inches;
- (NSString *)singleStringForSystolic:(NSString *)systolic diastolic:(NSString *)diastolic;
- (UITextField *)textFieldWithPlaceholder:(NSString *)placeholder;
- (void)resignKeyBoard;
- (void)updateAllergies;
- (void)updateConditions;
- (void)addPatientPressed;
- (void)initPatientDetailsScreen;
- (void)responseFromTryingToAddPatient:(NSData *)data;
- (void)showAlertViewWithMessage:(NSString *)message;

@end

@implementation PatientDetailsViewController

@synthesize tableHeaderView = __tableHeaderView;
@synthesize photoButton = __photoButton;
@synthesize nameLabel = __nameLabel;
@synthesize ageLabel = __ageLabel;
@synthesize bloodTypeLabel = __bloodTypeLabel;
@synthesize patient = __patient;
@synthesize allergyTextFields = __allergyTextFields;
@synthesize conditionsTextFields = __conditionsTextFields;
@synthesize allergyCountBeforeEditing = __allergyCountBeforeEditing;
@synthesize conditionCountBeforeEditing = __conditionCountBeforeEditing;
@synthesize begginingEditMode = __begginingEditMode;
@synthesize addingPatient = __addingPatient;
@synthesize patientImage = __patientImage;
@synthesize office = __office;
@synthesize delegate = __delegate;

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
    [self initPatientDetailsScreen];
}

- (void)initPatientDetailsScreen
{
    [self.tableView setFrame: CGRectMake(0, 0, 320, 493)];
    self.tableView.tableHeaderView = self.tableHeaderView;
    self.navigationController.toolbarHidden = YES;
    
    self.allergyTextFields = [NSMutableArray new];
    self.conditionsTextFields = [NSMutableArray new];
    self.begginingEditMode = YES;
    
    if (self.addingPatient) {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Add Patient" style:UIBarButtonItemStyleBordered target:self action:@selector(addPatientPressed)];
        self.navigationItem.rightBarButtonItem.tintColor = [UIColor blueColor];
    } else {
        self.navigationItem.rightBarButtonItem = self.editButtonItem;
    }
    
    [Utilities RoundedBorderForImageView:self.patientImage];
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.patientImage.image = [self getImageForPatient:self.patient];
    [self updatePhotoButton];
    [self.tableView reloadData];
    
    // set up tableHeaderView
    self.nameLabel.text = [self.patient.firstname stringByAppendingFormat:@" %@", self.patient.lastname];
    self.ageLabel.text = [self calculateAgeFromDOB:self.patient.dob];
    self.photoButton.backgroundColor = [UIColor clearColor];
    self.bloodTypeLabel.text = self.patient.bloodType;

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

#define kBgQueue dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)

#define kPatientInOfficeString @"http://www.ladookie4343.com/MedicalApp/patientInOffice.php"
#define kPatientInOfficeURL [NSURL URLWithString: kPatientInOfficeString]
#define kQueryString [NSString stringWithFormat:@"officeID=%d&patientID=%d", self.office.officeID, self.patient.patientID]

- (void)addPatientPressed
{
    dispatch_async(kBgQueue, ^{
        NSData *data = [Utilities dataFromPHPScript:kPatientInOfficeURL post:YES request:kQueryString];
        [self performSelectorOnMainThread:@selector(responseFromTryingToAddPatient:) withObject:data waitUntilDone:YES];
    });
    
}

#define kAddPatientURLString @"http://www.ladookie4343.com/MedicalApp/addPatient.php"
#define kAddPatientURL [NSURL URLWithString:kAddPatientURLString]

- (void)responseFromTryingToAddPatient:(NSData *)data
{
    NSString *alreadyInOffice = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    if ([alreadyInOffice isEqualToString:@"yes"]) {
        [self showAlertViewWithMessage:@"This patient is already in your office."];
    } else {
        [Utilities dataFromPHPScript:kAddPatientURL post:YES request:kQueryString];
        self.delegate.addedPatient = YES;
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)showAlertViewWithMessage:(NSString *)message
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil 
                                                    message:message
                                                   delegate:nil 
                                          cancelButtonTitle:@"OK" 
                                          otherButtonTitles:nil];
    [alert show];   
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

#define HEADER_HEIGHT 40

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == DETAILS_SECTION) {
        return 20;
    }
    return HEADER_HEIGHT;
}

- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section 
{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, HEADER_HEIGHT)];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(25, 16, tableView.bounds.size.width - 10, 18)];
    [headerView addSubview:label];
    label.text = @"";
    label.textColor = [UIColor whiteColor];
    label.font = [UIFont boldSystemFontOfSize:16];
    label.backgroundColor = [UIColor clearColor];
    switch (section) {
        case STATS_SECTION:
            label.text = @"Latest Measurements";
            break;
        case ALLERGIES_SECTION:
            label.text = @"Allergies";
            break;
        case CONDITIONS_SECTION:
            label.text = @"Medical Conditions";
            break;
        default:
            break;
    }
    return headerView;
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
       
        NSMutableArray *items, *textFields;
        NSString *insertString, *placeHolder;
        static NSString *cellId;
        int rowCount;
        if (indexPath.section == ALLERGIES_SECTION) {
            items = self.patient.allergies;
            rowCount = self.patient.allergies.count;
            insertString = @"Add new allergy...";
            placeHolder = @"Enter a new allergy.";
            textFields = self.allergyTextFields;
            cellId = @"AllergyCellId";
            if (indexPath.row < rowCount && [PLACEHOLDER isEqualToString:[items objectAtIndex:indexPath.row]]) {
                cellId = @"allergyTextField";
            }
        } else {
            items = self.patient.medicalConditions;
            rowCount = self.patient.medicalConditions.count;
            insertString = @"Add new medical condition...";
            placeHolder = @"Enter a new medical condition.";
            textFields = self.conditionsTextFields;
            cellId = @"conditionCellId";
            if (indexPath.row < rowCount && [PLACEHOLDER isEqualToString:[items objectAtIndex:indexPath.row]]) {
                cellId = @"conditionTextField";
            }
        }
        UITextField *textField;
        cell = [self.tableView dequeueReusableCellWithIdentifier:cellId];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault 
                                          reuseIdentifier:cellId];
            if (indexPath.row == rowCount) {
                cell.textLabel.text = insertString;
            } else {
                if ([PLACEHOLDER isEqualToString:[items objectAtIndex:indexPath.row]]) {
                    textField = [self textFieldWithPlaceholder:placeHolder];
                    [textFields addObject:textField];
                    [cell.contentView addSubview:textField];
                } else {
                    cell.textLabel.text = [items objectAtIndex:indexPath.row];
                }
            }
        } else {
            if ([cell.reuseIdentifier isEqualToString:@"allergyTextField"] ||
                [cell.reuseIdentifier isEqualToString:@"conditionTextField"]) {
                UITextField *textField = [cell.contentView.subviews objectAtIndex:0];
                if (self.begginingEditMode) {
                    textField.text = nil;
                }
            }
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
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

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle 
                                            forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        if (indexPath.section == ALLERGIES_SECTION) {
            [self.patient.allergies removeObjectAtIndex:indexPath.row];
            self.allergyCountBeforeEditing--;
        } else if (indexPath.section == CONDITIONS_SECTION) {
            [self.patient.medicalConditions removeObjectAtIndex:indexPath.row];
            self.conditionCountBeforeEditing--;
        }
        [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] 
                              withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        if (indexPath.section == ALLERGIES_SECTION) {
            [self.patient.allergies addObject:PLACEHOLDER];
        } else if (indexPath.section == CONDITIONS_SECTION) {
            [self.patient.medicalConditions addObject:PLACEHOLDER];
        }
        [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] 
                              withRowAnimation:UITableViewRowAnimationLeft];
    }
}

#define kBgQueue dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)

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
        [self.tableView insertRowsAtIndexPaths:paths withRowAnimation:UITableViewRowAnimationLeft];
        self.allergyCountBeforeEditing = self.patient.allergies.count;
        self.conditionCountBeforeEditing = self.patient.medicalConditions.count;
    } else {
        NSIndexPath *allergyIndexPath = [NSIndexPath indexPathForRow:self.patient.allergies.count 
                                                           inSection:ALLERGIES_SECTION];
        NSIndexPath *conditionsIndexPath = [NSIndexPath indexPathForRow:self.patient.medicalConditions.count 
                                                              inSection:CONDITIONS_SECTION];
        NSArray *paths = [NSArray arrayWithObjects:allergyIndexPath, conditionsIndexPath, nil];
        [self.tableView deleteRowsAtIndexPaths:paths withRowAnimation:UITableViewRowAnimationFade];
        
        [self resignKeyBoard];
        [self updateAllergies];
        [self updateConditions];
        [self.tableView reloadData];
        self.begginingEditMode = YES;
        
        dispatch_async(kBgQueue, ^{
            [self.patient updateAllergies];
            [self.patient updateMedicalConditions];
        });
    }
}

- (void)resignKeyBoard
{
    for (UITextField *textField in self.allergyTextFields) {
        [textField resignFirstResponder];
    }
    for (UITextField *textField in self.conditionsTextFields) {
        [textField resignFirstResponder];
    }

}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView 
           editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == ALLERGIES_SECTION && indexPath.row == self.patient.allergies.count) {
        return UITableViewCellEditingStyleInsert;
    } else if (indexPath.section == CONDITIONS_SECTION && 
               indexPath.row == self.patient.medicalConditions.count) {
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
    UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(10, 12, 240, 31)];
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

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    self.begginingEditMode = NO;
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
        
    if ([self.patient.patientImage isEqualToString:@""]) {
        self.patientImage.image = [UIImage imageNamed:@"noImage.png"];
    }
    
    if (self.editing) {
        [self.photoButton setImage:[UIImage imageNamed:@"editImage.png"] 
                          forState:UIControlStateNormal];
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

- (void)updateAllergies
{
    NSLog(@"%d", self.allergyTextFields.count);
    int numDeleted = 0;
    for (int i = 0; i < self.allergyTextFields.count; i++) {
        UITextField *textField = [self.allergyTextFields objectAtIndex:i];
        if (textField.text == nil || [@"" isEqualToString:[Utilities trimmedString:textField.text]]) {
            [self.patient.allergies removeObjectAtIndex:self.allergyCountBeforeEditing + i - numDeleted];
            numDeleted++;
        } else {
            [self.patient.allergies replaceObjectAtIndex:self.allergyCountBeforeEditing + i 
                                              withObject:textField.text];
        }
    }
    [self.allergyTextFields removeAllObjects];
}

- (void)updateConditions
{
    int numDeleted = 0;
    for (int i = 0; i < self.conditionsTextFields.count; i++) {
        UITextField *textField = [self.conditionsTextFields objectAtIndex:i];
        if (textField.text == nil || [@"" isEqualToString:[Utilities trimmedString:textField.text]]) {
            [self.patient.medicalConditions removeObjectAtIndex:self.conditionCountBeforeEditing + i - numDeleted];
            numDeleted++;
        } else {
            [self.patient.medicalConditions replaceObjectAtIndex:self.conditionCountBeforeEditing + i 
                                                      withObject:textField.text];
        }
    }
    [self.conditionsTextFields removeAllObjects];
}
@end























