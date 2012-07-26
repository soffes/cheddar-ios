//
//  CDIAddTaskAnimationView.h
//  Cheddar for iOS
//
//  Created by Sam Soffes on 4/29/12.
//  Copyright (c) 2012 Nothing Magical. All rights reserved.
//

@interface CDIAddTaskAnimationView : UIView

@property (nonatomic, strong) NSString *title;

- (void)animationToPoint:(CGPoint)point height:(CGFloat)height insertTask:(void(^)(void))insertTask completion:(void(^)(void))completion;

@end
