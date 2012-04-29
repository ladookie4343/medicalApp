//
//  PatientSearchViewController.h
//  medical
//
//  Created by Matt LaDuca on 4/28/12.
//  Copyright (c) 2012  PPA. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PatientSearchViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, UISearchDisplayDelegate>

// data source members
@property (strong, nonatomic) NSArray *patients;

// search members
@property (strong, nonatomic) NSMutableArray *patientSearchResults;
@property (strong, nonatomic) NSString *savedSearchTerm;

@property (strong, nonatomic) IBOutlet UIView *loadingView;

@end
