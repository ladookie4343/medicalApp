//
//  TestsViewController.h
//  medical
//
//  Created by Matt LaDuca on 4/30/12.
//  Copyright (c) 2012  PPA. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TestDetailsViewController.h"

@class Patient;
@class Doctor;

@interface TestsViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, 
    cancelTestButtonDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *tests;

@property (strong, nonatomic) Patient *patient;
@property (strong, nonatomic) Doctor *doctor;

@end
