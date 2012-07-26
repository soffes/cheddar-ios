//
//  CDITaskTableViewCell.h
//  Cheddar for iOS
//
//  Created by Sam Soffes on 4/5/12.
//  Copyright (c) 2012 Nothing Magical. All rights reserved.
//

#import "CDITableViewCell.h"

@class CDKTask;
@class CDIAttributedLabel;

@interface CDITaskTableViewCell : CDITableViewCell

+ (CGFloat)cellHeightForTask:(CDKTask *)task width:(CGFloat)width;

@property (nonatomic, strong) CDKTask *task;
@property (nonatomic, strong, readonly) CDIAttributedLabel *attributedLabel;

@end
