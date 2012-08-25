//
//  CDITasksPlaceholderView.m
//  Cheddar for iOS
//
//  Created by Sam Soffes on 5/23/12.
//  Copyright (c) 2012 Nothing Magical. All rights reserved.
//

#import "CDITasksPlaceholderView.h"
#import "UIFont+CheddariOSAdditions.h"

@implementation CDITasksPlaceholderView

- (id)initWithFrame:(CGRect)frame {
	if ((self = [super initWithFrame:frame])) {
		self.userInteractionEnabled = NO;
		self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
		
		self.iconImageView.image = [UIImage imageNamed:@"task-icon"];
		self.arrowImageView.image = [UIImage imageNamed:@"add-task-arrow"];
		self.titleLabel.text = @"You don't have any\ntasks in this list.";
		self.arrowLabel.text = @"Add a task";
	}
	return self;
}

@end
