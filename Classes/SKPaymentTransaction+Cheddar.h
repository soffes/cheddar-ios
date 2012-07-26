//
//  SKPaymentTransaction+Cheddar.h
//  Cheddar for iOS
//
//  Created by Sam Soffes on 5/15/12.
//  Copyright (c) 2012 Nothing Magical. All rights reserved.
//

#import <StoreKit/StoreKit.h>

@interface SKPaymentTransaction (Cheddar)

- (NSString *)transactionReceiptString;

@end
