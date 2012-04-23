//
//  PatientsViewController.h
//  medical
//
//  Created by Matt LaDuca on 3/31/12.
//  Copyright (c) 2012  PPA. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Office;

@interface PatientsViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, UISearchDisplayDelegate>

// data source members
@property (strong, nonatomic) NSArray *patients;
@property (strong, nonatomic) Office *office;

// search members
@property (strong, nonatomic) NSMutableArray *patientSearchResults;
@property (strong, nonatomic) NSString *savedSearchTerm;

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIView *loadingView;

@end
