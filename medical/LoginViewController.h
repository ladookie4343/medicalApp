//
//  ViewController.h
//  medical
//
//  Created by Matt LaDuca on 2/11/12.
//  Copyright (c) 2012  PPA. All rights reserved.
//


// TODO:
//  - program the go button on the keyboard to act like the "Log On" button.
//  - make it so that when the user touches outside the keybaord, the keyboard resigns itself.
//  - implement a inputAccessoryView for the keyboard.
//  - customize login button.


#import <UIKit/UIKit.h>
#import "GradientButton.h"


@interface LoginViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet GradientButton *logOnButton;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end
