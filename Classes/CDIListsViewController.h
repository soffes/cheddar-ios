//
//  CDIListsViewController.h
//  Cheddar for iOS
//
//  Created by Sam Soffes on 3/30/12.
//  Copyright (c) 2012 Nothing Magical. All rights reserved.
//

#import "CDIManagedTableViewController.h"

extern NSString *const kCDISelectedListKey;

@interface CDIListsViewController : CDIManagedTableViewController

- (void)showSettings:(id)sender;
- (void)createList:(id)sender;

@end
