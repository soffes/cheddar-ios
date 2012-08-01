//
//  UIFont+CheddariOSAdditions.h
//  Cheddar for iOS
//
//  Created by Sam Soffes on 4/23/12.
//  Copyright (c) 2012 Nothing Magical. All rights reserved.
//

extern NSString *const kCDIFontRegularKey;
extern NSString *const kCDIFontItalicKey;
extern NSString *const kCDIFontBoldKey;
extern NSString *const kCDIFontBoldItalicKey;

@interface UIFont (CheddariOSAdditions)

#pragma mark - Font Names

+ (NSDictionary *)cheddarFontMapForFontKey:(NSString *)key;
+ (NSString *)cheddarFontNameForFontKey:(NSString *)key style:(NSString *)style;
+ (NSString *)cheddarFontNameForStyle:(NSString *)style;

#pragma mark - Fonts

+ (UIFont *)cheddarFontOfSize:(CGFloat)fontSize fontKey:(NSString *)key;
+ (UIFont *)boldCheddarFontOfSize:(CGFloat)fontSize fontKey:(NSString *)key;
+ (UIFont *)boldItalicCheddarFontOfSize:(CGFloat)fontSize fontKey:(NSString *)key;
+ (UIFont *)italicCheddarFontOfSize:(CGFloat)fontSize fontKey:(NSString *)key;


#pragma mark - Standard

+ (UIFont *)cheddarFontOfSize:(CGFloat)fontSize;
+ (UIFont *)italicCheddarFontOfSize:(CGFloat)fontSize;
+ (UIFont *)boldCheddarFontOfSize:(CGFloat)fontSize;
+ (UIFont *)boldItalicCheddarFontOfSize:(CGFloat)fontSize;


#pragma mark - Interface

+ (UIFont *)cheddarInterfaceFontOfSize:(CGFloat)fontSize;
+ (UIFont *)boldCheddarInterfaceFontOfSize:(CGFloat)fontSize;

@end
