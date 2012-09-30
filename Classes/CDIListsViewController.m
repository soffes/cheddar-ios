//
//  CDIListsViewController.m
//  Cheddar for iOS
//
//  Created by Sam Soffes on 3/30/12.
//  Copyright (c) 2012 Nothing Magical. All rights reserved.
//

#import "CDIListsViewController.h"
#import "CDIListTableViewCell.h"
#import "CDITasksViewController.h"
#import "CDICreateListViewController.h"
#import "CDISettingsViewController.h"
#import "CDISplitViewController.h"
#import "UIColor+CheddariOSAdditions.h"
#import "CDIUpgradeViewController.h"
#import "CDIListsPlaceholderView.h"
#import "CDIAddListTableViewCell.h"
#import "CDIHUDView.h"
#import "SMTEDelegateController.h"
#import <SSToolkit/UIScrollView+SSToolkitAdditions.h>

#ifdef CHEDDAR_USE_PASSWORD_FLOW
	#import "CDISignInViewController.h"
#else
	#import "CDIWebSignInViewController.h"
#endif

NSString *const kCDISelectedListKey = @"CDISelectedListKey";

@interface CDIListsViewController ()
@property (nonatomic, strong) SMTEDelegateController *textExpander;
- (void)_listUpdated:(NSNotification *)notification;
- (void)_currentUserDidChange:(NSNotification *)notification;
- (void)_createList:(id)sender;
- (void)_cancelAddingList:(id)sender;
- (void)_selectListAtIndexPath:(NSIndexPath *)indexPath newList:(BOOL)newList;
- (void)_checkUser;
- (void)_beginEditingWithGesture:(UIGestureRecognizer *)gestureRecognizer;
- (BOOL)_shouldEditRowForGesture:(UIGestureRecognizer *)gestureRecognizer;
@end

@implementation CDIListsViewController {
	CDKList *_selectedList;
	BOOL _adding;
	BOOL _checkForOneList;
}


@synthesize textExpander = _textExpander;


#pragma mark - NSObject

- (void)dealloc {
	if (self.textExpander) {
		[[NSNotificationCenter defaultCenter] removeObserver:self.textExpander];
	}
}


#pragma mark - UIViewController

- (void)viewDidLoad {
	[super viewDidLoad];
	UIImageView *title = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"nav-title"]];
    title.accessibilityLabel = @"Cheddar";
	title.frame = CGRectMake(0.0f, 0.0f, 116.0f, 21.0f);	
	self.navigationItem.titleView = title;
	self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Lists" style:UIBarButtonItemStyleBordered target:nil action:nil];
	self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"plus"] style:UIBarButtonItemStyleBordered target:self action:@selector(createList:)];

	[self setEditing:NO animated:NO];

	self.noContentView = [[CDIListsPlaceholderView alloc] initWithFrame:CGRectZero];

	if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_listUpdated:) name:kCDKListDidUpdateNotificationName object:nil];
	}
	
	_checkForOneList = YES;
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_currentUserDidChange:) name:kCDKCurrentUserChangedNotificationName object:nil];
	
	if ([SMTEDelegateController isTextExpanderTouchInstalled]) {
		self.textExpander = [[SMTEDelegateController alloc] init];
		self.textExpander.nextDelegate = self;
		[[NSNotificationCenter defaultCenter] addObserver:self.textExpander selector:@selector(willEnterForeground) name:UIApplicationWillEnterForegroundNotification object:nil];
	}
}


- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
		[self _checkUser];
	}
}

- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
	if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
		[self _checkUser];
	}
	
	[SSRateLimit executeBlock:^{
		[self refresh:nil];
	} name:@"refresh-lists" limit:30.0];
}


- (void)setEditing:(BOOL)editing animated:(BOOL)animated {
	[super setEditing:editing animated:animated];
	
	if (editing) {
		self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleBordered target:self action:@selector(toggleEditMode:)];
		self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Settings" style:UIBarButtonItemStyleBordered target:self action:@selector(showSettings:)];
	} else {
		self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Edit" style:UIBarButtonItemStyleBordered target:self action:@selector(toggleEditMode:)];
		self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"plus"] style:UIBarButtonItemStyleBordered target:self action:@selector(createList:)];
	}

	if (!editing && UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
		[self.tableView selectRowAtIndexPath:[self.fetchedResultsController indexPathForObject:_selectedList] animated:YES scrollPosition:UITableViewScrollPositionNone];
	}
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
	if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
		return YES;
	}
	
	return toInterfaceOrientation != UIInterfaceOrientationPortraitUpsideDown;
}

