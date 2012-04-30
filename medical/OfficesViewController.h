//
//  OfficeTableViewController.h
//  medical
//
//  Created by Matt LaDuca on 3/10/12.
//  Copyright (c) 2012  PPA. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OfficesViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) NSArray *offices;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIView *loadingView;
//@property (weak, nonatomic) IBOutlet UIImageView *officeImage;

@end
