//
//  CDIRenameTaskViewController.m
//  Cheddar for iOS
//
//  Created by Sam Soffes on 5/30/12.
//  Copyright (c) 2012 Nothing Magical. All rights reserved.
//

#import "CDIRenameTaskViewController.h"
#import "UIColor+CheddariOSAdditions.h"
#import "UIFont+CheddariOSAdditions.h"

@interface CDIRenameTaskViewController () <UITextViewDelegate>
- (void)_keyboardDidShow:(NSNotification *)notification;
- (void)_keyboardDidHide:(NSNotification *)notification;
- (void)_updateTextViewFrame;
@end

@implementation CDIRenameTaskViewController {
	CGRect _keyboardRect;
}

@synthesize task = _task;
@synthesize textView = _textView;


#pragma mark - NSObject

- (void)dealloc {
	[[NSNotificationCenter defaultCenter] removeObserver:self];
}


#pragma mark - UIViewController

- (void)viewDidLoad {
	[super viewDidLoad];
	self.title = @"Edit Task";
	
	self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancel:)];
	self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Save" style:UIBarButtonItemStyleDone target:self action:@selector(save:)];
	
	self.view.backgroundColor = [UIColor whiteColor];

	_textView = [[SSTextView alloc] initWithFrame:self.view.bounds];
	_textView.delegate = self;
	_textView.autocapitalizationType = UITextAutocapitalizationTypeSentences;
	_textView.autocorrectionType = UITextAutocorrectionTypeYes;
	_textView.textColor = [UIColor cheddarTextColor];
	_textView.placeholderTextColor = [UIColor cheddarLightTextColor];
	_textView.placeholder = @"What do you have to do?";
	_textView.returnKeyType = UIReturnKeyGo;
	_textView.font = [UIFont cheddarFontOfSize:18.0f];
	_textView.text = self.task.text;
	[self.view addSubview:_textView];

	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_keyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_keyboardDidHide:) name:UIKeyboardDidHideNotification object:nil];
}


- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	[_textView becomeFirstResponder];
}


- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
	[UIView animateWithDuration:duration delay:0.0 options:UIViewAnimationOptionAllowUserInteraction animations:^{
		[self _updateTextViewFrame];
	} completion:nil];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
	if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
		return YES;
	}
	
	return toInterfaceOrientation != UIInterfaceOrientationPortraitUpsideDown;
}


#pragma mark - Actions

- (void)save:(id)sender {
	self.task.text = self.textView.text;
	[self.task save];
	[self.task update];
	[self.navigationController dismissModalViewControllerAnimated:YES];
}


- (void)cancel:(id)sender {
	[self.navigationController dismissModalViewControllerAnimated:YES];
}


#pragma mark - Private

- (void)_updateTextViewFrame {
	CGSize size = self.view.bounds.size;
	CGFloat heightAdjust = UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ? 0.0f : fminf(_keyboardRect.size.width, _keyboardRect.size.height);
	_textView.frame = CGRectMake(0.0f, 0.0f, size.width, size.height - heightAdjust);
}


- (void)_keyboardDidShow:(NSNotification *)notification {
	NSDictionary *userInfo = [notification userInfo];
	_keyboardRect = [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
	
	CGFloat duration = [[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
	[UIView animateWithDuration:duration delay:0.0 options:UIViewAnimationOptionAllowUserInteraction animations:^{
		[self _updateTextViewFrame];
	} completion:nil];
}


- (void)_keyboardDidHide:(NSNotification *)notification {
	NSDictionary *userInfo = [notification userInfo];
	_keyboardRect = CGRectZero;

	CGFloat duration = [[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
	[UIView animateWithDuration:duration delay:0.0 options:UIViewAnimationOptionAllowUserInteraction animations:^{
		[self _updateTextViewFrame];
	} completion:nil];
}


#pragma mark - UITextViewDelegate

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
	if ([text isEqual:@"\n"]) {
		[self save:textView];
		return NO;
	}
	return YES;
}

@end
