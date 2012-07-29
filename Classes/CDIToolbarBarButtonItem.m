//
//  CDIToolbarBarButtonItem.m
//  Cheddar for iOS
//
//  Created by Sam Soffes on 7/28/12.
//  Copyright (c) 2012 Nothing Magical. All rights reserved.
//

#import "CDIToolbarBarButtonItem.h"

@implementation CDIToolbarBarButtonItem {
	UIButton *_button;
	UIImage *_image;
	UIImage *_landscapeImage;
}

- (id)initWithCustomImage:(UIImage *)image landscapeImagePhone:(UIImage *)landscapeImagePhone target:(id)target action:(SEL)action {
	CGRect rect = CGRectZero;
	rect.size = image.size;
	
	_button = [[UIButton alloc] initWithFrame:rect];
	_button.showsTouchWhenHighlighted = YES;
	[_button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
	
	if ((self = [self initWithCustomView:_button])) {
		_image = image;
		
//		if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
//			[_button setImage:_image forState:UIControlStateNormal];
//		} else {
//			_landscapeImage = landscapeImagePhone;
//		}
		
		[_button setImage:_image forState:UIControlStateNormal];
	}
	return self;
}

@end
