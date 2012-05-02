//
//  SurgeriesViewController.m
//  medical
//
//  Created by Matt LaDuca on 4/30/12.
//  Copyright (c) 2012  PPA. All rights reserved.
//

#import "SurgeriesViewController.h"
#import "SurgeryDetailsViewController.h"
#import "Surgery.h"

@interface SurgeriesViewController ()
@property (nonatomic, strong) Surgery *selectedSurgery;
@end

@implementation SurgeriesViewController
@synthesize tableView;
@synthesize surgeries = __surgeries;
@synthesize selectedSurgery = __selectedSurgery;

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated
{
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
    return self.surgeries.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"CellIdentifier";
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    Surgery *surgery = [self.surgeries objectAtIndex:indexPath.row];
    
    NSDateFormatter *dateformatter = [[NSDateFormatter alloc] init];
    dateformatter.dateStyle = NSDateFormatterMediumStyle;
    
    cell.textLabel.text = [dateformatter stringFromDate:surgery.when];
    return cell;
}

#define kBgQueue dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView deselectRowAtIndexPath:indexPath animated:NO];
    self.selectedSurgery = [self.surgeries objectAtIndex:indexPath.row];
    [self performSegueWithIdentifier:@"SurgeryDetailsTransition" sender:self];
}



//- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
//{
//    VisitDetailsViewController *visitDetailsVC;
//    
//    if ([segue.identifier isEqualToString:@"AddSurgeryTransition"]) {
//        visitDetailsVC = [[[segue destinationViewController] viewControllers] objectAtIndex:0];
//    } else if ([segue.identifier isEqualToString:@"SurgeryDetailsTransition"]) {
//        visitDetailsVC = segue.destinationViewController;
//    }
//    visitDetailsVC.doctor = self.doctor;
//    visitDetailsVC.patient = self.patient;
//    visitDetailsVC.office = self.office;
//    
//    if ([segue.identifier isEqualToString:@"SurgeryDetailsTransition"]) {
//        visitDetailsVC.visit = self.selectedVisit;
//        visitDetailsVC.addingNewVisit = NO;
//    } else if ([segue.identifier isEqualToString:@"AddSurgeryTransition"]) {
//        Visit *newVisit = [Visit new];
//        newVisit.when = [NSDate date];
//        [self.visits addObject:newVisit];
//        visitDetailsVC.visit = newVisit;
//        visitDetailsVC.addingNewVisit = YES;
//        visitDetailsVC.delegate = self;
//    }
//
//}

#pragma mark - editing methods

#define kDeletePatientURLString @"http://www.ladookie4343.com/MedicalApp/deletePatient.php"
#define kDeletePatientURL [NSURL URLWithString:kDeletePatientURLString]

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        
        [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        
    }
}

#pragma mark - Search Methods


@end
























