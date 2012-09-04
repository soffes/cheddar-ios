//
//  UISplitViewController.h
//  Cheddar for iOS
//
//  Created by Sam Soffes on 4/24/12.
//  Copyright (c) 2012 Nothing Magical. All rights reserved.
//

@class CDIListsViewController;
@class CDITasksViewController;

@interface CDISplitViewController : UISplitViewController

+ (CDISplitViewController *)sharedSplitViewController;

@property (nonatomic, strong, readonly) CDIListsViewController *listsViewController;
@property (nonatomic, strong, readonly) CDITasksViewController *listViewController;

@end
