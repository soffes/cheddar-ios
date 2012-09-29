//
//  CDITableViewCellDeleteConfirmationControl.m
//  Cheddar for iOS
//
//  Created by Sam Soffes on 5/24/12.
//  Copyright (c) 2012 Nothing Magical. All rights reserved.
//

#import "CDITableViewCellDeleteConfirmationControl.h"
#import "UIFont+CheddariOSAdditions.h"
#import <objc/runtime.h>

@implementation CDITableViewCellDeleteConfirmationControl

- (void)drawRectCustom:(CGRect)rect {
	UIImage *image = nil;
	if (self.highlighted) {
		image = [UIImage imageNamed:@"archive-button-highlighted"];
	} else {
		image = [UIImage imageNamed:@"archive-button"];
	}
	[[image stretchableImageWithLeftCapWidth:5 topCapHeight:0] drawInRect:rect];

	NSString *text = [self valueForKey:@"title"];
	UIFont *font = [UIFont cheddarInterfaceFontOfSize:15.0f];
	UILineBreakMode lineBreakMode = UILineBreakModeClip;
	UITextAlignment alignment = UITextAlignmentCenter;

	rect.origin.y += 8.0f;
	[[UIColor colorWithRed:0.588f green:0.090f blue:0.125f alpha:1.0f] set];
	[text drawInRect:rect withFont:font lineBreakMode:lineBreakMode alignment:alignment];

	[[UIColor whiteColor] set];
	rect.origin.y -= 1.0f;
	[text drawInRect:rect withFont:font lineBreakMode:lineBreakMode alignment:alignment];
}

@end
