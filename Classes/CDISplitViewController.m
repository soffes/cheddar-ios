//
//  UISplitViewController.m
//  Cheddar for iOS
//
//  Created by Sam Soffes on 4/24/12.
//  Copyright (c) 2012 Nothing Magical. All rights reserved.
//

#import "CDISplitViewController.h"
#import "CDIListsViewController.h"
#import "CDITasksViewController.h"
#import "CDIAppDelegate.h"

@interface CDISplitViewController () <UISplitViewControllerDelegate>
@end

@implementation CDISplitViewController

@synthesize listsViewController = _listsViewController;
@synthesize listViewController = _listViewController;


#pragma mark - Class Methods

+ (CDISplitViewController *)sharedSplitViewController {
	return (CDISplitViewController *)[[[CDIAppDelegate sharedAppDelegate] window] rootViewController];
}


#pragma mark - NSObject

- (id)init {
	if ((self = [super init])) {
		_listsViewController = [[CDIListsViewController alloc] init];
		_listViewController = [[CDITasksViewController alloc] init];
		
		self.viewControllers = [[NSArray alloc] initWithObjects:
								[[UINavigationController alloc] initWithRootViewController:_listsViewController],
								[[UINavigationController alloc] initWithRootViewController:_listViewController],
								nil];
		
		self.delegate = self;
	}
	return self;
}


#pragma mark - UIViewController

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
	return YES;
}


#pragma mark - UISplitViewControllerDelegate

- (BOOL)splitViewController:(UISplitViewController *)svc shouldHideViewController:(UIViewController *)vc inOrientation:(UIInterfaceOrientation)orientation {
	return NO;
}

@end
