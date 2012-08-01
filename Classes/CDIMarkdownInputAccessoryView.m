//
//  CDIMarkdownInputAccessoryView.m
//  Cheddar for iOS
//
//  Created by Josh Johnson on 7/31/12.
//  Copyright (c) 2012 Nothing Magical. All rights reserved.
//

#import "CDIMarkdownInputAccessoryView.h"

typedef enum {
    CDIMarkdownInputTypePound = 0,
    CDIMarkdownInputTypeStar = 1,
    CDIMarkdownInputTypeUnderscore = 2,
    CDIMarkdownInputTypeOpenSquareBracket = 3,
    CDIMarkdownInputTypeCloseSquareBracket = 4,
    CDIMarkdownInputTypeOpenParenthesis = 5,
    CDIMarkdownInputTypeCloseParenthesis = 6,
    CDIMarkdownInputTypeAtSymbol = 7
} CDIMarkdownInputType;

static NSString * const CDIMarkdownInputTypeValue[] = {
    [CDIMarkdownInputTypePound] = @"#",
    [CDIMarkdownInputTypeStar] = @"*",
    [CDIMarkdownInputTypeUnderscore] = @"_",
    [CDIMarkdownInputTypeOpenSquareBracket] = @"[",
    [CDIMarkdownInputTypeCloseSquareBracket] = @"]",
    [CDIMarkdownInputTypeOpenParenthesis] = @"(",
    [CDIMarkdownInputTypeCloseParenthesis] = @")",
    [CDIMarkdownInputTypeAtSymbol] = @"@"
};

@interface CDIMarkdownInputAccessoryView () {
    NSUInteger inputTypeCount;
}

@property (nonatomic, strong) UIToolbar *toolbar;

- (void)_buttonWasTapped:(id)sender;

@end

@implementation CDIMarkdownInputAccessoryView

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        _toolbar = [[UIToolbar alloc] initWithFrame:frame];
        [_toolbar setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
        [self addSubview:_toolbar];
        
        inputTypeCount = sizeof(CDIMarkdownInputTypeValue) / sizeof([NSString class]);
        NSArray *inputTypeStrings = [[NSArray alloc] initWithObjects:CDIMarkdownInputTypeValue count:inputTypeCount];
        CGFloat leftOffset = 0;
        CGFloat buttonWidth = self.frame.size.width / inputTypeCount;

        for (NSString *inputTypeString in inputTypeStrings) {
            UIButton *markdownKey = [UIButton buttonWithType:UIButtonTypeCustom];
            [markdownKey setTitle:inputTypeString forState:UIControlStateNormal];
            [markdownKey setShowsTouchWhenHighlighted:YES];
            [markdownKey addTarget:self action:@selector(_buttonWasTapped:) forControlEvents:UIControlEventTouchUpInside];
            leftOffset += buttonWidth;
            [_toolbar addSubview:markdownKey];
        }
    }
    return self;
}

#pragma mark - Class methods

+ (CGFloat)defaultHeight {
    return 44.0f;
}

#pragma mark - Layout

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat leftOffset = 0;
    CGFloat buttonWidth = self.toolbar.frame.size.width / inputTypeCount;
    for (id keyButton in self.toolbar.subviews) {
        if ([keyButton isKindOfClass:[UIButton class]]) {
            [keyButton setFrame:(CGRect){ leftOffset, 0, buttonWidth, self.frame.size.height }];
            leftOffset += buttonWidth;
        }
    }
}


#pragma mark - Button Action

- (void)_buttonWasTapped:(id)sender {
    if ([self.delegate respondsToSelector:@selector(markdownAccessoryView:didSelectKeyForString:)]) {
        UIButton *tappedButton = (UIButton *)sender;
        [self.delegate markdownAccessoryView:self didSelectKeyForString:[tappedButton titleForState:UIControlStateNormal]];
    }

    [[UIDevice currentDevice] playInputClick];
}


#pragma mark - UIInputViewAudioFeedback

- (BOOL)enableInputClicksWhenVisible {
    return YES;
}


@end
