//
//  CDISessionsViewController.h
//  Cheddar for iOS
//
//  Created by Sam Soffes on 4/23/12.
//  Copyright (c) 2012 Nothing Magical. All rights reserved.
//

@interface CDISessionsViewController : UITableViewController <UITextFieldDelegate>

@property (nonatomic, strong, readonly) UITextField *usernameTextField;
@property (nonatomic, strong, readonly) UITextField *passwordTextField;

+ (CGFloat)textFieldWith;

@end
