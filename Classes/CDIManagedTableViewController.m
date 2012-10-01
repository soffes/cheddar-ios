//
//  CDIManagedTableViewController.m
//  Cheddar for iOS
//
//  Created by Sam Soffes on 4/10/12.
//  Copyright (c) 2012 Nothing Magical. All rights reserved.
//

#import "CDIManagedTableViewController.h"
#import "CDITableViewCell.h"
#import "UIColor+CheddariOSAdditions.h"
#import "CDILoadingView.h"

@implementation CDIManagedTableViewController {
	UITapGestureRecognizer *_tableViewTapGestureRecognizer;
	BOOL _allowScrolling;
}

@synthesize pullToRefreshView = _pullToRefreshView;
@synthesize editingIndexPath = _editingIndexPath;
@synthesize keyboardRect = _keyboardRect;
@synthesize coverView = _coverView;


- (UIView *)coverView {
	if (!_coverView) {
		CGRect frame = self.tableView.bounds;
		frame.origin.y += [CDITableViewCell cellHeight];
		frame.size.height -= [CDITableViewCell cellHeight];
		_coverView = [[UIView alloc] initWithFrame:frame];
		_coverView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleBottomMargin;
		_coverView.backgroundColor = [UIColor colorWithWhite:1.0f alpha:0.9f];
		_coverView.alpha = 0.0f;
		
		[_coverView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(coverViewTapped:)]];
		[self.tableView addSubview:_coverView];
	}
	return _coverView;
}


#pragma mark - NSObject

- (void)dealloc {
	[[NSNotificationCenter defaultCenter] removeObserver:self];

	_pullToRefreshView.delegate = nil;
	[_pullToRefreshView removeFromSuperview];
	_pullToRefreshView = nil;
}


#pragma mark - UIViewController

- (void)viewDidLoad {
	[super viewDidLoad];
	
	self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
	self.tableView.rowHeight = [CDITableViewCell cellHeight];
	
	UIView *background = [[UIView alloc] initWithFrame:CGRectZero];
	background.backgroundColor = [UIColor cheddarArchesColor];
	self.tableView.backgroundView = background;
	
	SSGradientView *footer = [[SSGradientView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, 3.0f)];
	footer.backgroundColor = [UIColor clearColor];
	footer.colors = [NSArray arrayWithObjects:
					 [UIColor colorWithWhite:0.937f alpha:1.0f],
					 [UIColor colorWithWhite:0.937f alpha:0.0f],
					 nil];
	self.tableView.tableFooterView = footer;
	
	_tableViewTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(endCellTextEditing)];
	_tableViewTapGestureRecognizer.enabled = NO;
	_tableViewTapGestureRecognizer.cancelsTouchesInView = NO;
	[self.tableView addGestureRecognizer:_tableViewTapGestureRecognizer];
	
	_pullToRefreshView = [[CDIPullToRefreshView alloc] initWithScrollView:self.tableView delegate:self];

	self.loadingView = [[CDILoadingView alloc] initWithFrame:self.view.bounds];
	self.loadingView.userInteractionEnabled = NO;
	
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHide:) name:UIKeyboardDidHideNotification object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refresh:) name:UIApplicationDidBecomeActiveNotification object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refresh:) name:kCDKCurrentUserChangedNotificationName object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityChanged:) name:kReachabilityChangedNotification object:nil];
}


- (void)setEditing:(BOOL)editing animated:(BOOL)animated {
	[super setEditing:editing animated:animated];
	_tableViewTapGestureRecognizer.enabled = editing;
	if (!editing) {
		[self endCellTextEditing];
	}
}


- (void)viewWillAppear:(BOOL)animated {
	[self refresh:nil];
	[super viewWillAppear:animated];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
	if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
		return YES;
	}
	
	return toInterfaceOrientation != UIInterfaceOrientationPortraitUpsideDown;
}


#pragma mark - SSManagedViewController

- (void)setLoading:(BOOL)loading animated:(BOOL)animated {
	[super setLoading:loading animated:animated];
	
	if (self.loading) {
		[self.pullToRefreshView startLoading];
	} else {
		[self.pullToRefreshView finishLoading];
	}
}


- (void)showLoadingView:(BOOL)animated {
	if (!self.loadingView || self.loadingView.superview) {
		return;
	}
	
	self.loadingView.alpha = 0.0f;
	self.loadingView.frame = self.view.bounds;
	[self.tableView addSubview:self.loadingView];
	
	void (^change)(void) = ^{
		self.loadingView.alpha = 1.0f;
	};
	
	
	if (animated) {
		[UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionAllowUserInteraction animations:change completion:nil];
	} else {
		change();
	}
}


