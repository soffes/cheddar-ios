//
//  CDISettingsTapPickerViewController.m
//  Cheddar for iOS
//
//  Created by Sam Soffes on 7/29/12.
//  Copyright (c) 2012 Nothing Magical. All rights reserved.
//

#import "CDISettingsTapPickerViewController.h"

@implementation CDISettingsTapPickerViewController

#pragma mark - Class Methods

+ (NSString *)defaultsKey {
	static NSString *key = @"CDISettingTapAction";
	return key;
}


+ (NSString *)selectedKey {
	return [[NSUserDefaults standardUserDefaults] stringForKey:[self defaultsKey]];
}


+ (void)setSelectedKey:(NSString *)key {
	[[NSUserDefaults standardUserDefaults] setObject:key forKey:[self defaultsKey]];
}

+ (NSDictionary *)valueMap {
	static NSDictionary *map = nil;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		map = [[NSDictionary alloc] initWithObjectsAndKeys:
			   @"Nothing", @"nothing",
			   @"Complete", @"complete",
			   @"Edit", @"edit",
			   nil];
	});
	return map;
}


+ (NSString *)textForKey:(NSString *)key {
	return [[self valueMap] objectForKey:key];
}


#pragma mark - UIViewController

- (void)viewDidLoad {
	[super viewDidLoad];
	self.title = @"Tap Action";
}



#pragma mark - CDIPickerViewController

- (void)loadKeys {
	self.keys = [[NSArray alloc] initWithObjects:@"nothing", @"complete", @"edit", nil];
	self.selectedKey = [[self class] selectedKey];
}


- (NSString *)cellTextForKey:(id)key {
	return [[self class] textForKey:key];
}


#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	[super tableView:tableView didSelectRowAtIndexPath:indexPath];
	
	// Notify the parent view controller of the change
//	SCPickerDemoViewController *viewController = (SCPickerDemoViewController *)[self.navigationController.viewControllers objectAtIndex:([self.navigationController.viewControllers count] - 2)];
//	viewController.selectedAbbreviation = [self.keys objectAtIndex:indexPath.row];
	
	[[self class] setSelectedKey:[self.keys objectAtIndex:indexPath.row]];
	[self.navigationController popViewControllerAnimated:YES];
}


@end
