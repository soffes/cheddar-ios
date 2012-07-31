//
//  CDINoListsView.m
//  Cheddar for iOS
//
//  Created by Sam Soffes on 5/24/12.
//  Copyright (c) 2012 Nothing Magical. All rights reserved.
//

#import "CDINoListsView.h"
#import "UIFont+CheddariOSAdditions.h"

@implementation CDINoListsView

- (id)initWithFrame:(CGRect)frame {
	if ((self = [super initWithFrame:frame])) {
		self.userInteractionEnabled = NO;

		UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(115.0f, 106.0f, 90.0f, 110.0f)];
		imageView.image = [UIImage imageNamed:@"list-icon"];
		[self addSubview:imageView];
		
		UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20.0f, 230.0f, 280.0f, 60.0f)];
		label.backgroundColor = [UIColor clearColor];
		label.numberOfLines = 2;
		label.textAlignment = UITextAlignmentCenter;
		label.textColor = [UIColor colorWithRed:0.702f green:0.694f blue:0.686f alpha:1.0f];
		label.text = @"You don't have any lists.";
		label.font = [UIFont cheddarFontOfSize:22.0f];
		label.shadowColor = [UIColor whiteColor];
		label.shadowOffset = CGSizeMake(0.0f, 1.0f);
		[self addSubview:label];

		// iPad's nav bar buttons are 7pt from the edge instead of iPhone's 5pt
		CGFloat offset = UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ? 2.0f : 0.0f;

		imageView = [[UIImageView alloc] initWithFrame:CGRectMake(272.0f - offset, 5.0f, 34.0f, 40.0f)];
		imageView.image = [UIImage imageNamed:@"add-list-arrow"];
		[self addSubview:imageView];

		label = [[UILabel alloc] initWithFrame:CGRectMake(200.0f - offset, 30.0f, 75.0f, 22.0f)];
		label.text = @"Add a list";
		label.textAlignment = UITextAlignmentRight;
		label.backgroundColor = [UIColor clearColor];
		label.font = [UIFont fontWithName:@"Noteworthy" size:19.0f];
		label.textColor = [UIColor colorWithWhite:0.294f alpha:0.45f];
		label.transform = CGAffineTransformMakeRotation(DEGREES_TO_RADIANS(-4.0f));
		[self addSubview:label];
	}
	return self;
}

@end
