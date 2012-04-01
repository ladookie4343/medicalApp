//
//  PatientsViewController.h
//  medical
//
//  Created by Matt LaDuca on 3/31/12.
//  Copyright (c) 2012  PPA. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PatientsViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *infoButton;

@end
