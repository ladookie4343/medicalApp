//
//  PatientsTableViewCell.m
//  medical
//
//  Created by Matt LaDuca on 4/12/12.
//  Copyright (c) 2012  PPA. All rights reserved.
//

#import "PatientsTableViewCell.h"

@implementation PatientsTableViewCell

@synthesize firstNameLabel;
@synthesize lastNameLabel;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    return [super initWithStyle:style reuseIdentifier:reuseIdentifier];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

@end
