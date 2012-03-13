//
//  Office.m
//  medical
//
//  Created by Matt LaDuca on 3/3/12.
//  Copyright (c) 2012  PPA. All rights reserved.
//

#import "Office.h"
#import "Utilities.h"

@implementation Office

@synthesize officeID = _officeID;
@synthesize name = _name;
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
    NSString *postRequest = [NSString stringWithFormat:@"username=%@", username];
    NSData *responseData = [Utilities dataFromPHPScript:kOfficeRetrievalURL post:YES request:postRequest];
    
    NSMutableArray *offices = [[NSMutableArray alloc] init];
    
    NSError *error;
    NSArray *json = [NSJSONSerialization JSONObjectWithData:responseData options:kNilOptions error:&error];
    
    for (int i = 0; i < json.count; i++) {
        NSDictionary *jsonOffice = [json objectAtIndex:i];
        
        Office *office = [Office new];
        office.officeID = [[jsonOffice objectForKey:@"officeID"] intValue];
        office.name = [jsonOffice objectForKey:@"name"];
        office.street = [jsonOffice objectForKey:@"street"];
        office.city = [jsonOffice objectForKey:@"city"];
        office.state = [jsonOffice objectForKey:@"state"];
        office.zipcode = [jsonOffice objectForKey:@"zip"];
        office.phone = [jsonOffice objectForKey:@"phone"];
        office.email = [jsonOffice objectForKey:@"email"];
        office.website = [jsonOffice objectForKey:@"website"];
        office.officeImage = [jsonOffice objectForKey:@"image"];
        
        [offices addObject:office];
    }
    return offices;
}

@end
