//
//  CDITransactionObserver.m
//  Cheddar for iOS
//
//  Created by Sam Soffes on 5/15/12.
//  Copyright (c) 2012 Nothing Magical. All rights reserved.
//

#import "CDITransactionObserver.h"
#import "SKPaymentTransaction+CheddariOSAdditions.h"

NSString *const kCDITransactionObserverDidUpdateProductsNotificationName = @"CDITransactionObserverDidUpdateProductsNotification";
NSString *const kCDIPaymentTransactionDidCompleteNotificationName = @"CDIPaymentTransactionDidCompleteNotification";
NSString *const kCDIPaymentTransactionDidFailNotificationName = @"CDIPaymentTransactionDidFailNotification";
NSString *const kCDIPaymentTransactionDidCancelNotificationName = @"CDIPaymentTransactionDidCancelNotification";

@interface CDITransactionObserver () <SKProductsRequestDelegate>
@end

@implementation CDITransactionObserver {
	NSMutableDictionary *_products;
	BOOL _requestingProducts;
}

@synthesize products = _products;

+ (CDITransactionObserver *)defaultObserver {
	static CDITransactionObserver *defaultObserver = nil;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		defaultObserver = [[self alloc] init];
	});
	return defaultObserver;
}


- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions {
	for (SKPaymentTransaction *transaction in transactions) {
		if (transaction.transactionState == SKPaymentTransactionStateFailed) {
			[[NSNotificationCenter defaultCenter] postNotificationName:kCDIPaymentTransactionDidFailNotificationName object:transaction];
		}
		
		BOOL valid = (transaction.transactionState == SKPaymentTransactionStatePurchased || transaction.transactionState == SKPaymentTransactionStateRestored);
		if (!transaction.transactionReceipt || !valid) {
			continue;
		}

		NSDictionary *params = [[NSDictionary alloc] initWithObjectsAndKeys:
								transaction.transactionReceiptString, @"itunes_receipt",
								nil];
		[[CDKHTTPClient sharedClient] postPath:@"receipts" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
			__weak NSManagedObjectContext *context = [CDKUser mainContext];
			[context performBlockAndWait:^{
				CDKUser *user = [CDKUser currentUser];
				user.hasPlus = [NSNumber numberWithBool:YES];
				[user save];
			}];
			
			dispatch_async(dispatch_get_main_queue(), ^{
				[[SKPaymentQueue defaultQueue] finishTransaction:transaction];
				[[NSNotificationCenter defaultCenter] postNotificationName:kCDIPaymentTransactionDidCompleteNotificationName object:transaction];
				[[NSNotificationCenter defaultCenter] postNotificationName:kCDKPlusDidChangeNotificationName object:[CDKUser currentUser]];
			
				UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Cheddar Plus" message:@"Thanks for upgrading to Cheddar Plus. Enjoy!" delegate:nil cancelButtonTitle:@"I'm Awesome" otherButtonTitles:nil];
				[alert show];
			});
		} failure:^(AFHTTPRequestOperation *operation, NSError *error) {
			[[NSNotificationCenter defaultCenter] postNotificationName:kCDIPaymentTransactionDidFailNotificationName object:transaction];
		}];
	}
}


- (void)updateProducts {
	if (_products || _requestingProducts) {
		return;
	}
	
	_requestingProducts = YES;
	
	NSSet *identifiers = [[NSSet alloc] initWithObjects:@"cheddar_plus_3mo", @"cheddar_plus_6mo", @"cheddar_plus_1yr", nil];
	SKProductsRequest *request = [[SKProductsRequest alloc] initWithProductIdentifiers:identifiers];
	request.delegate = self;
	[request start];
}


#pragma mark - SKProductsRequestDelegate

- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response {
	_products = [[NSMutableDictionary alloc] init];
	for (SKProduct *product in response.products) {
		[_products setObject:product forKey:product.productIdentifier];
	}
	
	[[NSNotificationCenter defaultCenter] postNotificationName:kCDITransactionObserverDidUpdateProductsNotificationName object:nil];
}


- (void)paymentQueue:(SKPaymentQueue *)queue restoreCompletedTransactionsFailedWithError:(NSError *)error {
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Restore Failed" message:@"Restoring your transactions failed." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
	[alert show];
}


- (void)paymentQueueRestoreCompletedTransactionsFinished:(SKPaymentQueue *)queue {
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Transactions Restored" message:@"Your transactions have been restored." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
	[alert show];
}

@end