#pragma mark - Gestures

- (BOOL)_shouldEditRowForGesture:(UIGestureRecognizer *)gestureRecognizer {
    BOOL didLongPressGestureSucceed = [gestureRecognizer isKindOfClass:[UITapGestureRecognizer class]] && gestureRecognizer.state == UIGestureRecognizerStateEnded;
    BOOL didTapGestureSucceed = [gestureRecognizer isKindOfClass:[UILongPressGestureRecognizer class]] && gestureRecognizer.state == UIGestureRecognizerStateBegan;
    return didTapGestureSucceed || didLongPressGestureSucceed;
}


- (void)_beginEditingWithGesture:(UIGestureRecognizer *)gestureRecognizer {
    if ([self _shouldEditRowForGesture:gestureRecognizer]) {
        if (![self isEditing]) {
            [self setEditing:YES animated:YES];
        }
        
        [self editRow:gestureRecognizer];
    }
}


#pragma mark - SSManagedViewController

- (Class)entityClass {
	return [CDKList class];
}


- (NSPredicate *)predicate {
	return [NSPredicate predicateWithFormat:@"archivedAt = nil && user = %@", [CDKUser currentUser]];
}


#pragma mark - SSManagedTableViewController

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
	CDKList *list = [self objectForViewIndexPath:indexPath];
	[(CDIListTableViewCell *)cell setList:list];
}


- (NSIndexPath *)viewIndexPathForFetchedIndexPath:(NSIndexPath *)fetchedIndexPath {
	if (_adding) {
		return [NSIndexPath indexPathForRow:fetchedIndexPath.row + 1 inSection:fetchedIndexPath.section];
	}

	return fetchedIndexPath;
}


- (NSIndexPath *)fetchedIndexPathForViewIndexPath:(NSIndexPath *)viewIndexPath {
	if (_adding) {
		return [NSIndexPath indexPathForRow:viewIndexPath.row - 1 inSection:viewIndexPath.section];
	}

	return viewIndexPath;
}


#pragma mark - CDIManagedTableViewController

- (void)coverViewTapped:(id)sender {
	[self _cancelAddingList:sender];
}


#pragma mark - Actions

- (void)refresh:(id)sender {
	if (self.loading || ![CDKUser currentUser]) {
		return;
	}
	
	self.loading = YES;
	[[CDKHTTPClient sharedClient] getListsWithSuccess:^(AFJSONRequestOperation *operation, id responseObject) {
		dispatch_async(dispatch_get_main_queue(), ^{
			self.loading = NO;
		});
	} failure:^(AFJSONRequestOperation *operation, NSError *error) {
		dispatch_async(dispatch_get_main_queue(), ^{
			[SSRateLimit resetLimitForName:@"refresh-lists"];
			self.loading = NO;
		});
	}];

	// Also update their user incase push for updates failed
	[[CDKHTTPClient sharedClient] updateCurrentUserWithSuccess:nil failure:nil];
}


- (void)showSettings:(id)sender {
	CDISettingsViewController *viewController = [[CDISettingsViewController alloc] init];
	UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:viewController];
	navigationController.modalPresentationStyle = UIModalPresentationFormSheet;
    [self toggleEditMode:self];
	[self.navigationController presentModalViewController:navigationController animated:YES];
}


- (void)createList:(id)sender {
	if (self.fetchedResultsController.fetchedObjects.count >= 2 && [[CDKUser currentUser] hasPlus].boolValue == NO) {
		UIViewController *viewController = [[CDIUpgradeViewController alloc] init];
		UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:viewController];
		navigationController.modalPresentationStyle = UIModalPresentationFormSheet;
		[self.navigationController presentModalViewController:navigationController animated:YES];
		return;
	}

	[self hideNoContentView:YES];
	UIView *coverView = self.coverView;
	coverView.frame = self.view.bounds;
	[self setEditing:NO animated:YES];
	self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStyleBordered target:self action:@selector(_cancelAddingList:)];
	self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Create" style:UIBarButtonItemStyleDone target:self action:@selector(_createList:)];
	[UIView animateWithDuration:0.2 delay:0.0 options:UIViewAnimationOptionAllowUserInteraction animations:^{
		[self.tableView scrollToTopAnimated:NO];
		coverView.alpha = 1.0f;

		_adding = YES;
		[self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationTop];
		coverView.frame = CGRectMake(0.0f, [CDIListTableViewCell cellHeight], self.tableView.bounds.size.width, self.tableView.bounds.size.height - [CDIListTableViewCell cellHeight]);
	} completion:nil];
	return;
}


