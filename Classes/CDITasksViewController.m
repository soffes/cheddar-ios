//
//  CDITasksViewController.m
//  Cheddar for iOS
//
//  Created by Sam Soffes on 3/31/12.
//  Copyright (c) 2012 Nothing Magical. All rights reserved.
//

#import "CDITasksViewController.h"
#import "CDITaskTableViewCell.h"
#import "CDIAddTaskView.h"
#import "CDIAddTaskAnimationView.h"
#import "CDIAttributedLabel.h"
#import "CDICreateListViewController.h"
#import "CDITasksPlaceholderView.h"
#import "CDIEditTaskViewController.h"
#import "CDIWebViewController.h"
#import "CDISettingsTapPickerViewController.h"
#import "CDIHUDView.h"
#import "CDICheckboxButton.h"
#import "CDIKeyboardBar.h"
#import "UIColor+CheddariOSAdditions.h"
#import "UIFont+CheddariOSAdditions.h"

@interface CDITasksViewController () <CDIAddTaskViewDelegate, TTTAttributedLabelDelegate, UITextFieldDelegate, UIActionSheetDelegate, UIAlertViewDelegate>
@property (nonatomic, strong) CDIAddTaskView *addTaskView;
@property (nonatomic, strong) NSMutableArray *currentTags;
- (void)_renameList:(id)sender;
- (void)_archiveTasks:(id)sender;
- (void)_archiveAllTasks:(id)sender;
- (void)_archiveCompletedTasks:(id)sender;
- (void)_toggleCompletion:(CDICheckboxButton *)sender;
- (void)_editTask:(CDKTask *)task;
@end

@implementation CDITasksViewController {
	NSIndexPath *_textEditingIndexPath;
	dispatch_semaphore_t _createTaskSemaphore;
}

@synthesize addTaskView = _addTaskView;
@synthesize currentTags = _currentTags;
@synthesize focusKeyboard = _focusKeyboard;

- (void)setManagedObject:(SSManagedObject *)managedObject {
	CDKList *list = (CDKList *)self.managedObject;

	void *context = (__bridge void *)self;
	if (list) {
		[list removeObserver:self forKeyPath:@"title" context:context];
		[list removeObserver:self forKeyPath:@"archivedAt" context:context];
	}
	
	[super setManagedObject:managedObject];
	list = (CDKList *)self.managedObject;
	
	self.title = self.list.title;
	self.tableView.hidden = self.list == nil;
	
	if (list == nil) {
		return;
	}
	
	[list addObserver:self forKeyPath:@"title" options:NSKeyValueObservingOptionNew context:context];
	[list addObserver:self forKeyPath:@"archivedAt" options:NSKeyValueObservingOptionNew context:context];

	self.ignoreChange = YES;
	[self closeTags];
	
	self.fetchedResultsController.fetchRequest.predicate = self.predicate;
	[self.fetchedResultsController performFetch:nil];
	[self.tableView reloadData];
	self.ignoreChange = NO;
	
	[self setEditing:NO animated:NO];
	[self setLoading:NO animated:NO];
	
	[SSRateLimit executeBlock:^{
		[self refresh:nil];
	} name:[NSString stringWithFormat:@"refresh-list-%@", self.list.remoteID] limit:30.0];
}


- (CDKList *)list {
	return (CDKList *)self.managedObject;
}


- (CDIAddTaskView *)addTaskView {
	if (!_addTaskView) {
		_addTaskView = [[CDIAddTaskView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.tableView.bounds.size.width, [CDIAddTaskView height])];
		_addTaskView.delegate = self;
		[_addTaskView.renameListButton addTarget:self action:@selector(_renameList:) forControlEvents:UIControlEventTouchUpInside];
		[_addTaskView.archiveTasksButton addTarget:self action:@selector(_archiveTasks:) forControlEvents:UIControlEventTouchUpInside];
		[_addTaskView.archiveAllTasksButton addTarget:self action:@selector(_archiveAllTasks:) forControlEvents:UIControlEventTouchUpInside];
		[_addTaskView.archiveCompletedTasksButton addTarget:self action:@selector(_archiveCompletedTasks:) forControlEvents:UIControlEventTouchUpInside];
	}
	return _addTaskView;
}


