//
//  CDIPullToRefreshView.m
//  Cheddar for iOS
//
//  Created by Sam Soffes on 4/9/12.
//  Copyright (c) 2012 Nothing Magical. All rights reserved.
//

#import "CDIPullToRefreshView.h"
#import "CDIPullToRefreshContentView.h"

@implementation CDIPullToRefreshView

@synthesize bottomBorderColor = _bottomBorderColor;

#pragma mark - UIView

- (id)initWithFrame:(CGRect)frame {
	if ((self = [super initWithFrame:frame])) {
		self.backgroundColor = [UIColor whiteColor];
		self.contentView = [[CDIPullToRefreshContentView alloc] initWithFrame:CGRectZero];
		self.bottomBorderColor = [UIColor colorWithWhite:0.92f alpha:1.0f];
	}
	return self;
}


- (void)drawRect:(CGRect)rect {
	[self.bottomBorderColor setFill];
	
	CGSize size = self.bounds.size;
	CGContextFillRect(UIGraphicsGetCurrentContext(), CGRectMake(0.0f, size.height - 1.0f, size.width, 1.0f));
}

@end
