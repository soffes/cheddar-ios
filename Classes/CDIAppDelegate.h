//
//  CDIAppDelegate.h
//  Cheddar for iOS
//
//  Created by Sam Soffes on 3/25/12.
//  Copyright (c) 2012 Nothing Magical. All rights reserved.
//

@interface CDIAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

+ (CDIAppDelegate *)sharedAppDelegate;
- (void)applyStylesheet;

@end
