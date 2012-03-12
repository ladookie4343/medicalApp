//
//  Utilities.m
//  medical
//
//  Created by Matt LaDuca on 3/11/12.
//  Copyright (c) 2012  PPA. All rights reserved.
//

#import "Utilities.h"

@interface Utilities()

+ (void)makePOSTrequest:(NSString *)request toScript:(NSURL *)script;
+ (void)makeGETrequestToScript:(NSURL *)script;

@end

@implementation Utilities

NSData *responseData;

+ (NSData *)dataFromPHPScript:(NSURL *)script post:(BOOL)post request:(NSString *)request
{
    if (post) {
        [self makePOSTrequest:request toScript:script];
    } else {
        [self makeGETrequestToScript:script];
    }
    return responseData;
}

#define kBgQueue dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)

+ (void)makePOSTrequest:(NSString *)requestData toScript:(NSURL *)script
{
    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:script];
    [request setHTTPMethod:@"POST"];
    
    [request setHTTPBody:[requestData dataUsingEncoding:NSUTF8StringEncoding]]; 
    
    
    dispatch_async(kBgQueue, ^{ 
        NSURLResponse *response;
        NSError *error;
        NSData *data = [NSURLConnection sendSynchronousRequest:request 
                                                     returningResponse:&response 
                                                                 error:&error];
        [self performSelectorOnMainThread:@selector(responseFromScript:) 
                               withObject:data 
                            waitUntilDone:YES];
    });
}

+ (void)makeGETrequestToScript:(NSURL *)script
{
    dispatch_async(kBgQueue, ^{
        NSData *data = [NSData dataWithContentsOfURL:script];
        [self performSelectorOnMainThread:@selector(responseFromScript:) 
                               withObject:data 
                            waitUntilDone:YES];
    });
}

+ (void)responseFromScript:(NSData *)data
{
    responseData = data;
}


@end
