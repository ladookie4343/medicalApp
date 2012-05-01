//
//  Visit.m
//  medical
//
//  Created by Matt LaDuca on 3/29/12.
//  Copyright (c) 2012  PPA. All rights reserved.
//

#import "Visit.h"
#import "Utilities.h"

@implementation Visit

@synthesize visitID = _visitID;
@synthesize patientID = _patientID;
@synthesize doctorID = _doctorID;
@synthesize when = _when;
@synthesize reason = _reason;
@synthesize diagnosis = _diagnosis;
@synthesize height = _height;
@synthesize weight = _weight;
@synthesize bpSystolic = _bpSystolic;
@synthesize bpDiastolic = _bpDiastolic;

#define kRetrieveVisitsURLString @"http://www.ladookie4343.com/MedicalApp/retrieveVisits.php"
#define kRetrieveVisitsURL [NSURL URLWithString:kRetrieveVisitsURLString]

+ (NSMutableArray *)VisitsForPatient:(int)patientID office:(int)officeID doctor:(int)doctorID
{
    NSString *queryString = [NSString stringWithFormat:@"patientID=%d&officeID=%d&doctorID=%d",
                             patientID, officeID, doctorID];
    NSData *responseData = [Utilities dataFromPHPScript:kRetrieveVisitsURL post:YES request:queryString];
    
    NSMutableArray *visits = [[NSMutableArray alloc] init];
    
    NSError *error;
    NSArray *json = [NSJSONSerialization JSONObjectWithData:responseData options:kNilOptions error:&error];
    
    NSString *readabledata = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"yyyy-MM-dd"];
    if (![@"[null]" isEqualToString:readabledata]) {
        for (int i = 0; i < json.count; i++) {
            NSDictionary *jsonVisit = [json objectAtIndex:i];
            Visit *visit = [Visit new];
            visit.patientID = [[jsonVisit objectForKey:@"patientID"] intValue];
            visit.visitID = [[jsonVisit objectForKey:@"visitID"] intValue];
            visit.doctorID = [[jsonVisit objectForKey:@"doctorID"] intValue];
            visit.when = [df dateFromString:[jsonVisit objectForKey:@"when"]];
            visit.reason = [jsonVisit objectForKey:@"reason"];
            visit.diagnosis = [jsonVisit objectForKey:@"diagnosis"];
            visit.height = [jsonVisit objectForKey:@"height"];
            visit.weight = [jsonVisit objectForKey:@"weight"];
            visit.bpSystolic = [jsonVisit objectForKey:@"bp_systolic"];
            visit.bpDiastolic = [jsonVisit objectForKey:@"bp_diastolic"];
            [visits addObject:visit];
        }
    }
    return visits;    
}

@end
