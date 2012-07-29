//
//  CDIWebViewController.m
//  Cheddar for iOS
//
//  Created by Sam Soffes on 7/28/12.
//  Copyright (c) 2012 Nothing Magical. All rights reserved.
//

#import "CDIWebViewController.h"
#import "CDIToolbarBarButtonItem.h"
#import "UIColor+CheddariOSAdditions.h"

@interface CDIWebViewController ()
- (void)_updateBrowserUI;
@end

@implementation CDIWebViewController {
	NSURL *_url;
	UIActivityIndicatorView *_indicator;
	UIBarButtonItem *_backBarButton;
	UIBarButtonItem *_forwardBarButton;
	UIBarButtonItem *_reloadBarButton;
}

@synthesize webView = _webView;

#pragma mark - UIViewController

- (void)viewDidLoad {
	[super viewDidLoad];
	
	_indicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 22.0f, 22.0f)];
	_indicator.hidesWhenStopped = YES;
	self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:_indicator];
	
	_webView = [[SSWebView alloc] initWithFrame:self.view.bounds];
	_webView.backgroundColor = [UIColor cheddarArchesColor];
	_webView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	_webView.delegate = self;
	_webView.scalesPageToFit = YES;
	[_webView loadURL:_url];
	[self.view addSubview:_webView];
	
	_backBarButton = [[CDIToolbarBarButtonItem alloc] initWithCustomImage:[UIImage imageNamed:@"back-button"] landscapeImagePhone:[UIImage imageNamed:@"back-button-mini"] target:_webView action:@selector(goBack)];
	_forwardBarButton = [[CDIToolbarBarButtonItem alloc] initWithCustomImage:[UIImage imageNamed:@"forward-button"] landscapeImagePhone:[UIImage imageNamed:@"forward-button-mini"] target:_webView action:@selector(goForward)];
	_reloadBarButton = [[CDIToolbarBarButtonItem alloc] initWithCustomImage:[UIImage imageNamed:@"reload-button"] landscapeImagePhone:[UIImage imageNamed:@"reload-button-mini"] target:_webView action:@selector(reload)];
	
	UIBarButtonItem *flexibleSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
	
	self.toolbarItems = [NSArray arrayWithObjects:
						 _backBarButton,
						 flexibleSpace,
						 _forwardBarButton,
						 flexibleSpace,
						 _reloadBarButton,
						 flexibleSpace,
						 [[CDIToolbarBarButtonItem alloc] initWithCustomImage:[UIImage imageNamed:@"safari-button"] landscapeImagePhone:[UIImage imageNamed:@"safari-button-mini"] target:self action:@selector(openSafari:)],
						 flexibleSpace,
						 [[CDIToolbarBarButtonItem alloc] initWithCustomImage:[UIImage imageNamed:@"action-button"] landscapeImagePhone:[UIImage imageNamed:@"action-button-mini"] target:self action:@selector(openActionSheet:)],
						 nil];
	
	if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
		self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Close" style:UIBarButtonItemStyleBordered target:self action:@selector(close:)];
	}
}


- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	[self.navigationController setToolbarHidden:NO animated:animated];
}


- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
	[self.navigationController setToolbarHidden:YES animated:animated];
}


#pragma mark - URL Loading

- (void)loadURL:(NSURL *)url {
	_url = url;
}


- (NSURL *)currentURL {
	NSURL *url = _webView.lastRequest.mainDocumentURL;
	if (!url) {
		url = _url;
	}
	return url;
}


#pragma mark - Actions

- (void)close:(id)sender {
	[self.navigationController dismissModalViewControllerAnimated:YES];
}


- (void)openSafari:(id)sender {
	[[UIApplication sharedApplication] openURL:self.currentURL];
}


- (void)openActionSheet:(id)sender {
	UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Copy URL", @"Email URL", nil];
	actionSheet.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
	[actionSheet showInView:self.navigationController.view];
}


- (void)copyURL:(id)sender {
	[[UIPasteboard generalPasteboard] setURL:self.currentURL];
}


- (void)emailURL:(id)sender {
	
}


#pragma mark - Private

- (void)_updateBrowserUI {
	_backBarButton.enabled = [_webView canGoBack];
	_forwardBarButton.enabled = [_webView canGoForward];
	[_webView isLoadingPage] ? [_indicator startAnimating] : [_indicator stopAnimating];
}


#pragma mark - SSWebViewDelegate

- (void)webViewDidStartLoadingPage:(SSWebView *)aWebView {
	self.title = _webView.lastRequest.mainDocumentURL.absoluteString;
	[self _updateBrowserUI];
}


- (void)webViewDidLoadDOM:(SSWebView *)aWebView {
	NSString *title = [_webView stringByEvaluatingJavaScriptFromString:@"document.title"];
	if (title && title.length > 0) {
		self.title = title;
	}
}


- (void)webViewDidFinishLoadingPage:(SSWebView *)aWebView {
	[self _updateBrowserUI];
}


#pragma mark - UIActionSheet

- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex {
	if (buttonIndex == 0) {
		[self copyURL:actionSheet];
	} else if (buttonIndex == 1) {
		[self emailURL:actionSheet];
	}
}

@end
