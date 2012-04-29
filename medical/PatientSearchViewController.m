//
//  PatientSearchViewController.m
//  medical
//
//  Created by Matt LaDuca on 4/28/12.
//  Copyright (c) 2012  PPA. All rights reserved.
//

#import "PatientSearchViewController.h"
#import "PatientsTableViewCell.h"
#import "PatientDetailsViewController.h"
#import "Patient.h"
#import "Utilities.h"

@interface PatientSearchViewController ()

@property (nonatomic, strong) Patient *selectedPatient;

- (void)handleSearchForTerm:(NSString *)term scope:(NSString *)scope;
- (void)finishedSearchingPatients;

@end

@implementation PatientSearchViewController
@synthesize selectedPatient = __selectedPatient;
@synthesize patientSearchResults = __patientSearchResults;
@synthesize savedSearchTerm = __savedSearchTerm;
@synthesize loadingView = __loadingView;


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if (self.savedSearchTerm) {
        self.searchDisplayController.searchBar.text = self.savedSearchTerm;
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [self.loadingView removeFromSuperview];
}

- (void)viewDidUnload
{
    self.savedSearchTerm = self.searchDisplayController.searchBar.text;
    self.patientSearchResults = nil;
    
    [self setLoadingView:nil];
    
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)doneButtonPressed:(id)sender 
{
    [self dismissModalViewControllerAnimated:YES];
}


#pragma mark - Table View Methods



- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.patientSearchResults.count;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"PatientCell";
    
    PatientsTableViewCell *cell = 
        (PatientsTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[PatientsTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault 
                                            reuseIdentifier:CellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    Patient *patient = [self.patientSearchResults objectAtIndex:indexPath.row];
    cell.textLabel.text = [patient.firstname stringByAppendingFormat:@" %@", patient.lastname];
    
//    cell.firstNameLabel.text = patient.firstname;
//    [cell.firstNameLabel sizeToFit];
//    
//    cell.lastNameLabel.frame = CGRectMake(20 + cell.firstNameLabel.frame.size.width + 6, 11, 120, 22);
//    cell.lastNameLabel.text = patient.lastname;
    
    return cell;
}

#define kBgQueue dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    self.selectedPatient = [self.patientSearchResults objectAtIndex:indexPath.row];

    
    [Utilities showLoadingView:self.loadingView InView:self.view];
    
    dispatch_async(kBgQueue, ^{
        [self.selectedPatient GetDetailsForPatientDetailsVC];
        [self.selectedPatient GetLatestStats];
        [self performSelectorOnMainThread:@selector(finishedLoadingPatient) 
                               withObject:nil 
                            waitUntilDone:YES];
    });
}

- (void)finishedLoadingPatient
{
    [self performSegueWithIdentifier:@"PatientDetailsFromSearch" sender:self];
    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString: @"PatientDetailsFromSearch"]) {
        PatientDetailsViewController *patientDetailVC = segue.destinationViewController;
        patientDetailVC.patient = self.selectedPatient;
    }
    [self.loadingView removeFromSuperview];
}

#pragma mark - Search Methods


- (void)handleSearchForTerm:(NSString *)term scope:(NSString *)scope
{
    self.savedSearchTerm = term;
    
    if (self.patientSearchResults ==  nil) {
        self.patientSearchResults = [[NSMutableArray alloc] init];
    }
    
    [self.patientSearchResults removeAllObjects];
    
    if ([scope isEqualToString:@"Patient ID"]) {
        self.patientSearchResults = [Patient patientsForSearchById:[term intValue]];
    } else if ([scope isEqualToString:@"Last Name"]) {
        self.patientSearchResults = [Patient patientsForSearchByLastName:term];
    }    
}

- (void)finishedSearchingPatients
{
    [self.searchDisplayController.searchResultsTableView reloadData];
}

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    dispatch_async(kBgQueue, ^{
        [self handleSearchForTerm:searchString scope:
            [[self.searchDisplayController.searchBar scopeButtonTitles] objectAtIndex:
             [self.searchDisplayController.searchBar selectedScopeButtonIndex]]];
        [self performSelectorOnMainThread:@selector(finishedSearchingPatients) withObject:nil waitUntilDone:YES];
    });
    
    return NO;
}


@end

















