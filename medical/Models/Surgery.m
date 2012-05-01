//
//  Surgery.m
//  medical
//
//  Created by Matt LaDuca on 3/29/12.
//  Copyright (c) 2012  PPA. All rights reserved.
//

#import "Surgery.h"
#import "Utilities.h"

@implementation Surgery

@synthesize when = _when;
@synthesize type = _type;
@synthesize result = _result;
@synthesize complications = _complications;

#define kRetrieveSurgeriesURLString @"http://www.ladookie4343.com/MedicalApp/retrieveSurgeries.php"
#define kRetrieveSurgeriesURL [NSURL URLWithString:kRetrieveSurgeriesURLString]

+ (NSMutableArray *)SurgeriesForPatient:(int)patientID
{
    NSString *queryString = [NSString stringWithFormat:@"patientID=%d", patientID];
    NSData *responseData = [Utilities dataFromPHPScript:kRetrieveSurgeriesURL post:YES request:queryString];
    
    NSMutableArray *surgeries = [[NSMutableArray alloc] init];
    
    NSError *error;
    NSArray *json = [NSJSONSerialization JSONObjectWithData:responseData options:kNilOptions error:&error];
    
    NSString *readabledata = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"yyyy-MM-dd"];
    if (![@"[null]" isEqualToString:readabledata]) {
        for (int i = 0; i < json.count; i++) {
            NSDictionary *jsonSurgery = [json objectAtIndex:i];
            Surgery *surgery = [Surgery new];
            surgery.when = [df dateFromString:[jsonSurgery objectForKey:@"when"]];
            surgery.type = [jsonSurgery objectForKey:@"type"];
            surgery.result = [jsonSurgery objectForKey:@"result"];
            surgery.complications = [jsonSurgery objectForKey:@"complications"];
            [surgeries addObject:surgery];
        }
    }
    return surgeries; 
}

@end
