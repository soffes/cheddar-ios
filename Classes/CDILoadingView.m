//
//  CDILoadingView.m
//  Cheddar for iOS
//
//  Created by Sam Soffes on 5/28/12.
//  Copyright (c) 2012 Nothing Magical. All rights reserved.
//

#import "CDILoadingView.h"
#import "UIFont+CheddariOSAdditions.h"
#import "UIColor+CheddariOSAdditions.h"

@implementation CDILoadingView

- (id)initWithFrame:(CGRect)frame {
	if ((self = [super initWithFrame:frame])) {
		self.textLabel.font = [UIFont cheddarInterfaceFontOfSize:16.0f];
		self.backgroundColor = [UIColor clearColor];
	}
	return self;
}

@end
