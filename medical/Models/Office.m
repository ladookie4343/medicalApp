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

- (id) initWithOfficeID:(int)oid street:(NSString *)street city:(NSString *)city
                  state:(NSString *)state zipcode:(NSString *)zipcode
{
    if (self = [self init]) {
        self.officeID = oid;
        self.street = street;
        self.city = city;
        self.state = state;
        self.zipcode = zipcode;
    }
    return self;
}

@end
