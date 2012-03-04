//
//  ViewController.h
//  medical
//
//  Created by Matt LaDuca on 2/11/12.
//  Copyright (c) 2012  PPA. All rights reserved.
//


// TODO:
//
//  - Add medical logo above login
//
//  - With the medical logo above login, will need to make
//    UserID and Password slide up the screen so that the
//    keyboard doesn't cover them up
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
