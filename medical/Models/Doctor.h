//
//  Doctor.h
//  medical
//
//  Created by Matt LaDuca on 5/1/12.
//  Copyright (c) 2012  PPA. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Doctor : NSObject

@property (assign, nonatomic) int doctorID;
@property (strong, nonatomic) NSString *firstname;
@property (strong, nonatomic) NSString *lastname;

- (id)initFromUserName:(NSString *)username;

@end
