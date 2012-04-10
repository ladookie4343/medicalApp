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
- (char)lastNameFirstCharForPatient:(Patient *)patient;

@property (strong, nonatomic) NSMutableArray *patientsByLastName;
@end

@implementation PatientsViewController
@synthesize office = _office;
@synthesize patients = _patients;
@synthesize tableView = _tableView;
@synthesize patientsByLastName = _patientsByLastName;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.patientsByLastName = [[NSMutableArray alloc] init];
    [self splitPatientsByLastname];
    
    self.navigationController.toolbarHidden = NO;
    self.toolbarItems = [self customToolBarItems];
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

- (void)testPatientsByLastName
{
    for (int i = 0; i < self.patientsByLastName.count; i++) {
        NSArray *patientsL = [self.patientsByLastName objectAtIndex:i];
        for (int j = 0; j < patientsL.count; j++) {
            Patient *p = [patientsL objectAtIndex:j];
            NSLog(@"%@", p.lastname);
        }
    }
}

-(void)splitPatientsByLastname
{
    NSMutableArray *splittingPoints = [[NSMutableArray alloc] init];
    
    [splittingPoints addObject:[NSNumber numberWithInt:-1]];
    for (int i = 0; i < self.patients.count - 1; i++) {
        if ([self lastNameFirstCharForPatient:[self.patients objectAtIndex:i]] !=
            [self lastNameFirstCharForPatient:[self.patients objectAtIndex:i + 1]]) {
            [splittingPoints addObject:[NSNumber numberWithInt:i]];
        }
    }
    [splittingPoints addObject:[NSNumber numberWithInt:self.patients.count - 1]];
    
    for (int i = 0; i < splittingPoints.count - 1; i++) {
        int startLocation, length;
        startLocation = [[splittingPoints objectAtIndex:i] intValue] + 1;
        length = [[splittingPoints objectAtIndex:i + 1] intValue] - (startLocation - 1);
        [self.patientsByLastName addObject:[self.patients subarrayWithRange:NSMakeRange(startLocation, length)]];
    }
    
    //[self testPatientsByLastName];
}

- (char)lastNameFirstCharForPatient:(Patient *)patient
{
    return [patient.lastname characterAtIndex:0];
}

#pragma mark - Button Pressed Methods

- (IBAction)logoutPressed:(UIBarButtonItem *)sender 
{
    [self.navigationController popToRootViewControllerAnimated:NO];
}

#pragma mark - Table View Methods

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSArray *patientsWithSimilarLastName = [self.patientsByLastName objectAtIndex:section];
    Patient *p = [patientsWithSimilarLastName objectAtIndex:0];
    char firstLetterOfLastName = [[p.lastname uppercaseString] characterAtIndex:0];
    
    return [NSString stringWithFormat:@"%c", firstLetterOfLastName];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.patientsByLastName.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray *patientsWithSimilarLastName = [self.patientsByLastName objectAtIndex:section];
    return patientsWithSimilarLastName.count;
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    NSMutableArray *firstLettersOfLastName = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < self.patientsByLastName.count; i++) {
        NSArray *patientsWithSimilarLastName = [self.patientsByLastName objectAtIndex:i];
        Patient *p = [patientsWithSimilarLastName objectAtIndex:0];
        char letter = [[p.lastname uppercaseString] characterAtIndex:0];
        [firstLettersOfLastName addObject: [NSString stringWithFormat:@"%c", letter]];
    }
    return [NSArray arrayWithArray:firstLettersOfLastName];
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title 
               atIndex:(NSInteger)index
{
    return index;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"PatientCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:CellIdentifier];
    }
    
    NSArray *patientsWithSimilarLastName = [self.patientsByLastName objectAtIndex:indexPath.section];
    Patient *p = [patientsWithSimilarLastName objectAtIndex:indexPath.row];
    
    cell.textLabel.text = p.lastname;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
}

#pragma mark - Helper Methods

- (NSArray *)customToolBarItems
{
    UIButton *infoUIButton = [UIButton buttonWithType:UIButtonTypeInfoLight];
    [infoUIButton addTarget:self action:@selector(infoPressed) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *info = [[UIBarButtonItem alloc] initWithCustomView:infoUIButton];
    
    UIBarButtonItem *fixedSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace 
                                                                                target:nil 
                                                                                action:nil];
    fixedSpace.width = 243;
    
    
    UIBarButtonItem *addPatient = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd 
                                                                                target:self 
                                                                                action:@selector(addPatient)];
    addPatient.style = UIBarButtonItemStyleBordered;
    
    return [NSArray arrayWithObjects:addPatient, fixedSpace, info, nil];
}

@end

















































