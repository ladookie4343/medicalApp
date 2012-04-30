//
//  PatientSearchViewController.h
//  medical
//
//  Created by Matt LaDuca on 4/28/12.
//  Copyright (c) 2012  PPA. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PatientDetailsViewController.h"

@class Office;

@interface PatientSearchViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, UISearchDisplayDelegate, AddPatientDelegate>

// search members
@property (strong, nonatomic) NSMutableArray *patientSearchResults;
@property (strong, nonatomic) NSString *savedSearchTerm;

@property (strong, nonatomic) IBOutlet UIView *loadingView;
@property (strong, nonatomic) Office *office;
@property (nonatomic, assign) BOOL addedPatient;

@end