#pragma mark - NSObject

- (id)init {
	if ((self = [super init])) {
		_createTaskSemaphore = dispatch_semaphore_create(0);
		dispatch_semaphore_signal(_createTaskSemaphore);
		
		self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Tasks" style:UIBarButtonItemStyleBordered target:nil action:nil];
	}
	return self;
}


- (void)dealloc {
	[[NSNotificationCenter defaultCenter] removeObserver:self];
	self.managedObject = nil;
	
	dispatch_semaphore_wait(_createTaskSemaphore, DISPATCH_TIME_FOREVER);
	dispatch_release(_createTaskSemaphore);
}


#pragma mark - UIViewController

- (void)viewDidLoad {
	[super viewDidLoad];
	
	[self setEditing:NO animated:NO];
	self.view.backgroundColor = [UIColor cheddarArchesColor];
	self.tableView.hidden = self.list == nil;
	self.tableView.scrollIndicatorInsets = UIEdgeInsetsMake([CDIAddTaskView height], 0.0f, 0.0f, 0.0f);
	self.pullToRefreshView.bottomBorderColor = [UIColor colorWithWhite:0.8f alpha:1.0f];

	self.noContentView = [[CDITasksPlaceholderView alloc] initWithFrame:CGRectZero];

}


- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
	
	[SSRateLimit executeBlock:^{
		[self refresh:nil];
	} name:[NSString stringWithFormat:@"refresh-list-%@", self.list.remoteID] limit:30.0];

	if (_focusKeyboard) {
		[self.addTaskView.textField becomeFirstResponder];
		_focusKeyboard = NO;
	}
}


- (void)setEditing:(BOOL)editing animated:(BOOL)animated {
	[super setEditing:editing animated:animated];
	
	if (!self.navigationItem.rightBarButtonItem) {
		self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Edit" style:UIBarButtonItemStyleBordered target:self action:@selector(toggleEditMode:)];
	}
	self.navigationItem.rightBarButtonItem.title = editing ? @"Done" : @"Edit";
	self.navigationItem.rightBarButtonItem.enabled = self.currentTags.count == 0 && self.list;
	[self.addTaskView setEditing:editing animated:animated];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
	if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
		return YES;
	}
	
	return toInterfaceOrientation != UIInterfaceOrientationPortraitUpsideDown;
}


#pragma mark - SSManagedViewController

+ (Class)fetchedResultsControllerClass {
	return [SSFilterableFetchedResultsController class];
}


- (Class)entityClass {
	return [CDKTask class];
}


- (NSPredicate *)predicate {
	return [NSPredicate predicateWithFormat:@"list = %@ AND archivedAt = nil", self.list];
}


#pragma mark - SSManagedTableViewController

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
	CDITaskTableViewCell *taskCell = (CDITaskTableViewCell *)cell;
	taskCell.task = [self objectForViewIndexPath:indexPath];
	taskCell.attributedLabel.tag = indexPath.row;
}


#pragma mark - CDIManagedTableViewController

- (void)editRow:(UIGestureRecognizer *)editingGestureRecognizer {
	NSIndexPath *indexPath = [self.tableView indexPathForCell:(UITableViewCell *)editingGestureRecognizer.view];
	if (!indexPath) {
		return;
	}

	CDKTask *task = [self objectForViewIndexPath:indexPath];
	[self _editTask:task];
}


- (void)coverViewTapped:(id)sender {
	[self.addTaskView.textField resignFirstResponder];
}


#pragma mark - Actions

