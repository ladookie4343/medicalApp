//
//  TestDetailsViewController.m
//  medical
//
//  Created by Matt LaDuca on 4/30/12.
//  Copyright (c) 2012  PPA. All rights reserved.
//

#import "TestDetailsViewController.h"
#import "Test.h"
#import "Patient.h"
#import "Doctor.h"

@interface TestDetailsViewController ()

@property (nonatomic, assign) BOOL cancelled;

@end

@implementation TestDetailsViewController
@synthesize testTypeTextField = __testTypeTextField;
@synthesize testResultTextView = __testResultTextView;
@synthesize cancelled = __cancelled;
@synthesize delegate = __delegate;
@synthesize doctor = __doctor;
@synthesize patient = __patient;
@synthesize test = __test;
@synthesize addingNewTest = __addingNewTest;

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateStyle = NSDateFormatterMediumStyle;
    
    if (!self.addingNewTest) {
        self.testTypeTextField.text = self.test.testType;
        self.testResultTextView.text = self.test.testResult;
        self.navigationItem.title = [dateFormatter stringFromDate:self.test.when];
    } else {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelPressed:)];
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(savePressed:)];
        self.navigationItem.rightBarButtonItem.tintColor = [UIColor redColor];
        self.navigationItem.leftBarButtonItem.tintColor = [UIColor colorWithRed:34/255.0 green:96/255.0 blue:221/255.0 alpha:1.0];
        self.navigationItem.title = @"Add Test";
        self.testTypeTextField.enabled = YES;
        self.testResultTextView.editable = YES;
    }
}

#define kAddSurgeryURLString @"http://www.ladookie4343.com/MedicalApp/addSurgery.php"
#define kAddSurgeryURL [NSURL URLWithString:kAddSurgeryURLString]

- (void)viewWillDisappear:(BOOL)animated
{
    if (self.addingNewTest && !self.cancelled) {
        self.test.testType = self.testTypeTextField.text;
        self.test.testResult = self.testResultTextView.text;
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.dateFormat = @"yyyy-MM-dd";
        
        NSString *queryString = [NSString stringWithFormat:@"patientID=%d&doctorID=%d&date=%@&type=%@&result=%@", self.patient.patientID, self.doctor.doctorID, [dateFormatter stringFromDate:self.test.when], self.testTypeTextField.text, self.testResultTextView.text];
        [Utilities dataFromPHPScript:kAddSurgeryURL post:YES request:queryString];
    }
}

- (void)viewDidUnload
{
    [self setTestResultTextView:nil];
    [self setTestTypeTextField:nil];
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

//- (void)textViewDidBeginEditing:(UITextView *)textView
//{
//    if (textView == self.complicationsTextView) {
//        self.bottomTextViewActive = YES;
//    }
//}

//- (void)registerForKeyboardNotifications
//{
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(keyboardWasShown:)
//                                                 name:UIKeyboardDidShowNotification object:nil];
//    
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(keyboardWillBeHidden:)
//                                                 name:UIKeyboardWillHideNotification object:nil];
//    
//}
//
//- (void)keyboardWasShown:(NSNotification*)aNotification
//{
//    NSDictionary* info = [aNotification userInfo];
//    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
//    
//    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, kbSize.height, 0.0);
//    self.scrollView.contentInset = contentInsets;
//    self.scrollView.scrollIndicatorInsets = contentInsets;
//    
//    // If active text field is hidden by keyboard, scroll it so it's visible
//    CGRect aRect = self.view.frame;
//    aRect.size.height -= kbSize.height;
//    if (self.bottomTextViewActive) {
//        CGPoint scrollPoint;
//        scrollPoint = CGPointMake(0.0, 175);
//        [self.scrollView setContentOffset:scrollPoint animated:YES];
//        self.bottomTextViewActive = NO;
//    }
//}
//
//- (void)keyboardWillBeHidden:(NSNotification*)aNotification
//{
//    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
//    self.scrollView.contentInset = contentInsets;
//    self.scrollView.scrollIndicatorInsets = contentInsets;
//}

@end
