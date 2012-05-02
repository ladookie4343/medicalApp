//
//  TestsViewController.m
//  medical
//
//  Created by Matt LaDuca on 4/30/12.
//  Copyright (c) 2012  PPA. All rights reserved.
//

#import "TestsViewController.h"
#import "Test.h"
#import "Patient.h"
#import "Doctor.h"

@interface TestsViewController ()
@property (nonatomic, strong) Test *selectedTest;
@end

@implementation TestsViewController

@synthesize tableView = __tableView;
@synthesize doctor = __doctor;
@synthesize patient = __patient;
@synthesize selectedTest = __selectedTest;
@synthesize tests = __tests;

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
    return self.tests.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"CellIdentifier";
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    Test *test = [self.tests objectAtIndex:indexPath.row];
    
    NSDateFormatter *dateformatter = [[NSDateFormatter alloc] init];
    dateformatter.dateStyle = NSDateFormatterMediumStyle;
    
    cell.textLabel.text = [dateformatter stringFromDate:test.when];
    return cell;
}

#define kBgQueue dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView deselectRowAtIndexPath:indexPath animated:NO];
    self.selectedTest = [self.tests objectAtIndex:indexPath.row];
    [self performSegueWithIdentifier:@"TestDetailsTransition" sender:self];
}



- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    TestDetailsViewController *testDetailsVC;
    
    if ([segue.identifier isEqualToString:@"AddTestTransition"]) {
        testDetailsVC = [[[segue destinationViewController] viewControllers] objectAtIndex:0];
    } else if ([segue.identifier isEqualToString:@"TestDetailsTransition"]) {
        testDetailsVC = segue.destinationViewController;
    }
    testDetailsVC.doctor = self.doctor;
    testDetailsVC.patient = self.patient;
    
    if ([segue.identifier isEqualToString:@"TestDetailsTransition"]) {
        testDetailsVC.test = self.selectedTest;
        testDetailsVC.addingNewTest = NO;
    } else if ([segue.identifier isEqualToString:@"AddTestTransition"]) {
        Test *newTest = [Test new];
        newTest.when = [NSDate date];
        [self.tests addObject:newTest];
        testDetailsVC.test = newTest;
        testDetailsVC.addingNewTest = YES;
        testDetailsVC.delegate = self;
    }
    
}

- (void)cancelButtonPressed:(id)sender
{
    [self.tests removeLastObject];
}


@end





















