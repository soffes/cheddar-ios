//
//  CDISettingsTapPickerViewController.m
//  Cheddar for iOS
//
//  Created by Sam Soffes on 7/29/12.
//  Copyright (c) 2012 Nothing Magical. All rights reserved.
//

#import "CDISettingsTapPickerViewController.h"
#import "UIColor+CheddariOSAdditions.h"
#import "UIFont+CheddariOSAdditions.h"

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


- (NSArray *)keys {
	return [[NSArray alloc] initWithObjects:kCDITapActionNothingKey, kCDITapActionCompleteKey, kCDITapActionEditKey, nil];
}


#pragma mark - UIViewController

- (void)viewDidLoad {
	[super viewDidLoad];
	self.title = @"Tap Action";

	SSLabel *footer = [[SSLabel alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.view.frame.size.width, 80.0f)];
	CGFloat inset = UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone ? 10.0f : 30.0f;
	footer.textEdgeInsets = UIEdgeInsetsMake(0.0f, inset, 0.0f, inset);
	footer.verticalTextAlignment = SSLabelVerticalTextAlignmentTop;
	footer.backgroundColor = [UIColor clearColor];
	footer.textColor = [UIColor cheddarLightTextColor];
	footer.font = [UIFont cheddarInterfaceFontOfSize:14.0f];
	footer.textAlignment = UITextAlignmentCenter;
	footer.numberOfLines = 0;
	footer.text = @"Change what action tapping a task preforms. Tapping the checkbox will always toggle completion.";
	self.tableView.tableFooterView = footer;
}

@end
