//
//  CDISettingsFontPickerViewController.m
//  Cheddar for iOS
//
//  Created by Sam Soffes on 7/29/12.
//  Copyright (c) 2012 Nothing Magical. All rights reserved.
//

#import "CDISettingsFontPickerViewController.h"
#import "CDISettingsViewController.h"
#import "UIFont+CheddariOSAdditions.h"
#import <SSToolkit/NSString+SSToolkitAdditions.h>

NSString *const kCDIFontDefaultsKey = @"CDIFontDefaults";
NSString *const kCDIFontGothamKey = @"Gotham";
NSString *const kCDIFontHelveticaNeueKey = @"HelveticaNeue";
NSString *const kCDIFontHoeflerKey = @"Hoefler";
NSString *const kCDIFontAvenirKey = @"Avenir";

@implementation CDISettingsFontPickerViewController

#pragma mark - Class Methods

+ (NSString *)defaultsKey {
	return kCDIFontDefaultsKey;
}


+ (NSDictionary *)valueMap {
	static NSDictionary *map = nil;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		if ([self supportsAvenir]) {
			map = [[NSDictionary alloc] initWithObjectsAndKeys:
				   @"Gotham", kCDIFontGothamKey,
				   @"Helvetica Neue", kCDIFontHelveticaNeueKey,
				   @"Hoefler", kCDIFontHoeflerKey,
				   @"Avenir", kCDIFontAvenirKey,
				   nil];
		} else {
			map = [[NSDictionary alloc] initWithObjectsAndKeys:
				   @"Gotham", kCDIFontGothamKey,
				   @"Helvetica Neue", kCDIFontHelveticaNeueKey,
				   @"Hoefler", kCDIFontHoeflerKey,
				   nil];
		}
	});
	return map;
}

- (NSArray *)keys {
	if ([[self class] supportsAvenir]) {
		return [[NSArray alloc] initWithObjects:kCDIFontGothamKey, kCDIFontHelveticaNeueKey, kCDIFontHoeflerKey, kCDIFontAvenirKey, nil];
	}
	
	return [[NSArray alloc] initWithObjects:kCDIFontGothamKey, kCDIFontHelveticaNeueKey, kCDIFontHoeflerKey, nil];
}


+ (BOOL)supportsAvenir {
	NSComparisonResult result = [[[UIDevice currentDevice] systemVersion] compareToVersionString:@"6.0"];
	return result == NSOrderedDescending || result == NSOrderedSame;
}


#pragma mark - UIViewController

- (void)viewDidLoad {
	[super viewDidLoad];
	self.title = @"Font";
}


#pragma mark - UITableViewDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	UITableViewCell *cell = [super tableView:tableView cellForRowAtIndexPath:indexPath];

	NSString *key = [[self keys] objectAtIndex:indexPath.row];
	cell.textLabel.font = [UIFont cheddarFontOfSize:18.0f fontKey:key];
	
	return cell;
}


#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	[super tableView:tableView didSelectRowAtIndexPath:indexPath];
	[[NSNotificationCenter defaultCenter] postNotificationName:kCDIFontDidChangeNotificationName object:nil];
}

@end
