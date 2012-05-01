//
//  Test.h
//  medical
//
//  Created by Matt LaDuca on 3/29/12.
//  Copyright (c) 2012  PPA. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Test : NSObject

@property (nonatomic, strong) NSString *doctor;
@property (nonatomic, strong) NSDate *when;
@property (nonatomic, strong) NSString *testType;
@property (nonatomic, strong) NSString *testResult;

+ (NSMutableArray *)testsForPatient:(int)patientID;

@end
