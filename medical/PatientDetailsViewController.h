//
//  PatientDetailsViewController.h
//  medical
//
//  Created by Matt LaDuca on 4/25/12.
//  Copyright (c) 2012  PPA. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Patient;
@class Office;

@protocol AddPatientDelegate <NSObject>

@property (nonatomic, assign) BOOL addedPatient;

@end

@interface PatientDetailsViewController : UITableViewController <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIView *tableHeaderView;
@property (weak, nonatomic) IBOutlet UIButton *photoButton;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *ageLabel;
@property (weak, nonatomic) IBOutlet UILabel *bloodTypeLabel;
@property (weak, nonatomic) IBOutlet UIImageView *patientImage;

@property (assign, nonatomic) BOOL addingPatient;

@property (strong, nonatomic) Patient *patient;
@property (strong, nonatomic) Office *office;

@property (strong, nonatomic) id<AddPatientDelegate> delegate;

@end
