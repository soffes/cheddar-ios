//
//  CDISettingsFontPickerViewController.h
//  Cheddar for iOS
//
//  Created by Sam Soffes on 7/29/12.
//  Copyright (c) 2012 Nothing Magical. All rights reserved.
//

#import "CDIPickerViewController.h"

extern NSString *const kCDIFontDefaultsKey;
extern NSString *const kCDIFontGothamKey;
extern NSString *const kCDIFontHelveticaNeueKey;
extern NSString *const kCDIFontHoeflerKey;
extern NSString *const kCDIFontAvenirKey;

@interface CDISettingsFontPickerViewController : CDIPickerViewController

+ (BOOL)supportsAvenir;

@end
