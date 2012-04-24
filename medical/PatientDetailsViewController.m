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

@property (strong, nonatomic) NSMutableArray *allergyTextFields;
@property (strong, nonatomic) NSMutableArray *conditionsTextFields;
@property (assign, nonatomic) int conditionCountBeforeEditing;
@property (assign, nonatomic) int allergyCountBeforeEditing;
@property (assign, nonatomic) int editingSection;

- (UIImage *)getImageForPatient:(Patient *)patient;
- (void)updatePhotoButton;
- (UILabel *)labelWithStat:(NSString *)stat;
- (UILabel *)labelWithText:(NSString *)text;
- (void)registerForKeyboardNotifications;
- (UITextField *)textFieldForSection:(int)section Row:(int)row;

@end

@implementation PatientDetailsViewController

@synthesize tableView = _tableView;
@synthesize tableHeaderView = _tableHeaderView;
@synthesize photoButton = _photoButton;
@synthesize nameLabel = _nameLabel;
@synthesize ageLabel = _ageLabel;
@synthesize bloodTypeLabel = _bloodTypeLabel;
@synthesize patient = _patient;
@synthesize allergyTextFields = _allergyTextFields;
@synthesize conditionsTextFields = _conditionsTextFields;
@synthesize allergyCountBeforeEditing = _allergyCountBeforeEditing;
@synthesize conditionCountBeforeEditing = _conditionCountBeforeEditing;
@synthesize editingSection = _editingSection;

#define STATS_SECTION 0
#define DETAILS_SECTION 1
#define ALLERGIES_SECTION 2
#define CONDITIONS_SECTION 3

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self registerForKeyboardNotifications];
    self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.tableView.tableHeaderView = self.tableHeaderView;
    self.allergyTextFields = [NSMutableArray new];
    self.conditionsTextFields = [NSMutableArray new];
    
    self.nameLabel.text = [self.patient.firstname stringByAppendingFormat:@" %@", self.patient.lastname];
    self.ageLabel.text = [self calculateAgeFromDOB:self.patient.dob];
    self.bloodTypeLabel.text = self.patient.bloodType;
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

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = nil;    
    
    if (indexPath.section == STATS_SECTION) {
        static NSString *StatCellIdentifier = @"StatCell";
        cell = [self.tableView dequeueReusableCellWithIdentifier:StatCellIdentifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:StatCellIdentifier];
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.userInteractionEnabled = NO;
        switch (indexPath.row) {
            case 0: {
                UILabel *statLabel = [self labelWithText:@"height"];
                UILabel *actualStats = [self labelWithStat:[self convertInchesToFeet:self.patient.height]];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                [cell addSubview:statLabel];
                [cell addSubview:actualStats];
                break;
            }
            case 1: {
                UILabel *statLabel = [self labelWithText:@"weight"];
                NSString *weight;
                if (self.patient.latestWeight == nil) {
                    weight = @"No previous record.";
                } else {
                    weight = [NSString stringWithFormat:@"%@ pounds", self.patient.latestWeight];
                }
                UILabel *actualStats = [self labelWithStat:weight];
                [cell addSubview:statLabel];
                [cell addSubview:actualStats];
                break;
            }
            case 2: {
                UILabel *statLabel = [self labelWithText:@"blood pressure"];
                UILabel *actualStats = [self labelWithStat:[self singleStringForSystolic:self.patient.latestBPSys diastolic:self.patient.latestBPDia]];
                [cell addSubview:statLabel];
                [cell addSubview:actualStats];
                break;
            }
            default:
                break;
        }
    } else if (indexPath.section == DETAILS_SECTION) {
        static NSString *DetailCellIdentifier = @"DetailCell";
        cell = [self.tableView dequeueReusableCellWithIdentifier:DetailCellIdentifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:DetailCellIdentifier];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
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
        static NSString *AllergyCellIdentifier = @"AllergyCell";
        cell = [self.tableView dequeueReusableCellWithIdentifier:AllergyCellIdentifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:AllergyCellIdentifier];
            cell.accessoryType = UITableViewCellAccessoryNone;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        UITextField *tf = [self textFieldForSection:ALLERGIES_SECTION Row:indexPath.row];
        [cell addSubview:tf];
    } else if (indexPath.section == CONDITIONS_SECTION) {
        static NSString *ConditionCellIdentifier = @"ConditionCell";
        cell = [self.tableView dequeueReusableCellWithIdentifier:ConditionCellIdentifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ConditionCellIdentifier];
            cell.accessoryType = UITableViewCellAccessoryNone;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        UITextField *tf = [self textFieldForSection:CONDITIONS_SECTION Row:indexPath.row];
        [cell addSubview:tf];
    }
    return cell;
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
            [self.allergyTextFields addObject:tf];
        } else {
            tf.text = [self.patient.medicalConditions objectAtIndex:row];
            [self.conditionsTextFields addObject:tf];
        }
        tf.enabled = self.editing;
    } else {
        // add new row
        if (allergySection) {
            tf.placeholder = @"add new allergy";
            [self.allergyTextFields addObject:tf];
        } else {
            tf.placeholder = @"add new medical condition";
            [self.conditionsTextFields addObject:tf];
        }
        tf.enabled = YES;
    }
    return tf;
}

#pragma mark - Editing rows

#define kBgQueue dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)

