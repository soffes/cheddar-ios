//
//  CDIAddTaskView.m
//  Cheddar for iOS
//
//  Created by Sam Soffes on 4/16/12.
//  Copyright (c) 2012 Nothing Magical. All rights reserved.
//

#import "CDIAddTaskView.h"
#import "CDITableViewCell.h"
#import "CDITagView.h"
#import "CDIKeyboardBar.h"
#import "UIColor+CheddariOSAdditions.h"
#import "UIFont+CheddariOSAdditions.h"
#import "UIButton+CheddariOSAdditions.h"
#import "SMTEDelegateController.h"

@interface CDIAddTaskView () <UITextFieldDelegate>
@property (nonatomic, strong) SMTEDelegateController *textExpander;
- (void)_closeTags;
@end

@implementation CDIAddTaskView {
	UIView *_tagContainer;
	UIView *_tagViewShadow;
	CDITagView *_tagView;
}

@synthesize textExpander = _textExpander;
@synthesize delegate = _delegate;
@synthesize textField = _textField;
@synthesize shadowView = _shadowView;
@synthesize editing = _editing;
@synthesize renameListButton = _renameListButton;
@synthesize archiveTasksButton = _archiveTasksButton;
@synthesize archiveAllTasksButton = _archiveAllTasksButton;
@synthesize archiveCompletedTasksButton = _archiveCompletedTasksButton;


#pragma mark - Accessors

- (void)setEditing:(BOOL)editing {
	[self setEditing:editing animated:YES];
}


#pragma mark - Class Methods

+ (CGFloat)height {
	return [CDITableViewCell cellHeight];
}


+ (CGFloat)margin {
	if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
		return 7.0f;
	}
	return 5.0f;
}


#pragma mark - NSObject

- (void)dealloc {
	[[NSNotificationCenter defaultCenter] removeObserver:self.textExpander];
}


#pragma mark - UIView

- (id)initWithFrame:(CGRect)frame {
	if ((self = [super initWithFrame:frame])) {
		self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
		self.backgroundColor = [UIColor redColor];
		
		CGSize size = self.bounds.size;

		SSGradientView *backgroundView = [[SSGradientView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, size.width, [[self class] height])];
		backgroundView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
		backgroundView.colors = [NSArray arrayWithObjects:
								  [UIColor colorWithRed:0.941f green:0.941f blue:0.941f alpha:1.0f],
								  [UIColor colorWithRed:0.890f green:0.890f blue:0.890f alpha:1.0f],
								  nil];
		backgroundView.bottomInsetColor = [UIColor colorWithWhite:0.914f alpha:1.0f];
		backgroundView.bottomBorderColor = [UIColor colorWithWhite:0.706f alpha:1.0f];
		[self addSubview:backgroundView];
		
		_renameListButton = [UIButton cheddarBigButton];
		[_renameListButton setTitle:@"Rename List" forState:UIControlStateNormal];
		_renameListButton.alpha = 0.0f;
		[self addSubview:_renameListButton];
		
		_archiveTasksButton = [UIButton cheddarBigButton];
		[_archiveTasksButton setTitle:@"Archive Tasks" forState:UIControlStateNormal];
		_archiveTasksButton.alpha = 0.0f;
		[self addSubview:_archiveTasksButton];

		_archiveAllTasksButton = [UIButton cheddarBigButton];
		[_archiveAllTasksButton setTitle:@"Archive All" forState:UIControlStateNormal];
		_archiveAllTasksButton.alpha = 0.0f;
		[self addSubview:_archiveAllTasksButton];
		
		_archiveCompletedTasksButton = [UIButton cheddarBigButton];
		[_archiveCompletedTasksButton setTitle:@"Archive Completed" forState:UIControlStateNormal];
		_archiveCompletedTasksButton.alpha = 0.0f;
		[self addSubview:_archiveCompletedTasksButton];
		
		_textField = [[SSTextField alloc] initWithFrame:CGRectZero];
		_textField.delegate = self;
		_textField.background = [[UIImage imageNamed:@"textfield"] stretchableImageWithLeftCapWidth:8 topCapHeight:0];
		_textField.textEdgeInsets = UIEdgeInsetsMake(0.0f, 13.0f, 0.0f, 13.0f);
		_textField.autocapitalizationType = UITextAutocapitalizationTypeSentences;
		_textField.autocorrectionType = UITextAutocorrectionTypeYes;
		_textField.textColor = [UIColor cheddarTextColor];
		_textField.placeholderTextColor = [UIColor cheddarLightTextColor];
		_textField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
		_textField.placeholder = @"What do you have to do?";
		_textField.returnKeyType = UIReturnKeyGo;
		_textField.font = [UIFont cheddarFontOfSize:18.0f];

		CDIKeyboardBar *keyboardBar = [[CDIKeyboardBar alloc] initWithFrame:CGRectMake(0.0f, 0.0f, size.width, UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ? 54.0f : 36.0f)];
		keyboardBar.keyInputView = _textField;
		_textField.inputAccessoryView = keyboardBar;
		[self addSubview:_textField];
		
		_shadowView = [[SSGradientView alloc] initWithFrame:CGRectMake(0.0f, [[self class] height], size.width, 3.0f)];
		_shadowView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
		_shadowView.backgroundColor = [UIColor clearColor];
		_shadowView.colors = [NSArray arrayWithObjects:
							  [UIColor colorWithWhite:0.0f alpha:0.1f],
							  [UIColor colorWithWhite:0.0f alpha:0.0f],
							  nil];
		_shadowView.alpha = 0.0f;
		[self addSubview:_shadowView];
		
		if ([SMTEDelegateController isTextExpanderTouchInstalled]) {
			self.textExpander = [[SMTEDelegateController alloc] init];
			self.textExpander.nextDelegate = self;
			_textField.delegate = self.textExpander;
			[[NSNotificationCenter defaultCenter] addObserver:self.textExpander selector:@selector(willEnterForeground) name:UIApplicationWillEnterForegroundNotification object:nil];
		}
	}
	return self;
}


