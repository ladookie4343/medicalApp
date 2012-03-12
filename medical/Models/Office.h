//
//  Office.h
//  medical
//
//  Created by Matt LaDuca on 3/3/12.
//  Copyright (c) 2012  PPA. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Office : NSObject 

@property (nonatomic, assign) int officeID;
@property (nonatomic, strong) NSString *street;
@property (nonatomic, strong) NSString *city;
@property (nonatomic, strong) NSString *state;
@property (nonatomic, strong) NSString *zipcode;
@property (nonatomic, strong) NSString *phone;
@property (nonatomic, strong) NSString *email;
@property (nonatomic, strong) NSString *website;
@property (nonatomic, strong) NSString *officeImage;

+ (NSArray *)OfficesForUsername:(NSString *)username;

@end
