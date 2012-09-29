//
//  CDIKeyboardButton.m
//  Cheddar for iOS
//
//  Created by Sam Soffes on 9/28/12.
//  Copyright (c) 2012 Nothing Magical. All rights reserved.
//

#import "CDIKeyboardButton.h"

@implementation CDIKeyboardButton

@synthesize character = _character;

- (id)initWithCharacter:(NSString *)character {
	if ((self = [super init])) {
		_character = character;
		
		[self setTitle:character forState:UIControlStateNormal];
		[self setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
		[self setTitleShadowColor:[UIColor whiteColor] forState:UIControlStateNormal];

		self.titleLabel.font = [UIFont boldSystemFontOfSize:22.0f];
		self.titleLabel.shadowOffset = CGSizeMake(0.0f, 1.0f);
	}
	return self;
}


- (void)drawRect:(CGRect)rect {
	[super drawRect:rect];

	CGContextRef context = UIGraphicsGetCurrentContext();

	[[UIColor colorWithRed:0.910f green:0.910f blue:0.922f alpha:1.0f] setFill];
	CGContextFillRect(context, CGRectMake(0.0f, 0.0f, 1.0f, self.bounds.size.height));

	[[UIColor colorWithRed:0.643f green:0.643f blue:0.651f alpha:1.0f] setFill];
	CGContextFillRect(context, CGRectMake(self.bounds.size.width - 1.0f, 0.0f, 1.0f, self.bounds.size.height));
}

@end
