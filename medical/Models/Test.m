//
//  Test.m
//  medical
//
//  Created by Matt LaDuca on 3/29/12.
//  Copyright (c) 2012  PPA. All rights reserved.
//

#import "Test.h"
#import "Utilities.h"

@implementation Test

@synthesize doctor = _doctor;
@synthesize when = _when;
@synthesize testType = _testType;
@synthesize testResult = _testResult;

#define kRetrieveTestsURLString @"http://www.ladookie4343.com/MedicalApp/retrieveTests.php"
#define kRetrieveTestsURL [NSURL URLWithString:kRetrieveTestsURLString]


+ (NSMutableArray *)testsForPatient:(int)patientID
{
    NSString *queryString = [NSString stringWithFormat:@"patientID=%d", patientID];
    NSData *responseData = [Utilities dataFromPHPScript:kRetrieveTestsURL post:YES request:queryString];
    
    NSMutableArray *tests = [[NSMutableArray alloc] init];
    
    NSError *error;
    NSArray *json = [NSJSONSerialization JSONObjectWithData:responseData options:kNilOptions error:&error];
    
    NSString *readabledata = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"yyyy-MM-dd"];
    if (![@"[null]" isEqualToString:readabledata]) {
        for (int i = 0; i < json.count; i++) {
            NSDictionary *jsonTest = [json objectAtIndex:i];
            Test *test = [Test new];
            test.when = [df dateFromString:[jsonTest objectForKey:@"when"]];
            test.testType = [jsonTest objectForKey:@"test_type"];
            test.testResult = [jsonTest objectForKey:@"test_result"];
            [tests addObject:test];
        }
    }
    return tests; 
}

@end
