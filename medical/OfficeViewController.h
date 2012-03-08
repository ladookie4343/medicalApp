//
//  OfficeViewController.h
//  medical
//
//  Created by Matt LaDuca on 3/1/12.
//  Copyright (c) 2012  PPA. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Office.h"

@interface OfficeViewController : UITableViewController <UITableViewDelegate>

@property (nonatomic, strong) Office *office;

@property (weak, nonatomic) IBOutlet UILabel *phoneNumber;
@property (weak, nonatomic) IBOutlet UILabel *email;
@property (weak, nonatomic) IBOutlet UILabel *website;
@property (weak, nonatomic) IBOutlet UILabel *location;

@end
