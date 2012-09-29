//
//  CDIAddListTableViewCell.m
//  Cheddar for iOS
//
//  Created by Sam Soffes on 5/30/12.
//  Copyright (c) 2012 Nothing Magical. All rights reserved.
//

#import "CDIAddListTableViewCell.h"
#import "UIFont+CheddariOSAdditions.h"
#import "UIColor+CheddariOSAdditions.h"

@implementation CDIAddListTableViewCell

@synthesize textField = _textField;
@synthesize closeButton = _closeButton;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
	if ((self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])) {
		self.selectionStyle = UITableViewCellSelectionStyleNone;
		
		SSBorderedView *background = [[SSBorderedView alloc] initWithFrame:CGRectZero];
		background.backgroundColor = [UIColor whiteColor];
		background.bottomBorderColor = [UIColor colorWithWhite:0.92f alpha:1.0f];
		background.contentMode = UIViewContentModeRedraw;
		self.backgroundView = background;

		_textField = [[SSTextField alloc] initWithFrame:CGRectZero];
		_textField.textColor = [UIColor cheddarTextColor];
		_textField.placeholderTextColor = [UIColor cheddarLightTextColor];
		_textField.font = [UIFont cheddarFontOfSize:18.0f];
		_textField.backgroundColor = [UIColor whiteColor];
		_textField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
		_textField.returnKeyType = UIReturnKeyDone;
		_textField.placeholder = @"Name your list";
		_textField.autocapitalizationType = UITextAutocapitalizationTypeWords;
		[self.contentView addSubview:_textField];

		_closeButton = [[UIButton alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 40.0f, 51.0f)];
		[_closeButton setImage:[UIImage imageNamed:@"x"] forState:UIControlStateNormal];
		self.accessoryView = _closeButton;
	}
	return self;
}


- (void)layoutSubviews {
	[super layoutSubviews];

	CGSize size = self.contentView.bounds.size;
	_textField.frame = CGRectMake(10.0f, 1.0f, size.width - 20.0f, size.height - 2.0f);
}

@end
