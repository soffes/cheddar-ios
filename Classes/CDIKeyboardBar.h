//
//  CDIKeyboardBar.h
//  Cheddar for iOS
//
//  Created by Sam Soffes on 9/28/12.
//  Copyright (c) 2012 Nothing Magical. All rights reserved.
//

@interface CDIKeyboardBar : SSGradientView <UIInputViewAudioFeedback>

@property (nonatomic, weak) id<UIKeyInput> keyInputView;

+ (NSArray *)characters;

@end
