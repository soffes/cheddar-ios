//
//  CDIPullToRefreshContentView.m
//  Cheddar for iOS
//
//  Created by Sam Soffes on 4/9/12.
//  Copyright (c) 2012 Nothing Magical. All rights reserved.
//

#import "CDIPullToRefreshContentView.h"
#import "UIColor+CheddariOSAdditions.h"
#import "UIFont+CheddariOSAdditions.h"

@implementation CDIPullToRefreshContentView

- (id)initWithFrame:(CGRect)frame {
	if ((self = [super initWithFrame:frame])) {
		self.statusLabel.font = [UIFont cheddarInterfaceFontOfSize:15.0f];
		self.statusLabel.textColor = [UIColor cheddarTextColor];
		self.statusLabel.backgroundColor = [UIColor whiteColor];
	}
	return self;
}

@end
