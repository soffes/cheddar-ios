//
//  CDIMarkdownInputAccessoryView.h
//  Cheddar for iOS
//
//  Created by Josh Johnson on 8/1/12.
//  Copyright (c) 2012 Nothing Magical. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CDIMarkdownInputAccessoryViewDelegate;

@interface CDIMarkdownInputAccessoryView : UIView <UIInputViewAudioFeedback>

@property (nonatomic, weak) NSObject<CDIMarkdownInputAccessoryViewDelegate> *delegate;

+ (CGFloat)defaultHeight;

@end

@protocol CDIMarkdownInputAccessoryViewDelegate <NSObject>

@required

- (void)markdownAccessoryView:(CDIMarkdownInputAccessoryView *)markdownView didSelectKeyForString:(NSString *)characterString;

@end
