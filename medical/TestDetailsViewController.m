//
//  TestDetailsViewController.m
//  medical
//
//  Created by Matt LaDuca on 4/30/12.
//  Copyright (c) 2012  PPA. All rights reserved.
//

#import "TestDetailsViewController.h"

@interface TestDetailsViewController ()

@end

@implementation TestDetailsViewController
@synthesize testTypeTextField;
@synthesize testResultTextView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)viewDidUnload
{
    [self setTestTypeTextField:nil];
    [self setTestResultTextView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
