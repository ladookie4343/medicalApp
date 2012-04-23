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
#import "OfficeDetailsViewController.h"
#import "PatientsTableViewCell.h"
#import "PatientDetailsViewController.h"
#import "Utilities.h"

@interface PatientsViewController ()
- (void)splitPatientsByLastname;
- (NSArray *)customToolBarItems;
- (void)infoPressed;
- (void)addPatient;
- (char)lastNameFirstCharForPatient:(Patient *)patient;
- (void)handleSearchForTerm:(NSString *)term;

@property (strong, nonatomic) NSMutableArray *patientsByLastName;
@property (strong, nonatomic) Patient *selectedPatient;
@end

@implementation PatientsViewController
@synthesize office = _office;
@synthesize patients = _patients;
@synthesize tableView = _tableView;
@synthesize loadingView = _loadingView;
@synthesize patientsByLastName = _patientsByLastName;
@synthesize patientSearchResults = _patientSearchResults;
@synthesize savedSearchTerm = _savedSearchTerm;
@synthesize selectedPatient = _selectedPatient;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.patientsByLastName = [[NSMutableArray alloc] init];
    [self splitPatientsByLastname];
    
    self.navigationController.toolbarHidden = NO;
    self.toolbarItems = [self customToolBarItems];
    
    if (self.savedSearchTerm) {
        self.searchDisplayController.searchBar.text = self.savedSearchTerm;
    }
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
    self.savedSearchTerm = self.searchDisplayController.searchBar.text;
    self.patientSearchResults = nil;
    [self setLoadingView:nil];
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
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
    if (tableView == self.tableView) {
        NSArray *patientsWithSimilarLastName = [self.patientsByLastName objectAtIndex:section];
        Patient *p = [patientsWithSimilarLastName objectAtIndex:0];
        char firstLetterOfLastName = [[p.lastname uppercaseString] characterAtIndex:0];
        
        return [NSString stringWithFormat:@"%c", firstLetterOfLastName];
    } else {
        return @"";
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        return 1;
    } else {
        return self.patientsByLastName.count;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        return self.patientSearchResults.count;
    } else {
        NSArray *patientsWithSimilarLastName = [self.patientsByLastName objectAtIndex:section];
        return patientsWithSimilarLastName.count;
    }
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    if (tableView == self.tableView) {
        NSMutableArray *firstLettersOfLastName = [[NSMutableArray alloc] init];
        
        for (int i = 0; i < self.patientsByLastName.count; i++) {
            NSArray *patientsWithSimilarLastName = [self.patientsByLastName objectAtIndex:i];
            Patient *p = [patientsWithSimilarLastName objectAtIndex:0];
            char letter = [[p.lastname uppercaseString] characterAtIndex:0];
            [firstLettersOfLastName addObject: [NSString stringWithFormat:@"%c", letter]];
        }
        return [NSArray arrayWithArray:firstLettersOfLastName];
    } else {
        return nil;
    }
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title 
               atIndex:(NSInteger)index
{
    return index;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PatientsTableViewCell *cell = (PatientsTableViewCell *)[self.tableView dequeueReusableCellWithIdentifier:@"PatientCell"];
    
    NSArray *patientsWithSimilarLastName = [self.patientsByLastName objectAtIndex:indexPath.section];
    
    Patient *p;
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        p = [self.patientSearchResults objectAtIndex:indexPath.row];
    } else {
        p = [patientsWithSimilarLastName objectAtIndex:indexPath.row];
    }
    
    
    cell.firstNameLabel.text = p.firstname;
    [cell.firstNameLabel sizeToFit];
    
    cell.lastNameLabel.frame = CGRectMake(20 + cell.firstNameLabel.frame.size.width + 6, 11, 120, 22);
    cell.lastNameLabel.text = p.lastname;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        self.selectedPatient = [self.patientSearchResults objectAtIndex:indexPath.row];
    } else {
        NSArray *patientsWithSimilarLastName = [self.patientsByLastName objectAtIndex:indexPath.section];
        self.selectedPatient = [patientsWithSimilarLastName objectAtIndex:indexPath.row];
    }
    [self performSegueWithIdentifier:@"PatientDetailSegue" sender:self];
    [Utilities showLoadingView:self.loadingView InView:self.view];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"officeDetailsSegue"]) {
        ((OfficeDetailsViewController *)segue.destinationViewController).office = self.office;
    } else if ([segue.identifier isEqualToString: @"PatientDetailSegue"]) {
        PatientDetailsViewController *patientDetailVC = segue.destinationViewController;
        [self.selectedPatient GetDetailsForPatientDetailsVC];
        [self.selectedPatient GetLatestStats];
        patientDetailVC.patient = self.selectedPatient;
    }
    [self.loadingView removeFromSuperview];
}

#pragma mark - Search Methods


- (void)handleSearchForTerm:(NSString *)term
{
    self.savedSearchTerm = term;
    
    if (self.patientSearchResults ==  nil) {
        self.patientSearchResults = [[NSMutableArray alloc] init];
    }
    
    [self.patientSearchResults removeAllObjects];
    if (self.savedSearchTerm.length != 0) {
        for (Patient *p in self.patients) {
            NSString *fullName = [NSString stringWithFormat:@"%@ %@", p.firstname, p.lastname];
            if ([fullName rangeOfString:term options:NSCaseInsensitiveSearch].location != NSNotFound) {
                [self.patientSearchResults addObject:p];
            }
        }
    }
}

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    [self handleSearchForTerm:searchString];
    return YES;
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

















































