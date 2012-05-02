//
//  SurgeriesViewController.h
//  medical
//
//  Created by Matt LaDuca on 4/30/12.
//  Copyright (c) 2012  PPA. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SurgeryDetailsViewController.h"

@class Patient;
@class Doctor;

@interface SurgeriesViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, cancelSurgeryButtonDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *surgeries;

@property (strong, nonatomic) Patient *patient;
@property (strong, nonatomic) Doctor *doctor;

@end
