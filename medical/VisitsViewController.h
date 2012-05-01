//
//  VisitsViewController.h
//  medical
//
//  Created by Matt LaDuca on 4/30/12.
//  Copyright (c) 2012  PPA. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VisitDetailsViewController.h"

@class Doctor;
@class Patient;
@class Office;

@interface VisitsViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, cancelButtonDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *visits;
@property (strong, nonatomic) Doctor *doctor;
@property (strong, nonatomic) Office *office;
@property (strong, nonatomic) Patient *patient;

@end
