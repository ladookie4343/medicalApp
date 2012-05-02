//
//  TestDetailsViewController.h
//  medical
//
//  Created by Matt LaDuca on 4/30/12.
//  Copyright (c) 2012  PPA. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Doctor;
@class Patient;
@class Test;

@protocol cancelTestButtonDelegate <NSObject>

- (void)cancelButtonPressed:(id)sender;

@end

@interface TestDetailsViewController : UIViewController <UITextFieldDelegate, UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UITextField *testTypeTextField;
@property (weak, nonatomic) IBOutlet UITextView *testResultTextView;

@property (strong, nonatomic) Test *test;
@property (strong, nonatomic) Patient *patient;
@property (strong, nonatomic) Doctor *doctor;

@property (strong, nonatomic) id<cancelTestButtonDelegate> delegate;
@property (assign, nonatomic) BOOL addingNewTest;

@end
