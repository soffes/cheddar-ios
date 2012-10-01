//
//  CDIUpgradeViewController.m
//  Cheddar for iOS
//
//  Created by Sam Soffes on 5/16/12.
//  Copyright (c) 2012 Nothing Magical. All rights reserved.
//

#import "CDIUpgradeViewController.h"
#import "CDIHUDView.h"
#import "UIColor+CheddariOSAdditions.h"
#import "UIFont+CheddariOSAdditions.h"
#import "UIButton+CheddariOSAdditions.h"
#import "TTTAttributedLabel.h"
#import <QuartzCore/QuartzCore.h>
#import <StoreKit/StoreKit.h>
#import "CDITransactionObserver.h"

@interface CDIUpgradeViewController ()
- (void)_purchaseProductIdentifier:(NSString *)identifier;
- (void)_animateView:(UIView *)view xDisplacement:(CGFloat)displacement delay:(NSTimeInterval)delay;
@end

@implementation CDIUpgradeViewController {
	BOOL _animating;
	BOOL _purchasing;
	UIButton *_laterButton;
	UIButton *_upgradeButton;
	UIButton *_restoreButton;
}


#pragma mark - UIViewController

- (void)viewDidLoad {
	[super viewDidLoad];
	
	self.title = @"Plus Required";
	self.view.backgroundColor = [UIColor cheddarArchesColor];
//	self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Restore" style:UIBarButtonItemStyleBordered target:self action:@selector(restore:)];
	
	CGFloat width = self.view.frame.size.width;
	
	TTTAttributedLabel *label = [[TTTAttributedLabel alloc] initWithFrame:CGRectMake(20.0f, 10.0f, width - 40.0f, 300.0f)];
	label.autoresizingMask = UIViewAutoresizingFlexibleWidth;
	label.backgroundColor = [UIColor clearColor];
	label.font = [UIFont cheddarInterfaceFontOfSize:18.0f];
	label.numberOfLines = 0;
	label.textColor = [UIColor cheddarTextColor];
	label.verticalAlignment = TTTAttributedLabelVerticalAlignmentTop;
	NSString *text = @"You need Cheddar Plus to create more than 2 lists. Upgrading only takes a minute.\n\nWith a Plus account, you can create unlimited lists. You only get two lists with a free account.";
	[label setText:text afterInheritingLabelAttributesAndConfiguringWithBlock:^NSMutableAttributedString *(NSMutableAttributedString *mutableAttributedString) {
		CTFontRef boldFont = CTFontCreateWithName((__bridge CFStringRef)kCDIBoldFontName, 20.0f, NULL);
		if (boldFont) {
			[mutableAttributedString addAttribute:(__bridge NSString *)kCTFontAttributeName value:(__bridge id)boldFont range:NSMakeRange(119, 15)];
			CFRelease(boldFont);
		}
		
		[mutableAttributedString addAttribute:(__bridge NSString *)kCTForegroundColorAttributeName value:(__bridge id)[UIColor cheddarLightTextColor].CGColor range:NSMakeRange(136, 43)];
		
		return mutableAttributedString;
	}];
	[self.view addSubview:label];
	
	CGFloat vOffset = UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ? 30.0f : 0.0f;
	
	_laterButton = [UIButton cheddarBigGrayButton];
	_laterButton.frame = CGRectMake(roundf((width - 280.0f) / 2.0f), 292.0f + vOffset, 280.0f, 45.0f);
	_laterButton.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
	[_laterButton setTitle:@"Later" forState:UIControlStateNormal];
	[_laterButton addTarget:self action:@selector(cancel:) forControlEvents:UIControlEventTouchUpInside];
	[self.view addSubview:_laterButton];
	
	_upgradeButton = [UIButton cheddarBigOrangeButton];
	_upgradeButton.frame = CGRectMake(roundf((width - 280.0f) / 2.0f), 346.0f + vOffset, 280.0f, 45.0f);
	_upgradeButton.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
	[_upgradeButton setTitle:@"Upgrade Now" forState:UIControlStateNormal];
	[_upgradeButton addTarget:self action:@selector(upgrade:) forControlEvents:UIControlEventTouchUpInside];
	[self.view addSubview:_upgradeButton];
}


- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];

	if (!_restoreButton) {
		CGFloat width = self.view.bounds.size.width;
		CGFloat hOffset = UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ? 2.0f : 0.0f;
		_restoreButton = [UIButton cheddarBarButton];
		_restoreButton.frame = CGRectMake(width - 79.0f - hOffset, 7.0f, 74.0f, 30.0f);
		_restoreButton.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleBottomMargin;
		[_restoreButton setTitle:@"Restore" forState:UIControlStateNormal];
		[_restoreButton addTarget:self action:@selector(restore:) forControlEvents:UIControlEventTouchUpInside];
		[self.navigationController.navigationBar addSubview:_restoreButton];
	}
}


- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
	[[CDITransactionObserver defaultObserver] updateProducts];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
	if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
		return YES;
	}
	
	return toInterfaceOrientation == UIInterfaceOrientationPortrait;
}


- (NSUInteger)supportedInterfaceOrientations {
	if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
		return UIInterfaceOrientationMaskAll;
	}

	return UIInterfaceOrientationMaskPortrait;
}


