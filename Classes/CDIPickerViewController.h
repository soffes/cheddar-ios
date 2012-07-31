//
//  CDIPickerViewController.h
//  Cheddar for iOS
//
//  Created by Sam Soffes on 7/29/12.
//  Copyright (c) 2012 Nothing Magical. All rights reserved.
//

#import "CDIGroupedTableViewController.h"

@interface CDIPickerViewController : CDIGroupedTableViewController

@property (nonatomic, strong) NSIndexPath *currentIndexPath;

+ (NSString *)defaultsKey;
+ (NSString *)selectedKey;
+ (void)setSelectedKey:(NSString *)key;
+ (NSDictionary *)valueMap;
+ (NSString *)textForKey:(NSString *)key;
+ (NSString *)textForSelectedKey;

- (NSArray *)keys;
- (NSString *)cellTextForKey:(id)key;
- (UIImage *)cellImageForKey:(id)key;

@end
