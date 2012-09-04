//
//  CDITasksViewController.h
//  Cheddar for iOS
//
//  Created by Sam Soffes on 3/31/12.
//  Copyright (c) 2012 Nothing Magical. All rights reserved.
//

#import "CDIManagedTableViewController.h"

@class CDKList;
@class CDKTag;

@interface CDITasksViewController : CDIManagedTableViewController

@property (nonatomic, strong, readonly) CDKList *list;
@property (nonatomic, assign) BOOL focusKeyboard;

- (void)addTag:(CDKTag *)tag;
- (void)closeTags;

@end
