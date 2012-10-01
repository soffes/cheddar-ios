//
//  UIColor+CheddariOSAdditions.m
//  Cheddar for iOS
//
//  Created by Sam Soffes on 4/8/12.
//  Copyright (c) 2012 Nothing Magical. All rights reserved.
//

#import "UIColor+CheddariOSAdditions.h"

@implementation UIColor (CheddariOSAdditions)

+ (UIColor *)cheddarArchesColor {
	return [self colorWithPatternImage:[UIImage imageNamed:@"arches"]];
}


+ (UIColor *)cheddarTextColor {
	return [self colorWithWhite:0.267f alpha:1.0f];
}


+ (UIColor *)cheddarLightTextColor {
	return [self colorWithWhite:0.651f alpha:1.0f];
}


+ (UIColor *)cheddarBlueColor {
	return [self colorWithRed:0.031f green:0.506f blue:0.702f alpha:1.0f];
}


+ (UIColor *)cheddarSteelColor {
	return [self colorWithRed:0.376f green:0.408f blue:0.463f alpha:1.0f];
}


+ (UIColor *)cheddarHighlightColor {
	return [self colorWithRed:1.000f green:0.996f blue:0.792f alpha:1.0f];
}


+ (UIColor *)cheddarOrangeColor {
	return [self colorWithRed:1.000f green:0.447f blue:0.263f alpha:1.0f];
}

@end
