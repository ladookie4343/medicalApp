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
#import "Office.h"

@interface VisitDetailsViewController ()

- (void)enableFields;
- (void)registerForKeyboardNotifications;

@property (nonatomic, strong) UITextField *activeField;
@property (nonatomic, assign) BOOL cancelled;
@property (nonatomic, strong) NSMutableArray *textFields;
@property (nonatomic, assign) BOOL beginningEditMode;
@end

@implementation VisitDetailsViewController
@synthesize tableView = __tableView;
@synthesize diagnosisTextField = __diagnosisTextField;
@synthesize reasonTextView = __reasonTextView;
@synthesize pressureTextField = __pressureTextField;
@synthesize weightTextField = __weightTextField;
@synthesize heightTextField = __heightTextField;
@synthesize visitDetailsScrollView = __visitDetailsScrollView;
@synthesize visit = __visit;
@synthesize delegate = __delegate;
@synthesize addingNewVisit = __addingNewVisit;
@synthesize doctor = __doctor;
@synthesize patient = __patient;
@synthesize office = __office;
@synthesize activeField = __activeField;
@synthesize cancelled = __cancelled;
@synthesize textFields = __textFields;
@synthesize beginningEditMode = __beginningEditMode;

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self registerForKeyboardNotifications];
}

- (void)viewWillAppear:(BOOL)animated
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateStyle = NSDateFormatterMediumStyle;

    if (!self.addingNewVisit) {
        self.reasonTextView.text = self.visit.reason;
        self.diagnosisTextField.text = self.visit.diagnosis;
        self.weightTextField.text = self.visit.weight;
        self.heightTextField.text = self.visit.height;
        self.pressureTextField.text = [NSString stringWithFormat:@"%@ / %@", 
                                       self.visit.bpSystolic, self.visit.bpDiastolic];
        self.navigationItem.title = [dateFormatter stringFromDate:self.visit.when];
        [self.visit getPrescriptions];
    } else {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelPressed:)];
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(savePressed:)];
        self.navigationItem.rightBarButtonItem.tintColor = [UIColor redColor];
        self.navigationItem.leftBarButtonItem.tintColor = [UIColor colorWithRed:34/255.0 green:96/255.0 blue:221/255.0 alpha:1.0];
        self.navigationItem.title = @"Add Visit";
        [self enableFields];
        [self setEditing:YES animated:NO];
    }
}

#define kAddVisitURLString @"http://www.ladookie4343.com/MedicalApp/addVisit.php"
#define kAddVisitURL [NSURL URLWithString:kAddVisitURLString]

- (void)viewWillDisappear:(BOOL)animated
{
    if (self.addingNewVisit && !self.cancelled) {
        NSArray *bpComponents = [self.pressureTextField.text componentsSeparatedByString:@" / "];
        self.visit.bpSystolic = [bpComponents objectAtIndex:0];
        self.visit.bpDiastolic = [bpComponents objectAtIndex:1];
        self.visit.weight = self.weightTextField.text;
        self.visit.height = self.heightTextField.text;
        self.visit.reason = self.reasonTextView.text;
        self.visit.diagnosis = self.diagnosisTextField.text;
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.dateFormat = @"yyyy-MM-dd";
        NSDate *now = [NSDate date];
        
        
        NSString *queryString = [NSString stringWithFormat:@"patientID=%d&officeID=%d&doctorID=%d&date=%@&reason=%@&diagnosis=%@&height=%@&weight=%@&bp_systolic=%@&bp_diastolic=%@", self.patient.patientID, self.office.officeID, self.doctor.doctorID, [dateFormatter stringFromDate:now], self.reasonTextView.text, self.diagnosisTextField.text, self.heightTextField.text, self.weightTextField.text, [bpComponents objectAtIndex:0], [bpComponents objectAtIndex:1]];
        [Utilities dataFromPHPScript:kAddVisitURL post:YES request:queryString];
        [self.visit updatePrescriptions];
     }
}

