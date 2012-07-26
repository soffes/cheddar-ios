//
//  UIFont+CheddariOSAdditions.m
//  Cheddar for iOS
//
//  Created by Sam Soffes on 4/23/12.
//  Copyright (c) 2012 Nothing Magical. All rights reserved.
//

#import "UIFont+CheddariOSAdditions.h"

@implementation UIFont (CheddariOSAdditions)

+ (UIFont *)cheddarFontOfSize:(CGFloat)fontSize {
	return [self fontWithName:kCDIRegularFontName size:fontSize];
}


+ (UIFont *)boldCheddarFontOfSize:(CGFloat)fontSize {
	return [self fontWithName:kCDIBoldFontName size:fontSize];
}


+ (UIFont *)boldItalicCheddarFontOfSize:(CGFloat)fontSize {
	return [self fontWithName:kCDIBoldItalicFontName size:fontSize];
}


+ (UIFont *)italicCheddarFontOfSize:(CGFloat)fontSize {
	return [self fontWithName:kCDIItalicFontName size:fontSize];
}

@end
