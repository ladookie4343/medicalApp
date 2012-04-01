//
//  OfficeTableViewCell.h
//  medical
//
//  Created by Matt LaDuca on 3/12/12.
//  Copyright (c) 2012  PPA. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OfficeTableViewCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UILabel *officeNameLabel;
@property (nonatomic, weak) IBOutlet UILabel *officeLocationLabel;
@property (nonatomic, strong) IBOutlet UIImageView *officeImageView;

@end

/*
 @property (nonatomic, weak) IBOutlet UILabel *officeNameLabel;
 @property (nonatomic, weak) IBOutlet UILabel *officeLocationLabel;
 @property (nonatomic, strong) IBOutlet UIImageView *officeImageView;
*/