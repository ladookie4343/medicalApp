//
//  PatientDetailsViewController.h
//  medical
//
//  Created by Matt LaDuca on 4/17/12.
//  Copyright (c) 2012  PPA. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Patient;

@interface PatientDetailsViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *tableHeaderView;
@property (weak, nonatomic) IBOutlet UIButton *photoButton;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *ageLabel;
@property (weak, nonatomic) IBOutlet UILabel *bloodTypeLabel;
@property (strong, nonatomic) Patient *patient;
@property (assign, nonatomic) int latestWeight;
@property (assign, nonatomic) int bpSystolic;
@property (assign, nonatomic) int bpDiastolic;

@end
