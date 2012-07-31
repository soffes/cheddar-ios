//
//  CDISettingsTapPickerViewController.m
//  Cheddar for iOS
//
//  Created by Sam Soffes on 7/29/12.
//  Copyright (c) 2012 Nothing Magical. All rights reserved.
//

#import "CDISettingsTapPickerViewController.h"

NSString *const kCDITapActionDefaultsKey = @"CDITapActionDefaults";
NSString *const kCDITapActionNothingKey = @"CDITapActionNothing";
NSString *const kCDITapActionCompleteKey = @"CDITapActionComplete";
NSString *const kCDITapActionEditKey = @"CDITapActionEdit";

@implementation CDISettingsTapPickerViewController

#pragma mark - Class Methods

+ (NSString *)defaultsKey {
	return kCDITapActionDefaultsKey;
}


+ (NSDictionary *)valueMap {
	static NSDictionary *map = nil;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		map = [[NSDictionary alloc] initWithObjectsAndKeys:
			   @"Nothing", kCDITapActionNothingKey,
			   @"Complete", kCDITapActionCompleteKey,
			   @"Edit", kCDITapActionEditKey,
			   nil];
	});
	return map;
}


+ (NSString *)textForKey:(NSString *)key {
	return [[self valueMap] objectForKey:key];
}


- (NSArray *)keys {
	return [[NSArray alloc] initWithObjects:kCDITapActionNothingKey, kCDITapActionCompleteKey, kCDITapActionEditKey, nil];
}


#pragma mark - UIViewController

- (void)viewDidLoad {
	[super viewDidLoad];
	self.title = @"Tap Action";
}



#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	[super tableView:tableView didSelectRowAtIndexPath:indexPath];
	
	// Notify the parent view controller of the change
//	SCPickerDemoViewController *viewController = (SCPickerDemoViewController *)[self.navigationController.viewControllers objectAtIndex:([self.navigationController.viewControllers count] - 2)];
//	viewController.selectedAbbreviation = [self.keys objectAtIndex:indexPath.row];
}

@end
