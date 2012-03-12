//
//  Office.m
//  medical
//
//  Created by Matt LaDuca on 3/3/12.
//  Copyright (c) 2012  PPA. All rights reserved.
//

#import "Office.h"

@implementation Office

@synthesize officeID = _officeID;
@synthesize street = _street;
@synthesize city = _city;
@synthesize state = _state;
@synthesize zipcode = _zipcode;
@synthesize phone = _phone;
@synthesize email = _email;
@synthesize website = _website;
@synthesize officeImage = _officeImage;

#define kOfficeRetrievalURL [NSURL URLWithString: @"http://www.ladookie4343.com/MedicalApp/retrieveOffices.php"]


+ (NSArray *)OfficesForUsername:(NSString *)username
{
    
}

@end
