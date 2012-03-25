//
//  ViewController.h
//  medical
//
//  Created by Matt LaDuca on 2/11/12.
//  Copyright (c) 2012  PPA. All rights reserved.
//


// TODO:
//
//  - Add medical logo above in navbar
//
//  - Add button to allow user to save the username


#import <UIKit/UIKit.h>


@interface LoginViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, 
    UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *logOnButton;
@property (strong, nonatomic) IBOutlet UIToolbar *keyboardToolbar;
@property (strong, nonatomic) IBOutlet UIView *loadingView;

@end
