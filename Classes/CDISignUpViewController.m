//
//  CDISignUpViewController.m
//  Cheddar for iOS
//
//  Created by Sam Soffes on 4/23/12.
//  Copyright (c) 2012 Nothing Magical. All rights reserved.
//

#import "CDISignUpViewController.h"
#import "CDISignInViewController.h"
#import "CDIHUDView.h"
#import "UIColor+CheddariOSAdditions.h"
#import "UIFont+CheddariOSAdditions.h"

@interface CDISignUpViewController ()
@property (nonatomic, strong, readonly) UITextField *emailTextField;
@end

@implementation CDISignUpViewController

@synthesize emailTextField = _emailTextField;

- (UITextField *)emailTextField {
	if (!_emailTextField) {
		_emailTextField = [[UITextField alloc] initWithFrame:CGRectMake(0.0f, 0.0f, [[self class] textFieldWith], 30.0f)];
		_emailTextField.keyboardType = UIKeyboardTypeEmailAddress;
		_emailTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
		_emailTextField.autocorrectionType = UITextAutocorrectionTypeNo;
		_emailTextField.textColor = [UIColor cheddarBlueColor];
		_emailTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
		_emailTextField.delegate = self;
		_emailTextField.returnKeyType = UIReturnKeyNext;
		_emailTextField.placeholder = @"Your email address";
		_emailTextField.font = [UIFont cheddarInterfaceFontOfSize:18.0f];
	}
	return _emailTextField;
}


#pragma mark - UIViewController

- (void)viewDidLoad {
	[super viewDidLoad];
	self.title = @"Cheddar";
	self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Sign Up" style:UIBarButtonItemStyleBordered target:nil action:nil];
//	self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Sign Up" style:UIBarButtonItemStyleBordered target:self action:@selector(signUp:)];

	UIButton *footer = [[UIButton alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, 34.0f)];
	[footer setTitle:@"Already have an account? Sign In →" forState:UIControlStateNormal];
	[footer setTitleColor:[UIColor cheddarBlueColor] forState:UIControlStateNormal];
	[footer setTitleColor:[UIColor cheddarTextColor] forState:UIControlStateHighlighted];
	[footer addTarget:self action:@selector(signIn:) forControlEvents:UIControlEventTouchUpInside];
	footer.titleLabel.font = [UIFont cheddarInterfaceFontOfSize:16.0f];
	self.tableView.tableFooterView = footer;
}


#pragma mark - Actions

- (void)signIn:(id)sender {
	[self.navigationController pushViewController:[[CDISignInViewController alloc] init] animated:YES];
}


- (void)signUp:(id)sender {
	CDIHUDView *hud = [[CDIHUDView alloc] initWithTitle:@"Signing up..." loading:YES];
	[hud show];
	
	[[CDKHTTPClient sharedClient] signUpWithUsername:self.usernameTextField.text email:self.emailTextField.text password:self.passwordTextField.text success:^(AFJSONRequestOperation *operation, id responseObject) {
		dispatch_async(dispatch_get_main_queue(), ^{
			[hud completeAndDismissWithTitle:@"Signed Up!"];
			[self.navigationController dismissModalViewControllerAnimated:YES];
		});
	} failure:^(AFJSONRequestOperation *operation, NSError *error) {
		dispatch_async(dispatch_get_main_queue(), ^{
			[hud failAndDismissWithTitle:@"Failed"];
		});
	}];
}


#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return 3;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	static NSString *const cellIdentifier = @"cellIdentifier";
	
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
	if (!cell) {
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
		cell.selectionStyle = UITableViewCellSelectionStyleNone;
		cell.textLabel.textColor = [UIColor cheddarTextColor];
		cell.textLabel.font = [UIFont cheddarInterfaceFontOfSize:18.0f];
	}
	
	if (indexPath.row == 0) {
		cell.textLabel.text = @"Username";
		cell.accessoryView = self.usernameTextField;
		self.usernameTextField.placeholder = @"Choose a username";
	} else if (indexPath.row == 1) {
		cell.textLabel.text = @"Email";
		cell.accessoryView = self.emailTextField;
	} else if (indexPath.row == 2) {
		cell.textLabel.text = @"Password";
		cell.accessoryView = self.passwordTextField;
		self.passwordTextField.placeholder = @"Choose a password";
	}
	
	return cell;
}


#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
	if (textField == self.usernameTextField) {
		[self.emailTextField becomeFirstResponder];
	} else if (textField == self.emailTextField) {
		[self.passwordTextField becomeFirstResponder];
	} else if (textField == self.passwordTextField) {
		[self signUp:textField];
	}
	return NO;
}

@end
