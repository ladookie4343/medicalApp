//
//  ViewController.h
//  medical
//
//  Created by Matt LaDuca on 2/11/12.
//  Copyright (c) 2012  PPA. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface LoginViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, 
    UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *logOnButton;
@property (strong, nonatomic) IBOutlet UIToolbar *keyboardToolbar;
@property (strong, nonatomic) IBOutlet UIView *loadingView;

@end
