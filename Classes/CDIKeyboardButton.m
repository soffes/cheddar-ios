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
		self.contentMode = UIViewContentModeRedraw;
		
		_character = character;
		
		[self setTitle:character forState:UIControlStateNormal];
		[self setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
		[self setTitleShadowColor:[UIColor whiteColor] forState:UIControlStateNormal];

		self.titleLabel.font = [UIFont boldSystemFontOfSize:22.0f];
		self.titleLabel.shadowOffset = CGSizeMake(0.0f, 1.0f);
	}
	return self;
}


- (void)setHighlighted:(BOOL)highlighted {
	[super setHighlighted:highlighted];
	[self setNeedsDisplay];
}


- (void)drawRect:(CGRect)rect {
	[super drawRect:rect];

	CGContextRef context = UIGraphicsGetCurrentContext();
	NSArray *colors = nil;
	CGGradientRef gradient = NULL;

	if (self.highlighted) {
		colors = @[[UIColor colorWithRed:0.788f green:0.792f blue:0.816f alpha:1.0f],
				   [UIColor colorWithRed:0.690f green:0.694f blue:0.722f alpha:1.0f]];
		gradient = SSCreateGradientWithColors(colors);
		SSDrawGradientInRect(context, gradient, self.bounds);
		CGGradientRelease(gradient);

		colors = @[[UIColor colorWithRed:0.894f green:0.894f blue:0.910f alpha:1.0f],
				   [UIColor colorWithRed:0.843f green:0.847f blue:0.859f alpha:1.0f]];
		gradient = SSCreateGradientWithColors(colors);
		SSDrawGradientInRect(context, gradient, CGRectMake(0.0f, 0.0f, 1.0f, self.bounds.size.height));
		CGGradientRelease(gradient);
	} else {
		colors = @[[UIColor colorWithRed:0.965f green:0.965f blue:0.973f alpha:1.0f],
				   [UIColor colorWithRed:0.910f green:0.910f blue:0.922f alpha:1.0f]];
		gradient = SSCreateGradientWithColors(colors);
		SSDrawGradientInRect(context, gradient, CGRectMake(0.0f, 0.0f, 1.0f, self.bounds.size.height));
		CGGradientRelease(gradient);
	}

	colors = @[[UIColor colorWithRed:0.651f green:0.651f blue:0.655f alpha:1.0f],
						[UIColor colorWithRed:0.573f green:0.573f blue:0.588f alpha:1.0f]];
	gradient = SSCreateGradientWithColors(colors);
	SSDrawGradientInRect(context, gradient, CGRectMake(self.bounds.size.width - 1.0f, 0.0f, 1.0f, self.bounds.size.height));
	CGGradientRelease(gradient);
}

@end
