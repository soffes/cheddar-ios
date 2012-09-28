//
//  CDIKeyboardButton.h
//  Cheddar for iOS
//
//  Created by Sam Soffes on 9/28/12.
//  Copyright (c) 2012 Nothing Magical. All rights reserved.
//

@interface CDIKeyboardButton : UIButton

@property (nonatomic, strong, readonly) NSString *character;

- (id)initWithCharacter:(NSString *)character;

@end
