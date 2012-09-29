//
//  CDISettingsTextSizePickerViewController.h
//  Cheddar for iOS
//
//  Created by Sam Soffes on 7/29/12.
//  Copyright (c) 2012 Nothing Magical. All rights reserved.
//

#import "CDIPickerViewController.h"

extern NSString *const kCDITextSizeDefaultsKey;
extern NSString *const kCDITextSizeLargeKey;
extern NSString *const kCDITextSizeMediumKey;
extern NSString *const kCDITextSizeSmallKey;

@interface CDISettingsTextSizePickerViewController : CDIPickerViewController

+ (CGFloat)fontSizeAdjustment;

@end
