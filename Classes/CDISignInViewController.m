//
//  CDISignInViewController.m
//  Cheddar for iOS
//
//  Created by Sam Soffes on 3/30/12.
//  Copyright (c) 2012 Nothing Magical. All rights reserved.
//

#import "CDISignInViewController.h"
#import "CDISignUpViewController.h"
#import "CDIHUDView.h"
#import "UIColor+CheddariOSAdditions.h"
#import "UIFont+CheddariOSAdditions.h"

@implementation CDISignInViewController

#pragma mark - UIViewController

- (void)viewDidLoad {
	[super viewDidLoad];
	
	self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Sign In" style:UIBarButtonItemStyleBordered target:nil action:nil];
//	self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Sign In" style:UIBarButtonItemStyleBordered target:self action:@selector(signIn:)];

	UIButton *footer = [[UIButton alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, 34.0f)];
	[footer setTitle:@"Forgot your password? Reset it →" forState:UIControlStateNormal];
	[footer setTitleColor:[UIColor cheddarBlueColor] forState:UIControlStateNormal];
	[footer setTitleColor:[UIColor cheddarTextColor] forState:UIControlStateHighlighted];
	[footer addTarget:self action:@selector(forgot:) forControlEvents:UIControlEventTouchUpInside];
	footer.titleLabel.font = [UIFont cheddarInterfaceFontOfSize:16.0f];
	self.tableView.tableFooterView = footer;
}


#pragma mark - Actions

- (void)signIn:(id)sender {	
	CDIHUDView *hud = [[CDIHUDView alloc] initWithTitle:@"Signing in..." loading:YES];
	[hud show];
	
	[[CDKHTTPClient sharedClient] signInWithLogin:self.usernameTextField.text password:self.passwordTextField.text success:^(AFJSONRequestOperation *operation, id responseObject) {
		dispatch_async(dispatch_get_main_queue(), ^{
			[hud completeAndDismissWithTitle:@"Signed In!"];
			[self.navigationController dismissModalViewControllerAnimated:YES];
		});
	} failure:^(AFJSONRequestOperation *operation, NSError *error) {
		dispatch_async(dispatch_get_main_queue(), ^{
			[hud failAndDismissWithTitle:[[operation response] statusCode] == 401 ? @"Invalid" : @"Failed"];
		});
	}];
}


- (void)forgot:(id)sender {
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://cheddarapp.com/forgot"]];
}


#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return 2;
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
		self.usernameTextField.placeholder = @"Username or Email";
	} else if (indexPath.row == 1) {
		cell.textLabel.text = @"Password";
		cell.accessoryView = self.passwordTextField;
		self.passwordTextField.placeholder = @"Your Password";
	}
	
	return cell;
}


#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
	if (textField == self.usernameTextField) {
		[self.passwordTextField becomeFirstResponder];
	} else if (textField == self.passwordTextField) {
		[self signIn:textField];
	}
	return NO;
}

@end
