//
//  Utilities.h
//  medical
//
//  Created by Matt LaDuca on 3/11/12.
//  Copyright (c) 2012  PPA. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Utilities : NSObject

+ (NSData *)dataFromPHPScript:(NSURL *)script post:(BOOL)post request:(NSString *)request;
+ (void)showLoadingView:(UIView *)loadingView InView:(UIView *)view;
+ (NSString *)trimmedString:(NSString *)string;
+ (void)RoundedBorderForImageView:(UIImageView *)imageView;
+ (UITextField *)textFieldWithPlaceholder:(NSString *)placeholder delegate:(id<UITextFieldDelegate>)delegate;

@end
