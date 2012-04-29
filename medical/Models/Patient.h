//
//  Patient.h
//  medical
//
//  Created by Matt LaDuca on 3/29/12.
//  Copyright (c) 2012  PPA. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Visit;
@class Test;
@class Surgery;

@interface Patient : NSObject

@property (nonatomic, assign) int patientID;
@property (nonatomic, strong) NSString *firstname;
@property (nonatomic, strong) NSString *lastname;
@property (nonatomic, strong) NSString *height;
@property (nonatomic, strong) NSDate *dob;
@property (nonatomic, strong) NSArray * visits;
@property (nonatomic, strong) NSArray *tests;
@property (nonatomic, strong) NSArray *surgeries;
@property (nonatomic, strong) NSString *bloodType;
@property (nonatomic, strong) NSMutableArray *allergies;
@property (nonatomic, strong) NSMutableArray *medicalConditions;
@property (nonatomic, strong) NSString *patientImage;
@property (nonatomic, strong) NSString *latestWeight;
@property (nonatomic, strong) NSString *latestBPSys;
@property (nonatomic, strong) NSString *latestBPDia;

// deletes all rows in allergy table for this patient 
// and adds the rows currently in allergies array
- (void)updateAllergies;

// deletes all rows in medicalConditions table for this patient 
// and adds the rows currently in allergies array
- (void)updateMedicalConditions;

// gets additional information from patient for patientDetailsViewController:
// dob, height, bloodtype, allergies, medicalConditions,
- (void)GetDetailsForPatientDetailsVC;

- (void)GetLatestStats;

+ (NSArray *)patientsForPatientsTable:(int)officeID;

+ (NSMutableArray *)patientsForSearchByLastName:(NSString *)lastname;

+ (NSMutableArray *)patientsForSearchById:(int)Id;

+ (NSMutableArray *)testPatients;

@end
