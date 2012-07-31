//
//  CDINoTasksView.m
//  Cheddar for iOS
//
//  Created by Sam Soffes on 5/23/12.
//  Copyright (c) 2012 Nothing Magical. All rights reserved.
//

#import "CDINoTasksView.h"
#import "UIFont+CheddariOSAdditions.h"

@implementation CDINoTasksView

- (id)initWithFrame:(CGRect)frame {
	if ((self = [super initWithFrame:frame])) {
		self.userInteractionEnabled = NO;
		self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
		
		UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(roundf((frame.size.width - 108.0f) / 2.0f), 136.0f, 108.0f, 83.0f)];
		imageView.image = [UIImage imageNamed:@"task-icon"];
		imageView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin;
		[self addSubview:imageView];

		UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(roundf((frame.size.width - 280.0f) / 2.0f), 260.0f, 280.0f, 60.0f)];
		label.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin;
		label.backgroundColor = [UIColor clearColor];
		label.numberOfLines = 2;
		label.textAlignment = UITextAlignmentCenter;
		label.textColor = [UIColor colorWithRed:0.702f green:0.694f blue:0.686f alpha:1.0f];
		label.text = @"You don't have any\ntasks in this list.";
		label.font = [UIFont cheddarFontOfSize:22.0f];
		label.shadowColor = [UIColor whiteColor];
		label.shadowOffset = CGSizeMake(0.0f, 1.0f);
		[self addSubview:label];

		// iPad's nav bar buttons are 7pt from the edge instead of iPhone's 5pt
		CGFloat offset = UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ? 2.0f : 0.0f;
		
		imageView = [[UIImageView alloc] initWithFrame:CGRectMake(13.0f + offset, 56.0f, 34.0f, 40.0f)];
		imageView.image = [UIImage imageNamed:@"add-task-arrow"];
		[self addSubview:imageView];
		
		label = [[UILabel alloc] initWithFrame:CGRectMake(41.0f + offset, 80.0f, 85.0f, 22.0f)];
		label.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin;
		label.text = @"Add a task";
		label.textAlignment = UITextAlignmentCenter;
		label.backgroundColor = [UIColor clearColor];
		label.font = [UIFont fontWithName:@"Noteworthy" size:19.0f];
		label.textColor = [UIColor colorWithWhite:0.294f alpha:0.45f];
		label.transform = CGAffineTransformMakeRotation(DEGREES_TO_RADIANS(-2.0f));
		[self addSubview:label];
	}
	return self;
}

@end
