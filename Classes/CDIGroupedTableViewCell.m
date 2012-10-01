//
//  CDIGroupedTableViewCell.m
//  Cheddar for iOS
//
//  Created by Sam Soffes on 7/28/12.
//  Copyright (c) 2012 Nothing Magical. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "CDIGroupedTableViewCell.h"
#import "UIColor+CheddariOSAdditions.h"
#import "UIFont+CheddariOSAdditions.h"

@interface CDIGroupedTableViewCell ()
- (void)_setupSelectedBackgroundView;
@end

@implementation CDIGroupedTableViewCell


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
	if ((self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])) {
		self.backgroundColor = [UIColor whiteColor];
		self.textLabel.font = [UIFont cheddarInterfaceFontOfSize:17.0f];
		self.textLabel.textColor = [UIColor cheddarTextColor];
		self.detailTextLabel.font = [UIFont cheddarInterfaceFontOfSize:17.0f];
		self.detailTextLabel.textColor = [UIColor cheddarBlueColor];
		
		[self _setupSelectedBackgroundView];
	}
	return self;
}


- (void)setAccessoryType:(UITableViewCellAccessoryType)accessoryType {
	if (accessoryType == UITableViewCellAccessoryDisclosureIndicator) {
		UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 10.0f, 15.0f)];
		imageView.image = [UIImage imageNamed:@"disclosure"];
		imageView.highlightedImage = [UIImage imageNamed:@"disclosure-highlighted"];
		self.accessoryView = imageView;
		return;
	} else if (accessoryType == UITableViewCellAccessoryCheckmark) {
		UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 15.0f, 12.0f)];
		imageView.image = [UIImage imageNamed:@"cell-checkmark"];
		imageView.highlightedImage = [UIImage imageNamed:@"cell-checkmark-highlighted"];
		self.accessoryView = imageView;
		return;
	}
	
	self.accessoryView = nil;
	[super setAccessoryType:accessoryType];
}


#pragma mark - Private

- (void)_setupSelectedBackgroundView {
	SSGradientView *selectedBackground = [[SSGradientView alloc] initWithFrame:CGRectZero];
	selectedBackground.colors = [[NSArray alloc] initWithObjects:
								 [UIColor colorWithRed:0.0f green:0.722f blue:0.918f alpha:1.0f],
								 [UIColor colorWithRed:0.0f green:0.631f blue:0.835f alpha:1.0f],
								 nil];
	selectedBackground.bottomBorderColor = [UIColor colorWithRed:0.0f green:0.502f blue:0.725f alpha:1.0f];
	selectedBackground.contentMode = UIViewContentModeRedraw;
	
	// Calculate corners
	UIRectCorner cornersToRound = 0;
	if ([self.reuseIdentifier isEqualToString:@"Top"]) {
		cornersToRound = (UIRectCornerTopLeft | UIRectCornerTopRight);
	}
	
	if ([self.reuseIdentifier isEqualToString:@"Bottom"]) {
		cornersToRound = (UIRectCornerBottomLeft | UIRectCornerBottomRight);
	}
	
	if ([self.reuseIdentifier isEqualToString:@"Both"]) {
		cornersToRound = UIRectCornerAllCorners;
	}
	
	// Setup rect
	CGRect rect = self.bounds;
	CGFloat cellWidth = rect.size.width;
	if (cellWidth > 480.0f) {
		cellWidth -= 60.0f;
	} else {
		cellWidth -= 18.0f;
	}
	
	CGFloat cellHeight = rect.size.height;
	if ([self.reuseIdentifier isEqualToString:@"Bottom"] || [self.reuseIdentifier isEqualToString:@"Both"]) {
		cellHeight -= 1.0;
	}
	
	CGRect cellRect = CGRectMake(rect.origin.x, rect.origin.y, cellWidth, cellHeight);
	
	// Round corners. From: http://stackoverflow.com/a/5826698
	UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:cellRect byRoundingCorners:cornersToRound
														 cornerRadii:CGSizeMake(8.0, 8.0)];
	
	// Create the shape layer and set its path
	CAShapeLayer *maskLayer = [CAShapeLayer layer];
	maskLayer.frame = cellRect;
	maskLayer.path = maskPath.CGPath;
	
	// Set the newly created shape layer as the mask for the view's layer
	selectedBackground.layer.mask = maskLayer;
	self.selectedBackgroundView = selectedBackground;
}

@end
