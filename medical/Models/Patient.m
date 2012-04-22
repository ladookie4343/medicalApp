//
//  Patient.m
//  medical
//
//  Created by Matt LaDuca on 3/29/12.
//  Copyright (c) 2012  PPA. All rights reserved.
//

#import "Patient.h"
#import "Utilities.h"

@implementation Patient

@synthesize patientID = _patientID;
@synthesize firstname = _firstname;
@synthesize lastname = _lastname;
@synthesize height = _height;
@synthesize dob = _dob;
@synthesize visits = _visits;
@synthesize tests = _tests;
@synthesize surgeries = _surgeries;
@synthesize allergies = _allergies;
@synthesize medicalConditions = _medicalConditions;
@synthesize patientImage = _patientImage;

#define kPatientsRetrievalURL [NSURL URLWithString: @"http://www.ladookie4343.com/MedicalApp/retrievePatients.php"]

+ (NSArray *)patientsForPatientsTable:(int)officeID
{
    NSString *postRequest = [NSString stringWithFormat:@"officeID=%d", officeID];
    NSData *responseData = [Utilities dataFromPHPScript:kPatientsRetrievalURL post:YES request:postRequest];
    
    //NSString *readabledata = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
    //NSLog(@"%@", readabledata);
    
    NSMutableArray *patients = [[NSMutableArray alloc] init];
    
    NSError *error;
    NSArray *json = [NSJSONSerialization JSONObjectWithData:responseData options:kNilOptions error:&error];
    
    for (int i = 0; i < json.count; i++) {
        NSDictionary *jsonPatient = [json objectAtIndex:i];
        Patient *patient = [Patient new];
        patient.patientID = [[jsonPatient objectForKey:@"patientID"] intValue];
        patient.firstname = [jsonPatient objectForKey:@"firstname"];
        patient.lastname = [jsonPatient objectForKey:@"lastname"];
        patient.patientImage = [jsonPatient objectForKey:@"image"];
        [patients addObject:patient];
    }
    return patients;
}

+ (void)updateAllergies
{
    
}

// deletes all rows in medicalConditions table for this patient 
// and adds the rows currently in allergies array
+ (void)updateMedicalConditions
{
    
}

@end
