//
//  UIFont+CheddariOSAdditions.m
//  Cheddar for iOS
//
//  Created by Sam Soffes on 4/23/12.
//  Copyright (c) 2012 Nothing Magical. All rights reserved.
//

#import "UIFont+CheddariOSAdditions.h"
#import "CDISettingsFontPickerViewController.h"
#import "CDISettingsTextSizePickerViewController.h"

NSString *const kCDIFontRegularKey = @"Regular";
NSString *const kCDIFontItalicKey = @"Italic";
NSString *const kCDIFontBoldKey = @"Bold";
NSString *const kCDIFontBoldItalicKey = @"BoldItalic";

@implementation UIFont (CheddariOSAdditions)

#pragma mark - Font Names

+ (NSDictionary *)cheddarFontMapForFontKey:(NSString *)key {
	static NSDictionary *fontDictionary = nil;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		fontDictionary = [[NSDictionary alloc] initWithObjectsAndKeys:
						  [[NSDictionary alloc] initWithObjectsAndKeys:
						   kCDIRegularFontName, kCDIFontRegularKey,
						   kCDIItalicFontName, kCDIFontItalicKey,
						   kCDIBoldFontName, kCDIFontBoldKey,
						   kCDIBoldItalicFontName, kCDIFontBoldItalicKey,
						   nil], kCDIFontGothamKey,
						  [[NSDictionary alloc] initWithObjectsAndKeys:
						   @"HelveticaNeue", kCDIFontRegularKey,
						   @"HelveticaNeue-Italic", kCDIFontItalicKey,
						   @"HelveticaNeue-Bold", kCDIFontBoldKey,
						   @"HelveticaNeue-BoldItalic", kCDIFontBoldItalicKey,
						   nil], kCDIFontHelveticaNeueKey,
						  [[NSDictionary alloc] initWithObjectsAndKeys:
						   @"HoeflerText-Regular", kCDIFontRegularKey,
						   @"HoeflerText-Italic", kCDIFontItalicKey,
						   @"HoeflerText-Black", kCDIFontBoldKey,
						   @"HoeflerText-BlackItalic", kCDIFontBoldItalicKey,
						   nil], kCDIFontHoeflerKey,
						  [[NSDictionary alloc] initWithObjectsAndKeys:
						   @"Avenir-Book", kCDIFontRegularKey,
						   @"Avenir-BookOblique", kCDIFontItalicKey,
						   @"Avenir-Black", kCDIFontBoldKey,
						   @"Avenir-BlackOblique", kCDIFontBoldItalicKey,
						   nil], kCDIFontAvenirKey,
						  nil];
	});
	return [fontDictionary objectForKey:key];
}


+ (NSString *)cheddarFontNameForFontKey:(NSString *)key style:(NSString *)style {
	return [[self cheddarFontMapForFontKey:key] objectForKey:style];
}


+ (NSString *)cheddarFontNameForStyle:(NSString *)style {
	return [self cheddarFontNameForFontKey:[CDISettingsFontPickerViewController selectedKey] style:style];
}


#pragma mark - Fonts

+ (UIFont *)cheddarFontOfSize:(CGFloat)fontSize fontKey:(NSString *)key {
	NSString *fontName = [self cheddarFontNameForFontKey:key style:kCDIFontRegularKey];
	return [self fontWithName:fontName size:fontSize];
}


+ (UIFont *)italicCheddarFontOfSize:(CGFloat)fontSize fontKey:(NSString *)key {
	NSString *fontName = [self cheddarFontNameForFontKey:key style:kCDIFontItalicKey];
	return [self fontWithName:fontName size:fontSize];
}


+ (UIFont *)boldCheddarFontOfSize:(CGFloat)fontSize fontKey:(NSString *)key {
	NSString *fontName = [self cheddarFontNameForFontKey:key style:kCDIFontBoldKey];
	return [self fontWithName:fontName size:fontSize];
}


+ (UIFont *)boldItalicCheddarFontOfSize:(CGFloat)fontSize fontKey:(NSString *)key {
	NSString *fontName = [self cheddarFontNameForFontKey:key style:kCDIFontBoldItalicKey];
	return [self fontWithName:fontName size:fontSize];
}


#pragma mark - Standard

+ (UIFont *)cheddarFontOfSize:(CGFloat)fontSize {
	fontSize += [CDISettingsTextSizePickerViewController fontSizeAdjustment];
	return [self cheddarFontOfSize:fontSize fontKey:[CDISettingsFontPickerViewController selectedKey]];
}


+ (UIFont *)italicCheddarFontOfSize:(CGFloat)fontSize {
	fontSize += [CDISettingsTextSizePickerViewController fontSizeAdjustment];
	return [self italicCheddarFontOfSize:fontSize fontKey:[CDISettingsFontPickerViewController selectedKey]];
}


+ (UIFont *)boldCheddarFontOfSize:(CGFloat)fontSize {
	fontSize += [CDISettingsTextSizePickerViewController fontSizeAdjustment];
	return [self boldCheddarFontOfSize:fontSize fontKey:[CDISettingsFontPickerViewController selectedKey]];
}


+ (UIFont *)boldItalicCheddarFontOfSize:(CGFloat)fontSize {
	fontSize += [CDISettingsTextSizePickerViewController fontSizeAdjustment];
	return [self boldItalicCheddarFontOfSize:fontSize fontKey:[CDISettingsFontPickerViewController selectedKey]];
}


#pragma mark - Interface

+ (UIFont *)cheddarInterfaceFontOfSize:(CGFloat)fontSize {
	return [self fontWithName:kCDIRegularFontName size:fontSize];
}


+ (UIFont *)boldCheddarInterfaceFontOfSize:(CGFloat)fontSize {
	return [self fontWithName:kCDIBoldFontName size:fontSize];
}

@end
