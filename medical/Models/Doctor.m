//
//  Doctor.m
//  medical
//
//  Created by Matt LaDuca on 5/1/12.
//  Copyright (c) 2012  PPA. All rights reserved.
//

#import "Doctor.h"

@implementation Doctor : NSObject
@synthesize doctorID = __doctorID;
@synthesize firstname = __firstname;
@synthesize lastname = __lastname;

#define kDoctorInfoURLString @"http://www.ladookie4343.com/MedicalApp/doctorInfo.php"
#define kDoctorInfoURL [NSURL URLWithString:kDoctorInfoURLString]

- (id)initFromUserName:(NSString *)username
{
    if (self = [super init]) {
        NSString *postRequest = [NSString stringWithFormat:@"username=%@", username];
        NSData *responseData = [Utilities dataFromPHPScript:kDoctorInfoURL post:YES request:postRequest];
        
        //NSString *readabledata = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
        //NSLog(@"%@", readabledata);
        
        NSError *error;
        NSDictionary *doctor = [NSJSONSerialization JSONObjectWithData:responseData options:kNilOptions error:&error];
        self.doctorID = [[doctor objectForKey:@"doctorID"] intValue];
        self.firstname = [doctor objectForKey:@"firstname"];
        self.lastname = [doctor objectForKey:@"lastname"];

    }
    return self;
}

@end
