//
//  CDICheckboxButton.h
//  Cheddar for iOS
//
//  Created by Sam Soffes on 9/3/12.
//  Copyright (c) 2012 Nothing Magical. All rights reserved.
//

@interface CDICheckboxButton : UIButton

// We need a reference to the table view cell so the action action get the index path by passing the table view cell to
// the table view.
@property (nonatomic, weak) UITableViewCell *tableViewCell;

@end
