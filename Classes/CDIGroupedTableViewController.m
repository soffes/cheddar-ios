//
//  CDIGroupedTableViewController.m
//  Cheddar for iOS
//
//  Created by Sam Soffes on 7/29/12.
//  Copyright (c) 2012 Nothing Magical. All rights reserved.
//

#import "CDIGroupedTableViewController.h"
#import "UIColor+CheddariOSAdditions.h"
#import "UIFont+CheddariOSAdditions.h"

@implementation CDIGroupedTableViewController {
	NSCache *_headerCache;
}

#pragma mark - NSObject

- (id)init {
	return (self = [super initWithStyle:UITableViewStyleGrouped]);
}


#pragma mark - UIViewController

- (void)viewDidLoad {
	[super viewDidLoad];
	
	UIView *background = [[UIView alloc] initWithFrame:CGRectZero];
	background.backgroundColor = [UIColor cheddarArchesColor];
	self.tableView.backgroundView = background;
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
	if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
		return YES;
	}
	
	return toInterfaceOrientation != UIInterfaceOrientationPortraitUpsideDown;
}


#pragma mark - UITableViewDelegate

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {	
	if (!_headerCache) {
		_headerCache = [[NSCache alloc] init];
	}
	
	NSNumber *key = [NSNumber numberWithInteger:section];
	SSLabel *label = [_headerCache objectForKey:key];
	if (!label) {
		NSString *text = [self tableView:tableView titleForHeaderInSection:section];
		if (!text) {
			return nil;
		}
		
		CGFloat x = UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ? 40.0f : 20.0f;
		label = [[SSLabel alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.view.frame.size.width, 44.0f)];
		label.textEdgeInsets = UIEdgeInsetsMake(10.0f, x, 0.0f, 0.0f);
		label.autoresizingMask = UIViewAutoresizingFlexibleWidth;
		label.backgroundColor = [UIColor clearColor];
		label.textColor = [UIColor cheddarTextColor];
		label.font = [UIFont boldCheddarInterfaceFontOfSize:17.0f];
		label.shadowColor = [UIColor whiteColor];
		label.shadowOffset = CGSizeMake(0.0f, 1.0f);
		label.text = text;
		[_headerCache setObject:label forKey:key];
	}
	
	return label;
}

@end
