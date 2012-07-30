//
//  CDIPickerViewController.h
//  Cheddar for iOS
//
//  Created by Sam Soffes on 7/29/12.
//  Copyright (c) 2012 Nothing Magical. All rights reserved.
//

#import "CDIGroupedTableViewController.h"

@interface CDIPickerViewController : CDIGroupedTableViewController

@property (nonatomic, strong) NSArray *keys;
@property (nonatomic, strong) id selectedKey;
@property (nonatomic, strong) NSIndexPath *currentIndexPath;

- (void)loadKeys;
- (NSString *)cellTextForKey:(id)key;
- (UIImage *)cellImageForKey:(id)key;

@end
