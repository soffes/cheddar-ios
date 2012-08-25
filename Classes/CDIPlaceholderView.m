//
//  CDIPlaceholderView.m
//  Cheddar for iOS
//
//  Created by Sam Soffes on 8/25/12.
//  Copyright (c) 2012 Nothing Magical. All rights reserved.
//

#import "CDIPlaceholderView.h"
#import "UIColor+CheddariOSAdditions.h"
#import "UIFont+CheddariOSAdditions.h"

@implementation CDIPlaceholderView

@synthesize iconImageView = _iconImageView;
@synthesize arrowImageView = _arrowImageView;
@synthesize arrowLabel = _arrowLabel;
@synthesize titleLabel = _titleLabel;
@synthesize arrowAligment = _arrowAligment;

#pragma mark - UIView

- (id)initWithFrame:(CGRect)frame {
	if ((self = [super initWithFrame:frame])) {
		self.userInteractionEnabled = NO;
		self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        self.backgroundColor = [UIColor clearColor];

		_iconImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
		_iconImageView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin;
		[self addSubview:_iconImageView];

		_arrowImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
		[self addSubview:_arrowImageView];

		_arrowLabel = [[UILabel alloc] initWithFrame:CGRectZero];
		_arrowLabel.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin;
		_arrowLabel.text = @"Add a task";
		_arrowLabel.textAlignment = UITextAlignmentCenter;
		_arrowLabel.backgroundColor = [UIColor clearColor];
		_arrowLabel.font = [UIFont fontWithName:@"Noteworthy" size:19.0f];
		_arrowLabel.textColor = [UIColor colorWithWhite:0.294f alpha:0.45f];
		_arrowLabel.transform = CGAffineTransformMakeRotation(DEGREES_TO_RADIANS(-2.0f));
		[self addSubview:_arrowLabel];

		_titleLabel = [[SSLabel alloc] initWithFrame:CGRectZero];
		_titleLabel.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin;
		_titleLabel.backgroundColor = [UIColor clearColor];
		_titleLabel.numberOfLines = 2;
		_titleLabel.textAlignment = UITextAlignmentCenter;
		_titleLabel.textColor = [UIColor colorWithRed:0.702f green:0.694f blue:0.686f alpha:1.0f];
		_titleLabel.font = [UIFont cheddarInterfaceFontOfSize:22.0f];
		_titleLabel.shadowColor = [UIColor whiteColor];
		_titleLabel.shadowOffset = CGSizeMake(0.0f, 1.0f);
		_titleLabel.verticalTextAlignment = SSLabelVerticalTextAlignmentTop;
		[self addSubview:_titleLabel];
	}
	return self;
}


- (void)layoutSubviews {
	CGSize size = self.frame.size;

	// iPad's nav bar buttons are 7pt from the edge instead of iPhone's 5pt
	CGFloat offset = UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ? 2.0f : 0.0f;

	if (_arrowAligment == CDIPlaceholderViewArrowAlignmentLeft) {
		_arrowImageView.frame = CGRectMake(13.0f + offset, 56.0f, 34.0f, 40.0f);
		_arrowLabel.frame = CGRectMake(41.0f + offset, 80.0f, 85.0f, 22.0f);
	} else {
		_arrowImageView.frame = CGRectMake(size.width - 48.0f - offset, 5.0f, 34.0f, 40.0f);
		_arrowLabel.frame = CGRectMake(size.width - 120.0f - offset, 30.0f, 75.0f, 22.0f);
	}

	CGSize iconSize = _iconImageView.image.size;
	_iconImageView.frame = CGRectMake(roundf((size.width - iconSize.width) / 2.0f), roundf((size.height - iconSize.height) / 2.0f), iconSize.width, iconSize.height);
	_titleLabel.frame = CGRectMake(roundf((size.width - 280.0f) / 2.0f), _iconImageView.frame.origin.y + iconSize.height + 18.0f, 280.0f, 60.0f);
}

@end