- (void)setEditing:(BOOL)editing animated:(BOOL)animated 
{
    [super setEditing:editing animated:animated];
    [self updatePhotoButton];
    [self.navigationItem setHidesBackButton:editing animated:YES];
    
    [self.tableView beginUpdates];
    
    
    
    NSUInteger allergiesCount = self.patient.allergies.count;
    NSArray *allergiesInsertIndexPath = [NSArray arrayWithObject:[NSIndexPath indexPathForRow:allergiesCount inSection:ALLERGIES_SECTION]];
    
    NSUInteger conditionsCount = self.patient.medicalConditions.count;
    NSArray *conditionsInsertIndexPath = [NSArray arrayWithObject:[NSIndexPath indexPathForRow:conditionsCount inSection:CONDITIONS_SECTION]];
    
    NSLog(@"%d", self.allergyTextFields.count);
    NSLog(@"%d", self.conditionsTextFields.count);
    for (UITextField *tf in self.allergyTextFields) {
        NSLog(@"%@", tf);
    }
    for (UITextField *tf in self.conditionsTextFields) {
        NSLog(@"%@", tf);
    }
    
    if (editing) {
        [self getArrayCounts];
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
        
        NSLog(@"%d", self.allergyTextFields.count);
        NSLog(@"%d", self.conditionsTextFields.count);
        
        NSLog(@"|%@|", ((UITextField *)[self.allergyTextFields objectAtIndex:self.allergyTextFields.count - 1]).text);
        
        NSLog(@"|%@|", ((UITextField *)[self.conditionsTextFields objectAtIndex:self.conditionsTextFields.count - 1]).text);
        
        // if no text was entered in the 'add new allergy' row then delete it.
        if (((UITextField *)[self.allergyTextFields objectAtIndex:self.allergyTextFields.count - 1]).text == nil) {
            [self.tableView deleteRowsAtIndexPaths:allergiesInsertIndexPath 
                                  withRowAnimation:UITableViewRowAnimationTop];
            [self.allergyTextFields removeObjectAtIndex:self.allergyTextFields.count - 1];
        }
        // if no text was entered in the 'add new medical condition' row then delete it.
        if (((UITextField *)[self.conditionsTextFields objectAtIndex:self.conditionsTextFields.count - 1]).text == nil) {
            [self.tableView deleteRowsAtIndexPaths:conditionsInsertIndexPath 
                                  withRowAnimation:UITableViewRowAnimationTop];
            [self.conditionsTextFields removeObjectAtIndex:self.conditionsTextFields.count - 1];
        }
    }
    
    [self.tableView endUpdates];

    dispatch_async(kBgQueue, ^{
        if (!editing) {
            if (self.allergyCountBeforeEditing != self.allergyTextFields.count) {
                [self.patient updateAllergies];
            }
            if (self.conditionCountBeforeEditing != self.conditionsTextFields.count) {
                [self.patient updateMedicalConditions];
            }
        }
    });
}

- (void)getArrayCounts
{
    self.allergyCountBeforeEditing = self.allergyTextFields.count;
    self.conditionCountBeforeEditing = self.conditionsTextFields.count;
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath 
{
    NSIndexPath *rowToSelect = indexPath;
    
    if (self.editing && indexPath.section == DETAILS_SECTION) {
        [tableView deselectRowAtIndexPath:indexPath animated:NO];
        rowToSelect = nil;
    }
    return rowToSelect;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath 
{
    NSLog(@"Hello");
}


- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath 
{
    UITableViewCellEditingStyle style = UITableViewCellEditingStyleNone;
    
    // only allow editing in the allerigies and conditions section
    if (indexPath.section == ALLERGIES_SECTION) {
        if (indexPath.row < self.patient.allergies.count) {
            style = UITableViewCellEditingStyleDelete;
        }
    }
    
    if (indexPath.section == CONDITIONS_SECTION) {
        if (indexPath.row < self.patient.medicalConditions.count) {
            style = UITableViewCellEditingStyleDelete;
        }
    }
    return style;
}


- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath 
{
    // Only allow deletion in allergies and medical conditions
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        if (indexPath.section == ALLERGIES_SECTION) {
            [self.patient.allergies removeObjectAtIndex:indexPath.row];
            [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]  withRowAnimation:UITableViewRowAnimationTop];
        } else if (indexPath.section == CONDITIONS_SECTION) {
            [self.patient.medicalConditions removeObjectAtIndex:indexPath.row];
            [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]  withRowAnimation:UITableViewRowAnimationTop];
        }
    }
}

#pragma mark - Photo stuff

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

#pragma mark - TextField Stuff

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if ([@"add new allergy" isEqualToString:textField.placeholder]) {
        self.editingSection = ALLERGIES_SECTION;
    } else {
        self.editingSection = CONDITIONS_SECTION;
    }
    return YES;
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

- (void)registerForKeyboardNotifications 
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardDidShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasHidden:)
                                                 name:UIKeyboardDidHideNotification object:nil];
}

- (void)keyboardWasShown:(NSNotification *)aNotification 
{
    CGRect keyboardBounds;
    [[aNotification.userInfo valueForKey:UIKeyboardFrameBeginUserInfoKey] getValue: &keyboardBounds];
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationBeginsFromCurrentState:YES];
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, keyboardBounds.size.height, 0);
    [UIView commitAnimations];
    int row = 0;
    if (self.editingSection == ALLERGIES_SECTION) {
        row = self.patient.allergies.count; 
    } else {
        row = self.patient.medicalConditions.count;
    }
    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:row inSection:self.editingSection]
                          atScrollPosition:UITableViewScrollPositionMiddle
                                  animated:YES];
}

- (void)keyboardWasHidden:(NSNotification *)aNotification 
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationBeginsFromCurrentState:YES];
    self.tableView.contentInset = UIEdgeInsetsZero;
    [UIView commitAnimations];
}

@end



























