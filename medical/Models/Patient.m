//
//  Patient.m
//  medical
//
//  Created by Matt LaDuca on 3/29/12.
//  Copyright (c) 2012  PPA. All rights reserved.
//

#import "Patient.h"
#import "Utilities.h"

@interface Patient ()
+ (NSMutableArray *)patientsSearchResultWithQueryString:(NSString *)queryString URL:(NSURL *)url;
@end

@implementation Patient

@synthesize patientID = __patientID;
@synthesize firstname = __firstname;
@synthesize lastname = __lastname;
@synthesize height = __height;
@synthesize dob = __dob;
@synthesize visits = __visits;
@synthesize tests = __tests;
@synthesize surgeries = __surgeries;
@synthesize bloodType = __bloodType;
@synthesize allergies = __allergies;
@synthesize medicalConditions = __medicalConditions;
@synthesize patientImage = __patientImage;
@synthesize latestWeight = __latestWeight;
@synthesize latestBPSys = __latestBPSys;
@synthesize latestBPDia = __latestBPDia;
@synthesize latestHeight = __latestHeight;
#define kPatientsRetrievalURL [NSURL URLWithString: @"http://www.ladookie4343.com/MedicalApp/retrievePatients.php"]

+ (NSMutableArray *)testPatients
{
    NSMutableArray *patients = [NSMutableArray new];
    
    Patient *p;
    p = [[Patient alloc] init];
    p.patientID = 4;
    p.firstname = @"Matt";
    p.lastname = @"LaDuca";
    [patients addObject:p];
    
    p = [[Patient alloc] init];
    p.patientID = 5;
    p.firstname = @"Tao";
    p.lastname = @"La";
    [patients addObject:p];
    
    return patients;
}

+ (NSMutableArray *)patientsForPatientsTable:(int)officeID
{
    NSString *queryString = [NSString stringWithFormat:@"officeID=%d", officeID];
    return [self patientsSearchResultWithQueryString:queryString URL:kPatientsRetrievalURL];
}

// deletes all rows in allergy table for this patient 
// and adds the rows currently in allergies array

#define kDeletaAllergiesURL [NSURL URLWithString:@"http://www.ladookie4343.com/MedicalApp/deleteAllergies.php"]
#define kAddAllergyURL [NSURL URLWithString:@"http://www.ladookie4343.com/MedicalApp/addAllergy.php"]
- (void)updateAllergies
{
    [Utilities dataFromPHPScript:kDeletaAllergiesURL 
                            post:YES 
                         request:[NSString stringWithFormat:@"patientID=%d", self.patientID]];
    
    // for each element in allergies call addallergy.php
    for (int i = 0; i < self.allergies.count; i++) {
        [Utilities dataFromPHPScript:kAddAllergyURL 
                                post:YES 
                             request:[NSString stringWithFormat:@"patientID=%d&allergy=%@", self.patientID, (NSString *)[self.allergies objectAtIndex:i]]];
    }
}

// deletes all rows in medicalConditions table for this patient 
// and adds the rows currently in allergies array
#define kDeletaMedicalConditionsURL [NSURL URLWithString:@"http://www.ladookie4343.com/MedicalApp/deleteMedicalConditions.php"]
#define kAddMedicalConditionURL [NSURL URLWithString:@"http://www.ladookie4343.com/MedicalApp/addMedicalCondition.php"]
- (void)updateMedicalConditions
{
    [Utilities dataFromPHPScript:kDeletaMedicalConditionsURL 
                            post:YES 
                         request:[NSString stringWithFormat:@"patientID=%d", self.patientID]];
    
    // for each element in allergies call addallergy.php
    for (int i = 0; i < self.medicalConditions.count; i++) {
        [Utilities dataFromPHPScript:kAddMedicalConditionURL 
                                post:YES 
                             request:[NSString stringWithFormat:@"patientID=%d&medicalCondition=%@", self.patientID, (NSString *)[self.medicalConditions objectAtIndex:i]]];
    }
}

#define kPatientDetailsURL [NSURL URLWithString: @"http://www.ladookie4343.com/MedicalApp/patientDetails.php"]

