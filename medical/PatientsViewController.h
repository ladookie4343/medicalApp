//
//  PatientsViewController.h
//  medical
//
//  Created by Matt LaDuca on 3/31/12.
//  Copyright (c) 2012  PPA. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Office;
@class Doctor;

@interface PatientsViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, UISearchDisplayDelegate>

@property (strong, nonatomic) Office *office;
@property (strong, nonatomic) Doctor *doctor;

// search members
@property (strong, nonatomic) NSMutableArray *patientSearchResults;
@property (strong, nonatomic) NSString *savedSearchTerm;

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIView *loadingView;


@end
