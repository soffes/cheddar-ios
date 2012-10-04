//
//  CDIEditTaskViewController.m
//  Cheddar for iOS
//
//  Created by Sam Soffes on 5/30/12.
//  Copyright (c) 2012 Nothing Magical. All rights reserved.
//

#import "CDIEditTaskViewController.h"
#import "CDIMoveTaskView.h"
#import "CDIKeyboardBar.h"
#import "UIColor+CheddariOSAdditions.h"
#import "UIFont+CheddariOSAdditions.h"

@interface CDIEditTaskViewController () <UITextViewDelegate>
- (void)_keyboardDidShow:(NSNotification *)notification;
- (void)_layout:(NSTimeInterval)duration;
@end

@implementation CDIEditTaskViewController {
	CGRect _keyboardRect;
	BOOL _shown;
	CDIMoveTaskView *_moveTaskView;
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

	_textView = [[SSTextView alloc] init];
	_textView.delegate = self;
	_textView.autocapitalizationType = UITextAutocapitalizationTypeSentences;
	_textView.autocorrectionType = UITextAutocorrectionTypeYes;
	_textView.textColor = [UIColor cheddarTextColor];
	_textView.placeholderTextColor = [UIColor cheddarLightTextColor];
	_textView.placeholder = @"What do you have to do?";
	_textView.returnKeyType = UIReturnKeyGo;
	_textView.font = [UIFont cheddarFontOfSize:18.0f];
	_textView.text = self.task.text;
	
	CDIKeyboardBar *keyboardBar = [[CDIKeyboardBar alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.view.bounds.size.width, UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ? 54.0f : 36.0f)];
	keyboardBar.keyInputView = _textView;
	_textView.inputAccessoryView = keyboardBar;
	[self.view addSubview:_textView];

	if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
		_moveTaskView = [[CDIMoveTaskView alloc] init];
		_moveTaskView.editViewController = self;
		[_moveTaskView.moveButton addTarget:self action:@selector(moveTask:) forControlEvents:UIControlEventTouchUpInside];
		[self.view addSubview:_moveTaskView];
	}

	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_keyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
}


- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];

	// Default to avoid flash
	CGSize size = self.view.frame.size;
	_keyboardRect = CGRectMake(0.0f, size.height - 216.0f, size.width, 216.0f);
	[self _layout:0.0];
	
	[_textView becomeFirstResponder];
}


- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
	[UIView animateWithDuration:duration delay:0.0 options:UIViewAnimationOptionAllowUserInteraction animations:^{
		[self _layout:duration];
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


- (void)moveTask:(id)sender {
	if ([_textView isFirstResponder]) {
		[_textView resignFirstResponder];
		[_moveTaskView.tableView flashScrollIndicators];
	} else {
		[_textView becomeFirstResponder];
	}
}


- (void)moveTaskToList:(CDKList *)newList {
	[self.task moveToList:newList];
	[self.navigationController dismissModalViewControllerAnimated:YES];
}


#pragma mark - Private

- (void)_layout:(NSTimeInterval)duration {
	CGSize size = self.view.bounds.size;
	CGFloat heightAdjust = UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ? 0.0f : _keyboardRect.size.height;
	CGFloat textViewHeight = size.height - heightAdjust - 32.0f;

	[UIView animateWithDuration:duration delay:0.0 options:UIViewAnimationOptionAllowUserInteraction | UIViewAnimationOptionCurveEaseInOut animations:^{
		_textView.frame = CGRectMake(0.0f, 0.0f, size.width, textViewHeight);
		_moveTaskView.frame = CGRectMake(0.0f, textViewHeight, size.width, size.height - textViewHeight);
	} completion:nil];
}


- (void)_keyboardDidShow:(NSNotification *)notification {
	NSDictionary *userInfo = [notification userInfo];
	_keyboardRect = [self.view convertRect:[[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue] fromView:nil];
	
	CGFloat duration = _shown ? [[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue] : 0.0f;
	[self _layout:duration];
	_shown = YES;
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
