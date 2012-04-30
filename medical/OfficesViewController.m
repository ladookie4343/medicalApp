//
//  OfficeTableViewController.m
//  medical
//
//  Created by Matt LaDuca on 3/10/12.
//  Copyright (c) 2012  PPA. All rights reserved.
//

#import "OfficesViewController.h"
#import "OfficeTableViewCell.h"
#import "QuartzCore/QuartzCore.h"
#import "Office.h"
#import "PatientsViewController.h"
#import "Patient.h"
#import "Utilities.h"

@interface OfficesViewController()
@property (nonatomic, strong) Office *selectedOffice;
@property (nonatomic, strong) NSArray *patientsForOffice;

- (UIImage *)getImageForOffice:(Office *)office;
- (void)finishedLoadingPatients;
@end

@implementation OfficesViewController

@synthesize offices = __offices;
@synthesize tableView = __tableView;
@synthesize loadingView = __loadingView;
//@synthesize officeImage = __officeImage;
@synthesize selectedOffice = __selectedOffice;
@synthesize patientsForOffice = __patientsForOffice;


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.hidesBackButton = YES;
}

- (void)viewDidUnload
{
    [self setTableView:nil];
    [self setLoadingView:nil];
    [super viewDidUnload];
}

- (void)viewWillAppear:(BOOL)animated
{
    self.navigationController.toolbarHidden = YES;
    [self.loadingView removeFromSuperview];
    
//    self.officeImage.layer.cornerRadius = 10.0;
//    self.officeImage.layer.borderColor = [UIColor blackColor].CGColor;
//    self.officeImage.layer.borderWidth = 0.75;
//    self.officeImage.clipsToBounds = YES;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.offices.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    OfficeTableViewCell *cell = (OfficeTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"OfficeCell"];
    
    Office *office = [self.offices objectAtIndex:indexPath.row];
    
    cell.officeImageView.image = [self getImageForOffice:office];
    [Utilities RoundedBorderForImageView:cell.officeImageView];

    cell.officeNameLabel.text = office.name;
    cell.officeLocationLabel.text = office.street;
    
    if (self.offices.count == 1) {
        cell.selectedBackgroundView = [[UIImageView alloc] initWithImage:
                                       [UIImage imageNamed:@"oneRowOnlySelected.png"]];
    } else if (self.offices.count > 1) {
        if (indexPath.row == 0) {
            cell.selectedBackgroundView = [[UIImageView alloc] initWithImage:
                                           [UIImage imageNamed:@"topRowSelected.png"]];
        } else if (indexPath.row == self.offices.count - 1) {
            cell.selectedBackgroundView = [[UIImageView alloc] initWithImage:
                                           [UIImage imageNamed:@"bottomRowSelected.png"]];
        } else {
            cell.selectedBackgroundView = [[UIImageView alloc] initWithImage:
                                           [UIImage imageNamed:@"middleRowSelected.png"]];
        }
    }
    return cell;
}

- (IBAction)logoutPressed:(id)sender 
{
    [self.navigationController popToRootViewControllerAnimated:NO];
}

#define kOfficeImageAddress @"http://www.ladookie4343.com/MedicalApp/officeImages/"

- (UIImage *)getImageForOffice:(Office *)office
{
    NSString *imageName = office.officeImage;
    NSString *imageURLstring = [kOfficeImageAddress stringByAppendingString:imageName];
    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:imageURLstring]];
    return [UIImage imageWithData:data];
}
                                                                 
#pragma mark - Table view delegate

#define kBgQueue dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    self.selectedOffice = [self.offices objectAtIndex:indexPath.row];
    [Utilities showLoadingView:self.loadingView InView:self.view];
    
    dispatch_async(kBgQueue, ^ {
        self.patientsForOffice = [Patient patientsForPatientsTable:self.selectedOffice.officeID];
        [self performSelectorOnMainThread:@selector(finishedLoadingPatients) 
                               withObject:nil 
                            waitUntilDone:YES];   
    });
}
         
- (void)finishedLoadingPatients
{
    [self performSegueWithIdentifier:@"SegueToPatientsView" sender:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    ((PatientsViewController *)segue.destinationViewController).office = self.selectedOffice;
    ((PatientsViewController *)segue.destinationViewController).patients = self.patientsForOffice;   
    [self.loadingView removeFromSuperview];
}

@end









































