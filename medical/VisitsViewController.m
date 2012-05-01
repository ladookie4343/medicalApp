//
//  VisitsViewController.m
//  medical
//
//  Created by Matt LaDuca on 4/30/12.
//  Copyright (c) 2012  PPA. All rights reserved.
//

#import "VisitsViewController.h"
#import "VisitDetailsViewController.h"
#import "Doctor.h"
#import "Visit.h"

@interface VisitsViewController ()

@property (strong, nonatomic) Visit *selectedVisit;

@end

@implementation VisitsViewController
@synthesize tableView = __tableView;
@synthesize visits = __visits;
@synthesize selectedVisit = __selectedVisit;
@synthesize doctor = __doctor;
@synthesize patient = __patient;
@synthesize office = __office;


- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated
{
    [self.tableView reloadData];
}

#define kBgQueue dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)

- (void)viewDidUnload
{
    [self setTableView:nil];
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table View Methods


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.visits.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"CellIdentifier";
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    Visit *visit = [self.visits objectAtIndex:indexPath.row];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    
    cell.textLabel.text = [dateFormatter stringFromDate:visit.when];

    return cell;
}

#define kBgQueue dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView deselectRowAtIndexPath:indexPath animated:NO];
    self.selectedVisit = [self.visits objectAtIndex:indexPath.row];
    [self performSegueWithIdentifier:@"TransitionToVisitDetails" sender:self];
}



- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{        
    VisitDetailsViewController *visitDetailsVC = [[[segue destinationViewController] viewControllers] objectAtIndex:0];
    visitDetailsVC.doctor = self.doctor;
    visitDetailsVC.patient = self.patient;
    visitDetailsVC.office = self.office;

    if ([segue.identifier isEqualToString:@"TransitionToVisitDetails"]) {
        visitDetailsVC.visit = self.selectedVisit;
        visitDetailsVC.addingNewVisit = NO;
    } else if ([segue.identifier isEqualToString:@"AddNewVisit"]) {
        Visit *newVisit = [Visit new];
        newVisit.when = [NSDate date];
        [self.visits addObject:newVisit];
        visitDetailsVC.visit = newVisit;
        visitDetailsVC.addingNewVisit = YES;
        visitDetailsVC.delegate = self;
    }
}

- (void)cancelButtonPressed:(id)sender
{
    [self.visits removeLastObject];
}

#pragma mark - add patient



@end
























