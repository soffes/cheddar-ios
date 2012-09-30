//
//  CDIEditTaskViewController.h
//  Cheddar for iOS
//
//  Created by Sam Soffes on 5/30/12.
//  Copyright (c) 2012 Nothing Magical. All rights reserved.
//

@class CDKTask;

@interface CDIEditTaskViewController : UIViewController

@property (nonatomic, strong) CDKTask *task;
@property (nonatomic, strong, readonly) SSTextView *textView;

- (void)save:(id)sender;
- (void)cancel:(id)sender;
- (void)moveTask:(id)sender;

- (void)moveTaskToList:(CDKList *)newList;

@end