#pragma mark - Private

- (void)_listUpdated:(NSNotification *)notification {
	if ([notification.object isEqual:_selectedList.remoteID] == NO) {
		return;
	}

	if (_selectedList.archivedAt != nil) {
		[CDISplitViewController sharedSplitViewController].listViewController.managedObject = nil;
		_selectedList = nil;
	}
}


- (void)_currentUserDidChange:(NSNotification *)notification {
	self.fetchedResultsController = nil;
	_checkForOneList = YES;
	[self.tableView reloadData];
}


- (void)_createList:(id)sender {
	CDIAddListTableViewCell *cell = (CDIAddListTableViewCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
	UITextField *textField = cell.textField;
	if (textField.text.length == 0) {
		[self _cancelAddingList:nil];
		return;
	}

	CDIHUDView *hud = [[CDIHUDView alloc] initWithTitle:@"Creating..." loading:YES];
	[hud show];
	
	CDKList *list = [[CDKList alloc] init];
	list.title = textField.text;
	list.position = [NSNumber numberWithInteger:INT32_MAX];
	list.user = [CDKUser currentUser];
	
	[list createWithSuccess:^{
		dispatch_async(dispatch_get_main_queue(), ^{
			[hud completeAndDismissWithTitle:@"Created!"];
			[self _cancelAddingList:nil];
			textField.text = nil;
			NSIndexPath *indexPath = [self.fetchedResultsController indexPathForObject:list];
			[self.tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
			[self _selectListAtIndexPath:indexPath newList:YES];
		});
	} failure:^(AFJSONRequestOperation *remoteOperation, NSError *error) {
		dispatch_async(dispatch_get_main_queue(), ^{
			NSDictionary *responseObject = remoteOperation.responseJSON;		
			if ([responseObject isKindOfClass:[NSDictionary class]] && [[responseObject objectForKey:@"error"] isEqualToString:@"plus_required"]) {
				[hud dismiss];
				UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Plus Required" message:@"You need Cheddar Plus to create more than 2 lists. Please upgrade to continue." delegate:self cancelButtonTitle:@"Later" otherButtonTitles:@"Upgrade", nil];
				[alert show];
			} else {
				[hud failAndDismissWithTitle:@"Failed"];
				[textField becomeFirstResponder];
			}
		});
	}];
}


- (void)_cancelAddingList:(id)sender {
	if (!_adding) {
		return;
	}

	_adding = NO;

	CDIAddListTableViewCell *cell = (CDIAddListTableViewCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
	if ([cell.textField isFirstResponder]) {
		[cell.textField resignFirstResponder];
	}

	[self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationTop];
	self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"plus"] style:UIBarButtonItemStyleBordered target:self action:@selector(createList:)];
	[self setEditing:NO animated:NO];
	[self hideCoverView];
	[self updatePlaceholderViews:YES];
}


- (void)_selectListAtIndexPath:(NSIndexPath *)indexPath newList:(BOOL)newList {
	if (_adding) {
		return;
	}

	if ([[self.tableView indexPathForSelectedRow] isEqual:indexPath] == NO) {
		[self.tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
	}
	
	CDKList *list = [self objectForViewIndexPath:indexPath];
	NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
	[userDefaults setObject:list.remoteID forKey:kCDISelectedListKey];
	[userDefaults synchronize];
	
	if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
		[CDISplitViewController sharedSplitViewController].listViewController.managedObject = list;
		_selectedList = list;
	} else {		
		CDITasksViewController *viewController = [[CDITasksViewController alloc] init];
		viewController.managedObject = list;
		viewController.focusKeyboard = newList;
		[self.navigationController pushViewController:viewController animated:YES];
	}

	_checkForOneList = NO;
}


- (void)_checkUser {
	if (![CDKUser currentUser]) {
#ifdef CHEDDAR_USE_PASSWORD_FLOW
		UIViewController *viewController = [[CDISignInViewController alloc] init];
#else
		UIViewController *viewController = [[CDIWebSignInViewController alloc] init];
#endif
		UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:viewController];
		navigationController.modalPresentationStyle = UIModalPresentationFormSheet;
		
		if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
			[self.splitViewController presentModalViewController:navigationController animated:YES];
		} else {
			[self.navigationController presentModalViewController:navigationController animated:NO];
		}
		return;
	}
}


