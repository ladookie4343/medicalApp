//
//  Surgery.h
//  medical
//
//  Created by Matt LaDuca on 3/29/12.
//  Copyright (c) 2012  PPA. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Surgery : NSObject

@property (nonatomic, strong) NSString *doctor;
@property (nonatomic, strong) NSDate *when;
@property (nonatomic, strong) NSString *type;
@property (nonatomic, strong) NSString *result;
@property (nonatomic, strong) NSString *difficulties;

@end
