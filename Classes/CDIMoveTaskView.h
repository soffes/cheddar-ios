//
//  CDIMoveTaskView.h
//  Cheddar for iOS
//
//  Created by Sam Soffes on 9/30/12.
//  Copyright (c) 2012 Nothing Magical. All rights reserved.
//

@class CDIEditTaskViewController;

@interface CDIMoveTaskView : UIView

@property (nonatomic, weak) CDIEditTaskViewController *editViewController;
@property (nonatomic, strong, readonly) UIButton *moveButton;
@property (nonatomic, strong, readonly) UITableView *tableView;

@end
