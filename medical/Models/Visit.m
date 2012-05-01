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

@synthesize visitID = __visitID;
@synthesize patientID = __patientID;
@synthesize doctorID = __doctorID;
@synthesize when = __when;
@synthesize reason = __reason;
@synthesize diagnosis = __diagnosis;
@synthesize height = __height;
@synthesize weight = __weight;
@synthesize bpSystolic = __bpSystolic;
@synthesize bpDiastolic = __bpDiastolic;
@synthesize prescriptions = __prescriptions;

#define kRetrieveVisitsURLString @"http://www.ladookie4343.com/MedicalApp/retrieveVisits.php"
#define kRetrieveVisitsURL [NSURL URLWithString:kRetrieveVisitsURLString]


- (id)init
{
	self.prescriptions = [NSMutableArray new];
    return self;
}

+ (NSMutableArray *)VisitsForPatient:(int)patientID office:(int)officeID
{
    NSString *queryString = [NSString stringWithFormat:@"patientID=%d&officeID=%d",
                             patientID, officeID];
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

#define kGetPrescriptionsURLString @"http://www.ladookie4343.com/MedicalApp/getPrescriptions.php"
#define kGetPrescriptionsURL [NSURL URLWithString:kGetPrescriptionsURLString]


- (void)getPrescriptions
{    
    NSString *queryString = [NSString stringWithFormat:@"visitID=%d", self.visitID];
    NSData *responseData = [Utilities dataFromPHPScript:kGetPrescriptionsURL post:YES request:queryString];
        
    NSError *error;
    NSArray *json = [NSJSONSerialization JSONObjectWithData:responseData options:kNilOptions error:&error];
    
    NSString *readabledata = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
    
    if (![@"[null]" isEqualToString:readabledata]) {
        for (int i = 0; i < json.count; i++) {
            NSDictionary *jsonPrescription = [json objectAtIndex:i];
            NSString *prescription = [jsonPrescription objectForKey:@"drug"];
            [self.prescriptions addObject:prescription];
        }
    }
}

@end


















