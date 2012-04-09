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
    
    [self testPatientsByLastName];
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


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return nil;
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

















