- (void)refresh:(id)sender {
	if (self.list == nil || self.loading) {
		return;
	}
	
	CDKList *list = self.list;
	self.loading = YES;
	[[CDKHTTPClient sharedClient] getTasksWithList:list success:^(AFJSONRequestOperation *operation, id responseObject) {
		dispatch_async(dispatch_get_main_queue(), ^{
			self.loading = NO;
		});
	} failure:^(AFJSONRequestOperation *operation, NSError *error) {
		dispatch_async(dispatch_get_main_queue(), ^{
			[SSRateLimit resetLimitForName:[NSString stringWithFormat:@"refresh-list-%@", self.list.remoteID]];
			self.loading = NO;
		});
	}];
}


#pragma mark - Tags

- (void)addTag:(CDKTag *)tag {
	if (!tag || [_currentTags containsObject:tag]) {
		return;
	}
	
	if (!_currentTags) {
		_currentTags = [[NSMutableArray alloc] init];
	}
	
	[_currentTags addObject:tag];
	
	SSFilterableFetchedResultsController *controller = (SSFilterableFetchedResultsController *)self.fetchedResultsController;
	
	NSString *filterName = [_currentTags componentsJoinedByString:@","];
	[self.addTaskView showTags:_currentTags];
	[controller addFilterPredicate:^BOOL(id obj) {
		return [(CDKTask *)obj hasTags:_currentTags];
	} forKey:filterName];
	[controller setActiveFilterByKey:filterName];
	
	self.navigationItem.rightBarButtonItem.enabled = NO;
	[self setEditing:NO animated:YES];
}


- (void)closeTags {
	[self.addTaskView closeTags];
	
	SSFilterableFetchedResultsController *controller = (SSFilterableFetchedResultsController *)self.fetchedResultsController;
	[controller removeCurrentFilter];
	
	[_currentTags removeAllObjects];
	
	self.navigationItem.rightBarButtonItem.enabled = YES;
}


#pragma mark - Private

- (void)updateTableViewOffsets {
	CGFloat offset = self.tableView.contentOffset.y;
	CGFloat top = [CDIAddTaskView height] - fminf(0.0f, offset);
	CGFloat bottom = (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) ? self.keyboardRect.size.height : 0.0f;
	self.tableView.scrollIndicatorInsets = UIEdgeInsetsMake(top, 0.0f, bottom, 0.0f);
	self.pullToRefreshView.defaultContentInset = UIEdgeInsetsMake(0.0f, 0.0f, bottom, 0.0f);
	self.addTaskView.shadowView.alpha = fmaxf(0.0f, fminf(offset / 24.0f, 1.0f));
}


- (void)_renameList:(id)sender {
	CDICreateListViewController *viewController = [[CDICreateListViewController alloc] init];
	viewController.list = self.list;
	UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:viewController];
	navigationController.modalPresentationStyle = UIModalPresentationFormSheet;
	[self.navigationController presentModalViewController:navigationController animated:YES];
}


- (void)_archiveTasks:(id)sender {
	// TODO: This is super ugly
	if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
		UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:@"Archive Completed", @"Archive All", nil];
		[actionSheet showFromRect:[sender frame] inView:self.view animated:YES];
	} else {
		UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Archive Completed", @"Archive All", nil];
		actionSheet.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
		[actionSheet showInView:self.navigationController.view];
	}
}


- (void)_archiveAllTasks:(id)sender {
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Archive All Tasks" message:@"Do you want to archive all of the tasks in this list?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Archive", nil];
	alert.tag = 1;
	[alert show];
}


- (void)_archiveCompletedTasks:(id)sender {
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Archive Completed Tasks" message:@"Do you want to archive all of the completed tasks in this list?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Archive", nil];
	alert.tag = 2;
	[alert show];
}


- (void)_toggleCompletion:(CDICheckboxButton *)sender {
	NSIndexPath *indexPath = [self.tableView indexPathForCell:(UITableViewCell *)sender.tableViewCell];
	if (!indexPath) {
		return;
	}

	CDKTask *task = [self objectForViewIndexPath:indexPath];
	if (!task) {
		return;
	}

	[task toggleCompleted];
}


