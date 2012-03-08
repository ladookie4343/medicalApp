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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - View lifecycle


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIView *containerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 300, 60)];
    UILabel *headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 20, 300, 40)];
    
    headerLabel.text = [NSString stringWithFormat:@"Matt's Dental Office"];
    headerLabel.textColor = [UIColor whiteColor];
    headerLabel.shadowColor = [UIColor blackColor];
    headerLabel.shadowOffset = CGSizeMake(0, 1);
    headerLabel.font = [UIFont boldSystemFontOfSize:22];
    headerLabel.backgroundColor = [UIColor clearColor];
    headerLabel.textAlignment = UITextAlignmentCenter;
    [containerView addSubview:headerLabel];
    self.tableView.tableHeaderView = containerView;
}

- (void)viewWillAppear:(BOOL)animated
{
    self.navigationItem.hidesBackButton = YES;
}


- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

/*
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
        return self.officeNameView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
        return 40;
   
}
*/

@end
