//
//  CDITransactionObserver.h
//  Cheddar for iOS
//
//  Created by Sam Soffes on 5/15/12.
//  Copyright (c) 2012 Nothing Magical. All rights reserved.
//

#import <StoreKit/StoreKit.h>

extern NSString *const kCDITransactionObserverDidUpdateProductsNotificationName;
extern NSString *const kCDIPaymentTransactionDidCompleteNotificationName;
extern NSString *const kCDIPaymentTransactionDidFailNotificationName;
extern NSString *const kCDIPaymentTransactionDidCancelNotificationName;

@interface CDITransactionObserver : NSObject <SKPaymentTransactionObserver>

@property (nonatomic, strong, readonly) NSDictionary *products;

+ (CDITransactionObserver *)defaultObserver;
- (void)updateProducts;

@end