- (void)_editTask:(CDKTask *)task {
	CDIEditTaskViewController *viewController = [[CDIEditTaskViewController alloc] init];
	viewController.task = task;
	UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:viewController];
	navigationController.modalPresentationStyle = UIModalPresentationFormSheet;
	[self.navigationController presentModalViewController:navigationController animated:YES];
}


#pragma mark - UITableViewDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	static NSString *const cellIdentifier = @"cellIdentifier";
	
	CDITaskTableViewCell *cell = (CDITaskTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
	if (!cell) {
		cell = [[CDITaskTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
		cell.selectionStyle = UITableViewCellSelectionStyleNone;
		cell.attributedLabel.delegate = self;
    	[cell setEditingAction:@selector(editRow:) forTarget:self];
		[cell.checkboxButton addTarget:self action:@selector(_toggleCompletion:) forControlEvents:UIControlEventTouchUpInside];
	}
	
	[self configureCell:cell atIndexPath:indexPath];
	
	return cell;
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
	return self.addTaskView;
}


#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	NSString *action = [CDISettingsTapPickerViewController selectedKey];
	
	// Nothing
	if ([action isEqualToString:kCDITapActionNothingKey]) {
		return;
	}	
	
	CDKTask *task = [self objectForViewIndexPath:indexPath];
	
	// Complete
	if ([action isEqualToString:kCDITapActionCompleteKey]) {
		[task toggleCompleted];
		return;
	}
	
	// Edit
	if ([action isEqualToString:kCDITapActionEditKey]) {
		[self _editTask:task];
	}
}


- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
	return @"Archive";
}


- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
	if (editingStyle != UITableViewCellEditingStyleDelete) {
		return;
	}
	
	CDKTask *task = [self objectForViewIndexPath:indexPath];
	task.archivedAt = [NSDate date];
	[task save];
	[task update];
}


- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath {
	if (sourceIndexPath.row == destinationIndexPath.row) {
		return;
	}
	
	self.ignoreChange = YES;
	NSMutableArray *tasks = [self.fetchedResultsController.fetchedObjects mutableCopy];
	CDKTask *task = [self objectForViewIndexPath:sourceIndexPath];
	[tasks removeObject:task];
	[tasks insertObject:task atIndex:destinationIndexPath.row];
	
	NSInteger i = 0;
	for (task in tasks) {
		task.position = [NSNumber numberWithInteger:i++];
	}
	
	[self.managedObjectContext save:nil];
	self.ignoreChange = NO;
	
	[CDKTask sortWithObjects:tasks];
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
	return [CDIAddTaskView height];
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	CDKTask *task = [self objectForViewIndexPath:indexPath];
	return [CDITaskTableViewCell cellHeightForTask:task width:tableView.frame.size.width];
}


#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
	if ([self showingCoverView]) {
		[self.addTaskView.textField resignFirstResponder];
	}
	
	[super scrollViewDidScroll:scrollView];
}


#pragma mark - CDIAddTaskViewDelegate

