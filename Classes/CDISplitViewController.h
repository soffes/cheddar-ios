//
//  UISplitViewController.h
//  Cheddar for iOS
//
//  Created by Sam Soffes on 4/24/12.
//  Copyright (c) 2012 Nothing Magical. All rights reserved.
//

@class CDIListsViewController;
@class CDIListViewController;

@interface CDISplitViewController : UISplitViewController

+ (CDISplitViewController *)sharedSplitViewController;

@property (nonatomic, strong, readonly) CDIListsViewController *listsViewController;
@property (nonatomic, strong, readonly) CDIListViewController *listViewController;

@end
