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

- (id) initWithOfficeID:(int)oid street:(NSString *)street city:(NSString *)city
                  state:(NSString *)state zipcode:(NSString *)zipcode;

@end
