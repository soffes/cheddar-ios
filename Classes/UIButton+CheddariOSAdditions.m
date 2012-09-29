//
//  UIButton+CheddariOSAdditions.m
//  Cheddar for iOS
//
//  Created by Sam Soffes on 5/16/12.
//  Copyright (c) 2012 Nothing Magical. All rights reserved.
//

#import "UIButton+CheddariOSAdditions.h"
#import "UIFont+CheddariOSAdditions.h"
#import "UIColor+CheddariOSAdditions.h"

@implementation UIButton (CheddariOSAdditions)

+ (UIButton *)cheddarBigButton {
	UIButton *button = [[self alloc] initWithFrame:CGRectZero];
	[button setBackgroundImage:[[UIImage imageNamed:@"big-button"] stretchableImageWithLeftCapWidth:6 topCapHeight:0] forState:UIControlStateNormal];
	[button setBackgroundImage:[[UIImage imageNamed:@"big-button-highlighted"] stretchableImageWithLeftCapWidth:6 topCapHeight:0] forState:UIControlStateHighlighted];
	[button setTitleColor:[UIColor colorWithRed:0.384 green:0.412 blue:0.455 alpha:1] forState:UIControlStateNormal];
	[button setTitleShadowColor:[UIColor whiteColor] forState:UIControlStateNormal];
	button.titleLabel.shadowOffset = CGSizeMake(0.0f, 1.0f);
	button.titleLabel.font = [UIFont cheddarInterfaceFontOfSize:18.0f];
	return button;
}


+ (UIButton *)cheddarBigOrangeButton {
	UIButton *button = [[self alloc] initWithFrame:CGRectZero];
	[button setBackgroundImage:[[UIImage imageNamed:@"big-orange-button"] stretchableImageWithLeftCapWidth:5 topCapHeight:0] forState:UIControlStateNormal];
	[button setBackgroundImage:[[UIImage imageNamed:@"big-orange-button-highlighted"] stretchableImageWithLeftCapWidth:5 topCapHeight:0] forState:UIControlStateHighlighted];
	[button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
	[button setTitleShadowColor:[UIColor colorWithWhite:0.0f alpha:0.2f] forState:UIControlStateNormal];
	button.titleLabel.font = [UIFont cheddarInterfaceFontOfSize:20.0f];
	button.titleLabel.shadowOffset = CGSizeMake(0.0f, 1.0f);
	button.titleEdgeInsets = UIEdgeInsetsMake(-1.0f, 0.0f, 0.0f, 0.0f);
	return button;
}


+ (UIButton *)cheddarBigGrayButton {
	UIButton *button = [[self alloc] initWithFrame:CGRectZero];
	[button setBackgroundImage:[[UIImage imageNamed:@"big-gray-button"] stretchableImageWithLeftCapWidth:5 topCapHeight:0] forState:UIControlStateNormal];
	[button setBackgroundImage:[[UIImage imageNamed:@"big-gray-button-highlighted"] stretchableImageWithLeftCapWidth:5 topCapHeight:0] forState:UIControlStateHighlighted];
	[button setTitleColor:[UIColor cheddarSteelColor] forState:UIControlStateNormal];
	[button setTitleShadowColor:[UIColor whiteColor] forState:UIControlStateNormal];
	button.titleLabel.font = [UIFont cheddarInterfaceFontOfSize:20.0f];
	button.titleLabel.shadowOffset = CGSizeMake(0.0f, 1.0f);
	button.titleEdgeInsets = UIEdgeInsetsMake(-1.0f, 0.0f, 0.0f, 0.0f);
	return button;
}


+ (UIButton *)cheddarBarButton {
	UIButton *button = [[self alloc] initWithFrame:CGRectZero];
	[button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
	[button setTitleShadowColor:[UIColor colorWithWhite:0.0f alpha:0.2f] forState:UIControlStateNormal];
	[button setBackgroundImage:[[UIImage imageNamed:@"nav-button"] stretchableImageWithLeftCapWidth:6 topCapHeight:0] forState:UIControlStateNormal];
	[button setBackgroundImage:[[UIImage imageNamed:@"nav-button-highlighted"] stretchableImageWithLeftCapWidth:6 topCapHeight:0] forState:UIControlStateHighlighted];
	button.titleLabel.font = [UIFont cheddarInterfaceFontOfSize:14.0f];
	button.titleLabel.shadowOffset = CGSizeMake(0.0f, 1.0f);
//	button.titleEdgeInsets = UIEdgeInsetsMake(-1.0f, 0.0f, 0.0f, 0.0f);
	return button;
}

@end
