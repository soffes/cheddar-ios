//
//  CDIViewArchiveButton.m
//  Cheddar for iOS
//
//  Created by Sam Soffes on 1/19/13.
//  Copyright (c) 2013 Nothing Magical. All rights reserved.
//

#import "CDIViewArchiveButton.h"
#import "UIColor+CheddariOSAdditions.h"
#import "UIFont+CheddariOSAdditions.h"

@interface CDIViewArchiveButton ()
@property (nonatomic, strong) UIImageView *disclosureImageView;
@end

@implementation CDIViewArchiveButton

#pragma mark - UIView

- (id)initWithFrame:(CGRect)frame {
	if ((self = [super initWithFrame:frame])) {
		self.contentMode = UIViewContentModeRedraw;
		[self setTitleColor:[[UIColor cheddarSteelColor] colorWithAlphaComponent:0.5f] forState:UIControlStateNormal];
		[self setTitleColor:[UIColor cheddarSteelColor] forState:UIControlStateHighlighted];
		self.titleLabel.font = [UIFont cheddarInterfaceFontOfSize:14.0f];
		self.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
		self.titleEdgeInsets = UIEdgeInsetsMake(0.0f, 10.0f, 0.0f, 0.0f);

		_disclosureImageView = [[UIImageView alloc] init];
		_disclosureImageView.image = [UIImage imageNamed:@"disclosure"];
		_disclosureImageView.highlightedImage = [UIImage imageNamed:@"disclosure-highlighted"];
		_disclosureImageView.alpha = 0.5f;
		[self addSubview:_disclosureImageView];
	}
	return self;
}


- (void)drawRect:(CGRect)rect {
	CGContextRef context = UIGraphicsGetCurrentContext();

	UIColor *color = self.highlighted ? [UIColor colorWithWhite:0.945f alpha:1.0f] : [UIColor colorWithWhite:0.957f alpha:1.0f];
	[color setFill];
	SSDrawRoundedRect(context, self.bounds, roundf(self.bounds.size.height / 2.0f));
}


- (void)layoutSubviews {
	[super layoutSubviews];
	CGSize size = self.bounds.size;
	self.disclosureImageView.frame = CGRectMake(size.width - 20.0f, roundf((size.height - 15.0f) / 2.0f), 10.0f, 15.0f);
}


#pragma mark - UIControl

- (void)setHighlighted:(BOOL)highlighted {
	[super setHighlighted:highlighted];
	self.disclosureImageView.alpha = highlighted ? 1.0f : 0.5f;
	[self setNeedsDisplay];
}

@end
