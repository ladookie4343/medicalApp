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

// deletes all rows in allergy table for this patient 
// and adds the rows currently in allergies array
- (void)updateAllergies
{
    [Utilities dataFromPHPScript:[NSURL URLWithString:@"http://www.ladookie4343.com/MedicalApp/deleteAllergies.php"] post:YES request:[NSString stringWithFormat:@"patientID=%d", self.patientID]];
    
    // for each element in allergies call addallergy.php
    for (int i = 0; i < self.allergies.count; i++) {
        [Utilities dataFromPHPScript:[NSURL URLWithString:@"http://www.ladookie4343.com/MedicalApp/addAllergy.php"] post:YES request:[NSString stringWithFormat:@"patientID=%d&allergy=%@", self.patientID, (NSString *)[self.allergies objectAtIndex:i]]];
    }
}

// deletes all rows in medicalConditions table for this patient 
// and adds the rows currently in allergies array
- (void)updateMedicalConditions
{
    [Utilities dataFromPHPScript:[NSURL URLWithString:@"http://www.ladookie4343.com/MedicalApp/deleteMedicalConditions.php"] post:YES request:[NSString stringWithFormat:@"patientID=%d", self.patientID]];
    
    // for each element in allergies call addallergy.php
    for (int i = 0; i < self.allergies.count; i++) {
        [Utilities dataFromPHPScript:[NSURL URLWithString:@"http://www.ladookie4343.com/MedicalApp/addMedicalCondition.php"] post:YES request:[NSString stringWithFormat:@"patientID=%d&medicalCondition=%@", self.patientID, (NSString *)[self.medicalConditions objectAtIndex:i]]];
    }
}

#define kPatientDetailsURL [NSURL URLWithString: @"http://www.ladookie4343.com/MedicalApp/patientDetails.php"]

// gets additional information from patient for patientDetailsViewController:
// dob, height, bloodtype, allergies, medicalConditions,
+ (Patient *)PatientForPatientDetailsVC:(Patient *)patient
{
    NSString *postRequest = [NSString stringWithFormat:@"patientID=%d", patient.patientID];
    NSData *responseData = [Utilities dataFromPHPScript:kPatientDetailsURL post:YES request:postRequest];
    
    NSError *error;
    NSArray *json = [NSJSONSerialization JSONObjectWithData:responseData options:kNilOptions error:&error];
    
    for (int i = 0; i < 3; i++) {
        switch (i) {
            case 0: {
                NSDateFormatter *df = [[NSDateFormatter alloc] init];
                [df setDateFormat:@"yyyy-MM-dd"];
                NSDictionary *patientDetails = [json objectAtIndex:i];
                patient.dob = [df dateFromString:(NSString *)[patientDetails objectForKey:@"dob"]];
                break;
            }
            case 1: {
                NSArray *jsonArray = [json objectAtIndex:i];
                NSMutableArray *allergies = [NSMutableArray new];
                for (int i = 0; i < jsonArray.count; i++) {
                    [allergies addObject:(NSString *)[jsonArray objectAtIndex:i]];
                }
                patient.allergies = allergies;
                break;
            }
            case 2: {
                NSArray *jsonArray = [json objectAtIndex:i];
                NSMutableArray *conditions = [NSMutableArray new];
                for (int i = 0; i < jsonArray.count; i++) {
                    [conditions addObject:(NSString *)[jsonArray objectAtIndex:i]];
                }
                patient.medicalConditions = conditions;
                break;
            }
            default:
                break;
        }
    }
    return patient;
}

@end

















