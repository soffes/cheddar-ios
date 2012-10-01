//
//  CDIMoveTaskView.m
//  Cheddar for iOS
//
//  Created by Sam Soffes on 9/30/12.
//  Copyright (c) 2012 Nothing Magical. All rights reserved.
//

#import "CDIMoveTaskView.h"
#import "CDIEditTaskViewController.h"
#import "CDIGroupedTableViewCell.h"
#import "UIFont+CheddariOSAdditions.h"
#import "UIColor+CheddariOSAdditions.h"

@interface CDIMoveTaskView () <UITableViewDataSource, UITableViewDelegate>
@end

@implementation CDIMoveTaskView {
	SSGradientView *_shadowView;
	UITableView *_tableView;
	NSArray *_lists;
}

@synthesize editViewController = _editViewController;
@synthesize moveButton = _moveButton;
@synthesize tableView = _tableView;

- (void)setEditViewController:(CDIEditTaskViewController *)editViewController {
	_editViewController = editViewController;
	
	// Get lists
	CDKList *currentList = _editViewController.task.list;
	NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
	fetchRequest.entity = [CDKList entity];
	fetchRequest.sortDescriptors = [CDKList defaultSortDescriptors];
	fetchRequest.predicate = [NSPredicate predicateWithFormat:@"remoteID != %@ AND archivedAt = nil AND user = %@", currentList.remoteID, [CDKUser currentUser]];
	_lists = [[CDKList mainContext] executeFetchRequest:fetchRequest error:nil];

	if (_lists.count == 0) {
		UILabel *instructionsLabel = (UILabel *)_tableView.tableHeaderView;
		instructionsLabel.text = @"You don't have any other lists.";
	}
}


#pragma mark - UIView

- (id)initWithFrame:(CGRect)frame {
	if ((self = [super initWithFrame:frame])) {
		_moveButton = [[UIButton alloc] init];
		_moveButton.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleBottomMargin;
		[_moveButton setImage:[UIImage imageNamed:@"move_task"] forState:UIControlStateNormal];
		[self addSubview:_moveButton];

		_tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
		_tableView.dataSource = self;
		_tableView.delegate = self;

		SSLabel *instructionsLabel = [[SSLabel alloc] initWithFrame:CGRectMake(0.0f, 0.0f, frame.size.width, 38.0f)];
		instructionsLabel.text = @"Select a list to move this task to";
		instructionsLabel.font = [UIFont cheddarInterfaceFontOfSize:14.0f];
		instructionsLabel.textColor = [UIColor cheddarLightTextColor];
		instructionsLabel.backgroundColor = [UIColor clearColor];
		instructionsLabel.textAlignment = UITextAlignmentCenter;
		instructionsLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
		instructionsLabel.textEdgeInsets = UIEdgeInsetsMake(10.0f, 0.0f, 0.0f, 0.0f);
		_tableView.tableHeaderView = instructionsLabel;

		UIView *backgroundView = [[UIView alloc] init];
		backgroundView.backgroundColor = [UIColor cheddarArchesColor];
		_tableView.backgroundView = backgroundView;

		[self addSubview:_tableView];

		_shadowView = [[SSGradientView alloc] init];
		_shadowView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleBottomMargin;
		_shadowView.backgroundColor = [UIColor clearColor];
		_shadowView.topBorderColor = [UIColor colorWithWhite:0.812f alpha:1.0f];
		_shadowView.colors = @[[UIColor colorWithWhite:0.937f alpha:1.0f],
							   [UIColor colorWithWhite:0.937f alpha:0.0f]];
		[self addSubview:_shadowView];
	}
	return self;
}


- (void)layoutSubviews {
	CGSize size = self.bounds.size;

	_moveButton.frame = CGRectMake(size.width - 32.0f, 0.0f, 32.0f, 32.0f);
	_tableView.frame = CGRectMake(0.0f, 32.0f, size.width, size.height - 32.0f);
	_shadowView.frame = CGRectMake(0.0f, 32.0f, size.width, 4.0f);
}


#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return _lists.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	NSString *cellIdentifier = @"None";
	NSUInteger numberOfRows = [tableView numberOfRowsInSection:indexPath.section];
	if (numberOfRows == 1) {
		cellIdentifier = @"Both";
	} else if (indexPath.row == 0) {
		cellIdentifier = @"Top";
	} else if (indexPath.row == numberOfRows - 1) {
		cellIdentifier = @"Bottom";
	}

	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
	if (!cell) {
		cell = [[CDIGroupedTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
	}

	cell.textLabel.text = [[_lists objectAtIndex:indexPath.row] title];

	return cell;
}


#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	[self.editViewController moveTaskToList:[_lists objectAtIndex:indexPath.row]];
}

@end