- (void)showNoContentView:(BOOL)animated {
	if (!self.noContentView || self.noContentView.superview) {
		return;
	}

	self.noContentView.alpha = 0.0f;
	self.noContentView.frame = self.view.bounds;
	[self.tableView addSubview:self.noContentView];
	
	void (^change)(void) = ^{
		self.noContentView.alpha = 1.0f;
	};
	
	
	if (animated) {
		[UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionAllowUserInteraction animations:change completion:nil];
	} else {
		change();
	}
}


#pragma mark - Actions

- (void)refresh:(id)sender {
	// Subclasses should override this
}


#pragma mark - Editing

- (void)toggleEditMode:(id)sender {
	[self setEditing:!self.editing animated:YES];
}


- (void)editRow:(UIGestureRecognizer *)editingGestureRecognizer {
	CDITableViewCell *cell = (CDITableViewCell *)[self.tableView cellForRowAtIndexPath:_editingIndexPath];
	cell.editingText = NO;
	cell.textField.delegate = nil;
	
	cell = (CDITableViewCell *)editingGestureRecognizer.view;
	cell.editingText = YES;
	cell.textField.delegate = self;

	_editingIndexPath = [self.tableView indexPathForCell:cell];
}


#pragma mark - Keyboard

- (void)updateTableViewOffsets {
	CGFloat offset = self.tableView.contentOffset.y;
	CGFloat top = fminf(0.0f, offset);
	CGFloat bottom = (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) ? self.keyboardRect.size.height : 0.0f;
	self.tableView.scrollIndicatorInsets = UIEdgeInsetsMake(top, 0.0f, bottom, 0.0f);
	self.pullToRefreshView.defaultContentInset = UIEdgeInsetsMake(0.0f, 0.0f, bottom, 0.0f);
}


- (void)keyboardDidShow:(NSNotification *)notification {
	NSDictionary *userInfo = [notification userInfo];
	_keyboardRect = [self.view convertRect:[[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue] fromView:nil];
	
	_allowScrolling = YES;
	CGFloat duration = [[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
	[UIView animateWithDuration:duration delay:0.0 options:UIViewAnimationOptionAllowUserInteraction animations:^{
		[self updateTableViewOffsets];

		// TODO: Once there are flexible row heights, change this to use better calculations
		if (_editingIndexPath && _editingIndexPath.row > 2) {
			CGRect cellRect = [self.tableView rectForRowAtIndexPath:_editingIndexPath];
			CGPoint offset = cellRect.origin;
			offset.y -= 51.0f;
			[self.tableView setContentOffset:offset animated:NO];
		}
	} completion:^(BOOL finished) {
		_allowScrolling = NO;
	}];
}


- (void)keyboardDidHide:(NSNotification *)notification {
	NSDictionary *userInfo = [notification userInfo];
	_keyboardRect = CGRectZero;
	
	[UIView beginAnimations:@"hideKeyboard" context:NULL];
	[UIView setAnimationDuration:[[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue]];
	[UIView setAnimationCurve:[[userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] integerValue]];
	[self updateTableViewOffsets];
	[UIView commitAnimations];	
}


- (void)reachabilityChanged:(NSNotification *)notification {
	if ([notification.object isReachable]) {
		[self refresh:nil];
	}
}


#pragma mark - Private

- (void)endCellTextEditing {
	CDITableViewCell *cell = (CDITableViewCell *)[self.tableView cellForRowAtIndexPath:_editingIndexPath];
	cell.editingText = NO;
	cell.textField.delegate = nil;
	_editingIndexPath = nil;
}


- (void)showCoverView {
	UIView *coverView = self.coverView;
	[UIView animateWithDuration:0.2 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut | UIViewAnimationOptionAllowUserInteraction animations:^{
		coverView.alpha = 1.0f;
	} completion:nil];
}


- (BOOL)showingCoverView {
	return _coverView != nil;
}


- (void)hideCoverView {
	[UIView animateWithDuration:0.2 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut | UIViewAnimationOptionAllowUserInteraction animations:^{
		_coverView.alpha = 0.0f;
	} completion:^(BOOL finished) {
		[_coverView removeFromSuperview];
		_coverView = nil;
	}];
}


- (void)coverViewTapped:(id)sender {
	// Subclasses should override this method
}


#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
	[self updateTableViewOffsets];
	
	if (_allowScrolling) {
		return;
	}
	
	[self endCellTextEditing];
}


#pragma mark - SSPullToRefreshViewDelegate

- (void)pullToRefreshViewDidStartLoading:(SSPullToRefreshView *)view {
	[self refresh:view];
}


#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
	return NO;
}


#pragma mark - NSFetchedResultsControllerDelegate

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
	[super controllerDidChangeContent:controller];
	
	if (self.editing && !self.hasContent) {
		[self setEditing:NO animated:YES];
	}
}

@end
