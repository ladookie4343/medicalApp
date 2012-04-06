//
//  Utilities.m
//  medical
//
//  Created by Matt LaDuca on 3/11/12.
//  Copyright (c) 2012  PPA. All rights reserved.
//

#import "Utilities.h"

@interface Utilities()

+ (NSData *)makePOSTrequest:(NSString *)request toScript:(NSURL *)script;

@end

@implementation Utilities

NSData *responseData;

+ (NSData *)dataFromPHPScript:(NSURL *)script post:(BOOL)post request:(NSString *)request
{
    if (post) {
        return [self makePOSTrequest:request toScript:script];
    } else {
        return [NSData dataWithContentsOfURL:script];
    }
}

+ (NSData *)makePOSTrequest:(NSString *)requestData toScript:(NSURL *)script
{
    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:script];
    [request setHTTPMethod:@"POST"];
    
    [request setHTTPBody:[requestData dataUsingEncoding:NSUTF8StringEncoding]]; 
    
    
    NSURLResponse *response;
    NSError *error;
    return [NSURLConnection sendSynchronousRequest:request 
                                 returningResponse:&response 
                                             error:&error];
}

+ (void)showLoadingView:(UIView *)loadingView InView:(UIView *)view
{
    [view addSubview:loadingView];
    loadingView.backgroundColor = [UIColor clearColor];
    loadingView.center = view.center;
}


@end
