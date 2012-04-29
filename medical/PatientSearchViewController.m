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

@end

@implementation PatientSearchViewController
@synthesize selectedPatient = __selectedPatient;
@synthesize patients = __patients;
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


- (void)infoPressed
{
    [self performSegueWithIdentifier:@"officeDetailsSegue" sender:self];
}

- (void)addPatient
{
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

- (IBAction)doneButtonPressed:(UIBarButtonItem *)sender 
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
    PatientsTableViewCell *cell = (PatientsTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"PatientCell"];
    
    
    Patient *patient = [self.patientSearchResults objectAtIndex:indexPath.row];

    
    cell.firstNameLabel.text = patient.firstname;
    [cell.firstNameLabel sizeToFit];
    
    cell.lastNameLabel.frame = CGRectMake(20 + cell.firstNameLabel.frame.size.width + 6, 11, 120, 22);
    cell.lastNameLabel.text = patient.lastname;
    
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
    [self performSegueWithIdentifier:@"PatientDetailSegue" sender:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString: @"PatientDetailSegue"]) {
        PatientDetailsViewController *patientDetailVC = segue.destinationViewController;
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
@end

















