//
//  CDIKeyboardBar.m
//  Cheddar for iOS
//
//  Created by Sam Soffes on 9/28/12.
//  Copyright (c) 2012 Nothing Magical. All rights reserved.
//

#import "CDIKeyboardBar.h"
#import "CDIKeyboardButton.h"

@interface CDIKeyboardBar ()
- (void)_buttonPressed:(CDIKeyboardButton *)button;
@end

@implementation CDIKeyboardBar {
	NSArray *_buttons;
}

@synthesize keyInputView = _keyInputView;

#pragma mark - Class Methods

+ (NSArray *)characters {
	return @[@"#", @"*", @"_", @"[", @"]", @"(", @")", @"`"];
}


#pragma mark - UIView

- (id)initWithFrame:(CGRect)frame {
	if ((self = [super initWithFrame:frame])) {
		self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
		
		self.topBorderColor = [UIColor colorWithRed:0.643f green:0.643f blue:0.651f alpha:1.0f];
		self.topInsetColor = [UIColor colorWithRed:0.965f green:0.965f blue:0.969f alpha:1.0f];
		self.colors = @[
			[UIColor colorWithRed:0.933f green:0.933f blue:0.941f alpha:1.0f],
			[UIColor colorWithRed:0.824f green:0.824f blue:0.847f alpha:1.0f]
		];

		// Setup buttons
		NSMutableArray *keys = [[NSMutableArray alloc] init];
		for (NSString *character in [[self class] characters]) {
			CDIKeyboardButton *button = [[CDIKeyboardButton alloc] initWithCharacter:character];
			[button addTarget:self action:@selector(_buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
			[keys addObject:button];
			[self addSubview:button];
		}
		_buttons = keys;
	}
	return self;
}


- (CGSize)sizeThatFits:(CGSize)size {
	size.height = UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ? 54.0f : 36.0f;
	size.width = fmaxf(size.width, 320.0f);
	return size;
}


- (void)layoutSubviews {
	NSUInteger count = [[[self class] characters] count];
	CGFloat width = roundf(self.bounds.size.width / (CGFloat)count);
	CGFloat height = self.bounds.size.height;
	for (NSUInteger i = 0; i < count; i++) {
		UIButton *button = _buttons[i];
		CGFloat x = (CGFloat)i * width;

		// Make sure the last one goes to the end
		if (i == count - 1) {
			width = self.bounds.size.width - x;
		}
		
		button.frame = CGRectMake(x, 1.0f, width, height - 1.0f);
	}
}


#pragma mark - UIInputViewAudioFeedback

- (BOOL)enableInputClicksWhenVisible {
	return YES;
}


#pragma mark - Private

- (void)_buttonPressed:(CDIKeyboardButton *)button {
	[[UIDevice currentDevice] playInputClick];
	[self.keyInputView insertText:button.character];
}

@end