#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	NSInteger rows = [super tableView:tableView numberOfRowsInSection:section];

	if (_adding) {
		return rows + 1;
	}
	
	return rows;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	static NSString *const cellIdentifier = @"cellIdentifier";
	static NSString *const addCellIdentifier = @"addCellIdentifier";

	if (_adding && indexPath.row == 0) {
		CDIAddListTableViewCell *cell = (CDIAddListTableViewCell *)[tableView dequeueReusableCellWithIdentifier:addCellIdentifier];
		if (!cell) {
			cell = [[CDIAddListTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:addCellIdentifier];
			
			if (self.textExpander) {
				cell.textField.delegate = self.textExpander;
			} else {
				cell.textField.delegate = self;
			}
			
			[cell.closeButton addTarget:self action:@selector(_cancelAddingList:) forControlEvents:UIControlEventTouchUpInside];
		}
		[cell.textField becomeFirstResponder];

		return cell;
	}

	CDIListTableViewCell *cell = (CDIListTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
	if (!cell) {
		cell = [[CDIListTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    	[cell setEditingAction:@selector(_beginEditingWithGesture:) forTarget:self];
	}
	
	cell.list = [self objectForViewIndexPath:indexPath];
	
	return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    if (_adding && indexPath.row == 0) {
        return NO;
    }
    
    return YES;
}


#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	[self _selectListAtIndexPath:indexPath newList:NO];
}


- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath {
	if (sourceIndexPath.row == destinationIndexPath.row) {
		return;
	}
	
	self.ignoreChange = YES;
	NSMutableArray *lists = [self.fetchedResultsController.fetchedObjects mutableCopy];
	CDKList *list = [self objectForViewIndexPath:sourceIndexPath];
	[lists removeObject:list];
	[lists insertObject:list atIndex:destinationIndexPath.row];
	
	NSInteger i = 0;
	for (list in lists) {
		list.position = [NSNumber numberWithInteger:i++];
	}
	
	[self.managedObjectContext save:nil];
	self.ignoreChange = NO;
	
	[CDKList sortWithObjects:lists];
}


- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
	return @"Archive";
}


- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
	if (editingStyle != UITableViewCellEditingStyleDelete) {
		return;
	}
	
	CDKList *list = [self objectForViewIndexPath:indexPath];
	
	if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
		CDITasksViewController *listViewController = [CDISplitViewController sharedSplitViewController].listViewController;
		if ([listViewController.managedObject isEqual:list]) {
			listViewController.managedObject = nil;
		}
	}
	
	list.archivedAt = [NSDate date];
	[list save];
	[list update];
}


- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
}


#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
	if (_adding) {
		[self _cancelAddingList:scrollView];
	}
}


#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
	if (_adding) {
		[self _createList:textField];
		return NO;
	}

	CDKList *list = [self objectForViewIndexPath:self.editingIndexPath];
	list.title = textField.text;
	[list save];
	[list update];
	
	[self endCellTextEditing];
	return NO;
}


- (void)textFieldDidEndEditing:(UITextField *)textField {
	if (_adding) {
		[self _cancelAddingList:textField];
	}
}


#pragma mark - NSFetchedResultsController

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
	[super controllerDidChangeContent:controller];
	
	if (_checkForOneList) {
		if ([self.navigationController topViewController] == self) {
			NSNumber *selectedList = [[NSUserDefaults standardUserDefaults] objectForKey:kCDISelectedListKey];
			if (selectedList) {
				CDKList *list = [CDKList objectWithRemoteID:selectedList];
				NSIndexPath *fIndexPath = [self.fetchedResultsController indexPathForObject:list];
				if (!fIndexPath) {
					_checkForOneList = NO;
					return;
				}
				
				NSIndexPath *selectedIndexPath = [self viewIndexPathForFetchedIndexPath:fIndexPath];
				[self _selectListAtIndexPath:selectedIndexPath newList:NO];
				return;
			}

			if (self.fetchedResultsController.fetchedObjects.count == 1) {
				[self _selectListAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] newList:NO];
				return;
			}
		}
		_checkForOneList = NO;
	}
}

@end
