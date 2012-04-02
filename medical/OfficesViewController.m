//
//  OfficeTableViewController.m
//  medical
//
//  Created by Matt LaDuca on 3/10/12.
//  Copyright (c) 2012  PPA. All rights reserved.
//

#import "OfficesViewController.h"
#import "OfficeTableViewCell.h"
#import "QuartzCore/QuartzCore.h"
#import "Office.h"
@interface OfficesViewController()

- (UIImage *)getImageForOffice:(Office *)office;

@end

@implementation OfficesViewController

@synthesize offices = _offices;
@synthesize tableView = _tableView;
@synthesize loadingView = _loadingView;

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.hidesBackButton = YES;
}

- (void)viewDidUnload
{
    [self setTableView:nil];
    [self setLoadingView:nil];
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.offices.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    OfficeTableViewCell *cell = (OfficeTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"OfficeCell"];
    
    Office *office = [self.offices objectAtIndex:indexPath.row];
    
    cell.officeImageView.image = [self getImageForOffice:office];
    cell.officeImageView.clipsToBounds = YES;
    cell.officeImageView.layer.cornerRadius = 5.0;
    cell.officeNameLabel.text = office.name;
    cell.officeLocationLabel.text = office.street;
    
    if (self.offices.count == 1) {
        cell.selectedBackgroundView = [[UIImageView alloc] initWithImage:
                                       [UIImage imageNamed:@"oneRowOnlySelected.png"]];
    } else if (self.offices.count > 1) {
        if (indexPath.row == 0) {
            cell.selectedBackgroundView = [[UIImageView alloc] initWithImage:
                                           [UIImage imageNamed:@"topRowSelected.png"]];
        } else if (indexPath.row == self.offices.count - 1) {
            cell.selectedBackgroundView = [[UIImageView alloc] initWithImage:
                                           [UIImage imageNamed:@"bottomRowSelected.png"]];
        } else {
            cell.selectedBackgroundView = [[UIImageView alloc] initWithImage:
                                           [UIImage imageNamed:@"middleRowSelected.png"]];
        }
    }
    return cell;
}

#define kOfficeImageAddress @"http://www.ladookie4343.com/MedicalApp/officeImages/"

- (UIImage *)getImageForOffice:(Office *)office
{
    NSString *imageName = office.officeImage;
    NSString *imageURLstring = [kOfficeImageAddress stringByAppendingString:imageName];
    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:imageURLstring]];
    return [UIImage imageWithData:data];
}
                                                                 
#pragma mark - Table view delegate

- (void)showLoadingView
{
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    [self showLoadingView];
    
    
}

@end









































