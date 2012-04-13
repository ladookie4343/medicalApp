//
//  PatientsTableViewCell.h
//  medical
//
//  Created by Matt LaDuca on 4/12/12.
//  Copyright (c) 2012  PPA. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PatientsTableViewCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UILabel *firstNameLabel;
@property (nonatomic, weak) IBOutlet UILabel *lastNameLabel;

@end
