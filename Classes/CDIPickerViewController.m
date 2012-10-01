//
//  CDIPickerViewController.m
//  Cheddar for iOS
//
//  Created by Sam Soffes on 7/29/12.
//  Copyright (c) 2012 Nothing Magical. All rights reserved.
//

#import "CDIPickerViewController.h"
#import "CDIGroupedTableViewCell.h"

@implementation CDIPickerViewController

#pragma mark - Accessors

@synthesize currentIndexPath = _currentIndexPath;


#pragma mark - UIViewController

- (void)viewDidLoad {
	[super viewDidLoad];
	
	NSString *selectedKey = [[self class] selectedKey];
	
	if (selectedKey != nil) {
		self.currentIndexPath = [NSIndexPath indexPathForRow:[self.keys indexOfObject:selectedKey] inSection:0];
		[self.tableView reloadData];
		[self.tableView scrollToRowAtIndexPath:self.currentIndexPath atScrollPosition:UITableViewScrollPositionMiddle animated:NO];
	}
}


#pragma mark - Picker

+ (NSString *)defaultsKey {
	return nil;
}


+ (NSString *)selectedKey {
	return [[NSUserDefaults standardUserDefaults] stringForKey:[self defaultsKey]];
}


+ (void)setSelectedKey:(NSString *)key {
	NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
	[userDefaults setObject:key forKey:[self defaultsKey]];
	[userDefaults synchronize];
}


// This method may be overridden by a subclass
- (NSString *)cellTextForKey:(id)key {
	return [[self class] textForKey:key];
}


// This method should be overridden by a subclass
- (UIImage *)cellImageForKey:(id)key {
    return nil;
}


// This method must be overridden by a subclass
- (NSArray *)keys {
	return nil;
}


// This method must be overridden by a subclass
+ (NSDictionary *)valueMap {
	return nil;
}


+ (NSString *)textForKey:(NSString *)key {
	return [[self valueMap] objectForKey:key];
}


+ (NSString *)textForSelectedKey {
	return [self textForKey:[self selectedKey]];
}


#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return (NSInteger)[self.keys count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *cellIdentifier = @"None";
	NSUInteger numberOfRows = [tableView numberOfRowsInSection:indexPath.section];
	if (numberOfRows == 1) {
		cellIdentifier = @"Both";
	} else if (indexPath.row == 0) {
		cellIdentifier = @"Top";
	} else if (indexPath.row == numberOfRows - 1) {
		cellIdentifier = @"Bottom";
	}
	
    CDIGroupedTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[CDIGroupedTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
	id key = [self.keys objectAtIndex:indexPath.row];
	cell.textLabel.text = [self cellTextForKey:key];
    cell.imageView.image = [self cellImageForKey:key];
	if([key isEqual:[[self class] selectedKey]]) {
		cell.accessoryType = UITableViewCellAccessoryCheckmark;
	} else {
		cell.accessoryType = UITableViewCellAccessoryNone;
	}
    return cell;
}


#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	[[tableView cellForRowAtIndexPath:indexPath] setAccessoryType:UITableViewCellAccessoryCheckmark];
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
	self.currentIndexPath = indexPath;
	
	[[self class] setSelectedKey:[self.keys objectAtIndex:indexPath.row]];
	[self.navigationController popViewControllerAnimated:YES];
}

@end
