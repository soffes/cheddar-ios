//
//  CDISettingsTableViewCell.m
//  Cheddar for iOS
//
//  Created by Sam Soffes on 7/28/12.
//  Copyright (c) 2012 Nothing Magical. All rights reserved.
//

#import "CDISettingsTableViewCell.h"
#import "UIColor+CheddariOSAdditions.h"
#import "UIFont+CheddariOSAdditions.h"

@implementation CDISettingsTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
	if ((self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])) {
		self.backgroundColor = [UIColor whiteColor];
		self.textLabel.font = [UIFont cheddarFontOfSize:17.0f];
		self.textLabel.textColor = [UIColor cheddarTextColor];
		self.detailTextLabel.font = [UIFont cheddarFontOfSize:17.0f];
		self.detailTextLabel.textColor = [UIColor cheddarBlueColor];
		
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

@end
