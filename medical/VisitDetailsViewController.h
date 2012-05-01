//
//  VisitDetailsViewController.h
//  medical
//
//  Created by Matt LaDuca on 4/30/12.
//  Copyright (c) 2012  PPA. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Visit;
@class Doctor;
@class Patient;
@class Office;

@protocol cancelButtonDelegate <NSObject>

- (void)cancelButtonPressed:(id)sender;

@end

@interface VisitDetailsViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UITextField *diagnosisTextField;
@property (weak, nonatomic) IBOutlet UITextView *reasonTextView;
@property (weak, nonatomic) IBOutlet UITextField *pressureTextField;
@property (weak, nonatomic) IBOutlet UITextField *weightTextField;
@property (weak, nonatomic) IBOutlet UITextField *heightTextField;
@property (weak, nonatomic) IBOutlet UIScrollView *visitDetailsScrollView;

@property (strong, nonatomic) Visit *visit;
@property (strong, nonatomic) Doctor *doctor;
@property (strong, nonatomic) Patient *patient;
@property (strong, nonatomic) Office *office;

@property (strong, nonatomic) id<cancelButtonDelegate> delegate;
@property (assign, nonatomic) BOOL addingNewVisit;

@end
