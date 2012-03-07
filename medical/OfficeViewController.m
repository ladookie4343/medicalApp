//
//  OfficeViewController.m
//  medical
//
//  Created by Matt LaDuca on 3/1/12.
//  Copyright (c) 2012  PPA. All rights reserved.
//

#import "OfficeViewController.h"

@implementation OfficeViewController

@synthesize office = _office;
@synthesize label1 = _label1;
@synthesize label2 = _label2;
@synthesize label3 = _label3;
@synthesize label4 = _label4;
@synthesize label5 = _label5;
@synthesize label6 = _label6;

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - View lifecycle


- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated
{
    self.label1.text = self.office.street;
    self.label2.text = self.office.city;
    self.label3.text = self.office.state;
    self.label4.text = self.office.zipcode;
    self.label5.text = self.office.phone;
    self.label6.text = self.office.email;
}


- (void)viewDidUnload
{
    [self setLabel1:nil];
    [self setLabel2:nil];
    [self setLabel3:nil];
    [self setLabel4:nil];
    [self setLabel5:nil];
    [self setLabel6:nil];
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
