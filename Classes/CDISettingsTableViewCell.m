//
//  CDISettingsTableViewCell.m
//  Cheddar for iOS
//
//  Created by Sam Soffes on 7/28/12.
//  Copyright (c) 2012 Nothing Magical. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "CDISettingsTableViewCell.h"
#import "UIColor+CheddariOSAdditions.h"
#import "UIFont+CheddariOSAdditions.h"

@implementation CDISettingsTableViewCell

@synthesize _cellIdentifier;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
	if ((self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])) {
		self._cellIdentifier = reuseIdentifier;
		
		self.backgroundColor = [UIColor whiteColor];
		self.textLabel.font = [UIFont cheddarFontOfSize:17.0f];
		self.textLabel.textColor = [UIColor cheddarTextColor];
		self.detailTextLabel.font = [UIFont cheddarFontOfSize:17.0f];
		self.detailTextLabel.textColor = [UIColor cheddarBlueColor];
		
		UIImageView *disclosureImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 10.0f, 15.0f)];
		disclosureImageView.image = [UIImage imageNamed:@"disclosure.png"];
		self.accessoryView = disclosureImageView;
		
		disclosureImageView.highlightedImage = [UIImage imageNamed:@"disclosure-highlighted.png"];
		SSGradientView *selectedBackground = [[SSGradientView alloc] initWithFrame:CGRectZero];
		selectedBackground.colors = [[NSArray alloc] initWithObjects:
									 [UIColor colorWithRed:0.0f green:0.722f blue:0.918f alpha:1.0f],
									 [UIColor colorWithRed:0.0f green:0.631f blue:0.835f alpha:1.0f],
									 nil];
		selectedBackground.bottomBorderColor = [UIColor colorWithRed:0.0f green:0.502f blue:0.725f alpha:1.0f];
		selectedBackground.contentMode = UIViewContentModeRedraw;
		self.selectedBackgroundView = selectedBackground;
	}
	return self;
}

- (void)drawRect:(CGRect)rect {
	if (![self._cellIdentifier hasSuffix:@"None"]) {
		UIView *selectedBackground = self.selectedBackgroundView;
		
		UIRectCorner cornersToRound;
		if ([self._cellIdentifier hasSuffix:@"Top"]) cornersToRound = (UIRectCornerTopLeft | UIRectCornerTopRight);
		if ([self._cellIdentifier hasSuffix:@"Bottom"]) cornersToRound = (UIRectCornerBottomLeft | UIRectCornerBottomRight);
		if ([self._cellIdentifier hasSuffix:@"Both"]) cornersToRound = UIRectCornerAllCorners;
		
		float cellWidth = rect.size.width;
		if (cellWidth > 480.0) cellWidth -= 60.0;
		else cellWidth -= 18.0;
		
		float cellHeight = rect.size.height;
		if ([self._cellIdentifier hasSuffix:@"Bottom"] || [self._cellIdentifier hasSuffix:@"Both"]) cellHeight -= 1.0;
		
		CGRect cellRect = CGRectMake(rect.origin.x, rect.origin.y, cellWidth, cellHeight);
		
		/* Rounding corners adapted from: http://stackoverflow.com/a/5826698 */
		// Create the path
		UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:cellRect
													   byRoundingCorners:cornersToRound
															 cornerRadii:CGSizeMake(10.0, 10.0)];
		
		// Create the shape layer and set its path
		CAShapeLayer *maskLayer = [CAShapeLayer layer];
		maskLayer.frame = cellRect;
		maskLayer.path = maskPath.CGPath;
		
		// Set the newly created shape layer as the mask for the view's layer
		selectedBackground.layer.mask = maskLayer;
		self.selectedBackgroundView = selectedBackground;
	}
	[super drawRect:rect];
}

@end
