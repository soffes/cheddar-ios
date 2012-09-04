//
//  CDICheckboxButton.m
//  Cheddar for iOS
//
//  Created by Sam Soffes on 9/3/12.
//  Copyright (c) 2012 Nothing Magical. All rights reserved.
//

#import "CDICheckboxButton.h"

@implementation CDICheckboxButton

@synthesize tableViewCell = _tableViewCell;

- (id)initWithFrame:(CGRect)frame {
	if ((self = [super initWithFrame:frame])) {
		self.adjustsImageWhenHighlighted = NO;
		[self setBackgroundImage:[[UIImage imageNamed:@"checkbox"] stretchableImageWithLeftCapWidth:4 topCapHeight:4] forState:UIControlStateNormal];
	}
	return self;
}

@end