- (void)layoutSubviews {
	CGFloat margin = [[self class] margin];
	CGSize size = self.bounds.size;
	_textField.frame = CGRectMake(margin - 3.0f, 2.0f, size.width - margin - margin + 6.0f, 46.0f);

	if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
		CGFloat spacing = 6.0f;
		if (size.width < 500.0f) {
			CGFloat width = roundf((size.width - margin - margin + 2.0f - spacing) / 2.0f);
			_renameListButton.frame = CGRectMake(margin - 1.0f, 5.0f, width, 42.0f);
			_archiveTasksButton.frame = CGRectMake(margin - 1.0f + spacing + width, 5.0f, width, 42.0f);
			_archiveAllTasksButton.frame = _archiveTasksButton.frame;
			_archiveCompletedTasksButton.frame = _archiveTasksButton.frame;
		} else {
			CGFloat width = roundf((size.width - margin - margin + 2.0f - spacing - spacing) / 3.0f);
			_renameListButton.frame = CGRectMake(margin - 1.0f, 5.0f, width, 42.0f);
			_archiveTasksButton.frame = CGRectMake(margin - 1.0f + spacing + width, 5.0f, width, 42.0f);
			_archiveAllTasksButton.frame = CGRectMake(margin - 1.0f + spacing + width, 5.0f, width, 42.0f);
			_archiveCompletedTasksButton.frame = CGRectMake(margin - 1.0f + spacing + width + spacing + width, 5.0f, width, 42.0f);
		}
	} else {
        CGFloat buttonWidth = roundf((size.width - margin - margin - margin) / 2.0f);
		_renameListButton.frame = CGRectMake(margin, 5.0f, buttonWidth, 42.0f);
		_archiveTasksButton.frame = CGRectMake(size.width - buttonWidth - margin, 5.0f, buttonWidth, 42.0f);
	}
}


- (void)setFrame:(CGRect)frame {
	if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
		if (frame.size.width < 500.0f && _archiveAllTasksButton.alpha > 0.0f) {
			[UIView animateWithDuration:0.2 delay:0.0 options:UIViewAnimationOptionAllowAnimatedContent animations:^{
				_archiveTasksButton.alpha = 1.0f;
				_archiveAllTasksButton.alpha = 0.0f;
				_archiveCompletedTasksButton.alpha = 0.0f;
			} completion:nil];
		} else if (frame.size.width >= 500.0f && _archiveTasksButton.alpha > 0.0f) {
			[UIView animateWithDuration:0.2 delay:0.0 options:UIViewAnimationOptionAllowAnimatedContent animations:^{
				_archiveTasksButton.alpha = 0.0f;
				_archiveAllTasksButton.alpha = 1.0f;
				_archiveCompletedTasksButton.alpha = 1.0f;
			} completion:nil];
		}
	}
	[super setFrame:frame];
}


#pragma mark - Editing

