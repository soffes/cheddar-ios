//
//  CDISettingsTextSizePickerViewController.m
//  Cheddar for iOS
//
//  Created by Sam Soffes on 7/29/12.
//  Copyright (c) 2012 Nothing Magical. All rights reserved.
//

#import "CDISettingsTextSizePickerViewController.h"
#import "CDISettingsViewController.h"
#import "UIFont+CheddariOSAdditions.h"
#import "UIColor+CheddariOSAdditions.h"

NSString *const kCDITextSizeDefaultsKey = @"CDITextSize";
NSString *const kCDITextSizeLargeKey = @"large";
NSString *const kCDITextSizeMediumKey = @"medium";
NSString *const kCDITextSizeSmallKey = @"small";

@implementation CDISettingsTextSizePickerViewController

#pragma mark - Class Methods


+ (CGFloat)fontSizeAdjustment {
	NSString *key = [self selectedKey];
	if ([key isEqualToString:kCDITextSizeSmallKey]) {
		return -3.0f;
	} if ([key isEqualToString:kCDITextSizeLargeKey]) {
		return 4.0f;
	}
	return 0.0f;
}


+ (NSString *)defaultsKey {
	return kCDITextSizeDefaultsKey;
}


+ (NSDictionary *)valueMap {
	static NSDictionary *map = nil;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		map = @{
	kCDITextSizeSmallKey: @"Small",
	kCDITextSizeMediumKey: @"Medium",
	kCDITextSizeLargeKey: @"Large"
		};
	});
	return map;
}

- (NSArray *)keys {
	return @[kCDITextSizeSmallKey, kCDITextSizeMediumKey, kCDITextSizeLargeKey];
}


#pragma mark - UIViewController

- (void)viewDidLoad {
	[super viewDidLoad];
	self.title = @"Text Size";
}


#pragma mark - UITableViewDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	UITableViewCell *cell = [super tableView:tableView cellForRowAtIndexPath:indexPath];

	cell.textLabel.font = [UIFont cheddarInterfaceFontOfSize:18.0f];
	cell.textLabel.textColor = [UIColor cheddarTextColor];

	return cell;
}


#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	[super tableView:tableView didSelectRowAtIndexPath:indexPath];
	[[NSNotificationCenter defaultCenter] postNotificationName:kCDIFontDidChangeNotificationName object:nil];
}

@end
