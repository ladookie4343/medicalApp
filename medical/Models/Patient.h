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
@property (nonatomic, strong) NSArray *allergies;
@property (nonatomic, strong) NSArray *medicalConditions;

@end