- (void)setEditing:(BOOL)editing animated:(BOOL)animated {
	_editing = editing;
	self.textField.enabled = !_editing;
	
	void (^change)(void) = ^{		
		_textField.alpha = _editing ? 0.0f : 1.0f;
		_renameListButton.alpha = _editing ? 1.0f : 0.0f;
		if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
			if (self.frame.size.width < 500.0f) {
				_archiveTasksButton.alpha = _renameListButton.alpha;
				_archiveAllTasksButton.alpha = 0.0f;
				_archiveCompletedTasksButton.alpha = 0.0f;
			} else {
				_archiveTasksButton.alpha = 0.0f;
				_archiveAllTasksButton.alpha = _renameListButton.alpha;
				_archiveCompletedTasksButton.alpha = _renameListButton.alpha;
			}
		} else {
			_archiveTasksButton.alpha = _renameListButton.alpha;
		}
	};
	
	if (animated) {
		[UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationCurveEaseInOut | UIViewAnimationOptionAllowUserInteraction animations:change completion:nil];
	} else {
		change();
	}
}


#pragma mark - Tag

- (void)showTags:(NSArray *)tags {
	_textField.enabled = NO;
	
	NSString *text = [[NSString stringWithFormat:@"#%@", [[tags valueForKey:@"name"] componentsJoinedByString:@" #"]] lowercaseString];
	
	if (!_tagContainer) {
		_tagContainer = [[UIView alloc] initWithFrame:self.bounds];
		_tagContainer.backgroundColor = [UIColor clearColor];
		_tagContainer.clipsToBounds = YES;
		[self addSubview:_tagContainer];
		
		CGSize size = self.bounds.size;
		
		_tagViewShadow = [[UIView alloc] initWithFrame:self.bounds];
		_tagViewShadow.backgroundColor = [UIColor blackColor];
		_tagViewShadow.alpha = 0.0f;
		[_tagContainer addSubview:_tagViewShadow];
		
		_tagView = [[CDITagView alloc] initWithFrame:CGRectMake(0.0f, size.height, size.width, size.height)];
		_tagView.textLabel.text = text;
		[_tagContainer addSubview:_tagView];
		
		UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(_closeTags)];
		[_tagView addGestureRecognizer:tap];
		
		[UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut | UIViewAnimationOptionAllowUserInteraction animations:^{
			_tagView.frame = CGRectMake(0.0f, 0.0f, size.width, size.height);
			_tagViewShadow.alpha = 0.55f;
		} completion:nil];
	} else {
		_tagView.textLabel.text = text;
	}
}


- (void)closeTags {
	_textField.enabled = YES;
	
	CGSize size = self.bounds.size;
	[UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut | UIViewAnimationOptionAllowUserInteraction animations:^{
		_tagView.frame = CGRectMake(0.0f, size.height, size.width, size.height);
		_tagViewShadow.alpha = 0.0f;
	} completion:^(BOOL finished) {
		[_tagView removeFromSuperview];
		_tagView = nil;
		
		[_tagViewShadow removeFromSuperview];
		_tagViewShadow = nil;
		
		[_tagContainer removeFromSuperview];
		_tagContainer = nil;
	}];
}


- (void)_closeTags {
	if ([self.delegate respondsToSelector:@selector(addTaskViewShouldCloseTags:)]) {
		[self.delegate addTaskViewShouldCloseTags:self];
	}
}


#pragma mark - UITextFieldDelegate

- (void)textFieldDidBeginEditing:(UITextField *)textField {
	_textField.background = [[UIImage imageNamed:@"textfield-focused"] stretchableImageWithLeftCapWidth:8 topCapHeight:0];
	
	if ([self.delegate respondsToSelector:@selector(addTaskViewDidBeginEditing:)]) {
		[self.delegate addTaskViewDidBeginEditing:self];
	}
}


- (void)textFieldDidEndEditing:(UITextField *)textField {
	_textField.background = [[UIImage imageNamed:@"textfield"] stretchableImageWithLeftCapWidth:8 topCapHeight:0];
	
	if ([self.delegate respondsToSelector:@selector(addTaskViewDidEndEditing:)]) {
		[self.delegate addTaskViewDidEndEditing:self];
	}
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField {
	if (textField.text.length == 0) {
		[textField resignFirstResponder];
		return NO;
	}
	
	NSString *title = textField.text;
	textField.text = nil;
	[self.delegate addTaskView:self didReturnWithTitle:title];
	return NO;
}

@end