// gets additional information from patient for patientDetailsViewController:
// dob, height, bloodtype, allergies, medicalConditions,
- (void)GetDetailsForPatientDetailsVC
{
    NSString *postRequest = [NSString stringWithFormat:@"patientID=%d", self.patientID];
    NSData *responseData = [Utilities dataFromPHPScript:kPatientDetailsURL post:YES request:postRequest];
    
    NSError *error;
    NSArray *json = [NSJSONSerialization JSONObjectWithData:responseData options:kNilOptions error:&error];
    
   // NSString *readabledata = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
   // NSLog(@"%@", readabledata);
    
    for (int i = 0; i < 3; i++) {
        switch (i) {
            case 0: {
                NSDateFormatter *df = [[NSDateFormatter alloc] init];
                [df setDateFormat:@"yyyy-MM-dd"];
                NSDictionary *patientDetails = [json objectAtIndex:i];
                self.dob = [df dateFromString:[patientDetails objectForKey:@"dob"]];
                self.height = [patientDetails objectForKey:@"height"];
                self.bloodType = [patientDetails objectForKey:@"bloodType"];
                break;
            }
            case 1: {
                NSArray *jsonArray = [json objectAtIndex:i];
                NSMutableArray *allergies = [NSMutableArray new];
                for (int i = 0; i < jsonArray.count; i++) {
                    [allergies addObject:[[jsonArray objectAtIndex:i] objectForKey:@"allergy"]];
                }
                self.allergies = allergies;
                break;
            }
            case 2: {
                NSArray *jsonArray = [json objectAtIndex:i];
                NSMutableArray *conditions = [NSMutableArray new];
                for (int i = 0; i < jsonArray.count; i++) {
                    [conditions addObject:[[jsonArray objectAtIndex:i] objectForKey:@"condition"]];
                }
                self.medicalConditions = conditions;
                break;
            }
            default:
                break;
        }
    }
}

#define kLatestStatsURL [NSURL URLWithString: @"http://www.ladookie4343.com/MedicalApp/latestWeightBP.php"]
- (void)GetLatestStats
{
    NSString *postRequest = [NSString stringWithFormat:@"patientID=%d", self.patientID];
    NSData *responseData = [Utilities dataFromPHPScript:kLatestStatsURL post:YES request:postRequest];
    
    //NSString *readabledata = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
    //NSLog(@"%@", readabledata);
    
    NSError *error;
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:responseData options:kNilOptions error:&error];
    
    self.latestWeight = [json objectForKey:@"weight"];
    self.latestBPSys = [json objectForKey:@"bp_systolic"];
    self.latestBPDia = [json objectForKey:@"bp_diastolic"];
    self.latestHeight = [json objectForKey:@"height"];
}

#define kPatientIDSearchURL [NSURL URLWithString:@"http://www.ladookie4343.com/MedicalApp/searchPatientsById.php"]
#define kPatientLastNameSearchURL [NSURL URLWithString:@"http://www.ladookie4343.com/MedicalApp/searchPatientsByLastName.php"]

+ (NSMutableArray *)patientsForSearchByLastName:(NSString *)lastname
{
    NSString *queryString = [NSString stringWithFormat:@"lastname=%@", lastname];
    return [self patientsSearchResultWithQueryString:queryString URL:kPatientLastNameSearchURL];
}

+ (NSMutableArray *)patientsForSearchById:(int)Id
{
    NSString *queryString = [NSString stringWithFormat:@"patientID=%d", Id];
    return [self patientsSearchResultWithQueryString:queryString URL:kPatientIDSearchURL];
}

+ (NSMutableArray *)patientsSearchResultWithQueryString:(NSString *)queryString URL:(NSURL *)url
{
    NSData *responseData = [Utilities dataFromPHPScript:url post:YES request:queryString];
    
    NSMutableArray *patients = [[NSMutableArray alloc] init];
    
    NSError *error;
    NSArray *json = [NSJSONSerialization JSONObjectWithData:responseData options:kNilOptions error:&error];
    
    NSString *readabledata = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
    
    if (![@"[null]" isEqualToString:readabledata]) {
        for (int i = 0; i < json.count; i++) {
            NSDictionary *jsonPatient = [json objectAtIndex:i];
            Patient *patient = [Patient new];
            patient.patientID = [[jsonPatient objectForKey:@"patientID"] intValue];
            patient.firstname = [jsonPatient objectForKey:@"firstname"];
            patient.lastname = [jsonPatient objectForKey:@"lastname"];
            patient.patientImage = [jsonPatient objectForKey:@"image"];
            [patients addObject:patient];
        }
    }
    return patients;    
}

@end

















