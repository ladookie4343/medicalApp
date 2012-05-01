//
//  TestDetailsViewController.h
//  medical
//
//  Created by Matt LaDuca on 4/30/12.
//  Copyright (c) 2012  PPA. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TestDetailsViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *testTypeTextField;
@property (weak, nonatomic) IBOutlet UITextView *testResultTextView;

@end