- (void)enableFields
{
    self.pressureTextField.enabled = YES;
    self.weightTextField.enabled = YES;
    self.reasonTextView.editable = YES;
    self.diagnosisTextField.enabled = YES;
    self.heightTextField.enabled = YES;
}

#define kBgQueue dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)

- (void)viewDidUnload
{
    [self setTableView:nil];
    [self setDiagnosisTextField:nil];
    [self setReasonTextView:nil];
    [self setPressureTextField:nil];
    [self setWeightTextField:nil];
    [self setVisitDetailsScrollView:nil];
    [super viewDidUnload];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    } else {
        return YES;
    }
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
    NSInteger rows;
    
    rows = self.visit.prescriptions.count;
    if (self.addingNewVisit) {
        rows++;
    }
    return rows;
}

#define PLACEHOLDER @"placeholder"

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"PrescriptionCell";
    
    UITextField *textField;
    
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        
        if (indexPath.row == self.visit.prescriptions.count) {
            cell.textLabel.text = @"Add new prescription...";
        } else {
            if ([PLACEHOLDER isEqualToString:[self.visit.prescriptions objectAtIndex:indexPath.row]]) {
                textField = [Utilities textFieldWithPlaceholder:@"Enter a new prescription." delegate:self];
                [self.textFields addObject:textField];
            } else {
                cell.textLabel.text = [self.visit.prescriptions objectAtIndex:indexPath.row];
            }
        }
    } else {
        UITextField *textField = [cell.contentView.subviews objectAtIndex:0];
        if (self.beginningEditMode) {
            textField.text = nil;
        }
    }
        
    return cell;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle 
                                            forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleInsert) {
        [self.visit.prescriptions addObject:PLACEHOLDER];
        [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] 
                              withRowAnimation:UITableViewRowAnimationLeft];
    }
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView 
           editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == self.visit.prescriptions.count) {
        return UITableViewCellEditingStyleInsert;
    }
    return UITableViewCellEditingStyleNone;
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated
{
    [super setEditing:editing animated:animated];
    
    if (editing) {
        NSIndexPath *rowInsert = [NSIndexPath indexPathForRow:self.visit.prescriptions.count inSection:0];
        NSArray *paths = [NSArray arrayWithObject:rowInsert];
        [self.tableView insertRowsAtIndexPaths:paths withRowAnimation:UITableViewRowAnimationLeft];
    } else {
        
    }
}

#pragma mark - navBar button methods

- (void)savePressed:(id)sender
{
    [self dismissModalViewControllerAnimated:YES];
}

- (void)cancelPressed:(id)sender 
{
    self.cancelled = YES;
    [self.delegate cancelButtonPressed:self];
    [self dismissModalViewControllerAnimated:YES];
}

#pragma mark - TextField Methods

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (void)registerForKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardDidShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification object:nil];
    
}

- (void)keyboardWasShown:(NSNotification*)aNotification
{
    NSDictionary* info = [aNotification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, kbSize.height, 0.0);
    self.visitDetailsScrollView.contentInset = contentInsets;
    self.visitDetailsScrollView.scrollIndicatorInsets = contentInsets;
    
    // If active text field is hidden by keyboard, scroll it so it's visible
    CGRect aRect = self.view.frame;
    aRect.size.height -= kbSize.height;
    if (!CGRectContainsPoint(aRect, self.activeField.frame.origin) ) {
        CGPoint scrollPoint = CGPointMake(0.0, self.activeField.frame.origin.y - kbSize.height + 50);
        [self.visitDetailsScrollView setContentOffset:scrollPoint animated:YES];
    }
}

- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    self.visitDetailsScrollView.contentInset = contentInsets;
    self.visitDetailsScrollView.scrollIndicatorInsets = contentInsets;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    self.activeField = textField;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    self.activeField = nil;
}
@end






















