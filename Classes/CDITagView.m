//
//  CDITagView.m
//  Cheddar for iOS
//
//  Created by Sam Soffes on 4/29/12.
//  Copyright (c) 2012 Nothing Magical. All rights reserved.
//

#import "CDITagView.h"
#import "UIFont+CheddariOSAdditions.h"

@implementation CDITagView

@synthesize textLabel = _textLabel;

- (id)initWithFrame:(CGRect)frame {
	if ((self = [super initWithFrame:frame])) {
		self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
		self.colors = [[NSArray alloc] initWithObjects:
					   [UIColor colorWithRed:0.0f green:0.722f blue:0.918f alpha:1.0f],
					   [UIColor colorWithRed:0.0f green:0.631f blue:0.835f alpha:1.0f],
					   nil];
		self.topBorderColor = [UIColor colorWithRed:0.392f green:0.808f blue:0.945f alpha:1.0f];
		self.bottomInsetColor = [UIColor colorWithRed:0.306f green:0.745f blue:0.886f alpha:1.0f];
		self.bottomBorderColor = [UIColor colorWithRed:0.0f green:0.502f blue:0.725f alpha:1.0f];
		
		UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10.0f, 13.0f, 24.0f, 24.0f)];
		imageView.image = [UIImage imageNamed:@"tag"];
		[self addSubview:imageView];
		
		_textLabel = [[UILabel alloc] initWithFrame:CGRectZero];
		_textLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
		_textLabel.backgroundColor = [UIColor clearColor];
		_textLabel.textColor = [UIColor whiteColor];
		_textLabel.shadowColor = [UIColor colorWithWhite:0.0f alpha:0.2f];
		_textLabel.shadowOffset = CGSizeMake(0.0f, 1.0f);
		_textLabel.font = [UIFont cheddarFontOfSize:24.0f];
		_textLabel.lineBreakMode = UILineBreakModeTailTruncation;
		[self addSubview:_textLabel];
		
		imageView = [[UIImageView alloc] initWithFrame:CGRectMake(self.bounds.size.width - 26.0f, 18.0f, 16.0f, 16.0f)];
		imageView.image = [UIImage imageNamed:@"tag-x"];
		imageView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
		[self addSubview:imageView];
	}
	return self;
}


- (void)layoutSubviews {
	[super layoutSubviews];
	
	_textLabel.frame = CGRectMake(44.0f, 13.0f, self.bounds.size.width - 74.0f, 24.0f);
}

@end
