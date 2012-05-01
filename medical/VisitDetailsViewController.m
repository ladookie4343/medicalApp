//
//  VisitDetailsViewController.m
//  medical
//
//  Created by Matt LaDuca on 4/30/12.
//  Copyright (c) 2012  PPA. All rights reserved.
//

#import "VisitDetailsViewController.h"
#import "Visit.h"
#import "Doctor.h"
#import "Patient.h"

@interface VisitDetailsViewController ()

- (void)enableFields;

@end

@implementation VisitDetailsViewController
@synthesize tableView = __tableView;
@synthesize diagnosisTextField = __diagnosisTextField;
@synthesize reasonTextView = __reasonTextView;
@synthesize pressureTextField = _pressureTextField;
@synthesize weightTextField = _weightTextField;
@synthesize heightTextField = _heightTextField;
@synthesize visit = __visit;
@synthesize delegate = __delegate;
@synthesize addingNewVisit = __addingNewVisit;
@synthesize doctor = __doctor;
@synthesize patient = __patient;

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateStyle = NSDateFormatterMediumStyle;
    self.navigationItem.title = [dateFormatter stringFromDate:self.visit.when];

    if (!self.addingNewVisit) {
        self.reasonTextView.text = self.visit.reason;
        self.diagnosisTextField.text = self.visit.diagnosis;
        self.weightTextField.text = self.visit.weight;
        self.pressureTextField.text = [NSString stringWithFormat:@"%@ / %@", 
                                       self.visit.bpSystolic, self.visit.bpDiastolic];
        [self.visit getPrescriptions];
    } else {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelPressed:)];
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(savePressed:)];
        [self enableFields];
    }
}

#define kAddVisitURLString @"http://www.ladookie4343.com/MedicalApp/addVisit.php"
#define kAddVisitURL [NSURL URLWithString:kAddVisitURLString]

/*
 $patientID = $mysqli->real_escape_string($_POST['patientID']);
 $officeID = $mysqli->real_escape_string($_POST['officeID']);
 $doctorID = $mysqli->real_escape_string($_POST['doctorID']);
 $date = $mysqli->real_escape_string($_POST['date']);
 $reason = $mysqli->real_escape_string($_POST['reason']);
 $diagnosis = $mysqli->real_escape_string($_POST['diagnosis']);
 $height = $mysqli->real_escape_string($_POST['height']);
 $weight = $mysqli->real_escape_string($_POST['weight']);
 $bp_systolic = $mysqli->real_escape_string($_POST['bp_systolic']);
 $bp_diastolic = $mysqli->real_escape_string($_POST['bp_diastolic']);
 */
- (void)viewWillDisappear:(BOOL)animated
{
    if (self.addingNewVisit) {
    NSArray *bpComponents = [self.pressureTextField.text componentsSeparatedByString:@" / "];
    self.visit.bpSystolic = [bpComponents objectAtIndex:0];
    self.visit.bpDiastolic = [bpComponents objectAtIndex:1];
    self.visit.weight = self.weightTextField.text;
    self.visit.reason = self.reasonTextView.text;
    self.visit.diagnosis = self.diagnosisTextField.text;
    
    NSString *queryString = [NSString stringWithFormat:@"patientID=%d&officeID=%d&doctorID=%d&date=%@&reason=%@&diagnosis=%@&height=%d&weight=%@&bp_systolic=%@&bp_diastolic=%@", 
    [Utilities dataFromPHPScript:kAddVisitURL post:YES request:<#(NSString *)#>

     }
}

- (void)enableFields
{
    self.pressureTextField.enabled = YES;
    self.weightTextField.enabled = YES;
    self.reasonTextView.editable = YES;
    self.diagnosisTextField.enabled = YES;
}

#define kBgQueue dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)

- (void)viewDidUnload
{
    [self setTableView:nil];
    [self setDiagnosisTextField:nil];
    [self setReasonTextView:nil];
    [self setPressureTextField:nil];
    [self setWeightTextField:nil];
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
    return self.visit.prescriptions.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"PrescriptionCell";
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    cell.textLabel.text = [self.visit.prescriptions objectAtIndex:indexPath.row];
    return cell;
}

- (void)savePressed:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)cancelPressed:(id)sender 
{
    [self.delegate cancelButtonPressed:self];
    [self.navigationController popViewControllerAnimated:YES];
}


@end
















     - (void)viewDidUnload {
         [self setHeightTextField:nil];
         [super viewDidUnload];
     }