#pragma mark - Actions

- (void)cancel:(id)sender {
	[self.navigationController dismissModalViewControllerAnimated:YES];
}


- (void)upgrade:(id)sender {
	if (_animating) {
		return;
	}
	_animating = YES;
	
	CGFloat width = self.view.frame.size.width;
	CGFloat x = roundf((width - 280.0f) / 2.0f);
	CGFloat offset = UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ? 30.0f : 0.0f;
	
	// Setup new buttons
	UIButton *threeMonthsButton = [UIButton cheddarBigGrayButton];
	threeMonthsButton.frame = CGRectMake(-280.0f, 292.0f + offset, 280.0f, 45.0f);
	[threeMonthsButton setTitle:@"3 months for $5.99" forState:UIControlStateNormal];
	[threeMonthsButton addTarget:self action:@selector(buyThreeMonths:) forControlEvents:UIControlEventTouchUpInside];
	[self.view addSubview:threeMonthsButton];

	UIButton *yearButton = [UIButton cheddarBigOrangeButton];
	yearButton.frame = CGRectMake(-280.0f, 346.0f + offset, 280.0f, 45.0f);
	[yearButton setTitle:@"1 year for $19.99" forState:UIControlStateNormal];
	[yearButton addTarget:self action:@selector(buyOneYear:) forControlEvents:UIControlEventTouchUpInside];
	[self.view addSubview:yearButton];
	
	UIButton *cancelButton = [UIButton cheddarBarButton];
	cancelButton.frame = CGRectMake(-63.0f, 7.0f, 63.0f, 30.0f);
	[cancelButton setTitle:@"Cancel" forState:UIControlStateNormal];
	[cancelButton addTarget:self action:@selector(cancel:) forControlEvents:UIControlEventTouchUpInside];
	[self.navigationController.navigationBar addSubview:cancelButton];
	
	NSTimeInterval step = 0.1;
	CGFloat displacement = x + 280.0f;
	CGFloat extraDisplacement = UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ? 7.0f : 5.0f;
	CGFloat cancelDisplacement = cancelButton.frame.size.width + extraDisplacement;
	CGFloat restoreDisplacement = _restoreButton.frame.size.width + extraDisplacement;
	
	[self _animateView:_laterButton xDisplacement:displacement delay:0.0];
	[self _animateView:_upgradeButton xDisplacement:displacement delay:step];
	[self _animateView:threeMonthsButton xDisplacement:displacement delay:(step * 2.0)];
	[self _animateView:yearButton xDisplacement:displacement delay:(step * 3.0)];
	[self _animateView:cancelButton xDisplacement:cancelDisplacement delay:(step * 3.0)];
	[self _animateView:_restoreButton xDisplacement:restoreDisplacement delay:0.0];
}


- (void)buyThreeMonths:(id)sender {
	[self _purchaseProductIdentifier:@"cheddar_plus_3mo"];
}


- (void)buyOneYear:(id)sender {
	[self _purchaseProductIdentifier:@"cheddar_plus_1yr"];
}


- (void)restore:(id)sender {
	[[SKPaymentQueue defaultQueue] restoreCompletedTransactions];
}


#pragma mark - Private

- (void)_purchaseProductIdentifier:(NSString *)identifier {
	if (_purchasing) {
		return;
	}
	_purchasing = YES;
	
	CDIHUDView *hud = [[CDIHUDView alloc] initWithTitle:@"Upgrading..."];
	[hud show];
	
	NSDictionary *products = [[CDITransactionObserver defaultObserver] products];
	SKProduct *product = [products objectForKey:identifier];
	
	if (!product) {
		// TODO: Handle
		NSLog(@"Unknown product");
	}
	
	SKPayment *payment = [SKPayment paymentWithProduct:product];
	[[SKPaymentQueue defaultQueue] addPayment:payment];
	
	__weak NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
	[notificationCenter addObserverForName:kCDIPaymentTransactionDidCompleteNotificationName object:nil queue:nil usingBlock:^(NSNotification *notificaiton) {
		[hud dismiss];
		_purchasing = NO;
		[self.navigationController dismissModalViewControllerAnimated:YES];
		[notificationCenter removeObserver:self];
	}];
	
	[notificationCenter addObserverForName:kCDIPaymentTransactionDidFailNotificationName object:nil queue:nil usingBlock:^(NSNotification *notificaiton) {
		[hud failAndDismissWithTitle:@"Failed"];
		[notificationCenter removeObserver:self];
		_purchasing = NO;
	}];

	[notificationCenter addObserverForName:kCDIPaymentTransactionDidCancelNotificationName object:nil queue:nil usingBlock:^(NSNotification *notificaiton) {
		[hud dismiss];
		[notificationCenter removeObserver:self];
		_purchasing = NO;
	}];
}


- (void)_animateView:(UIView *)view xDisplacement:(CGFloat)c delay:(NSTimeInterval)delay {
	[UIView animateWithDuration:0.4 delay:delay options:UIViewAnimationOptionAllowUserInteraction animations:^{
		CGRect frame = view.frame;
		frame.origin.x += c;
		view.frame = frame;
	} completion:nil];
}

@end
