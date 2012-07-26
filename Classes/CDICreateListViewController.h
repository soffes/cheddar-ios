//
//  CDICreateListViewController.h
//  Cheddar for iOS
//
//  Created by Sam Soffes on 4/7/12.
//  Copyright (c) 2012 Nothing Magical. All rights reserved.
//

@class CDKList;

@interface CDICreateListViewController : UITableViewController

@property (nonatomic, strong) CDKList *list;

- (void)create:(id)sender;
- (void)cancel:(id)sender;

@end
