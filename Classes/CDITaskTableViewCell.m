//
//  CDITaskTableViewCell.m
//  Cheddar for iOS
//
//  Created by Sam Soffes on 4/5/12.
//  Copyright (c) 2012 Nothing Magical. All rights reserved.
//

#import "CDITaskTableViewCell.h"
#import "CDIAttributedLabel.h"
#import "CDICheckboxButton.h"
#import "UIColor+CheddariOSAdditions.h"
#import "UIFont+CheddariOSAdditions.h"
#import "CDKTask+CheddariOSAdditions.h"
#import "CDISettingsTextSizePickerViewController.h"

@interface CDITaskTableViewCell ()
- (void)_updateAttributedText;
@end

@implementation CDITaskTableViewCell {
	UIImageView *_checkmark;
}

@synthesize task = _task;
@synthesize attributedLabel = _attributedLabel;
@synthesize checkboxButton = _checkboxButton;


- (void)setTask:(CDKTask *)task {
	_task = task;
	
	if (_task.isCompleted) {
		_attributedLabel.textColor = [UIColor cheddarLightTextColor];
		_checkmark.hidden = NO;
		_attributedLabel.linkAttributes = [NSDictionary dictionaryWithObjectsAndKeys:
										   (id)[UIColor colorWithWhite:0.45f alpha:1.0f].CGColor, (NSString *)kCTForegroundColorAttributeName,
										   nil];
	} else {
		_attributedLabel.textColor = [UIColor cheddarTextColor];
		_checkmark.hidden = YES;
		_attributedLabel.linkAttributes = [NSDictionary dictionaryWithObjectsAndKeys:
										   (id)[UIColor cheddarBlueColor].CGColor, (NSString *)kCTForegroundColorAttributeName,
										   nil];
	}

	[self _updateAttributedText];
}


#pragma mark - Class Methods

+ (CGFloat)cellHeightForTask:(CDKTask *)task width:(CGFloat)width {
	static TTTAttributedLabel *label = nil;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		label = [[TTTAttributedLabel alloc] initWithFrame:CGRectZero];
		label.numberOfLines = 0;
	});
	label.font = [UIFont cheddarFontOfSize:18.0f];
	label.text = task.attributedDisplayText;
	CGSize size = [label sizeThatFits:CGSizeMake(width - 54.0f, 2000.0f)];
	label.text = nil;

	CGFloat offset = ([CDISettingsTextSizePickerViewController fontSizeAdjustment] * 2.0f) - 1.0f;
	return size.height + 27.0f + offset;
}


#pragma mark - UITableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
	if ((self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier])) {
		self.textLabel.hidden = YES;
		
		_checkboxButton = [[CDICheckboxButton alloc] initWithFrame:CGRectZero];
		_checkboxButton.tableViewCell = self;
		[self.contentView addSubview:_checkboxButton];
		
		_checkmark = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"small-check"]];
		_checkmark.hidden = YES;
		[self.contentView addSubview:_checkmark];
		
		_attributedLabel = [[CDIAttributedLabel alloc] initWithFrame:CGRectZero];
		_attributedLabel.textColor = [UIColor cheddarTextColor];
		_attributedLabel.backgroundColor = [UIColor clearColor];
		_attributedLabel.numberOfLines = 0;
		_attributedLabel.verticalAlignment = TTTAttributedLabelVerticalAlignmentTop;
		[self updateFonts];
		[self.contentView addSubview:_attributedLabel];
		
		self.contentView.clipsToBounds = YES;
	}
	return self;
}


- (void)layoutSubviews {
	[super layoutSubviews];
	
	CGSize size = self.contentView.bounds.size;
	CGFloat offset = ([CDISettingsTextSizePickerViewController fontSizeAdjustment] * 2.0f) - 1.0f;
	CGFloat textYOffset = roundf(offset / 2.0f);

	if (self.editing) { // TODO: Only match reordering and not swipe to delete
		_checkboxButton.frame = CGRectMake(-34.0f, 13.0f + offset, 24.0f, 24.0f);
		_checkmark.frame = CGRectMake(-30.0f, 16.0f + offset, 22.0f, 18.0f);
		_attributedLabel.frame = CGRectMake(12.0f, 13.0f + textYOffset, size.width - 20.0f, size.height - 27.0f - offset);
	} else {
		_checkboxButton.frame = CGRectMake(10.0f, 13.0f + offset, 24.0f, 24.0f);
		_checkmark.frame = CGRectMake(12.0f, 16.0f + offset, 22.0f, 18.0f);
		_attributedLabel.frame = CGRectMake(44.0f, 13.0f + textYOffset, size.width - 54.0f, size.height - 27.0f - offset);
	}
}


#pragma mark - UITableViewCell

- (void)setEditing:(BOOL)editing animated:(BOOL)animated {
	[super setEditing:editing animated:animated];
	
	void (^change)(void) = ^{
		_checkboxButton.alpha = editing ? 0.0f : 1.0f;
		_checkmark.alpha = _checkboxButton.alpha;
	};
	
	if (animated) {
		[UIView animateWithDuration:0.18 delay:0.0 options:UIViewAnimationOptionCurveEaseIn | UIViewAnimationOptionAllowUserInteraction animations:change completion:nil];
	} else {
		change();
	}
}


- (void)prepareForReuse {
	[super prepareForReuse];
	self.task = nil;
}


#pragma mark - CDITableViewCell

- (void)updateFonts {
	[super updateFonts];
	_attributedLabel.font = [UIFont cheddarFontOfSize:18.0f];
	[self _updateAttributedText];
}


#pragma Private

- (void)_updateAttributedText {
	__weak CDKTask *task = _task;
	[_attributedLabel setText:_task.displayText afterInheritingLabelAttributesAndConfiguringWithBlock:^NSMutableAttributedString *(NSMutableAttributedString *mutableAttributedString) {
		[task addEntitiesToAttributedString:mutableAttributedString];
		return mutableAttributedString;
	}];

	// Add links
	for (NSDictionary *entity in _task.entities) {
		NSArray *indices = [entity objectForKey:@"display_indices"];
		NSRange range = NSMakeRange([[indices objectAtIndex:0] unsignedIntegerValue], 0);
		range.length = [[indices objectAtIndex:1] unsignedIntegerValue] - range.location;
		range = [_attributedLabel.text composedRangeWithRange:range];

		NSString *type = [entity objectForKey:@"type"];

		// Tag
		if ([type isEqualToString:@"tag"]) {
			NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"x-cheddar-tag://%@", [entity objectForKey:@"tag_name"]]];
			[_attributedLabel addLinkToURL:url withRange:range];
		}

		// Link
		else if ([type isEqualToString:@"link"]) {
			NSURL *url = [NSURL URLWithString:[entity objectForKey:@"url"]];
			[_attributedLabel addLinkToURL:url withRange:range];
		}
	}
}

@end
