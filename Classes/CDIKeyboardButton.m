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

@end
