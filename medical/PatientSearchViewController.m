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
#import "Office.h"

@interface PatientSearchViewController ()

@property (nonatomic, strong) Patient *selectedPatient;

- (void)handleSearchForTerm:(NSString *)term scope:(NSString *)scope;
- (void)finishedSearchingPatients;
- (void)timerDone;

@end

@implementation PatientSearchViewController
@synthesize selectedPatient = __selectedPatient;
@synthesize patientSearchResults = __patientSearchResults;
@synthesize savedSearchTerm = __savedSearchTerm;
@synthesize loadingView = __loadingView;
@synthesize office = __office;
@synthesize addedPatient;


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if (self.savedSearchTerm) {
        self.searchDisplayController.searchBar.text = self.savedSearchTerm;
    }
    NSLog(@"%d", self.office.officeID);
}

- (void)viewWillAppear:(BOOL)animated
{
    [self.loadingView removeFromSuperview];
    if (self.addedPatient) {
        [NSTimer scheduledTimerWithTimeInterval:0.5 
                                         target:self 
                                       selector:@selector(timerDone) 
                                       userInfo:nil 
                                        repeats:NO];
    }
}

- (void)timerDone
{
    [self dismissModalViewControllerAnimated:YES];
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
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] 
                                   initWithTitle: @"Back" 
                                   style: UIBarButtonItemStyleBordered
                                   target: nil action: nil];
    [self.navigationItem setBackBarButtonItem: backButton];

    if ([segue.identifier isEqualToString: @"PatientDetailsFromSearch"]) {
        PatientDetailsViewController *patientDetailVC = segue.destinationViewController;
        patientDetailVC.patient = self.selectedPatient;
        patientDetailVC.addingPatient = YES;
        patientDetailVC.office = self.office;
        patientDetailVC.delegate = self;
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
    if (![[Utilities trimmedString:searchString] isEqualToString:@""]) {
        dispatch_async(kBgQueue, ^{
            [self handleSearchForTerm:searchString scope:
                [[self.searchDisplayController.searchBar scopeButtonTitles] objectAtIndex:
                 [self.searchDisplayController.searchBar selectedScopeButtonIndex]]];
            [self performSelectorOnMainThread:@selector(finishedSearchingPatients) withObject:nil waitUntilDone:YES];
        });
    }
    
    return NO;
}

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchScope:(NSInteger)searchOption
{
    NSString *searchString = self.searchDisplayController.searchBar.text;
    if (![[Utilities trimmedString:searchString] isEqualToString:@""]) {
        dispatch_async(kBgQueue, ^{
            [self handleSearchForTerm:searchString scope:[[self.searchDisplayController.searchBar scopeButtonTitles] objectAtIndex:searchOption]];
            [self performSelectorOnMainThread:@selector(finishedSearchingPatients) withObject:nil waitUntilDone:YES];
        });
    }
    
    return NO;
}

@end

















