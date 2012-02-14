//
//  ViewController.m
//  medical
//
//  Created by Matt LaDuca on 2/11/12.
//  Copyright (c) 2012  PPA. All rights reserved.
//

#import "ViewController.h"

@interface ViewController()

- (void)fetchData:(NSData *)responseData;

@end

@implementation ViewController

@synthesize name = _name;
@synthesize type = _type;
@synthesize experience = _experience;

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
	
}

- (void)viewDidUnload
{
    [self setName:nil];
    [self setType:nil];
    [self setExperience:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

#define kBgQueue dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
#define kLadookieURL [NSURL URLWithString: @"http://www.ladookie4343.com/MedicalApp/doctor.php"]

- (IBAction)buttonPressed:(UIButton *)sender 
{
    dispatch_async(kBgQueue, ^{
        NSData *data = [NSData dataWithContentsOfURL:kLadookieURL];
        [self performSelectorOnMainThread:@selector(fetchData:) withObject:data waitUntilDone:YES];
    });
}

- (void)fetchData:(NSData *)responseData
{
    NSError *error;
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:responseData 
                                                         options:kNilOptions 
                                                           error:&error];
    NSString *firstname = [json objectForKey:@"firstname"];
    NSString *type = [json objectForKey:@"type"];
    NSString *experience = [json objectForKey:@"years_experience"];
    
    self.name.text = firstname;
    self.type.text = type;
    self.experience.text = experience;
}


@end
