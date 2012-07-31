//
//  CDIAddTaskView.h
//  Cheddar for iOS
//
//  Created by Sam Soffes on 4/16/12.
//  Copyright (c) 2012 Nothing Magical. All rights reserved.
//

@protocol CDIAddTaskViewDelegate;

@interface CDIAddTaskView : UIView

@property (nonatomic, weak) id<CDIAddTaskViewDelegate> delegate;
@property (nonatomic, strong, readonly) SSTextField *textField;
@property (nonatomic, strong, readonly) SSGradientView *shadowView;
@property (nonatomic, strong, readonly) UIButton *renameListButton;
@property (nonatomic, strong, readonly) UIButton *archiveTasksButton;
@property (nonatomic, strong, readonly) UIButton *archiveAllTasksButton;
@property (nonatomic, strong, readonly) UIButton *archiveCompletedTasksButton;
@property (nonatomic, assign) BOOL editing;

+ (CGFloat)height;
+ (CGFloat)margin;
- (void)setEditing:(BOOL)editing animated:(BOOL)animated;

- (void)showTags:(NSArray *)tags;
- (void)closeTags;

@end


@protocol CDIAddTaskViewDelegate <NSObject>

@required

- (void)addTaskView:(CDIAddTaskView *)addTaskView didReturnWithTitle:(NSString *)title;

@optional

- (void)addTaskViewDidBeginEditing:(CDIAddTaskView *)addTaskView;
- (void)addTaskViewDidEndEditing:(CDIAddTaskView *)addTaskView;
- (void)addTaskViewShouldCloseTags:(CDIAddTaskView *)addTaskView;

@end