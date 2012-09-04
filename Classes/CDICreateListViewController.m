//
//  CDICreateListViewController.m
//  Cheddar for iOS
//
//  Created by Sam Soffes on 4/7/12.
//  Copyright (c) 2012 Nothing Magical. All rights reserved.
//

#import "CDICreateListViewController.h"
#import "CDIHUDView.h"
#import "UIColor+CheddariOSAdditions.h"
#import "UIFont+CheddariOSAdditions.h"

@interface CDICreateListViewController () <UITextFieldDelegate, UIAlertViewDelegate>
@property (nonatomic, strong) UITextField *titleTextField;
@end

@implementation CDICreateListViewController

@synthesize titleTextField = _titleTextField;
@synthesize list = _list;

- (UITextField *)titleTextField {
	if (!_titleTextField) {
		_titleTextField = [[UITextField alloc] initWithFrame:CGRectMake(10.0f, 7.0f, 280.0f, 30.0f)];
		_titleTextField.autocapitalizationType = UITextAutocapitalizationTypeWords;
		_titleTextField.autocorrectionType = UITextAutocorrectionTypeYes;
		_titleTextField.textColor = [UIColor cheddarBlueColor];
		_titleTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
		_titleTextField.placeholder = @"Name Your List";
		_titleTextField.delegate = self;
		_titleTextField.returnKeyType = UIReturnKeyGo;
		_titleTextField.font = [UIFont cheddarFontOfSize:18.0f];
		_titleTextField.backgroundColor = [UIColor colorWithWhite:0.969f alpha:1.0f];
		
		if (self.list) {
			_titleTextField.text = self.list.title;
		}
	}
	return _titleTextField;
}


#pragma mark - NSObject

- (id)init {
	return (self = [super initWithStyle:UITableViewStyleGrouped]);
}


#pragma mark - UIViewController

- (void)viewDidLoad {
	[super viewDidLoad];
	if (self.list) {
		self.title = @"Rename List";
	} else {
		self.title = @"Create List";
	}
	
	self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancel:)];
	self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:(self.list ? @"Save" : @"Create") style:UIBarButtonItemStyleDone target:self action:@selector(create:)];
	
	UIView *background = [[UIView alloc] initWithFrame:CGRectZero];
	background.backgroundColor = [UIColor cheddarArchesColor];
	self.tableView.backgroundView = background;
}


- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	[self.titleTextField becomeFirstResponder];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
	if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
		return YES;
	}
	
	return toInterfaceOrientation != UIInterfaceOrientationPortraitUpsideDown;
}


#pragma mark - Actions

- (void)create:(id)sender {
	NSString *title = self.titleTextField.text;
	if (title.length == 0) {
		return;
	}
	
	self.titleTextField.enabled = NO;

	// Update list
	if (self.list) {
		self.list.title = title;
		[self.list save];
		[self.list update];
		[self.navigationController dismissModalViewControllerAnimated:YES];
		return;
	}

	// Create list
	CDIHUDView *hud = [[CDIHUDView alloc] initWithTitle:@"Creating..." loading:YES];
	[hud show];
	
	CDKList *list = [[CDKList alloc] init];
	list.title = title;
	list.position = [NSNumber numberWithInteger:INT32_MAX];
	
	[list createWithSuccess:^{
		dispatch_async(dispatch_get_main_queue(), ^{
			[hud completeAndDismissWithTitle:@"Created!"];
			[self.navigationController dismissModalViewControllerAnimated:YES];
		});
	} failure:^(AFJSONRequestOperation *remoteOperation, NSError *error) {
		dispatch_async(dispatch_get_main_queue(), ^{
			self.titleTextField.enabled = YES;
			
			NSDictionary *responseObject = remoteOperation.responseJSON;		
			if ([responseObject isKindOfClass:[NSDictionary class]] && [[responseObject objectForKey:@"error"] isEqualToString:@"plus_required"]) {
				[hud dismiss];
				UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Plus Required" message:@"You need Cheddar Plus to create more than 2 lists. Please upgrade to continue." delegate:self cancelButtonTitle:@"Later" otherButtonTitles:@"Upgrade", nil];
				[alert show];
			} else {
				[hud failAndDismissWithTitle:@"Failed"];
				[self.titleTextField becomeFirstResponder];
			}
		});
	}];
}


- (void)cancel:(id)sender {
	[self.navigationController dismissModalViewControllerAnimated:YES];
}


#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	static NSString *const cellIdentifier = @"cellIdentifier";
	
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
	if (!cell) {
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
		cell.selectionStyle = UITableViewCellSelectionStyleNone;
		[cell.contentView addSubview:self.titleTextField];
	}
	
	return cell;
}


#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
	if (textField == _titleTextField) {
		[self create:textField];
	}
	return NO;
}


#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView willDismissWithButtonIndex:(NSInteger)buttonIndex {
	if (buttonIndex == 1) {
		[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://cheddarapp.com/account#plus"]];
	}
}

@end
