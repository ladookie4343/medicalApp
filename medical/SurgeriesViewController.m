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
#import "Patient.h"
#import "Doctor.h"

@interface SurgeriesViewController ()
@property (nonatomic, strong) Surgery *selectedSurgery;
@end

@implementation SurgeriesViewController
@synthesize tableView;
@synthesize surgeries = __surgeries;
@synthesize selectedSurgery = __selectedSurgery;
@synthesize doctor = __doctor;
@synthesize patient = __patient;

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



- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    SurgeryDetailsViewController *surgeryDetailsVC;
    
    if ([segue.identifier isEqualToString:@"AddSurgeryTransition"]) {
        surgeryDetailsVC = [[[segue destinationViewController] viewControllers] objectAtIndex:0];
    } else if ([segue.identifier isEqualToString:@"SurgeryDetailsTransition"]) {
        surgeryDetailsVC = segue.destinationViewController;
    }
    surgeryDetailsVC.doctor = self.doctor;
    surgeryDetailsVC.patient = self.patient;
    
    if ([segue.identifier isEqualToString:@"SurgeryDetailsTransition"]) {
        surgeryDetailsVC.surgery = self.selectedSurgery;
        surgeryDetailsVC.addingNewSurgery = NO;
    } else if ([segue.identifier isEqualToString:@"AddSurgeryTransition"]) {
        Surgery *newSurgery = [Surgery new];
        newSurgery.when = [NSDate date];
        [self.surgeries addObject:newSurgery];
        surgeryDetailsVC.surgery = newSurgery;
        surgeryDetailsVC.addingNewSurgery = YES;
        surgeryDetailsVC.delegate = self;
    }

}

- (void)cancelButtonPressed:(id)sender
{
    [self.surgeries removeLastObject];
}



@end
























