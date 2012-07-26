//
//  CDKTask+CheddariOSAdditions.h
//  Cheddar for iOS
//
//  Created by Sam Soffes on 7/25/12.
//  Copyright (c) 2012 Nothing Magical. All rights reserved.
//

#import <CheddarKit/CheddarKit.h>

@interface CDKTask (CheddariOSAdditions)

- (NSAttributedString *)attributedDisplayText;
- (void)addEntitiesToAttributedString:(NSMutableAttributedString *)attributedString;

@end
