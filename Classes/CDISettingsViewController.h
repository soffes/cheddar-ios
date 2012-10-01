//
//  CDISettingsViewController.h
//  Cheddar for iOS
//
//  Created by Sam Soffes on 4/20/12.
//  Copyright (c) 2012 Nothing Magical. All rights reserved.
//

#import "CDIGroupedTableViewController.h"

extern NSString *const kCDIFontDidChangeNotificationName;

@interface CDISettingsViewController : CDIGroupedTableViewController

- (void)close:(id)sender;
- (void)upgrade:(id)sender;
- (void)signOut:(id)sender;

@end
