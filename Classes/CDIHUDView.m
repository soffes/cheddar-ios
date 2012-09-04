//
//  CDIHUDView.m
//  Cheddar for iOS
//
//  Created by Sam Soffes on 9/3/12.
//  Copyright (c) 2012 Nothing Magical. All rights reserved.
//

#import "CDIHUDView.h"
#import "UIFont+CheddariOSAdditions.h"

@implementation CDIHUDView

- (id)initWithTitle:(NSString *)aTitle loading:(BOOL)isLoading {
	if ((self = [super initWithTitle:aTitle loading:isLoading])) {
		self.textLabel.font = [UIFont cheddarInterfaceFontOfSize:15.0f];
	}
	return self;
}

@end
