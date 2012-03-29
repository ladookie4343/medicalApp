//
//  Visit.h
//  medical
//
//  Created by Matt LaDuca on 3/29/12.
//  Copyright (c) 2012  PPA. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Visit : NSObject

@property (nonatomic, assign) int patientID;
@property (nonatomic, strong) NSDate *when;
@property (nonatomic, strong) NSString *reason;
@property (nonatomic, strong) NSString *diagnosis;
@property (nonatomic, strong) NSString *height;
@property (nonatomic, strong) NSString *weight;
@property (nonatomic, strong) NSString *bpSystolic;
@property (nonatomic, strong) NSString *bpDiastolic;

@end
