//
//  SKPaymentTransaction+CheddariOSAdditions.m
//  Cheddar for iOS
//
//  Created by Sam Soffes on 5/15/12.
//  Copyright (c) 2012 Nothing Magical. All rights reserved.
//

#import "SKPaymentTransaction+CheddariOSAdditions.h"

@implementation SKPaymentTransaction (CheddariOSAdditions)

// From http://stackoverflow.com/a/1314501/118631
- (NSString *)transactionReceiptString {
	static char table[] = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/=";
	
	uint8_t *input = (uint8_t *)self.transactionReceipt.bytes;
	NSInteger length = self.transactionReceipt.length;
	NSMutableData *data = [NSMutableData dataWithLength:((length + 2) / 3) * 4];
	uint8_t *output = (uint8_t *)data.mutableBytes;
	
	for (NSInteger i = 0; i < length; i += 3) {
		NSInteger value = 0;
		for (NSInteger j = i; j < (i + 3); j++) {
			value <<= 8;
			
			if (j < length) {
				value |= (0xFF & input[j]);
			}
		}
		
		NSInteger index = (i / 3) * 4;
		output[index + 0] =                    table[(value >> 18) & 0x3F];
		output[index + 1] =                    table[(value >> 12) & 0x3F];
		output[index + 2] = (i + 1) < length ? table[(value >> 6)  & 0x3F] : '=';
		output[index + 3] = (i + 2) < length ? table[(value >> 0)  & 0x3F] : '=';
	}
	
	return [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
}

@end
