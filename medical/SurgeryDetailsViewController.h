//
//  SurgeryDetailsViewController.h
//  medical
//
//  Created by Matt LaDuca on 4/30/12.
//  Copyright (c) 2012  PPA. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Doctor;
@class Patient;
@class Surgery;

@protocol cancelSurgeryButtonDelegate <NSObject>

- (void)cancelButtonPressed:(id)sender;

@end

@interface SurgeryDetailsViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *surgeryTypeTextField;
@property (weak, nonatomic) IBOutlet UITextView *resultTextView;
@property (weak, nonatomic) IBOutlet UITextView *complicationsTextView;

@property (strong, nonatomic) Surgery *surgery;
@property (strong, nonatomic) Patient *patient;
@property (strong, nonatomic) Doctor *doctor;

@property (strong, nonatomic) id<cancelSurgeryButtonDelegate> delegate;
@property (assign, nonatomic) BOOL addingNewSurgery;
@end
