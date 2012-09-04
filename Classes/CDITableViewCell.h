//
//  CDITableViewCell.h
//  Cheddar for iOS
//
//  Created by Sam Soffes on 3/31/12.
//  Copyright (c) 2012 Nothing Magical. All rights reserved.
//

@interface CDITableViewCell : UITableViewCell

@property (nonatomic, strong, readonly) SSTextField *textField;
@property (nonatomic, assign) BOOL editingText;

+ (CGFloat)cellHeight;

- (void)setEditingAction:(SEL)editAction forTarget:(id)target;
- (void)updateFonts;

@end
