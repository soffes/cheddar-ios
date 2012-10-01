//
//  CDIUpgradeViewController.h
//  Cheddar for iOS
//
//  Created by Sam Soffes on 5/16/12.
//  Copyright (c) 2012 Nothing Magical. All rights reserved.
//

@interface CDIUpgradeViewController : UIViewController

- (void)cancel:(id)sender;
- (void)upgrade:(id)sender;

- (void)buyThreeMonths:(id)sender;
- (void)buyOneYear:(id)sender;
- (void)restore:(id)sender;

@end
