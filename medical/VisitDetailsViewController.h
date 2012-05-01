//
//  VisitDetailsViewController.h
//  medical
//
//  Created by Matt LaDuca on 4/30/12.
//  Copyright (c) 2012  PPA. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VisitDetailsViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UITextField *diagnosisTextField;
@property (weak, nonatomic) IBOutlet UITextView *reasonTextView;

@end
