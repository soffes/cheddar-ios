//
//  CDIPlaceholderView.h
//  Cheddar for iOS
//
//  Created by Sam Soffes on 8/25/12.
//  Copyright (c) 2012 Nothing Magical. All rights reserved.
//

typedef enum {
	CDIPlaceholderViewArrowAlignmentLeft,
	CDIPlaceholderViewArrowAlignmentRight
} CDIPlaceholderViewArrowAlignment;

@interface CDIPlaceholderView : UIView

@property (nonatomic, strong, readonly) UIImageView *iconImageView;
@property (nonatomic, strong, readonly) UIImageView *arrowImageView;
@property (nonatomic, strong, readonly) UILabel *arrowLabel;
@property (nonatomic, strong, readonly) SSLabel *titleLabel;

@property (nonatomic, assign) CDIPlaceholderViewArrowAlignment arrowAligment;

@end
