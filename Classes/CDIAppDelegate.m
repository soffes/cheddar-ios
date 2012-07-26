//
//  CDIAppDelegate.m
//  Cheddar for iOS
//
//  Created by Sam Soffes on 3/25/12.
//  Copyright (c) 2012 Nothing Magical. All rights reserved.
//

#import "CDIAppDelegate.h"
#import "CDISplitViewController.h"
#import "CDIListsViewController.h"
#import "CDITransactionObserver.h"
#import "CDIDefines.h"
#import "UIFont+Cheddar.h"
#import "LocalyticsUtilities.h"
#import <Crashlytics/Crashlytics.h>
#import <StoreKit/StoreKit.h>

@implementation CDIAppDelegate

@synthesize window = _window;


+ (CDIAppDelegate *)sharedAppDelegate {
	return (CDIAppDelegate *)[[UIApplication sharedApplication] delegate];
}


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
	// Configure analytics
#if CHEDDAR_PRODUCTION_MODE
	#ifdef CHEDDAR_CRASHLYTICS_KEY
	[Crashlytics startWithAPIKey:CHEDDAR_CRASHLYTICS_KEY];
	#endif

	#ifdef CHEDDAR_LOCALYTICS_KEY
	LLStartSession(CHEDDAR_LOCALYTICS_KEY);
	#endif
#endif
	
	// Optionally enable development mode
#ifdef CHEDDAR_API_DEVELOPMENT_MODE
	[CDKHTTPClient setDevelopmentMode:YES];
	[CDKPushController setDevelopmentMode:YES];
#endif
	
	// Initialize the window
	self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
	self.window.backgroundColor = [UIColor blackColor];
	
	[[self class] applyStylesheet];
	
	if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
		self.window.rootViewController = [[CDISplitViewController alloc] init];
		[self.window makeKeyAndVisible];
	} else {
		UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:[[CDIListsViewController alloc] init]];
		self.window.rootViewController = navigationController;
		[self.window makeKeyAndVisible];
		
		UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0f, 20.0f, 5.0f, 5.0f)];
		imageView.image = [UIImage imageNamed:@"corner-tl.png"];
		[self.window addSubview:imageView];
		
		imageView = [[UIImageView alloc] initWithFrame:CGRectMake(315.0f, 20.0f, 5.0f, 5.0f)];
		imageView.image = [UIImage imageNamed:@"corner-tr.png"];
		[self.window addSubview:imageView];
		
		imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, 475.0f, 5.0f, 5.0f)];
		imageView.image = [UIImage imageNamed:@"corner-bl.png"];
		[self.window addSubview:imageView];
		
		imageView = [[UIImageView alloc] initWithFrame:CGRectMake(315, 475.0f, 5.0f, 5.0f)];
		imageView.image = [UIImage imageNamed:@"corner-br.png"];
		[self.window addSubview:imageView];
	}
	
	// Defer some stuff to make launching faster
	dispatch_async(dispatch_get_main_queue(), ^{
		// Setup status bar network indicator
		[AFNetworkActivityIndicatorManager sharedManager].enabled = YES;
		
		// Set the OAuth client
		[[CDKHTTPClient sharedClient] setClientID:kCDIAPIClientID secret:kCDIAPIClientSecret];
		
		// Initialize the connection to Pusher		
		[CDKPushController sharedController];
		
		// Add the transaction observer
		[[SKPaymentQueue defaultQueue] addTransactionObserver:[CDITransactionObserver defaultObserver]];
	});

	return YES;
}


#if ANALYTICS_ENABLED
- (void)applicationWillEnterForeground:(UIApplication *)application {
    [[LocalyticsSession sharedLocalyticsSession] resume];
    [[LocalyticsSession sharedLocalyticsSession] upload];
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    [[LocalyticsSession sharedLocalyticsSession] close];
    [[LocalyticsSession sharedLocalyticsSession] upload];
}
#endif


- (void)applicationWillTerminate:(UIApplication *)application {
	[[SSManagedObject mainContext] save:nil];
	#if ANALYTICS_ENABLED
    [[LocalyticsSession sharedLocalyticsSession] close];
	#endif
}


+ (void)applyStylesheet {
	// Navigation bar
	id navigationBar = [UINavigationBar appearance];
	[navigationBar setBackgroundImage:[UIImage imageNamed:@"nav-background.png"] forBarMetrics:UIBarMetricsDefault];
	[navigationBar setTitleVerticalPositionAdjustment:-1.0f forBarMetrics:UIBarMetricsDefault];
	[navigationBar setTitleTextAttributes:[[NSDictionary alloc] initWithObjectsAndKeys:
										   [UIFont cheddarFontOfSize:22.0f], UITextAttributeFont,
										   [UIColor colorWithWhite:0.0f alpha:0.2f], UITextAttributeTextShadowColor,
										   [NSValue valueWithUIOffset:UIOffsetMake(0.0f, 1.0f)], UITextAttributeTextShadowOffset,
										   [UIColor whiteColor], UITextAttributeTextColor,
										   nil]];
	
	// Navigation bar button
	NSDictionary *barButtonTitleTextAttributes = [[NSDictionary alloc] initWithObjectsAndKeys:
												  [UIFont cheddarFontOfSize:14.0f], UITextAttributeFont,
												  [UIColor colorWithWhite:0.0f alpha:0.2f], UITextAttributeTextShadowColor,
												  [NSValue valueWithUIOffset:UIOffsetMake(0.0f, 1.0f)], UITextAttributeTextShadowOffset,
												  nil];
	id barButton = [UIBarButtonItem appearanceWhenContainedIn:[UINavigationBar class], nil];
	[barButton setBackButtonTitlePositionAdjustment:UIOffsetMake(1.0f, -2.0f) forBarMetrics:UIBarMetricsDefault];
	[barButton setTitlePositionAdjustment:UIOffsetMake(0.0f, 1.0f) forBarMetrics:UIBarMetricsDefault];
	[barButton setTitleTextAttributes:barButtonTitleTextAttributes forState:UIControlStateNormal];
	[barButton setTitleTextAttributes:barButtonTitleTextAttributes forState:UIControlStateHighlighted];
	[barButton setBackButtonBackgroundImage:[[UIImage imageNamed:@"nav-back.png"] stretchableImageWithLeftCapWidth:13 topCapHeight:0] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
	[barButton setBackButtonBackgroundImage:[[UIImage imageNamed:@"nav-back-highlighted.png"] stretchableImageWithLeftCapWidth:13 topCapHeight:0] forState:UIControlStateHighlighted barMetrics:UIBarMetricsDefault];
	[barButton setBackgroundImage:[[UIImage imageNamed:@"nav-button.png"] stretchableImageWithLeftCapWidth:6 topCapHeight:0] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
	[barButton setBackgroundImage:[[UIImage imageNamed:@"nav-button-highlighted.png"] stretchableImageWithLeftCapWidth:6 topCapHeight:0] forState:UIControlStateHighlighted barMetrics:UIBarMetricsDefault];
}

@end
