//
//  CDITableViewCell.m
//  Cheddar for iOS
//
//  Created by Sam Soffes on 3/31/12.
//  Copyright (c) 2012 Nothing Magical. All rights reserved.
//

#import "CDITableViewCell.h"
#import "CDISettingsViewController.h"
#import "UIColor+CheddariOSAdditions.h"
#import "UIFont+CheddariOSAdditions.h"

@interface CDITableViewCell () <UIGestureRecognizerDelegate>

@property (nonatomic, strong, readonly) UITapGestureRecognizer *editingTapGestureRecognizer;
@property (nonatomic, strong, readonly) UILongPressGestureRecognizer *editingLongPressGestureRecognizer;

@end


@implementation CDITableViewCell

@synthesize editingText = _editingText;
@synthesize textField = _textField;
@synthesize editingTapGestureRecognizer = _editingTapGestureRecognizer;
@synthesize editingLongPressGestureRecognizer = _editingLongPressGestureRecognizer;

- (UITextField *)textField {
	if (!_textField) {
		_textField = [[SSTextField alloc] initWithFrame:CGRectZero];
		_textField.textColor = self.textLabel.textColor;
		_textField.placeholderTextColor = [UIColor cheddarLightTextColor];
		_textField.backgroundColor = [UIColor whiteColor];
		_textField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
		_textField.returnKeyType = UIReturnKeyDone;
		_textField.alpha = 0.0f;
		[self updateFonts];
		[self.contentView addSubview:_textField];
	}
	return _textField;
}


- (void)setEditingText:(BOOL)editingText {
	_editingText = editingText;
	if (_editingText) {
		[self.contentView addSubview:self.textField];
		[self setNeedsLayout];
		[_textField becomeFirstResponder];
		
		[UIView animateWithDuration:0.2 delay:0.0f options:UIViewAnimationCurveEaseInOut | UIViewAnimationOptionAllowUserInteraction animations:^{
			_textField.alpha = 1.0f;
		} completion:nil];
	} else {
		[_textField resignFirstResponder];
		[UIView animateWithDuration:0.2 delay:0.0f options:UIViewAnimationCurveEaseInOut | UIViewAnimationOptionAllowUserInteraction animations:^{
			_textField.alpha = 0.0f;
		} completion:^(BOOL finished) {
			[_textField removeFromSuperview];
			_textField = nil;
		}];
	}
}


#pragma mark - Class Methods

+ (CGFloat)cellHeight {
	return 51.0f;
}


#pragma mark - UIView

- (void)layoutSubviews {
	[super layoutSubviews];
	CGSize size = self.contentView.bounds.size;
	
	if (self.editing) {
		_textField.frame = CGRectMake(10.0f, 1.0f, size.width - 46.0f, size.height - 2.0f);
	}
}


#pragma mark - UITableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
	if ((self = [super initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseIdentifier])) {		
		self.textLabel.textColor = [UIColor cheddarTextColor];
		[self updateFonts];
				
		SSBorderedView *background = [[SSBorderedView alloc] initWithFrame:CGRectZero];
		background.backgroundColor = [UIColor whiteColor];
		background.bottomBorderColor = [UIColor colorWithWhite:0.92f alpha:1.0f];
		background.contentMode = UIViewContentModeRedraw;
		self.backgroundView = background;		
		self.contentView.clipsToBounds = YES;
		
		_editingTapGestureRecognizer = [[UITapGestureRecognizer alloc] init];
		_editingTapGestureRecognizer.delegate = self;
		[self addGestureRecognizer:_editingTapGestureRecognizer];
        
		_editingLongPressGestureRecognizer = [[UILongPressGestureRecognizer alloc] init];
		_editingLongPressGestureRecognizer.delegate = self;
		[self addGestureRecognizer:_editingLongPressGestureRecognizer];

		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateFonts) name:kCDIFontDidChangeNotificationName object:nil];
	}
	return self;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
	[super setSelected:selected animated:animated];
	if (!selected) {
		self.textLabel.backgroundColor = [UIColor whiteColor];
	}
}


- (void)setEditing:(BOOL)editing animated:(BOOL)animated {
	[super setEditing:editing animated:animated];
	_editingTapGestureRecognizer.enabled = editing;
}


- (void)prepareForReuse {
	[super prepareForReuse];
	[self setEditingText:NO];
}


#pragma mark - Font Handling

- (void)updateFonts {
	_textField.font = self.textLabel.font;
	self.textLabel.font = [UIFont cheddarFontOfSize:18.0f];
}


#pragma mark - UIGestureRecognizerDelegate

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
	return [touch.view isKindOfClass:[UIControl class]] == NO;
}


#pragma mark - Gesture Actions

- (void)setEditingAction:(SEL)editAction forTarget:(id)target {
    [_editingTapGestureRecognizer addTarget:target action:editAction];
    [_editingLongPressGestureRecognizer addTarget:target action:editAction];
}

@end
