//
//  CDISettingsTapPickerViewController.h
//  Cheddar for iOS
//
//  Created by Sam Soffes on 7/29/12.
//  Copyright (c) 2012 Nothing Magical. All rights reserved.
//

#import "CDIPickerViewController.h"

@interface CDISettingsTapPickerViewController : CDIPickerViewController

+ (NSString *)defaultsKey;
+ (NSString *)selectedKey;
+ (void)setSelectedKey:(NSString *)key;
+ (NSDictionary *)valueMap;
+ (NSString *)textForKey:(NSString *)key;

@end