- (void)addTaskView:(CDIAddTaskView *)addTaskView didReturnWithTitle:(NSString *)title {
	dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
		dispatch_semaphore_wait(_createTaskSemaphore, DISPATCH_TIME_FOREVER);
		dispatch_async(dispatch_get_main_queue(), ^{
			CDIAddTaskAnimationView *animation = [[CDIAddTaskAnimationView alloc] initWithFrame:self.view.bounds];
			animation.title = title;
			[self.view addSubview:animation];
			
			self.ignoreChange = YES;
			
			NSInteger numberOfRows = [self.tableView numberOfRowsInSection:0];
			NSIndexPath *indexPath = [NSIndexPath indexPathForRow:numberOfRows inSection:0];
			
			CDKTask *task = [[CDKTask alloc] init];
			task.text = title;
			task.displayText = title;
			task.list = self.list;
			task.position = [NSNumber numberWithInteger:self.list.highestPosition + 1];
			
			CGPoint point = CGPointZero;
			if (numberOfRows > 0) {
				CGRect rect = [self.tableView rectForRowAtIndexPath:[NSIndexPath indexPathForRow:numberOfRows - 1 inSection:0]];
				point = rect.origin;
				point.y += rect.size.height;
			} else {
				point.y = [CDIAddTaskView height];
			}
			
			[animation animationToPoint:point height:self.tableView.bounds.size.height insertTask:^{
				[self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationNone];
				self.ignoreChange = NO;
			} completion:^{		
				[animation removeFromSuperview];
				dispatch_semaphore_signal(_createTaskSemaphore);
			}];
			
			[task createWithSuccess:nil failure:^(AFJSONRequestOperation *remoteOperation, NSError *error) {
				dispatch_async(dispatch_get_main_queue(), ^{
					addTaskView.textField.text = title;
					CDIHUDView *hud = [[CDIHUDView alloc] init];
					[hud failQuicklyWithTitle:@"Failed to create task"];
				});
			}];
		});
	});
}


- (void)addTaskViewDidBeginEditing:(CDIAddTaskView *)addTaskView {
	if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
		[self showCoverView];
	}
}


- (void)addTaskViewDidEndEditing:(CDIAddTaskView *)addTaskView {
	[self hideCoverView];
}


- (void)addTaskViewShouldCloseTags:(CDIAddTaskView *)addTaskView; {
	[self closeTags];
}


#pragma mark - TTTAttributedLabelDelegate

- (void)attributedLabel:(TTTAttributedLabel *)label didSelectLinkWithURL:(NSURL *)url {
	// Open tag
	if ([url.scheme isEqualToString:@"x-cheddar-tag"]) {
		CDKTag *tag = [CDKTag existingTagWithName:url.host];
		[self addTag:tag];
		return;
	}
	
	// Open browser
	if ([url.scheme.lowercaseString isEqualToString:@"http"] || [url.scheme.lowercaseString isEqualToString:@"https"]) {
		CDIWebViewController *viewController = [[CDIWebViewController alloc] init];
		[viewController loadURL:url];
		
		if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
			UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:viewController];
			[self.splitViewController presentModalViewController:navigationController animated:YES];
		} else {
			[self.navigationController pushViewController:viewController animated:YES];
		}
		return;
	}
	
	// Open other URLs
	[[UIApplication sharedApplication] openURL:url];
}


#pragma mark - UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex {
	if (buttonIndex == 0) {
		[self setEditing:NO animated:YES];
		[self.list archiveCompletedTasks];
	} else if (buttonIndex == 1) {
		[self setEditing:NO animated:YES];
		[self.list archiveAllTasks];
	}
}


#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
	if (buttonIndex == 0) {
		return;
	}

	[self setEditing:NO animated:YES];
	
	if (alertView.tag == 1) {
		[self.list archiveAllTasks];
		[self setEditing:NO animated:YES];
	} else if (alertView.tag == 2) {
		[self.list archiveCompletedTasks];
	}
}


#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
	CDKTask *task = [self objectForViewIndexPath:self.editingIndexPath];
	task.text = textField.text;
	task.displayText = textField.text;
	task.entities = nil;
	[task save];
	[task update];
	
	[self endCellTextEditing];
	return NO;
}


#pragma mark - NSKeyValueObserving

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
	if (context != (__bridge void *)self) {
		[super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
		return;
	}

	if ([keyPath isEqualToString:@"title"]) {
		self.title = [change objectForKey:NSKeyValueChangeNewKey];
	} else if (UI_USER_INTERFACE_IDIOM() != UIUserInterfaceIdiomPad && [keyPath isEqualToString:@"archivedAt"]) {
		if ([change objectForKey:NSKeyValueChangeNewKey] != [NSNull null]) {
			[self.navigationController popToRootViewControllerAnimated:YES];
		}
	}
}

@end
