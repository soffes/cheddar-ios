//
//  CDIListsPlaceholderView.m
//  Cheddar for iOS
//
//  Created by Sam Soffes on 5/24/12.
//  Copyright (c) 2012 Nothing Magical. All rights reserved.
//

#import "CDIListsPlaceholderView.h"
#import "UIFont+CheddariOSAdditions.h"

@implementation CDIListsPlaceholderView

- (id)initWithFrame:(CGRect)frame {
	if ((self = [super initWithFrame:frame])) {
		self.userInteractionEnabled = NO;
		self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;

		self.arrowAligment = CDIPlaceholderViewArrowAlignmentRight;
		self.arrowImageView.image = [UIImage imageNamed:@"add-list-arrow"];
		self.iconImageView.image = [UIImage imageNamed:@"list-icon"];
		self.titleLabel.text = @"You don't have any lists.";
		self.arrowLabel.text = @"Add a list";
	}
	return self;
}

@end