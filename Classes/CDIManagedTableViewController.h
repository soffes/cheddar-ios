//
//  CDIManagedTableViewController.h
//  Cheddar for iOS
//
//  Created by Sam Soffes on 4/10/12.
//  Copyright (c) 2012 Nothing Magical. All rights reserved.
//

#import "CDIPullToRefreshView.h"

@interface CDIManagedTableViewController : SSManagedTableViewController <SSPullToRefreshViewDelegate, UITextFieldDelegate>

@property (nonatomic, strong, readonly) CDIPullToRefreshView *pullToRefreshView;
@property (nonatomic, strong, readonly) NSIndexPath *editingIndexPath;
@property (nonatomic, assign, readonly) CGRect keyboardRect;
@property (nonatomic, strong) UIView *coverView;

- (void)refresh:(id)sender;
- (void)toggleEditMode:(id)sender;
- (void)endCellTextEditing;
- (void)editRow:(UIGestureRecognizer *)editingGestureRecognizer;

- (void)updateTableViewOffsets;
- (void)keyboardDidShow:(NSNotification *)notification;
- (void)keyboardDidHide:(NSNotification *)notification;
- (void)reachabilityChanged:(NSNotification *)notification;

- (void)showCoverView;
- (BOOL)showingCoverView;
- (void)hideCoverView;
- (void)coverViewTapped:(id)sender;

@end
