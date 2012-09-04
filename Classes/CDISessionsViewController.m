//
//  CDISessionsViewController.m
//  Cheddar for iOS
//
//  Created by Sam Soffes on 4/23/12.
//  Copyright (c) 2012 Nothing Magical. All rights reserved.
//

#import "CDISessionsViewController.h"
#import "UIColor+CheddariOSAdditions.h"
#import "UIFont+CheddariOSAdditions.h"

@implementation CDISessionsViewController

@synthesize usernameTextField = _usernameTextField;
@synthesize passwordTextField = _passwordTextField;

- (UITextField *)usernameTextField {
	if (!_usernameTextField) {
		_usernameTextField = [[UITextField alloc] initWithFrame:CGRectMake(0.0f, 0.0f, [[self class] textFieldWith], 30.0f)];
		_usernameTextField.keyboardType = UIKeyboardTypeEmailAddress;
		_usernameTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
		_usernameTextField.autocorrectionType = UITextAutocorrectionTypeNo;
		_usernameTextField.textColor = [UIColor cheddarBlueColor];
		_usernameTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
		_usernameTextField.delegate = self;
		_usernameTextField.returnKeyType = UIReturnKeyNext;
		_usernameTextField.font = [UIFont cheddarInterfaceFontOfSize:18.0f];
	}
	return _usernameTextField;
}


- (UITextField *)passwordTextField {
	if (!_passwordTextField) {
		_passwordTextField = [[UITextField alloc] initWithFrame:CGRectMake(0.0f, 0.0f, [[self class] textFieldWith], 30.0f)];
		_passwordTextField.secureTextEntry = YES;
		_passwordTextField.textColor = [UIColor cheddarBlueColor];
		_passwordTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
		_passwordTextField.delegate = self;
		_passwordTextField.returnKeyType = UIReturnKeyGo;
		_passwordTextField.font = [UIFont cheddarInterfaceFontOfSize:18.0f];
	}
	return _passwordTextField;
}


#pragma mark - Class Methods

+ (CGFloat)textFieldWith {
	return UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ? 360.0f : 180.0f;
}


#pragma mark - NSObject

- (id)init {
	if ((self = [super initWithStyle:UITableViewStyleGrouped])) {
		self.title = @"Cheddar";
		UIImageView *title = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"nav-title"]];
		title.frame = CGRectMake(0.0f, 0.0f, 116.0f, 21.0f);	
		self.navigationItem.titleView = title;
	}
	return self;
}


#pragma mark - UIViewController

- (void)viewDidLoad {
	[super viewDidLoad];
	
	UIView *background = [[UIView alloc] initWithFrame:CGRectZero];
	background.backgroundColor = [UIColor cheddarArchesColor];
	self.tableView.backgroundView = background;
}


- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	[self.usernameTextField becomeFirstResponder];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
	if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
		return YES;
	}
	
	return toInterfaceOrientation != UIInterfaceOrientationPortraitUpsideDown;
}

@end
