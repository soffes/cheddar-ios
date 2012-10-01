//
//  CDISignInViewController.m
//  Cheddar for iOS
//
//  Created by Sam Soffes on 4/23/12.
//  Copyright (c) 2012 Nothing Magical. All rights reserved.
//

#import "CDISignInViewController.h"
#import "CDIHUDView.h"
#import "UIColor+CheddariOSAdditions.h"
#import "UIFont+CheddariOSAdditions.h"

@interface CDISignInViewController ()
- (void)_toggleMode:(id)sender;
- (void)_toggleModeAnimated:(BOOL)animated;
- (void)_configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath;
- (void)_validateButton;
@end

@implementation CDISignInViewController {
	UIButton *_footerButton;
	BOOL _signUpMode;
}

@synthesize usernameTextField = _usernameTextField;
@synthesize emailTextField = _emailTextField;
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

	_footerButton = [[UIButton alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, 34.0f)];
	[_footerButton setTitleColor:[UIColor cheddarBlueColor] forState:UIControlStateNormal];
	[_footerButton setTitleColor:[UIColor cheddarTextColor] forState:UIControlStateHighlighted];
	[_footerButton addTarget:self action:@selector(_toggleMode:) forControlEvents:UIControlEventTouchUpInside];
	_footerButton.titleLabel.font = [UIFont cheddarInterfaceFontOfSize:16.0f];
	self.tableView.tableFooterView = _footerButton;

	_signUpMode = NO;
	[self _toggleModeAnimated:NO];
}


- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];

	// TODO: Terrible hack
	dispatch_async(dispatch_get_main_queue(), ^{
		[self.usernameTextField becomeFirstResponder];
	});
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
	if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
		return YES;
	}
	
	return toInterfaceOrientation != UIInterfaceOrientationPortraitUpsideDown;
}


#pragma mark - Actions

- (void)signIn:(id)sender {
	if (!self.navigationItem.rightBarButtonItem.enabled) {
		return;
	}

	CDIHUDView *hud = [[CDIHUDView alloc] initWithTitle:@"Signing in..." loading:YES];
	[hud show];

	[[CDKHTTPClient sharedClient] signInWithLogin:self.usernameTextField.text password:self.passwordTextField.text success:^(AFJSONRequestOperation *operation, id responseObject) {
		dispatch_async(dispatch_get_main_queue(), ^{
			[hud completeAndDismissWithTitle:@"Signed In!"];
			[self.navigationController dismissModalViewControllerAnimated:YES];
		});
	} failure:^(AFJSONRequestOperation *operation, NSError *error) {
		NSString *message = [[operation responseJSON] objectForKey:@"error_description"];

		dispatch_async(dispatch_get_main_queue(), ^{
			[hud failAndDismissWithTitle:[[operation response] statusCode] == 401 ? @"Invalid" : @"Failed"];

			UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
			[alert show];
		});
	}];
}


- (void)signUp:(id)sender {
	if (!self.navigationItem.rightBarButtonItem.enabled) {
		return;
	}
	
	CDIHUDView *hud = [[CDIHUDView alloc] initWithTitle:@"Signing up..." loading:YES];
	[hud show];

	[[CDKHTTPClient sharedClient] signUpWithUsername:self.usernameTextField.text email:self.emailTextField.text password:self.passwordTextField.text success:^(AFJSONRequestOperation *operation, id responseObject) {
		dispatch_async(dispatch_get_main_queue(), ^{
			[hud completeAndDismissWithTitle:@"Signed Up!"];
			[self.navigationController dismissModalViewControllerAnimated:YES];
		});
	} failure:^(AFJSONRequestOperation *operation, NSError *error) {
		NSString *message = [[operation responseJSON] objectForKey:@"error_description"];

		dispatch_async(dispatch_get_main_queue(), ^{
			[hud failAndDismissWithTitle:@"Failed"];

			UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
			[alert show];
		});
	}];
}


- (void)forgot:(id)sender {
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://cheddarapp.com/forgot"]];
}


#pragma mark - Private

- (void)_toggleMode:(id)sender {
	[self _toggleModeAnimated:YES];
}


- (void)_toggleModeAnimated:(BOOL)animated {
	NSArray *email = @[[NSIndexPath indexPathForRow:1 inSection:0]];

	BOOL focusPassword = [self.emailTextField isFirstResponder];
	UITableViewRowAnimation animation = animated ? UITableViewRowAnimationTop : UITableViewScrollPositionNone;

	// Switch to sign in
	if (_signUpMode) {
		_signUpMode = NO;

		[self.tableView beginUpdates];
		[self.tableView deleteRowsAtIndexPaths:email withRowAnimation:animation];
		[self.tableView endUpdates];

		[_footerButton setTitle:@"Don't have an account? Sign Up →" forState:UIControlStateNormal];

		self.usernameTextField.placeholder = @"Username or email";
		self.passwordTextField.placeholder = @"Your password";

		if (focusPassword) {
			[self.passwordTextField becomeFirstResponder];
		}

		self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Sign In" style:UIBarButtonItemStyleBordered target:self action:@selector(signIn:)];
	}

	// Switch to sign up
	else {
		_signUpMode = YES;

		[self.tableView beginUpdates];
		[self.tableView insertRowsAtIndexPaths:email withRowAnimation:animation];
		[self.tableView endUpdates];

		[_footerButton setTitle:@"Already have an account? Sign In →" forState:UIControlStateNormal];

		self.usernameTextField.placeholder = @"Choose a username";
		self.passwordTextField.placeholder = @"Choose a password";

		self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Sign Up" style:UIBarButtonItemStyleBordered target:self action:@selector(signUp:)];
	}

	[self _validateButton];
}


- (void)_configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
	if (indexPath.row == 0) {
		cell.textLabel.text = @"Username";
		cell.accessoryView = self.usernameTextField;
		return;
	}

	if (_signUpMode) {
		if (indexPath.row == 1) {
			cell.textLabel.text = @"Email";
			cell.accessoryView = self.emailTextField;
			return;
		}
	}

	cell.textLabel.text = @"Password";
	cell.accessoryView = self.passwordTextField;
}


- (void)_validateButton {
	BOOL valid = self.usernameTextField.text.length >= 1 && self.passwordTextField.text.length >= 6;

	if (_signUpMode && valid) {
		valid = self.emailTextField.text.length >= 5;
	}

	self.navigationItem.rightBarButtonItem.enabled = valid;
}


#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return _signUpMode ? 3 : 2;
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

	[self _configureCell:cell atIndexPath:indexPath];

	return cell;
}


#pragma mark - UITextFieldDelegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
	// TODO: Terrible hack #shipit
	dispatch_async(dispatch_get_main_queue(), ^{
		[self _validateButton];
	});
	return YES;
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField {
	if (textField == self.usernameTextField) {
		if (_signUpMode) {
			[self.emailTextField becomeFirstResponder];
		} else {
			[self.passwordTextField becomeFirstResponder];
		}
	} else if (textField == self.emailTextField) {
		[self.passwordTextField becomeFirstResponder];
	} else if (textField == self.passwordTextField) {
		if (_signUpMode) {
			[self signUp:textField];
		} else {
			[self signIn:textField];
		}
	}
	return NO;
}

@end
