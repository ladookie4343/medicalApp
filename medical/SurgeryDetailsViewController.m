//
//  SurgeryDetailsViewController.m
//  medical
//
//  Created by Matt LaDuca on 4/30/12.
//  Copyright (c) 2012  PPA. All rights reserved.
//

#import "SurgeryDetailsViewController.h"
#import "Surgery.h"
#import "Patient.h"
#import "Doctor.h"

@interface SurgeryDetailsViewController ()
@property (nonatomic, assign) BOOL cancelled;
@end

@implementation SurgeryDetailsViewController
@synthesize surgeryTypeTextField = __surgeryTypeTextField;
@synthesize resultTextView = __resultTextView ;
@synthesize complicationsTextView = __complicationsTextView;
@synthesize delegate = __delegate;
@synthesize surgery = __surgery;
@synthesize patient = __patient;
@synthesize cancelled = __cancelled;
@synthesize addingNewSurgery = __addingNewSurgery;
@synthesize doctor = __doctor;

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateStyle = NSDateFormatterMediumStyle;
    
    if (!self.addingNewSurgery) {
        self.surgeryTypeTextField.text = self.surgery.type;
        self.resultTextView.text = self.surgery.result;
        self.navigationItem.title = [dateFormatter stringFromDate:self.surgery.when];
    } else {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelPressed:)];
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(savePressed:)];
        self.navigationItem.rightBarButtonItem.tintColor = [UIColor redColor];
        self.navigationItem.leftBarButtonItem.tintColor = [UIColor colorWithRed:34/255.0 green:96/255.0 blue:221/255.0 alpha:1.0];
        self.navigationItem.title = @"Add Surgery";
        self.surgeryTypeTextField.enabled = YES;
        self.resultTextView.editable = YES;
        self.complicationsTextView.editable = YES;
    }
}

#define kAddSurgeryURLString @"http://www.ladookie4343.com/MedicalApp/addSurgery.php"
#define kAddSurgeryURL [NSURL URLWithString:kAddSurgeryURLString]

- (void)viewWillDisappear:(BOOL)animated
{
    if (self.addingNewSurgery && !self.cancelled) {
        self.surgery.type = self.surgeryTypeTextField.text;
        self.surgery.result = self.resultTextView.text;
        self.surgery.complications = self.complicationsTextView.text;
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.dateFormat = @"yyyy-MM-dd";
        NSDate *now = [NSDate date];
        self.surgery.when = now;
        
        NSString *queryString = [NSString stringWithFormat:@"patientID=%d&doctorID=%d&date=%@&type=%@&result=%@&complications=%@", self.patient.patientID, self.doctor.doctorID, [dateFormatter stringFromDate:now], self.surgeryTypeTextField.text, self.resultTextView.text, self.complicationsTextView.text];
        [Utilities dataFromPHPScript:kAddSurgeryURL post:YES request:queryString];
    }
}

- (void)viewDidUnload
{
    [self setSurgeryTypeTextField:nil];
    [self setResultTextView:nil];
    [self setComplicationsTextView:nil];
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

@end
